import Combine
import SwiftUI

enum ViewMode: String, CaseIterable {
    case edit
    case split
    case preview
}

struct ViewModeKey: FocusedValueKey {
    typealias Value = Binding<ViewMode>
}

struct DocumentTextKey: FocusedValueKey {
    typealias Value = String
}

struct DocumentFileURLKey: FocusedValueKey {
    typealias Value = URL
}

struct FindStateKey: FocusedValueKey {
    typealias Value = FindState
}

struct OutlineStateKey: FocusedValueKey {
    typealias Value = OutlineState
}

extension FocusedValues {
    var viewMode: Binding<ViewMode>? {
        get { self[ViewModeKey.self] }
        set { self[ViewModeKey.self] = newValue }
    }
    var documentText: String? {
        get { self[DocumentTextKey.self] }
        set { self[DocumentTextKey.self] = newValue }
    }
    var documentFileURL: URL? {
        get { self[DocumentFileURLKey.self] }
        set { self[DocumentFileURLKey.self] = newValue }
    }
    var findState: FindState? {
        get { self[FindStateKey.self] }
        set { self[FindStateKey.self] = newValue }
    }
    var outlineState: OutlineState? {
        get { self[OutlineStateKey.self] }
        set { self[OutlineStateKey.self] = newValue }
    }
}

// MARK: - Window Frame Persistence

/// Sets NSWindow.frameAutosaveName so macOS automatically saves/restores window size and position.
/// Uses a per-file autosave name so each document remembers its own window frame.
struct WindowFrameSaver: NSViewRepresentable {
    let fileURL: URL?

    final class Coordinator {
        var autosaveName: String?
    }

    private var autosaveName: String {
        fileURL?.absoluteString ?? "ClearlyUntitledWindow"
    }

    func makeCoordinator() -> Coordinator {
        Coordinator()
    }

    private func applyAutosaveName(
        to window: NSWindow,
        coordinator: Coordinator,
        persistCurrentFrame: Bool
    ) {
        guard coordinator.autosaveName != autosaveName else { return }
        coordinator.autosaveName = autosaveName
        window.setFrameAutosaveName(autosaveName)
        if persistCurrentFrame {
            window.saveFrame(usingName: autosaveName)
        }
    }

    func makeNSView(context: Context) -> NSView {
        let view = NSView()
        DispatchQueue.main.async {
            if let window = view.window {
                applyAutosaveName(
                    to: window,
                    coordinator: context.coordinator,
                    persistCurrentFrame: false
                )
                // Ensure the document window comes to front after opening.
                activateDocumentApp()
                window.makeKeyAndOrderFront(nil)
            }
        }
        return view
    }

    func updateNSView(_ nsView: NSView, context: Context) {
        guard let window = nsView.window else { return }
        applyAutosaveName(
            to: window,
            coordinator: context.coordinator,
            persistCurrentFrame: context.coordinator.autosaveName != nil
        )
    }
}

struct HiddenToolbarBackground: ViewModifier {
    func body(content: Content) -> some View {
        if #available(macOS 15.0, *) {
            content.toolbarBackgroundVisibility(.hidden, for: .windowToolbar)
        } else {
            content
        }
    }
}

// MARK: - Prove which binary is running (Dock vs stray Xcode instance)

/// Sets `NSWindow.subtitle` so you can see build + whether this is the MBP-Mods install or a DerivedData run.
struct WindowKindasBuildSubtitle: NSViewRepresentable {
    func makeNSView(context: Context) -> NSView {
        NSView(frame: .zero)
    }

    func updateNSView(_ nsView: NSView, context: Context) {
        let ver = Bundle.main.object(forInfoDictionaryKey: "CFBundleVersion") as? String ?? "?"
        let bundlePath = Bundle.main.bundlePath
        let origin: String = {
            if bundlePath.contains("/MBP-Mods/KindasMD/KindasMDEditor.app") {
                return "MBP-Mods install"
            }
            if bundlePath.contains("DerivedData") {
                return "⚠️ DerivedData — quit this; use Dock + KindasMD/KindasMDEditor.app"
            }
            return (bundlePath as NSString).lastPathComponent
        }()
        DispatchQueue.main.async {
            nsView.window?.subtitle = "KindasMD build \(ver) · \(origin)"
        }
    }
}

struct ContentView: View {
    @Binding var document: MarkdownDocument
    let fileURL: URL?
    @State private var mode: ViewMode
    @State private var positionSyncID = UUID().uuidString
    @AppStorage("editorFontSize") private var fontSize: Double = 16
    /// Box character palette (⌘⌥B / toolbar). Separate from MASTER strip.
    @AppStorage("kindasBlueprintStripVisible") private var boxStripVisible = true
    /// MASTER file picker + scratch editor (⌘⌥M / toolbar). Characters stay above when both are on.
    @AppStorage("kindasMasterStripVisible") private var masterStripVisible = true
    @State private var boxCells: [String] = KindasBoxGridConfig.defaultCells()
    @StateObject private var masterFolder = MasterFolderModel()
    /// When true, editor and preview share one scroll position (and follow each other in split view).
    @AppStorage("editorPreviewScrollSync") private var scrollSyncEnabled = true
    @StateObject private var findState = FindState()
    @StateObject private var fileWatcher = FileWatcher()
    @StateObject private var outlineState = OutlineState()
    @StateObject private var scrollRelay = ScrollSyncRelay()

    init(document: Binding<MarkdownDocument>, fileURL: URL? = nil) {
        self._document = document
        self.fileURL = fileURL
        // Opening a file from disk: always start in Editor. A global "last mode" of Preview
        // would hide the Blueprint strip and disable its toolbar control — feels like the feature vanished.
        let initialMode: ViewMode
        if fileURL != nil {
            initialMode = .edit
        } else {
            let storedMode = UserDefaults.standard.string(forKey: "viewMode")
            initialMode = ViewMode(rawValue: storedMode ?? "") ?? .edit
        }
        self._mode = State(initialValue: initialMode)
        DiagnosticLog.log("Document opened: \(fileURL?.lastPathComponent ?? "untitled")")
    }

    private var wordCount: Int {
        document.text.split { $0.isWhitespace || $0.isNewline }.count
    }

    private var characterCount: Int {
        document.text.count
    }

    var body: some View {
        HStack(spacing: 0) {
            VStack(spacing: 0) {
                if findState.isVisible {
                    FindBarView(findState: findState)
                    Divider()
                }
                if mode == .edit || mode == .split {
                    if boxStripVisible || masterStripVisible {
                        VStack(alignment: .leading, spacing: 0) {
                            if boxStripVisible {
                                KindasCharactersStripView(boxCells: $boxCells, fontSize: CGFloat(fontSize))
                            }
                            if boxStripVisible && masterStripVisible {
                                Divider()
                            }
                            if masterStripVisible {
                                KindasMasterStripView(
                                    masterModel: masterFolder,
                                    fontSize: CGFloat(fontSize),
                                    charactersVisible: boxStripVisible
                                )
                            }
                        }
                        .frame(
                            minHeight: (masterStripVisible && !boxStripVisible)
                                ? 0
                                : ((boxStripVisible && masterStripVisible) ? 120 : 0),
                            maxHeight: (masterStripVisible && !boxStripVisible)
                                ? 520
                                : ((boxStripVisible && masterStripVisible) ? 680 : 420)
                        )
                        .background(Theme.backgroundColorSwiftUI)
                        Divider()
                    }
                    ColumnRulerView(fontSize: CGFloat(fontSize))
                        .frame(height: 24)
                }
                Group {
                    if mode == .split {
                        HSplitView {
                            EditorView(text: $document.text, fontSize: CGFloat(fontSize), fileURL: fileURL, mode: mode, positionSyncID: positionSyncID, scrollSyncEnabled: scrollSyncEnabled, scrollRelay: scrollRelay, findState: findState, outlineState: outlineState)
                                .frame(minWidth: 220)
                            PreviewView(markdown: document.text, fontSize: CGFloat(fontSize), mode: mode, positionSyncID: positionSyncID, scrollSyncEnabled: scrollSyncEnabled, scrollRelay: scrollRelay, fileURL: fileURL, findState: findState, outlineState: outlineState)
                                .frame(minWidth: 220)
                        }
                    } else {
                        ZStack {
                            EditorView(text: $document.text, fontSize: CGFloat(fontSize), fileURL: fileURL, mode: mode, positionSyncID: positionSyncID, scrollSyncEnabled: scrollSyncEnabled, scrollRelay: scrollRelay, findState: findState, outlineState: outlineState)
                                .opacity(mode == .edit ? 1 : 0)
                                .allowsHitTesting(mode == .edit)
                            PreviewView(markdown: document.text, fontSize: CGFloat(fontSize), mode: mode, positionSyncID: positionSyncID, scrollSyncEnabled: scrollSyncEnabled, scrollRelay: scrollRelay, fileURL: fileURL, findState: findState, outlineState: outlineState)
                                .opacity(mode == .preview ? 1 : 0)
                                .allowsHitTesting(mode == .preview)
                        }
                    }
                }
            }
            .safeAreaInset(edge: .bottom, spacing: 0) {
                if mode != .preview {
                    HStack(spacing: 12) {
                        Text("\(wordCount) words")
                        Text("\(characterCount) characters")
                    }
                    .font(.caption)
                    .foregroundStyle(.tertiary)
                    .padding(.horizontal, 16)
                    .padding(.vertical, 6)
                    .background(Theme.backgroundColorSwiftUI)
                }
            }

            if outlineState.isVisible {
                Divider()
                OutlineView(outlineState: outlineState)
            }
        }
        .frame(minWidth: 500, minHeight: 400)
        .background(Theme.backgroundColorSwiftUI)
        .onChange(of: mode) { _, newMode in
            UserDefaults.standard.set(newMode.rawValue, forKey: "viewMode")
            if newMode == .edit || newMode == .split {
                masterFolder.ensureFolderAndRefresh()
            }
        }
        .toolbar {
            ToolbarItem(placement: .principal) {
                Picker("Mode", selection: $mode) {
                    Image(systemName: "pencil")
                        .tag(ViewMode.edit)
                    Image(systemName: "rectangle.split.2x1")
                        .tag(ViewMode.split)
                    Image(systemName: "eye")
                        .tag(ViewMode.preview)
                }
                .pickerStyle(.segmented)
                .frame(width: 152)
                .help("Editor / Split / Preview (⌘1 / ⌘3 / ⌘2)")
            }
            ToolbarItem(placement: .automatic) {
                Button {
                    withAnimation(.easeInOut(duration: 0.2)) {
                        boxStripVisible.toggle()
                    }
                } label: {
                    Label("Characters", systemImage: "square.grid.3x3")
                }
                .help("Toggle box character palette (⌘⌥B)")
                .disabled(mode == .preview)
            }
            ToolbarItem(placement: .automatic) {
                Button {
                    withAnimation(.easeInOut(duration: 0.2)) {
                        masterStripVisible.toggle()
                    }
                } label: {
                    Label("MASTER", systemImage: "doc.text")
                }
                .help("Toggle MASTER notes strip (⌘⌥M)")
                .disabled(mode == .preview)
            }
            ToolbarItem(placement: .automatic) {
                Button {
                    if scrollSyncEnabled {
                        scrollSyncEnabled = false
                    } else {
                        scrollSyncEnabled = true
                        ScrollBridge.publishSharedFraction(0, for: positionSyncID, source: .align)
                    }
                } label: {
                    Image(systemName: scrollSyncEnabled ? "link.circle.fill" : "link.circle")
                        .symbolRenderingMode(.hierarchical)
                        .foregroundStyle(scrollSyncEnabled ? Color.accentColor : Color.secondary)
                        .font(.system(size: 17))
                        .frame(width: 28, height: 22)
                        .contentShape(Circle())
                }
                .buttonStyle(.plain)
                .help(scrollSyncEnabled ? "Scroll sync on — linked; click to turn off" : "Scroll sync off — click to link editor and preview (starts at top)")
            }
            ToolbarItem(placement: .automatic) {
                Button {
                    withAnimation(.easeInOut(duration: 0.2)) {
                        outlineState.toggle()
                    }
                } label: {
                    Image(systemName: "list.bullet.indent")
                }
                .help("Document Outline (Shift+Cmd+O)")
            }
            ToolbarItem(placement: .automatic) {
                Button {
                    findState.present()
                } label: {
                    Image(systemName: "magnifyingglass")
                }
                .help("Find (Cmd+F)")
            }
        }
        .modifier(HiddenToolbarBackground())
        .background(WindowKindasBuildSubtitle())
        .background(WindowFrameSaver(fileURL: fileURL))
        .animation(.easeInOut(duration: 0.15), value: mode)
        .animation(.easeInOut(duration: 0.2), value: boxStripVisible)
        .animation(.easeInOut(duration: 0.2), value: masterStripVisible)
        .onReceive(NotificationCenter.default.publisher(for: .clearlyToggleBlueprint)) { _ in
            guard mode == .edit || mode == .split else { return }
            withAnimation(.easeInOut(duration: 0.2)) {
                boxStripVisible.toggle()
            }
        }
        .onReceive(NotificationCenter.default.publisher(for: .clearlyToggleMasterStrip)) { _ in
            guard mode == .edit || mode == .split else { return }
            withAnimation(.easeInOut(duration: 0.2)) {
                masterStripVisible.toggle()
            }
        }
        .focusedSceneValue(\.viewMode, $mode)
        .focusedSceneValue(\.documentText, document.text)
        .focusedSceneValue(\.documentFileURL, fileURL)
        .focusedSceneValue(\.findState, findState)
        .focusedSceneValue(\.outlineState, outlineState)
        .onAppear {
            // MASTER list must refresh on first open (strip toggle / mode). Root fix: real ~/ path, not container.
            masterFolder.ensureFolderAndRefresh()
            ScrollBridge.registerRelay(scrollRelay, for: positionSyncID)
            // v2 key: older builds stored 48 (or other) lengths; ignore and use defaults unless length matches 41×4.
            if let d = UserDefaults.standard.data(forKey: "kindasBoxGridCells_v2"),
               let decoded = try? JSONDecoder().decode([String].self, from: d),
               decoded.count == KindasBoxGridConfig.cellCount
            {
                boxCells = decoded
            }
            fileWatcher.onChange = { [self] newText in
                document.text = newText
            }
            fileWatcher.watch(fileURL, currentText: document.text)
            outlineState.parseHeadings(from: document.text)
        }
        .onDisappear {
            ScrollBridge.unregisterRelay(for: positionSyncID)
        }
        .onChange(of: boxCells) { _, newValue in
            if let data = try? JSONEncoder().encode(newValue) {
                UserDefaults.standard.set(data, forKey: "kindasBoxGridCells_v2")
            }
        }
        .onChange(of: fileURL) { _, newURL in
            fileWatcher.watch(newURL, currentText: document.text)
        }
        .onChange(of: document.text) { _, newText in
            fileWatcher.updateCurrentText(newText)
            outlineState.parseHeadings(from: newText)
        }
        .onChange(of: masterStripVisible) { _, visible in
            if visible {
                masterFolder.ensureFolderAndRefresh()
            }
        }
    }
}

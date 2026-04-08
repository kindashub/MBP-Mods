    ┌────────────────────────────────────────────────────────────────────────────────────┐
    │ ⦿ ⦿ ⦿                           ( (/) (/) (/) )               (a) (b) (c) (d) (e) │                                                           
    ├────────────────────────────────────────────────────────────────────────────────────┤
f--->   ┬ ┌ ┐ ╦  █ ░ <-- Example                                                         │ <--╎
    │────────────────────────────────────────────────────────────────────────────────────│    ╎-- Persistent fields. 
g--->                                                                          [MASTER]  │<┐  ╎   Stays between sessions
    │------------------------------------------------------------------------------------│ ╎  ╎   or new document.                                                                           
h--->   Editable Master.md                                                               │ ╎  ╎
    │                                                                                    │ <--╎
    │                                                                                    │ ╎
    │────────────────────────────────────────────────────────────────────────────────────│ └> [Master] is a field picker. 
    │                Edit                      ╎               Preview                   │    I lets you choose between docs
    │                                          ╎                                         │    in a master folder. These docs
    │                                          ╎                                         │    are the Source of truth for any
    │                                          ╎                                         │    given project or topic. 
    │                                          ╎                                         │    End the eitable area lets you
    │                                          ╎                                         │    see and write to the document 
    │                                          ╎                                         │    that is chosen. 
- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -  

a = Opens = f, a menu that has a set list of box characters. The characters are not the size of the text in edit fields, they are smaller. 
they also is not "written", but is inside small buttons that when clicked, copy the clicked item to the clipboard. 

┌─────────────────────────────────────────────────────────────────────────────────────┐
│ ▢ ▢ ▢ ▢ ▢ ▢ ▢ ▢ ▢ ▢ ▢ ▢ ▢ ▢ ▢ ▢ ▢ ▢ ▢ ▢ ▢ ▢ ▢ ▢ ▢ ▢ ▢ ▢ ▢ ▢ ▢ ▢ ▢ ▢ ▢ ▢ ▢ ▢ │
│ ▢ ▢ ▢ ▢ ▢ ▢ ▢ ▢ ▢ ▢ ▢ ▢ ▢ ▢ ▢ ▢ ▢ ▢ ▢ ▢ ▢ ▢ ▢ ▢ ▢ ▢ ▢ ▢ ▢ ▢ ▢ ▢ ▢ ▢ ▢ ▢ ▢ ▢ │
│ ▢ ▢ ▢ ▢ ▢ ▢ ▢ ▢ ▢ ▢ ▢ ▢ ▢ ▢ ▢ ▢ ▢ ▢ ▢ ▢ ▢ ▢ ▢ ▢ ▢ ▢ ▢ ▢ ▢ ▢ ▢ ▢ ▢ ▢ ▢ ▢ ▢ ▢ │
└─────────────────────────────────────────────────────────────────────────────────────┘

This folds down just like the old blueprint button did, the difference here is that it is not a writable field, and it shout not be as big. Instead we want to try to fit as much characters as possible in a smaller area, we do that by making the squares smaller. The squares can be populaded by pressing "edit squares", we then can can place characters in the squares by our liking. The buttons should not have a "copy icon", the copying to clipboard happens automatically when pressing a button. 

b = this will fold down a editable field just like the "blueprint" (g-h) field in the last version. But now it also has a field picker (g). When pressing it, one can choose to see whatever .md file is placed in the folder MASTER. This is a folder I will create, and it will contain the master files of various subjects. This is used in order to quickly open different masters and add information to them. Say I get an .md report from Claude, then I can read it in here, and at the same time chose different masters to add different info from the report, where it belongs. When adding to the edit field (h), where the master is displayed, we actually see the real document (in edit view) and when writing there, we write to that actual folder. The MASTER folder is inside TextMD folder. 

c) this was the old link button we created for version 1, if we keep the split screen working and not removing it this time, we might not need this "linking" icon. Since the editfield and the previewfield should be linked as default in the original Clearly.app. 

d) Outline. 

e) Search. 
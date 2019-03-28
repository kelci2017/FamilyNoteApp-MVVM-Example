# MVVM-Example

**ios example app with MMVM**

**Ideas**

* The FamilyNoteApp was created with MVVM design
* When user logedin and come to the noteboard, the notesearchviewmodel will be triggered to call the server to get all the initial today's notes and shown on the noteboard. If choose local search, the search content is the one on the screen, if choose global search, notesearchmodel will be triggered to call the server with input keywords and shown on the noteboard.
* If user click the notepad, user can submit a new note. When a note submmited, if you user come back to the noteboard, the new note will be shown beacause of observer in the noteboard.
* When user come to the settings, filter by from, to or date, then go back to noteboard, it shows the filtered notes by seleted from ,to and date.
* If user want to add some family members, click the add family members, then come to the add family member page, fill in the names and click add, the family members are posted to the server. When user come to notepad, the new added family members are shown in the spinner for from and and to textview. If user come to the settings and click the check notes from or to, the new added family members are also added in the name list.

* The view part is mainly the viewControllers, such as the noteboardViewControler, notepadViewControler, settingsViewControler, addfamilymembersViewControler, signinViewControler, registerViewControler
* The viewmodel part is mainly the webservice call, such as the noteSubmite, login, logout, noteSearch, register, familyMemberManager
* The model part is mainly in the server side, which is another repository in my github called App-server, the autnenatication is another repository Authentication-server
(Note: the app server and authentication server is created separately, mainly for future use, other servers can also use the authentication server, and the authentication server can be deployed to other places if needed)

**The design diagram**

![SettingsDiagram](https://github.com/kelci2017/FamilyNoteApp_ios/blob/NoteFamily_images/SettingsDiagram.JPG)
![NoteboardDiagram](https://github.com/kelci2017/FamilyNoteApp_ios/blob/NoteFamily_images/NoteboardDiagram.JPG)
![notepadDiagram](https://github.com/kelci2017/FamilyNoteApp_ios/blob/NoteFamily_images/notepadDiagram.JPG)

**Demo**

![Demo gif](https://github.com/kelci2017/FamilyNoteApp-MVVM-Example/blob/NoteFamily_images/part1.gif)

![Demo gif](https://github.com/kelci2017/FamilyNoteApp-MVVM-Example/blob/NoteFamily_images/part2.gif)

![LoginScreenshot](https://github.com/kelci2017/FamilyNoteApp_ios/blob/NoteFamily_images/login.png)
![LoginScreenshot](https://github.com/kelci2017/FamilyNoteApp_ios/blob/NoteFamily_images/notepad.png)
![LoginScreenshot](https://github.com/kelci2017/FamilyNoteApp_ios/blob/NoteFamily_images/noteboard.png)
![LoginScreenshot](https://github.com/kelci2017/FamilyNoteApp_ios/blob/NoteFamily_images/noteboard1.png)
![LoginScreenshot](https://github.com/kelci2017/FamilyNoteApp_ios/blob/NoteFamily_images/noteboard2.png)
![LoginScreenshot](https://github.com/kelci2017/FamilyNoteApp_ios/blob/NoteFamily_images/settings.png)
![LoginScreenshot](https://github.com/kelci2017/FamilyNoteApp_ios/blob/NoteFamily_images/settings1.png)
![RegisterScreenshot](https://github.com/kelci2017/FamilyNoteApp-MVVM-Example/blob/NoteFamily_images/register.png)
![AddFamilyMemberScreenshot](https://github.com/kelci2017/FamilyNoteApp-MVVM-Example/blob/NoteFamily_images/addFamilyMember.png)


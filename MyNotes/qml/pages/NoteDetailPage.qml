import Felgo
import QtQuick

/*!
    \qmltype NotesDetailPage
    \inqmlmodule Qml-MyNotes
    \inherits AppPage
    \brief This class provides the AppTextField for the notes to write.

    This class can be instantiated as shown below:
    \qml
         NotesDetailPage { }
    \endqml
*/
AppPage {
    id: page

    backgroundColor: 'black'

    rightBarItem: NavigationBarRow {

        // add new note
        IconButtonBarItem {
            iconType: IconType.save
            showItem: showItemAlways
            onClicked: {
               app.addNote(titleInput.text, noteInput.text)
               page.navigationStack.pop()
            }
        }
    }


    /*!
        \qmlproperty bool NotesDetailPage::noteId
        \brief This property is used to hold the id of the note being viewed.
    */
    property int noteId: 0

    /*!
        \qmlproperty bool NotesDetailPage::noteData
        \brief This property is used to hold the array of notes.
    */
    property var noteData: dataModel.noteDetails[noteId]

    // load data initially or when id changes
    onNoteIdChanged: {
        app.fetchNoteDetails(noteId)
    }

    // column to show all note object properties, if data is available
    Column {
        id: noteContainer
        y: spacing
        width: parent.width - 2 * spacing
        anchors.horizontalCenter: parent.horizontalCenter
        spacing: dp(Theme.navigationBar.defaultBarItemPadding)

         AppTextField {
            id: titleInput
            backgroundColor: 'black'
            width: parent.width
            anchors.horizontalCenter: parent.horizontalCenter
            height: implicitHeight
            text: noteData ? noteData.title : ""
            placeholderText: "Title"
            font.bold: true
            wrapMode: AppText.WrapAtWordBoundaryOrAnywhere
            color:'white'
        }
         AppTextField {
            id: noteInput
            backgroundColor: 'black'
            width: parent.width
            anchors.horizontalCenter: parent.horizontalCenter
            height: page.height - titleInput.height - noteContainer.spacing
            text: noteData ? noteData.note : ""
            placeholderText: "Write Here"
            wrapMode: AppText.WrapAtWordBoundaryOrAnywhere
            verticalAlignment: TextInput.AlignTop
            color:'white'
        }
    }
}

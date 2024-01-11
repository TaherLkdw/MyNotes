import Felgo
import QtQuick
/*!
    \qmltype NotesPage
    \inqmlmodule Qml-MyNotes
    \inherits AppPage
    \brief This class provides the GridView of the Notes created by user.

    This class can be instantiated as shown below:
    \qml
         NotesPage { }
    \endqml
*/

AppPage {
    id: page
    title: qsTr("Notes") // use qsTr for strings you want to translate
    backgroundColor: 'black'

    rightBarItem: NavigationBarRow {

        // add new note
        IconButtonBarItem {
            iconType: IconType.gear
            showItem: showItemAlways
            onClicked: {
               page.navigationStack.popAllExceptFirstAndPush(settingsPage)
            }
        }
    }

    // when a note is added, we open the detail page for it
    Connections {
        target: dataModel
        onNoteStored: note => {
                          page.navigationStack.popAllExceptFirstAndPush(detailPageComponent, { noteId: note.id })
                      }
    }

    // JsonListModel
    // A ViewModel for JSON data that offers best integration and performance with list views
    JsonListModel {
        id: listModel
        source: dataModel.notesList // show notes from data model
        keyField: "id"
        fields: ["id", "title", "note"]
    }

    // show sorted/filterd notes of data model
    GridView {
        id: listView
        anchors.fill: parent

        cellWidth: parent.width/2
        cellHeight: parent.height/3
        boundsBehavior: Flickable.StopAtBounds
        // the model specifies the data for the list view
        model: listModel

        // the delegate is the template item for each entry of the list
        delegate: SimpleRow {
            Rectangle {
                anchors.fill: parent
                color: 'transparent'
                border.color: 'orange'
            }

            height: listView.cellHeight - dp(3)
            width: listView.cellWidth - dp(3)
            text: model.title
            style.backgroundColor: 'black'
            style.textColor: 'white'
            style.selectedBackgroundColor: 'orange'
            style.detailTextColor: 'darkGrey'
            style.dividerColor: 'transparent'

            detailText: model.note
            detailTextItem.wrapMode: AppText.WrapAtWordBoundaryOrAnywhere
            detailTextItem.width: listView.cellWidth - dp(20)
            detailTextItem.maximumLineCount: 10

            // push detail page when selected, pass chosen note id
            onSelected: page.navigationStack.popAllExceptFirstAndPush(detailPageComponent, { noteId: model.id })
        }
    }
    FloatingActionButton {
        visible: true
        backgroundColor: 'black'
        iconType: IconType.plus
        iconColor: 'white'
        onClicked: page.navigationStack.push(detailPageComponent)
    }

    // component for creating detail pages
    Component {
        id: detailPageComponent
        NoteDetailPage { }
    }

    Component {
        id: settingsPage
        SettingsPage { }
    }
}

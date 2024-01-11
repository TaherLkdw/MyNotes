import Felgo
import QtQuick
import "model"
import "pages"


App {
    id: app
    // You get free licenseKeys from https://felgo.com/licenseKey
    // With a licenseKey you can:
    //  * Publish your games & apps for the app stores
    //  * Remove the Felgo Splash Screen or set a custom one (available with the Pro Licenses)
    //  * Add plugins to monetize, analyze & improve your apps (available with the Pro Licenses)
    //licenseKey: "<generate one from https://felgo.com/licenseKey>"

    signal fetchNotesList()

    signal fetchNoteDetails(int id)

    signal storeNote(var note)

    signal clearCache()

    // function to store a new note
    function addNote(title, note) {
        var draft = {
            note: note,
            title: title
        }

        storeNote(draft)
    }

    // app initialization
    Component.onCompleted: {
        // fetch note list data
        fetchNotesList()
    }

    // model
    DataModel {
        id: dataModel
        dispatcher: app // data model handles actions sent by logic
    }

    // view
    Navigation {
        id: navigation
        navigationMode: navigationModeNone

        // first tab
        NavigationItem {
            title: qsTr("MyNotes")
            iconType: IconType.list

            NavigationStack {
                id: navStackNotesPage
                navigationBar.backgroundColor: 'black'
                navigationBar.dividerColor: 'black'
                leftColumnBar.backgroundColor: 'black'
                leftColumnBar.dividerColor: 'black'

                splitView: tablet // use side-by-side view on tablets
                initialPage: NotesPage { }
            }
        }
    }
}

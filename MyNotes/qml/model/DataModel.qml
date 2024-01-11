import QtQuick
import Felgo

/*!
    \qmltype DataModel
    \inqmlmodule model
    \inherits Item
    \brief This class provides list of the Notes created by user.

    This class can be instantiated as shown below:
    \qml
         DataModel { }
    \endqml
*/

Item {

    /*!
        \qmlproperty bool DataModel::dispatcher
        \brief This property is used to configure target dispatcher.
    */
    property alias dispatcher: appConnection.target


    /*!
        \qmlproperty bool DataModel::notesList
        \brief This property is used to hold the array of notes.
    */
    readonly property alias notesList: _.notesList

    /*!
        \qmlproperty bool DataModel::noteDetails
        \brief This property is used to hold the map of notes.
    */
    readonly property alias noteDetails: _.noteDetails

    /*!
        \qmlproperty bool DataModel::file
        \brief This property is used to hold the name of a json file.
    */
    readonly property string file: "Notes/notesData.json"

    /*!
        \qmlsignal DataModel::noteStored(var note)
        \brief The noteStored(\a note) signal is emitted when user successfully stores the note.
    */
    // action success signals
    signal noteStored(var note)

    // listen to actions from dispatcher
    Connections {
        id: appConnection

        // action 1 - fetchNoteList
        onFetchNotesList: {
            var fileName = FileUtils.storageLocation(FileUtils.DocumentsLocation, file)
            var data = FileUtils.readFile(fileName)
            if (data) {
                var jsonObj = JSON.parse(data)

                // check cached value first
                var list = jsonObj["notesList"]
                if(list) {
                    _.notesList = list
                }

                _.noteDetails = jsonObj["notesMap"]
            }

        }

        // action 2 - fetchnoteDetails
        onFetchNoteDetails: id => {
                                var note = _.noteDetails[id]
                                if(note) {
                                    noteDetailsChanged() // signal change within model to update UI
                                }
                            }

        // action 3 - storeNote
        onStoreNote: note => {
                            note.id = _.notesList.length + 1
                            var jsonObj = {}
                            jsonObj["notesMap"] = {}
                            _.noteDetails[note.id] = note
                            jsonObj.notesMap = _.noteDetails

                             // add new item to notesList
                             _.notesList.unshift(note)

                            jsonObj["notesList"] = _.notesList

                            // cache updated note list
                            var fileContentAsString = JSON.stringify(jsonObj, null, "  ")
                            var fileName = FileUtils.storageLocation(FileUtils.DocumentsLocation, file)
                            var success = FileUtils.writeFile(fileName, fileContentAsString)
                            notesListChanged()

                            noteStored(note)
                     }

        // action 4 - clearCache
        onClearCache: {
            FileUtils.removeFile(file)
        }
    }

    // private
    Item {
        id: _

        // data properties
        property var notesList: []  // Array
        property var noteDetails: ({}) // Map
    }
}

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
    licenseKey: "2AE5C76740FEA334306FCC403665578909970023E8F80A83CE94BC56492FAD169FE92A966F4C61B75580B14F1412D611860CA682C37595E02285EC308637B4E3D6422641173720933F27E2E286166B77FF8ED11AA3D7506892FE7CDB5D2D10AA6B91425F7F2F65F7930F631235E094A435167BFF7E740330712DBAA90D7E934B3CC966170EAB3D5D5769746CD8C2D278496B66D2DBE6086FFC81E01DFFCF6FA5FC09DF41475521F83E2956BF31ED0EC6B29EA2BA59A871866BF8D4EAB5995CFD8AB33964AF46935E523B53A7873B4741E592952D798B11996AF38AA0E32EBCC8289AAEC87AB5A257D4499FB0AAF3C1D0768109B3AA838DDBC599C4495AE6E2E6378B146D23C35720B535C26F60650C190F0444F2E23CBC9446D93A5D5F7829719CDFBAB640CC97AAE66AB4A1B7C3201D"

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

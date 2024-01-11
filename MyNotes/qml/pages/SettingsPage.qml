import Felgo

AppPage {
    title: qsTr("Settings")
    backgroundColor: 'black'

    // show message if data not available
    AppText {
        id: noDataMessage
        anchors.verticalCenter: parent.verticalCenter
        text: qsTr("Settings information not available")
        width: parent.width
        horizontalAlignment: Qt.AlignHCenter
        color: 'white'
    }

}

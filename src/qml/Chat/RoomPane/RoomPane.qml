import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Layouts 1.12
import "../../Base"

HDrawer {
    id: roomPane
    saveName: "roomPane"

    edge: Qt.RightEdge
    defaultSize: buttonRepeater.childrenImplicitWidth
    minimumSize:
        buttonRepeater.count > 0 ? buttonRepeater.itemAt(0).implicitWidth : 0

    background: HColumnLayout{
        Rectangle {
            color: theme.chat.roomPaneButtons.background

            Layout.fillWidth: true
            Layout.preferredHeight: theme.baseElementsHeight
        }

        Rectangle {
            color: theme.chat.roomPane.background

            Layout.fillWidth: true
            Layout.fillHeight: true
        }
    }

    HColumnLayout {
        anchors.fill: parent

        HFlow {
            Layout.fillWidth: true

            HRepeater {
                id: buttonRepeater
                model: [
                    "members", "files", "notifications", "history", "settings"
                ]

                HButton {
                    height: theme.baseElementsHeight
                    backgroundColor: "transparent"
                    icon.name: "room-view-" + modelData
                    toolTip.text: qsTr(
                        modelData.charAt(0).toUpperCase() + modelData.slice(1)
                    )

                    autoExclusive: true
                    checked: swipeView.currentIndex === index
                    enabled: ["members", "settings"].includes(modelData)

                    onClicked: swipeView.currentIndex = index
                }
            }
        }

        SwipeView {
            id: swipeView
            interactive: ! roomPane.collapsed
            currentIndex: 4  // XXX

            Layout.fillWidth: true
            Layout.fillHeight: true

            MemberView {}
            Item {}
            Item {}
            Item {}
            SettingsView {}
        }
    }
}

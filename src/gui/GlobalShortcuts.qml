// SPDX-License-Identifier: LGPL-3.0-or-later

import QtQuick 2.12
import QtQuick.Controls 2.12
import "Base"

Item {
    visible: false

    // Flickable or ListView that should be affected by scroll shortcuts
    property Item flickTarget

    // A QQC Container that should be affected by tab navigation shortcuts
    property Container tabsTarget

    // DebugConsole that should be affected by console shortcuts
    property DebugConsole debugConsole

    readonly property Item toFlick:
        debugConsole && debugConsole.activeFocus ?
        debugConsole.commandsView : flickTarget


    // App

    HShortcut {
        enabled: debugMode
        sequences: settings.keys.startPythonDebugger
        onActivated: py.call("BRIDGE.pdb")
    }

    HShortcut {
        enabled: debugMode
        sequences: settings.keys.toggleDebugConsole
        onActivated:  {
            if (debugConsole) {
                debugConsole.visible = ! debugConsole.visible
            } else {
                utils.debug(mainUI || window)
            }
        }
    }

    HShortcut {
        sequences: settings.keys.reloadConfig
        onActivated: py.loadSettings(() => { mainUI.pressAnimation.start() })
    }

    HShortcut {
        sequences: settings.keys.zoomIn
        onActivated: theme.uiScale += 0.1
    }

    HShortcut {
        sequences: settings.keys.zoomOut
        onActivated: theme.uiScale = Math.max(0.1, theme.uiScale - 0.1)
    }

    HShortcut {
        sequences: settings.keys.zoomReset
        onActivated: theme.uiScale = 1
    }

    // Pages

    HShortcut {
        sequences: settings.keys.goToLastPage
        onActivated: mainUI.pageLoader.showPrevious()
    }

    // Page scrolling

    HShortcut {
        enabled: toFlick
        sequences: settings.keys.scrollUp
        onActivated: utils.flickPages(toFlick, -1 / 10)
    }

    HShortcut {
        enabled: toFlick
        sequences: settings.keys.scrollDown
        onActivated: utils.flickPages(toFlick, 1 / 10)
    }

    HShortcut {
        enabled: toFlick
        sequences: settings.keys.scrollPageUp
        onActivated: utils.flickPages(toFlick, -1)
    }

    HShortcut {
        enabled: toFlick
        sequences: settings.keys.scrollPageDown
        onActivated: utils.flickPages(toFlick, 1)
    }

    HShortcut {
        enabled: toFlick
        sequences: settings.keys.scrollToTop
        onActivated: utils.flickToTop(toFlick)
    }

    HShortcut {
        enabled: toFlick
        sequences: settings.keys.scrollToBottom
        onActivated: utils.flickToBottom(toFlick)
    }


    // Tab navigation

    HShortcut {
        enabled: tabsTarget
        sequences: settings.keys.previousTab
        onActivated: tabsTarget.setCurrentIndex(
            utils.numberWrapAt(tabsTarget.currentIndex - 1, tabsTarget.count),
        )
    }

    HShortcut {
        enabled: tabsTarget
        sequences: settings.keys.nextTab
        onActivated: tabsTarget.setCurrentIndex(
            utils.numberWrapAt(tabsTarget.currentIndex + 1, tabsTarget.count),
        )
    }


    // MainPane

    HShortcut {
        enabled: mainUI.accountsPresent
        sequences: settings.keys.focusMainPane
        onActivated: mainUI.mainPane.toggleFocus()
        context: Qt.ApplicationShortcut
    }

    HShortcut {
        enabled: mainUI.accountsPresent
        sequences: settings.keys.clearRoomFilter
        onActivated: mainUI.mainPane.toolBar.roomFilter = ""
    }

    HShortcut {
        enabled: mainUI.accountsPresent
        sequences: settings.keys.addNewAccount
        onActivated: mainUI.mainPane.toolBar.addAccountButton.clicked()
    }

    HShortcut {
        enabled: mainUI.accountsPresent
        sequences: settings.keys.addNewChat
        onActivated: mainUI.mainPane.mainPaneList.addNewChat()
    }


    HShortcut {
        enabled: mainUI.accountsPresent
        sequences: settings.keys.accountSettings
        onActivated: mainUI.mainPane.mainPaneList.accountSettings()
    }


    HShortcut {
        enabled: mainUI.accountsPresent
        sequences: settings.keys.toggleCollapseAccount
        onActivated: mainUI.mainPane.mainPaneList.toggleCollapseAccount()
    }


    HShortcut {
        enabled: mainUI.accountsPresent
        sequences: settings.keys.goToPreviousRoom
        onActivated: mainUI.mainPane.mainPaneList.previous()
    }

    HShortcut {
        enabled: mainUI.accountsPresent
        sequences: settings.keys.goToNextRoom
        onActivated: mainUI.mainPane.mainPaneList.next()
    }


    // Chat

    HShortcut {
        enabled: window.uiState.page === "Pages/Chat/Chat.qml"
        sequences: settings.keys.clearRoomMessages
        onActivated: utils.makePopup(
            "Popups/ClearMessagesPopup.qml",
            mainUI,
            {
                userId: window.uiState.pageProperties.userId,
                roomId: window.uiState.pageProperties.roomId,
            }
        )
    }

    HShortcut {
        enabled: window.uiState.page === "Pages/Chat/Chat.qml"
        sequences: settings.keys.sendFile
        onActivated: utils.makeObject(
            "Dialogs/SendFilePicker.qml",
            mainUI,
            {
                userId:          window.uiState.pageProperties.userId,
                roomId:          window.uiState.pageProperties.roomId,
                destroyWhenDone: true,
            },
            picker => { picker.dialog.open() }
        )
    }

    HShortcut {
        enabled: window.uiState.page === "Pages/Chat/Chat.qml"
        sequences: settings.keys.sendFileFromPathInClipboard
        onActivated: utils.sendFile(
            window.uiState.pageProperties.userId,
            window.uiState.pageProperties.roomId,
            Clipboard.text.trim(),
        )
    }
}
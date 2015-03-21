/**
 * This file is part of PushIt.
 *
 * Copyright 2015 (C) Mario Guerriero <marioguerriero33@gmail.com>
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
**/

import QtQuick 2.2
import Ubuntu.Components 1.1
import Ubuntu.Components.Popups 1.0
import Ubuntu.Components.ListItems 1.0

Dialog {
    id: root
    title: i18n.tr("Welcome to Pushit BETA")
    text: i18n.tr("Thanks for using this BETA version of Pushit. It is still not complete and you may experience some features missing or some issues. Please report any of them so that you will help Pushit to become even better! Feel free to report any feature request.")

    Row {
        CheckBox {
            id: dontShowAgainCB
            clip: true
            onTriggered: {
                settings.setSetting("show_beta_message", !checked);
            }
        }

        Label {
            text: i18n.tr("Don't show this next time")
            MouseArea {
                anchors.fill: parent
                onClicked: dontShowAgainCB.trigger()
            }
        }
    }

    Button {
        text: i18n.tr("Report")
        onClicked: {
            PopupUtils.close(root);
        }
    }

    Button {
        text: i18n.tr("Close")
        onClicked: {
            PopupUtils.close(root);
        }
    }
}

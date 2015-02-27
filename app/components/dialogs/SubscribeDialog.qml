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

Dialog {
    id: root
    title: i18n.tr("New Subscription")
    text: i18n.tr("Please insert channel id")

    Label {
        text: i18n.tr("Looking for channels?")
        color: "blue"
        font.underline: true

        MouseArea {
            anchors.fill: parent
            onClicked: Qt.openUrlExternally("https://www.pushbullet.com/channel")
        }
    }

    TextField {
        id: idField
    }

    Button {
        onClicked: PopupUtils.close(root)
    }

    Button {
        onClicked: PopupUtils.close(root)
    }
}

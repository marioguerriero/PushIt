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

    property var body
    onBodyChanged: bodyLabel.text = body

    UbuntuShape {
        height: units.gu(4)
        width: height
    }

    Label {
        id: bodyLabel
        fontSize: "medium"
    }

    Button {
        text: i18n.tr("Delete")
        onClicked: PopupUtils.close(root)
    }

    Button {
        text: i18n.tr("Share")
        onClicked: PopupUtils.close(root)
    }

    Button {
        text: i18n.tr("Close")
        onClicked: PopupUtils.close(root)
    }
}

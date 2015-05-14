/*
 * Flashback - Entertainment app for Ubuntu
 * Copyright (C) 2013, 2014 Nekhelesh Ramananthan <nik90@ubuntu.com>
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License version 3 as
 * published by the Free Software Foundation.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
 *
 */

import QtQuick 2.3
import Ubuntu.Components 0.1

// Walkthrough - Slide 7
Component {
    id: slide4
    Item {
        id: slide4Container

        Column {
            id: mainColumn

            spacing: units.gu(4)
            anchors.centerIn: parent

            Label {
                id: introductionText
                font.pixelSize: units.dp(50)
                font.bold: true
                text: i18n.tr("Done!")
                anchors.horizontalCenter: parent.horizontalCenter
            }

            Button {
                id: continueButton
                color: "white"
                height: units.gu(5)
                width: units.gu(25)
                enabled: logged
                text: i18n.tr("Start using ") + appName
                anchors.horizontalCenter: parent.horizontalCenter
                onClicked: finished()
            }
        }
    }
}

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
import Ubuntu.Components 1.1

Component {
    id: slide2
    Item {
        id: slide2Container

        Column {
            id: textColumn
            
            spacing: units.gu(6)
            anchors.fill: parent

            Label {
                id: introductionText
                text: i18n.tr("Pushbullet Account")
                height: contentHeight
                font.bold: true
                fontSize: "x-large"
                horizontalAlignment: Text.AlignHCenter
                anchors.horizontalCenter: parent.horizontalCenter
            }

            Image {
                id: centerImage
                height: parent.height - introductionText.height - body.contentHeight - 4*textColumn.spacing
                fillMode: Image.PreserveAspectFit
                source: Qt.resolvedUrl("../../pushit.png")
                anchors.horizontalCenter: parent.horizontalCenter
            }

            Label {
                id: body
                text: i18n.tr("To start using Pushit you need to log in your Pushbullet account.\n\nYou can use one of your social account to log in Pushbullet,\nthere is no need for additional subscriptions.")
                width: parent.width
                wrapMode: Text.WordWrap
                font.pixelSize: units.dp(17)
                horizontalAlignment: Text.AlignHCenter
                anchors.horizontalCenter: parent.horizontalCenter
            }
            
            Row {
                id: buttonRow

                height: units.gu(5)
                spacing: units.gu(2)
                anchors.horizontalCenter: parent.horizontalCenter
                
                Button {
                    height: units.gu(5)
                    width: units.gu(18)
                    text: i18n.tr("Log in")
                    color: "white"
                    onClicked: {
                        authPage.success.connect(onLogIn);
                        stack.push(authPage);
                    }
                }
            }
        }

        function onLogIn() {
            logged = true;
            stack.pop();
            walkthrough.next();
        }
    }
}

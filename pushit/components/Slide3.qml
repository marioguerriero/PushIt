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
import Ubuntu.Components 1.2
import Ubuntu.Components.Popups 1.0

import "../js/Pushbullet.js" as Pushbullet

Component {
    id: slide3
    Item {
        id: slide3Container

        Column {
            id: mainColumn

            spacing: units.gu(4)
            anchors.fill: parent

            Label {
                id: introductionText
                fontSize: "x-large"
                font.bold: true
                text: i18n.tr("Pushbullet Device")
                anchors.horizontalCenter: parent.horizontalCenter
            }

            Image {
                id: smileImage
                height: parent.height - introductionText.height - finalMessage.contentHeight - 4.4*mainColumn.spacing
                fillMode: Image.PreserveAspectFit
                source: Qt.resolvedUrl("../../data/ubuntu-logo.png")
                anchors.horizontalCenter: parent.horizontalCenter
            }

            Label {
                id: finalMessage
                text: i18n.tr("For a better experience you can associate a\nnew Ubuntu device to your Pushbullet account.\n(Not necessary)")
                width: parent.width
                wrapMode: Text.WordWrap
                font.pixelSize: units.dp(17)
                horizontalAlignment: Text.AlignHCenter
                anchors.horizontalCenter: parent.horizontalCenter
            }

            Row {
                height: units.gu(5)
                spacing: units.gu(2)
                anchors.horizontalCenter: parent.horizontalCenter

                TextField {
                    id: deviceNameField
                    width: units.gu(24)
                    height: units.gu(5)
                    placeholderText: i18n.tr("Device Name")
                    text: i18n.tr("Ubuntu")
                }

                Button {
                    color: "orange"
                    height: units.gu(5)
                    width: units.gu(18)
                    enabled: logged
                    text: i18n.tr("Create Device")
                    onClicked: {
                        var dialog = PopupUtils.open(Qt.resolvedUrl("dialogs/LoadingDialog.qml"), main);

                        var onLoad = function(data, error) {
                            PopupUtils.close(dialog);
                            walkthrough.next();
                        };

                        var data = { "nickname": deviceNameField.text, "type": "ubuntu" };
                        Pushbullet.addDevice(data, onLoad);
                    }
                }

            }
        }
    }
}

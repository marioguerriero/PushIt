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
import Ubuntu.Components.ListItems 1.0
import Ubuntu.Components.Popups 1.0

import "../../js/Pushbullet.js" as Pushbullet

Page {
    id: root
    title: i18n.tr("Push")
    visible: false

    Column {
        anchors.fill: parent
        anchors.leftMargin: units.gu(1)
        anchors.rightMargin: units.gu(1)
        spacing: units.gu(1)

        ItemSelector {
            id: typeSelector
            text: i18n.tr("Type:")
            model: [ i18n.tr("Note"), i18n.tr("Link"), i18n.tr("File") ]
            expanded: true
        }

        SingleValue {
            id: deviceSelector
            text: i18n.tr("To:")
            value: i18n.tr("None")
        }

        TextField {
            id: titleField
            width: parent.width
            placeholderText: i18n.tr("Title")
        }

        TextField {
            id: urlField
            width: parent.width
            placeholderText: i18n.tr("Url")
            visible: typeSelector.selectedIndex == 1
        }

        TextArea {
            id: bodyArea
            width: parent.width
            placeholderText: typeSelector.selectedIndex == 1 ? i18n.tr("Description") : i18n.tr("Content")
        }
    }


    function push(fileInfo) {
        var data = {};

        if(typeSelector.selectedIndex == 0) { // Note
            data = {    "type": "note",
                "title": titleField.text,
                "body": bodyArea.text };
        }
        else if(typeSelector.selectedIndex == 1) { // Link
            data = {    "type": "link",
                "title": titleField.text,
                "body": bodyArea.text,
                "url": urlField.text };
        }
        else if(typeSelector.selectedIndex == 2) { // File
            data = {    "type": "file",
                "file_name": fileInfo.file_name,
                "file_type": fileInfo.file_type,
                "file_url": fileInfo.file_url,
                "body": bodyArea.text };
        }

        var dialog = PopupUtils.open(Qt.resolvedUrl("../dialogs/LoadingDialog.qml"), root);
        var loadingFinished = function(data) {
            PopupUtils.close(dialog);
            stack.pop();
        }
        Pushbullet.push(data, loadingFinished);
    }

    tools: ToolbarItems {
        ToolbarButton {
            action: Action {
                text: i18n.tr("Push")
                iconName: "save"
                onTriggered: {
                    if(typeSelector.selectedIndex != 2) // If not pushing a file
                        push()
                    else {
                        var uploadComplete = function(fileInfo) {
                            push(fileInfo);
                        };

                        Pushbullet.uploadFile("path", "mimetype", uploadComplete);
                    }
                }
            }
        }
    }
}

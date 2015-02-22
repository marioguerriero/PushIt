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
    title: i18n.tr("Pushes")
    //head.foregroundColor: "#27AE60"

    property var pushes: null

    property var loadingDialog
    property bool loading: false
    onLoadingChanged: {
        if(!loading) {
            PopupUtils.close(loadingDialog);
        }
    }

    ListModel {
        id: model
    }

    UbuntuListView {
        id: list
        anchors.fill: parent
        model: model
        clip: true

        delegate: Expandable {
            id: item
            expandedHeight: contentColumn.height + units.gu(1)

            onClicked: {
                list.expandedIndex = index;
            }

            Column {
                id: contentColumn
                anchors { left: parent.left; right: parent.right }
                Item {
                    anchors { left: parent.left; right: parent.right}
                    height: item.collapsedHeight
                    Label {
                        anchors { left: parent.left; right: parent.right; verticalCenter: parent.verticalCenter}
                        text: title ? title : i18n.tr("Untitled")
                        wrapMode: Text.WordWrap
                    }
                }

                Label {
                    anchors { left: parent.left; right: parent.right }
                    text: {
                        if(type == "note") {
                            return body ? body : "";
                        }
                        else if(type == "link") {
                            color = "blue";
                            font.underline = true;
                            return url ? url : "";
                        }
                        else if(type == "file") {

                        }
                        return "";
                    }
                    wrapMode: Text.WordWrap

                    MouseArea {
                        anchors.fill: parent
                        onClicked: {
                            if(type == "note") {
                                if(body.length == 0) return;
                                var dialog = PopupUtils.open(Qt.resolvedUrl("../dialogs/NoteDialog.qml"), root);
                                dialog.title = title;
                                dialog.body = body;
                            }
                            else if(type == "link") {
                                Qt.openUrlExternally(url);
                            }
                        }
                    }
                }
            }
        }
    }

    Component.onCompleted: {
        loading = true;
        loadingDialog = PopupUtils.open(Qt.resolvedUrl("../dialogs/LoadingDialog.qml"), root);
        Pushbullet.setAccessToken(settings.getSetting("token"));
        if(pushes == null) {
            Pushbullet.getPushes(0, true, loadData);
        }
    }

    function loadData(data) {
        data.pushes = data;
        pushes = JSON.parse(data).pushes;
console.log("test")
        for(var n = 0; n < pushes.length; n++) {
            var push = pushes[n];
            model.append({  "type":         push.type,
                             "title":       push.title,
                             "body":        push.body,
                             "url":         push.url,
                             "created":     push.created,
                             "modified":    push.modified,
                             "active":      push.active,
                             "dismissed":   push.dismissed,
                             "sender_iden": push.sender_iden,
                             "sender_email":push.sender_email
                         });
        }
console.log(header)
        loading = false;
    }
}

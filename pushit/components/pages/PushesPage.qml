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

    property var pushes: null

    property var loadingDialog
    property bool loading: false
    onLoadingChanged: {
        if(!loading) {
            if(loadingDialog != null) PopupUtils.close(loadingDialog);
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
        visible: !emptyLabel.visible

        PullToRefresh {
            refreshing: loading
            onRefresh: reload()
        }

        delegate: Expandable {
            id: item
            collapseOnClick: true
            expandedHeight: contentColumn.height + units.gu(1)
            removable: true
            confirmRemoval: true

            onClicked: {
                list.expandedIndex = index;
            }

            onItemRemoved: {
                Pushbullet.deletePush(iden);
            }

            Column {
                id: contentColumn
                anchors { left: parent.left; right: parent.right }
                Item {
                    anchors { left: parent.left; right: parent.right}
                    height: item.expanded ? item.collapsedHeight + units.gu(3) : item.collapsedHeight
                    Row {
                        anchors { left: parent.left; right: parent.right; verticalCenter: parent.verticalCenter }
                        spacing: units.gu(1)
                        UbuntuShape {
                            id: iconShape
                            height: item.expanded ? units.gu(8) : units.gu(5)
                            width: height
                            anchors.verticalCenter: parent.verticalCenter
                            image: Image {
                                anchors.fill: parent
                                source: pbData.getIconSourceFromIden(sender_iden ? sender_iden : channel_iden)
                                onSourceChanged: console.log(source)
                            }
                        }

                        Label {
                            id: titleLabel
                            width: parent.width - iconShape.width
                            anchors.verticalCenter: parent.verticalCenter
                            text: title ? title : i18n.tr("Untitled")
                            maximumLineCount: 1
                            elide: Text.ElideRight
                            wrapMode: Text.WordWrap
                            fontSize: item.expanded ? "x-large" : "medium"
                        }
                    }
                }

                Label {
                    anchors { left: parent.left; right: parent.right }
                    text: {
                        if(type == "note" || type == "link") return body ? body : "";
                        return "";
                    }
                    visible: type != "file"
                    wrapMode: Text.WordWrap
                }

                Label {
                    anchors { left: parent.left; right: parent.right }
                    color: type == "link" ? "blue" : "white"
                    font.underline: type == "link"
                    text: {
                        if(type == "link") return url ? url : "";
                        return "";
                    }
                    visible: type == "link"
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

    Label {
        id: emptyLabel
        anchors.centerIn: parent
        visible: (model.count == undefined || model.count == 0)
        fontSize: "x-large"
        text: i18n.tr("No Pushes")
    }

    Component.onCompleted: {
        if(settings.getSetting("show-walkthrough")) return;

        if(settings.getSetting("token") == null) return;

        loading = true;
        loadingDialog = PopupUtils.open(Qt.resolvedUrl("../dialogs/LoadingDialog.qml"), root);
        Pushbullet.setAccessToken(settings.getSetting("token"));
        if(pushes == null) {
            Pushbullet.getPushes(0, true, loadData);
        }
    }

    function reload() {
        loading = true;
        loadingDialog = PopupUtils.open(Qt.resolvedUrl("../dialogs/LoadingDialog.qml"), root);
        model.clear();
        Pushbullet.getPushes(loadData);
    }

    function loadData(data, error) {
        if(error != null) {

        }

        if(loadingDialog == null || !loading) {
            loadingDialog = PopupUtils.open(Qt.resolvedUrl("../dialogs/LoadingDialog.qml"), root);
            loading = true;
        }

        pbData.pushes = JSON.parse(data).pushes;
        pushes = pbData.pushes;

        for(var n = 0; n < pushes.length; n++) {
            var push = pushes[n];
            if(push.type == null) continue;
            model.append({   "iden":        push.iden,
                             "type":        push.type,
                             "title":       push.title,
                             "body":        push.body,
                             "url":         push.url,
                             "created":     push.created,
                             "modified":    push.modified,
                             "active":      push.active,
                             "dismissed":   push.dismissed,
                             "sender_iden": push.sender_iden,
                             "channel_iden":push.channel_iden,
                             "sender_email":push.sender_email
                         });
        }

        loading = false;
        loadingDialog = null;
    }

    head.actions: [
        Action {
            text: i18n.tr("Push")
            iconName: "compose"
            onTriggered: stack.push(postPushPage)
        }
    ]
}

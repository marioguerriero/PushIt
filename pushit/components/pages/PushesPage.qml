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
import Ubuntu.Components 1.2
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

        property int selectedItem: -1

        PullToRefresh {
            refreshing: loading
            onRefresh: reload()
        }

        delegate: ListItem {
            id: item
            height: expanded ? contentColumn.height + units.gu(1) : collapsedHeight
            contentItem.anchors {
                leftMargin: units.gu(2)
                rightMargin: units.gu(2)
                topMargin: units.gu(0.5)
                bottomMargin: units.gu(0.5)
            }

            property var collapsedHeight: units.gu(7)
            property bool expanded: false

            Behavior on height { UbuntuNumberAnimation { duration: UbuntuAnimation.SlowDuration } }

            // Trailing and leading actions
            /*trailingActions: ListItemActions {
                actions: [
                    Action {
                        iconName: "share"
                    }
                ]
            }*/
            leadingActions: ListItemActions {
                actions: [
                    Action {
                        iconName: "delete"
                        onTriggered: {
                            item.visible = false;
                            item.height = 0; // TODO: Find a better solution
                            Pushbullet.deletePush(iden);
                        }
                    }
                ]
            }

            onClicked: {
                expanded = !expanded;
            }

            Column {
                id: contentColumn
                height: root.height / 2
                anchors { left: parent.left; right: parent.right }
                Item {
                    anchors { left: parent.left; right: parent.right}
                    height: item.expanded ? item.collapsedHeight + units.gu(3) : item.collapsedHeight
                    Row {
                        anchors { left: parent.left; right: parent.right;  }
                        spacing: units.gu(1)
                        UbuntuShape {
                            id: iconShape
                            height: item.expanded ? units.gu(10) : units.gu(6)
                            width: item.expanded ? units.gu(10) : units.gu(6)
                            anchors.verticalCenter: parent.verticalCenter
                            image: Image {
                                anchors.fill: parent
                                source: pbData.getIconSourceFromIden(sender_iden ? sender_iden : channel_iden)
                            }
                            Behavior on height { UbuntuNumberAnimation { duration: UbuntuAnimation.SlowDuration } }
                            Behavior on width { UbuntuNumberAnimation { duration: UbuntuAnimation.SlowDuration } }
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
                    anchors { left: parent.left; }
                    text: {
                        if(type == "note" || type == "link") return body ? body : "";
                        return "";
                    }
                    visible: type != "file"
                    wrapMode: Text.WordWrap
                }

                UbuntuShape {
                    visible: type == "file"
                    height: contentColumn.height * 0.7
                    width: contentColumn.width * 0.5
                    color: file_type ? (file_type.indexOf("image") > -1 ? "transparent" : "white") : "transparent"
                    anchors.topMargin: units.gu(1)
                    image: Image {
                        id: img
                        anchors.fill: parent
                        visible: file_type ? file_type.indexOf("image") > -1 : false
                        source: file_url ? file_url : ""
                        fillMode: Image.PreserveAspectCrop
                    }
                    Button {
                        anchors.fill: parent
                        visible: !img.visible
                        iconName: "document-save"
                        text: file_name ? file_name : ""
                        color: "white"
                    }
                    MouseArea {
                        anchors.fill: parent
                        onClicked: Qt.openUrlExternally(file_url);
                    }
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
                             "sender_email":push.sender_email,
                             "file_name":   push.file_name,
                             "file_type":   push.file_type,
                             "file_url":    push.file_url
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

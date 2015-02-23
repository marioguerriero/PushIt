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

Page {
    id: root
    title: i18n.tr("Subscriptions")

    property var subscriptions: null

    property var loadingDialog
    property bool loading: false
    onLoadingChanged: {
        if(!visible && !loading) {
            if(loadingDialog != null) PopupUtils.close(loadingDialog);
        }
    }

    onVisibleChanged: {
        if(visible && loading) {
            loadingDialog = PopupUtils.open(Qt.resolvedUrl("../dialogs/LoadingDialog.qml"), root);
        }
    }

    ListModel {
        id: model
    }

    UbuntuListView {
        id: list
        anchors.fill: parent
        visible: !emptyLabel.visible
        model: model
        clip: true

        delegate: Subtitled {
            text: channel.name
            subText: channel.description
            iconSource: channel.image_url
        }
    }

    Label {
        id: emptyLabel
        anchors.centerIn: parent
        visible: (model.count == undefined || model.count == 0)
        fontSize: "x-large"
        text: i18n.tr("No Subscriptions")
    }

    function loadData(data) {
        data.subscriptions = data;
        subscriptions = JSON.parse(data).subscriptions;

        for(var n = 0; n < subscriptions.length; n++) {
            var subscription = subscriptions[n];
            if(subscription.active && subscription != null)
                model.append({  "iden":     subscription.iden,
                                 "created": subscription.created,
                                 "modified":subscription.modified,
                                 "active":  subscription.active,
                                 "channel": subscription.channel
                             });
        }

        loading = false;
    }
}

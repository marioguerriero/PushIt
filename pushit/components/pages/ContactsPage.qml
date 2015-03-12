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
    title: i18n.tr("Contacts")

    property var contacts: null

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

        delegate: Standard {
            text: name
        }
    }

    Label {
        id: emptyLabel
        anchors.centerIn: parent
        visible: (model.count == undefined || model.count == 0)
        fontSize: "x-large"
        text: i18n.tr("No Contacts")
    }

    function loadData(data, error) {
        if(error != null) {

        }

        pbData.contacts = JSON.parse(data).contacts;
        contacts = pbData.contacts;

        for(var n = 0; n < contacts.length; n++) {
            var contact = contacts[n];
            model.append({  "iden":             contact.iden,
                             "name":            contact.name,
                             "created":         contact.created,
                             "modified":        contact.modified,
                             "email":           contact.email,
                             "email_normalized":contact.email_normalized,
                             "active":          contact.active
                         });
        }

        loading = false;
    }
}

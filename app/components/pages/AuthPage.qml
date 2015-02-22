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
import com.canonical.Oxide 1.0

import "../../js/OAuth.js" as OAuth

Page {
    id: root
    title: i18n.tr("Authentication")
    visible: false;

    WebView  {
        id: webView
        anchors.fill: parent

        preferences.localStorageEnabled: true

        onUrlChanged: {
            console.log(url)
            var token = OAuth.getAccessToken();
            var error = OAuth.getAccessError(url);
            if(error == null && token != null) {
                console.log(token);
                settings.setSetting("token", token);
                stack.pop()
                stack.push(tabs);
            }
            if(error != null) {
                 PopupUtils.open(Qt.resolvedUrl("../dialogs/AuthFailedDialog.qml"), root);
            }
        }
    }

    onVisibleChanged: {
        if(visible) reload();
    }

    function reload() {
        webView.url = OAuth.getAuthUri();
    }
}

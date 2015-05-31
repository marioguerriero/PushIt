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
import Ubuntu.Components.Popups 1.0

import "components"
import "components/pages"

import "js/Pushbullet.js" as Pushbullet

MainView {
    id: main
    objectName: "mainView"
    applicationName: "pushit.mefrio-g"

    width: units.gu(100)
    height: units.gu(75)

    backgroundColor: "#27AE60"

    PageStack {
        id: stack

        Tabs {
            id: tabs
            Tab { title: page.title; page: PushesPage { id: pushesPage } }
            Tab { title: page.title; page: ContactsPage { id: contactsPage } }
            Tab { title: page.title; page: DevicesPage { id: devicesPage } }
            Tab { title: page.title; page: SubscriptionsPage { id: subscriptionsPage } }
        }

        UserPage { id: userPage }

        PostPushPage { id: postPushPage }

        ChannelPage { id: channelPage }

        AuthPage { id: authPage }

        WalkthroughPage { id: walkthroughPage }
    }

    Data {
        id: pbData
    }

    Settings {
        id: settings

        Component.onCompleted: init();
    }

    function loadToken() {
        var token = settings.getSetting("token");
        Pushbullet.setAccessToken(token);
    }

    function loadData() {
        pushesPage.loading = true;
        Pushbullet.getPushes(pushesPage.loadData);

        devicesPage.loading = true;
        Pushbullet.getDevices(devicesPage.loadData);

        contactsPage.loading = true;
        Pushbullet.getContacts(contactsPage.loadData);

        subscriptionsPage.loading = true;
        Pushbullet.getSubscriptions(subscriptionsPage.loadData);

        userPage.loading = true;
        Pushbullet.getUserInformations(userPage.loadData);
    }

    Component.onCompleted: {
        // Show walkthrough page
        var showWalkthrough = settings.getSetting("show-walkthrough");
        console.log(showWalkthrough)
        if(showWalkthrough) {
            stack.push(walkthroughPage);
            return;
        }

        // Aquire token
        var token = settings.getSetting("token");
        if(token == null) {
            stack.push(authPage);
            return;
        }
        else
            stack.push(tabs);

        Pushbullet.setAccessToken(token);

        // Start loading informations in background
        loadData();

        // Show beta warning message
        if(settings.getSetting("beta") && settings.getSetting("show-beta-message"))
            PopupUtils.open(Qt.resolvedUrl("./components/dialogs/BetaWarningDialog.qml"));
    }
}


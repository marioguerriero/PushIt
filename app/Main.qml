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

import "components"
import "components/pages"

import "js/Pushbullet.js" as Pushbullet

MainView {
    objectName: "mainView"
    applicationName: "pushit.mefrio"

    // Removes the old toolbar and enables new features of the new header.
    useDeprecatedToolbar: false

    width: units.gu(100)
    height: units.gu(75)

    //backgroundColor: "#27AE60"

    PageStack {
        id: stack

        Tabs {
            id: tabs
            Tab { title: page.title; page: PushesPage { id: pushesPage } }
            Tab { title: page.title; page: ContactsPage { id: contactsPage } }
            Tab { title: page.title; page: DevicesPage { id: devicesPage } }
            Tab { title: page.title; page: SubscriptionsPage { id: subscriptionsPage } }
        }

        AuthPage {
            id: authPage
            visible: false
        }
    }

    Data {
        id: data
    }

    Settings {
        id: settings

        Component.onCompleted: init();
    }

    Component.onCompleted: {
        var token = settings.getSetting("token");
        settings.setSetting("token", token);
        if(token == null)
            stack.push(authPage);
        else
            stack.push(tabs);
        Pushbullet.setAccessToken(token);

        // Start loading informations in background
        devicesPage.loading = true;
        Pushbullet.getDevices(devicesPage.loadData);

        contactsPage.loading = true;
        Pushbullet.getContacts(contactsPage.loadData);

        subscriptionsPage.loading = true;
        Pushbullet.getSubscriptions(subscriptionsPage.loadData);
    }
}


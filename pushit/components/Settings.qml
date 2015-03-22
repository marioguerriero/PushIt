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
import U1db 1.0 as U1db

Item {
    id: root

    U1db.Database {
        id: storage
        path: "settingsdb"
    }

    U1db.Document {
        id: settings

        database: storage
        docId: 'settingsdb'
        create: true

        defaults: {
            token: null;
            beta: true;
            show_beta_message: true;
        }
    }

    // Set settings to default if they are not set
    function init() {
        var value = getSetting("token");
        if(value === undefined) {
            setSetting("token", null);
        }
        value = getSetting("beta");
        if(value === undefined) {
            setSetting("beta", true);
        }
        value = getSetting("show_beta_message");
        if(value === undefined) {
            setSetting("show_beta_message", true);
        }
    }

    function getSetting(name) {
        var tempContents = {};
        tempContents = settings.contents;
        return tempContents.hasOwnProperty(name) ? tempContents[name] : settings.defaults[name];
    }

    function setSetting(name, value) {
        if (getSetting(name) !== value) {
            var tempContents = {};
            tempContents = settings.contents;
            tempContents[name] = value;
            settings.contents = tempContents;
        }
    }
}

/*
 * Flashback - Entertainment app for Ubuntu
 * Copyright (C) 2013, 2014 Nekhelesh Ramananthan <nik90@ubuntu.com>
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License version 3 as
 * published by the Free Software Foundation.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
 *
 */

import QtQuick 2.3
import Ubuntu.Components 0.1
import ".."

// Initial Walkthrough tutorial
Walkthrough {
    id: walkthrough
    anchors.fill: parent
    visible: false

    appName: "Pushit"
    property bool logged: false

    onFinished: {
        stack.pop();
        stack.push(tabs);
        main.loadToken();
        main.loadData();
        settings.setSetting("show-walkthrough", false);
    }

    model: [
        Slide1{},
        Slide2{},
        Slide3{},
        Slide4{}
    ]
}

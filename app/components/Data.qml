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

QtObject {
    property var pushes
    property var devices
    property var contacts
    property var subscriptions
    property var user

    property string googleImgDomain: "googleusercontent.com"
    property string facebookImgDomain: "graph.facebook.com"
    property string pushbulletImgDomain: "pushbullet.imgix.net"

    function getIconSourceFromIden(iden, size) {
        if(size == null) size = 200;

        // Is it from user himself?
        if(user != null && user.iden == iden) return resizeImg(user.image_url, size);

        // Is it from a subscribed channel?
        for(var n = 0; n < subscriptions.length; n++) {
            var subscription = subscriptions[n];
            if(subscription.channel != null && subscription.channel.iden == iden) {
                return resizeImg(subscription.channel.image_url, size);
            }
        }

        return resizeImg(user.image_url, size); // TODO: fallback to something
    }

    function resizeImg(url, size) {
        if(url.indexOf(googleImgDomain) != -1) {
            return url + "?sz=" + size;
        }
        else if(url.indexOf(facebookImgDomain) != -1) {
            return url + "?width=" + size + "&height=" + size;
        }
        else if(url.indexOf(pushbulletImgDomain) != -1) {
            return url + "?w=" + size + "&h=" + size + "&fit=crop";
        }
        return url;
    }
}

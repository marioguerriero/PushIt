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

.pragma library

var access_token = null;
var api = "https://api.pushbullet.com/v2/";
var pushes = "pushes";
var devices = "devices";
var contacts = "contacts";
var subscriptions = "subscriptions";
var me = "users/me";

// Utility

function uploadFile(path, mimetype) {
    if(access_token == null) {
        console.log("WARNING: access_token not set");
        return;
    }
}

function setAccessToken(token) {
    access_token = token;
}

// Pushes

function push(type, dev, email, data, callback) {
    if(access_token == null) {
        console.log("WARNING: access_token not set");
        return;
    }
}

function deletePush(iden, callback) {
    if(access_token == null) {
        console.log("WARNING: access_token not set");
        return;
    }
}

function deleteAllPushes(callback) {
    if(access_token == null) {
        console.log("WARNING: access_token not set");
        return;
    }
}

function pushNote(dev, email, data, callback) {
    push("note", dev, data);
}

function pushLink(dev, email, data, callback) {
    push("link", dev, data);
}

function pushFile(dev, email, data, callback) {
    uploadFile(data.file_name, data.file_type);
    push("file", dev, data);
}

function getPushes(modified_after, active, callback) {
    if(access_token == null) {
        console.log("WARNING: access_token not set");
        return;
    }

    var http = new XMLHttpRequest();
    var params = "modified_after=" + modified_after;
    if(active == true) params += "&active";
    http.open("GET", api + pushes, true, access_token);

    http.onreadystatechange = function() {
        if(http.status == 200 && http.readyState == 4) // OK
            callback(http.responseText);
        if(http.status == 401); // UNAUTHORIZED
        if(http.status == 403); // FORBIDDEN
        if(http.status > 500); // SERVER ERROR
    };
    http.send(params);
}

// Devices

function getDevices(callback) {
    if(access_token == null) {
        console.log("WARNING: access_token not set");
        return;
    }

    var http = new XMLHttpRequest();
    http.open("GET", api + devices, true, access_token);

    http.onreadystatechange = function() {
        if(http.status == 200 && http.readyState == 4) // OK
            callback(http.responseText);
        if(http.status == 401); // UNAUTHORIZED
        if(http.status == 403); // FORBIDDEN
        if(http.status > 500); // SERVER ERROR
    };
    http.send(null);
}

function deleteDevice(iden, callback) {
    if(access_token == null) {
        console.log("WARNING: access_token not set");
        return;
    }
}

// Contacts

function getContacts(callback) {
    if(access_token == null) {
        console.log("WARNING: access_token not set");
        return;
    }

    var http = new XMLHttpRequest();
    http.open("GET", api + contacts, true, access_token);

    http.onreadystatechange = function() {
        if(http.status == 200 && http.readyState == 4) // OK
            callback(http.responseText);
        if(http.status == 401); // UNAUTHORIZED
        if(http.status == 403); // FORBIDDEN
        if(http.status > 500); // SERVER ERROR
    };
    http.send(null);
}

function addContact(name, email, callback) {
    if(access_token == null) {
        console.log("WARNING: access_token not set");
        return;
    }
}

function deleteContact(iden, callback) {
    if(access_token == null) {
        console.log("WARNING: access_token not set");
        return;
    }
}

// Subscriptions

function getSubscriptions(callback) {
    if(access_token == null) {
        console.log("WARNING: access_token not set");
        return;
    }

    var http = new XMLHttpRequest();
    http.open("GET", api + subscriptions, true, access_token);

    http.onreadystatechange = function() {
        if(http.status == 200 && http.readyState == 4) // OK
            callback(http.responseText);
        if(http.status == 401); // UNAUTHORIZED
        if(http.status == 403); // FORBIDDEN
        if(http.status > 500); // SERVER ERROR
    };
    http.send(null);
}

function subscribe(tag, callback) {
    if(access_token == null) {
        console.log("WARNING: access_token not set");
        return;
    }

    var http = new XMLHttpRequest();
    var params = { "channel_tag": tag };
    http.open("POST", api + subscriptions, true, access_token);

    //Send the proper header information along with the request
    http.setRequestHeader("Content-type", "application/json");
    http.setRequestHeader("Content-length", params.length);
    http.setRequestHeader("Connection", "close");

    http.onreadystatechange = function() {
        if(http.status == 200 && http.readyState == 4) // OK
            callback(http.responseText);
        if(http.status == 401); // UNAUTHORIZED
        if(http.status == 403); // FORBIDDEN
        if(http.status > 500); // SERVER ERROR
    };
    http.send(JSON.stringify(params));
}

function deleteSubscription(iden, callback) {
    if(access_token == null) {
        console.log("WARNING: access_token not set");
        return;
    }

    var http = new XMLHttpRequest();
    var params = "/" + iden;
    http.open("DELETE", api + subscriptions + params, true, access_token);

    http.onreadystatechange = function() {
        if(http.status == 200 && http.readyState == 4) // OK
            callback(http.responseText);
        if(http.status == 401); // UNAUTHORIZED
        if(http.status == 403); // FORBIDDEN
        if(http.status > 500); // SERVER ERROR
    };
    http.send(null);
}

// User

function getUserInformations(callback) {
    if(access_token == null) {
        console.log("WARNING: access_token not set");
        return;
    }

    var http = new XMLHttpRequest();
    http.open("GET", api + me, true, access_token);

    http.onreadystatechange = function() {
        if(http.status == 200 && http.readyState == 4) // OK
            callback(http.responseText);
        if(http.status == 401); // UNAUTHORIZED
        if(http.status == 403); // FORBIDDEN
        if(http.status > 500); // SERVER ERROR
    };
    http.send(null);
}

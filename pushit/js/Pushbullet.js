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
var file_server = "https://s3.amazonaws.com/pushbullet-uploads";
var pushes = "pushes";
var devices = "devices";
var contacts = "contacts";
var subscriptions = "subscriptions";
var me = "users/me";
var upload_request = "upload-request";

// Utility
function requestUploadAuthorization(path, mimetype, callback) {
    if(access_token == null) {
        console.log("WARNING: access_token not set");
        return;
    }

    var http = new XMLHttpRequest();
    var params = "file_name=" + path + "&file_type=" + mimetype;
    http.open("POST", api + upload_request, true, access_token);

    //Send the proper header information along with the request
    http.setRequestHeader("Content-type", "application/x-www-form-urlencoded");
    http.setRequestHeader("Content-length", params.length);
    http.setRequestHeader("Connection", "close");

    http.onreadystatechange = function() {
        if(http.status == 200 && http.readyState == 4) // OK
            callback(http.responseText, null);
        if(http.status == 401) // UNAUTHORIZED
            callback(http.statusText, http.status);
        if(http.status == 403) // FORBIDDEN
            callback(http.statusText, http.status);
        if(http.status > 500) // SERVER ERROR
            callback(http.statusText, http.status);
    };
    http.send(params);
}

function uploadFile(path, mimetype, callback) {
    if(access_token == null) {
        console.log("WARNING: access_token not set");
        return;
    }

    // Create an upload function which will upload the file
    var upload = function(data, error) {
        if(error != null) {
            return;
        }

        var http = new XMLHttpRequest();
        var json = JSON.parse(data);

        var params = "";
        var boundary = Math.random().toString().substr(2);
        for(var key in json.data) {
            params += "--" + boundary
                    + "\r\nContent-Disposition: form-data; name=" + key
                    + "\r\n\r\n" + json.data[key] + "\r\n";
        }
        params += "--" + boundary
                + "\r\nContent-Disposition: form-data; name=" + "file"
                + "\r\n\r\n@" + json.file_name + "\r\n";
        params += "--" + boundary + "--\r\n";

        http.open("POST", file_server, true, access_token);

        //Send the proper header information along with the request
        http.setRequestHeader("Content-type", "multipart/form-data; charset=utf-8; boundary=" + boundary);

        http.onreadystatechange = function() {
            if(http.status == 200 && http.readyState == 4) // OK
                callback(data, null);
            if(http.status == 401) // UNAUTHORIZED
                callback(http.statusText, http.status);
            if(http.status == 403) // FORBIDDEN
                callback(http.statusText, http.status);
            if(http.status > 500) // SERVER ERROR
                callback(http.statusText, http.status);
            console.log("Logging: " + http.status + " " + http.statusText)
        };
        http.send(params);
    };

    // Request authorization for uploading file
    // If authorization is grant, upload the file
    requestUploadAuthorization(path, mimetype, upload);
}

function setAccessToken(token) {
    access_token = token;
}

// Pushes

function push(data, callback) {
    if(access_token == null) {
        console.log("WARNING: access_token not set");
        return;
    }

    var http = new XMLHttpRequest();
    var params = JSON.stringify(data);
    http.open("POST", api + pushes, true, access_token);

    //Send the proper header information along with the request
    http.setRequestHeader("Content-type", "application/json");
    http.setRequestHeader("Content-length", params.length);
    http.setRequestHeader("Connection", "close");

    http.onreadystatechange = function() {
        if(http.status == 200 && http.readyState == 4) // OK
            callback(http.responseText, null);
        if(http.status == 401) // UNAUTHORIZED
            callback(http.statusText, http.status);
        if(http.status == 403) // FORBIDDEN
            callback(http.statusText, http.status);
        if(http.status > 500) // SERVER ERROR
            callback(http.statusText, http.status);
    };
    http.send(params);
}

function deletePush(iden, callback) {
    if(access_token == null) {
        console.log("WARNING: access_token not set");
        return;
    }

    var http = new XMLHttpRequest();
    var params = "/" + iden;
    http.open("DELETE", api + pushes + params, true, access_token);

    http.onreadystatechange = function() {
        if(http.status == 200 && http.readyState == 4) // OK
            callback(http.responseText, null);
        if(http.status == 401) // UNAUTHORIZED
            callback(http.statusText, http.status);
        if(http.status == 403) // FORBIDDEN
            callback(http.statusText, http.status);
        if(http.status > 500) // SERVER ERROR
            callback(http.statusText, http.status);
    };
    http.send(null);
}

function deleteAllPushes(callback) {
    if(access_token == null) {
        console.log("WARNING: access_token not set");
        return;
    }

    var http = new XMLHttpRequest();
    http.open("DELETE", api + pushes, true, access_token);

    http.onreadystatechange = function() {
        if(http.status == 200 && http.readyState == 4) // OK
            callback(http.responseText, null);
        if(http.status == 401) // UNAUTHORIZED
            callback(http.statusText, http.status);
        if(http.status == 403) // FORBIDDEN
            callback(http.statusText, http.status);
        if(http.status > 500) // SERVER ERROR
            callback(http.statusText, http.status);
    };
    http.send(null);
}

function getPushes(callback) {
    if(access_token == null) {
        console.log("WARNING: access_token not set");
        return;
    }

    var http = new XMLHttpRequest();
    var params = "modified_after=0";
    params += "&active";
    http.open("GET", api + pushes, true, access_token);

    http.onreadystatechange = function() {
        if(http.status == 200 && http.readyState == 4) // OK
            callback(http.responseText, null);
        if(http.status == 401) // UNAUTHORIZED
            callback(http.statusText, http.status);
        if(http.status == 403) // FORBIDDEN
            callback(http.statusText, http.status);
        if(http.status > 500) // SERVER ERROR
            callback(http.statusText, http.status);
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
            callback(http.responseText, null);
        if(http.status == 401) // UNAUTHORIZED
            callback(http.statusText, http.status);
        if(http.status == 403) // FORBIDDEN
            callback(http.statusText, http.status);
        if(http.status > 500) // SERVER ERROR
            callback(http.statusText, http.status);
    };
    http.send(null);
}

function addDevice(data, callback) {
    if(access_token == null) {
        console.log("WARNING: access_token not set");
        return;
    }

    var http = new XMLHttpRequest();
    var params = "nickname=" + data.nickname + "&type=" + data.type;
    console.log(data)
    http.open("POST", api + devices, true, access_token);

    //Send the proper header information along with the request
    http.setRequestHeader("Content-type", "application/x-www-form-urlencoded");
    http.setRequestHeader("Content-length", params.length);
    http.setRequestHeader("Connection", "close");

    http.onreadystatechange = function() {
        if(http.status == 200 && http.readyState == 4) // OK
            callback(http.responseText, null);
        if(http.status == 401) // UNAUTHORIZED
            callback(http.statusText, http.status);
        if(http.status == 403) // FORBIDDEN
            callback(http.statusText, http.status);
        if(http.status > 500) // SERVER ERROR
            callback(http.statusText, http.status);
    };
    http.send(params);
}

function deleteDevice(iden, callback) {
    if(access_token == null) {
        console.log("WARNING: access_token not set");
        return;
    }

    var http = new XMLHttpRequest();
    var params = "/" + iden;
    http.open("DELETE", api + devices + params, true, access_token);

    http.onreadystatechange = function() {
        if(http.status == 200 && http.readyState == 4) // OK
            callback(http.responseText, null);
        if(http.status == 401) // UNAUTHORIZED
            callback(http.statusText, http.status);
        if(http.status == 403) // FORBIDDEN
            callback(http.statusText, http.status);
        if(http.status > 500) // SERVER ERROR
            callback(http.statusText, http.status);
    };
    http.send(null);
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
            callback(http.responseText, null);
        if(http.status == 401) // UNAUTHORIZED
            callback(http.statusText, http.status);
        if(http.status == 403) // FORBIDDEN
            callback(http.statusText, http.status);
        if(http.status > 500) // SERVER ERROR
            callback(http.statusText, http.status);
    };
    http.send(null);
}

function addContact(data, callback) {
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
            callback(http.responseText, null);
        if(http.status == 401) // UNAUTHORIZED
            callback(http.statusText, http.status);
        if(http.status == 403) // FORBIDDEN
            callback(http.statusText, http.status);
        if(http.status > 500) // SERVER ERROR
            callback(http.statusText, http.status);
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
            callback(http.responseText, null);
        if(http.status == 401) // UNAUTHORIZED
            callback(http.statusText, http.status);
        if(http.status == 403) // FORBIDDEN
            callback(http.statusText, http.status);
        if(http.status > 500) // SERVER ERROR
            callback(http.statusText, http.status);
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
            callback(http.responseText, null);
        if(http.status == 401) // UNAUTHORIZED
            callback(http.statusText, http.status);
        if(http.status == 403) // FORBIDDEN
            callback(http.statusText, http.status);
        if(http.status > 500) // SERVER ERROR
            callback(http.statusText, http.status);
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
            callback(http.responseText, null);
        if(http.status == 401) // UNAUTHORIZED
            callback(http.statusText, http.status);
        if(http.status == 403) // FORBIDDEN
            callback(http.statusText, http.status);
        if(http.status > 500) // SERVER ERROR
            callback(http.statusText, http.status);
    };
    http.send(null);
}

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

var client_id = "jgYMK0ECO233wtziTCGYTjeis1nfCVdN";
var accepted_uri = "https://www.pushbullet.com/login-success";
var auth_link = "https://www.pushbullet.com/authorize?client_id=" + client_id +
    "&redirect_uri=" + encodeURI(accepted_uri) + "&response_type=token";

function getAuthUri() {
    return auth_link;
}

function getAccessToken(uri) {
    var url = uri.replace("#", "&");
    if(url.indexOf(accepted_uri) == -1) return null;
    return getURLParameter(url, "access_token");
}

function getAccessError(uri) {
    return getURLParameter(uri, "error");
}

function getURLParameter(url, name) {
  return decodeURIComponent((new RegExp('[?|&]' + name + '=' + '([^&;]+?)(&|#|;|$)').exec(url)||[,""])[1].replace(/\+/g, '%20'))||null;
}

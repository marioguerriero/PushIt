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

#include "FileUploader.h"

#include<QDebug>

#include<QMimeDatabase>
#include<QFile>

#include<QHttpMultiPart>
#include<QHttpPart>
#include<QNetworkAccessManager>

FileUploader::FileUploader(QObject *parent) :
    QObject(parent) {
    mPath = NULL;
}

FileUploader::~FileUploader() {
    delete mPath;
}

void FileUploader::upload() {
    if(!mPath) {
        qDebug() << "ERROR: File path not set";
    }
    else {
        QHttpMultiPart *multiPart = new QHttpMultiPart(QHttpMultiPart::FormDataType);

        QFile *file = new QFile("image.jpg");

        QHttpPart filePart;
        filePart.setHeader(QNetworkRequest::ContentDispositionHeader, QVariant("form-data; name=\"file\""));
        filePart.setBody(file->fileName().toLocal8Bit());

        QHttpPart typePart;
        typePart.setHeader(QNetworkRequest::ContentDispositionHeader, QVariant("form-data; name=\"content-type\""));
        typePart.setBody(mimeType().toLocal8Bit());

        file->setParent(multiPart); // we cannot delete the file now, so delete it with the multiPart

        multiPart->append(filePart);
        multiPart->append(typePart);

        QUrl url(api);
        QNetworkRequest request(url);

        QNetworkAccessManager manager;
        QNetworkReply *reply = manager.post(request, multiPart);
        multiPart->setParent(reply); // delete the multiPart with the reply

        connect(reply, SIGNAL(uploadProgress(qint64,qint64)), this, SLOT(uploadProgress(qint64,qint64)));
        connect(reply, SIGNAL(error(QNetworkReply::NetworkError)), this, SLOT(onError(QNetworkReply::NetworkError)));
        connect(reply, SIGNAL(finished()), this, SLOT(uploadFinished()));
    }
}

void FileUploader::uploadFinished() {
    QString data = (QString) reply->readAll();
    qDebug() << data;
    qDebug() << "Upload finished";

    if (reply->error() > 0) {
        qDebug() << "Error occured: " << reply->error() << " : " << reply->errorString();
    }
    else {
        qDebug() << "Upload success";
    }
}

void FileUploader::onUploadProgress(qint64 a, qint64 b) {
    qDebug() << a  << "/" << b;
}

void FileUploader::onError(QNetworkReply::NetworkError err) {
    qDebug() << err;
}

// File utils
QString FileUploader::mimeType() {
    if(!mPath) {
        qDebug() << "ERROR: File path not set";
        return NULL;
    }

    return QMimeDatabase().mimeTypeForFile(*mPath).name();
}

void FileUploader::setPath(QString path) {
    *mPath = path;
    Q_EMIT pathChanged();
}

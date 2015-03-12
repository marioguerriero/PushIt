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

#include "File.h"

#include <QMimeDatabase>
#include <QMimeType>
#include <QFileInfo>

File::File(QObject *parent) :
    QObject(parent)
{
    mFile = NULL;
}

File::~File() {
    mFile = NULL;
}

QString File::mimeType() {
    if(!mFile) return NULL;

    QMimeDatabase mimeDb;
    QMimeType mimeType;

    mimeType = mimeDb.mimeTypeForFile(QFileInfo(*mFile));

    return mimeType.name();
}

void File::setPath(QString path)
{
    mPath = path;
    mFile = new QFile(path);
    Q_EMIT pathChanged();
}

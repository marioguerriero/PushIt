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

#ifndef FILE_H
#define FILE_H

#include <QObject>
#include <QFile>

class File : public QObject
{
    Q_OBJECT
    Q_PROPERTY( QString path READ path WRITE setPath NOTIFY pathChanged )
    Q_PROPERTY( QString mimeType READ mimeType )

public:
    explicit File(QObject *parent = 0);
    ~File();

Q_SIGNALS:
    void pathChanged();

protected:
    QString path() { return mPath; }
    void setPath(QString path);

    QString mimeType();

    QString mPath;
    QString mType;

    QFile* mFile;
};

#endif // FILE_H


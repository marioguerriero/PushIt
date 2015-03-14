TEMPLATE = aux
TARGET = pushit

RESOURCES += pushit.qrc

QML_FILES += $$files(*.qml,true) \
					   $$files(*.js,true)

CONF_FILES +=  pushit.apparmor \
               pushit.desktop \
               pushit.png

OTHER_FILES += $${CONF_FILES} \
               $${QML_FILES} \
    components/dialogs/DeviceSelectorDialog.qml

#specify where the qml/js files are installed to
qml_files.path = /pushit
qml_files.files += $${QML_FILES}

#specify where the config files are installed to
config_files.path = /pushit
config_files.files += $${CONF_FILES}

INSTALLS+=config_files qml_files


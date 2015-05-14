TEMPLATE = aux
TARGET = pushit

RESOURCES += pushit.qrc

QML_FILES += $$files(*.qml) \
             $$files(*.js)

COMPONENT_FILES += $$files(components/*.qml) \
                   $$files(components/*.js)

DIALOGS_FILES += $$files(components/dialogs/*.qml) \
                 $$files(components/dialogs/*.js)

PAGES_FILES += $$files(components/pages/*.qml) \
               $$files(components/pages/*.js)

JS_FILES += $$files(js/*.qml) \
            $$files(js/*.js)

CONF_FILES +=  pushit.apparmor \
               pushit.desktop \
               pushit.png

OTHER_FILES += $${QML_FILES} \
               $${DIALOGS_FILES} \
               $${PAGES_FILES} \
               $${JS_FILES} \
               $${CONF_FILES} \
    components/Slide2.qml

#specify where the qml/js files are installed to
qml_files.path = /pushit
qml_files.files += $${QML_FILES}

component_files.path = /pushit/components
component_files.files += $${COMPONENT_FILES}

dialog_files.path = /pushit/components/dialogs
dialog_files.files += $${DIALOGS_FILES}

pages_files.path = /pushit/components/pages
pages_files.files += $${PAGES_FILES}

js_files.path = /pushit/js
js_files.files += $${JS_FILES}

#specify where the config files are installed to
config_files.path = /pushit
config_files.files += $${CONF_FILES}

INSTALLS += qml_files component_files dialog_files pages_files js_files config_files


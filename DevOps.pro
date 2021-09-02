QT += quick quickcontrols2 network svg

CONFIG += c++11

emscripten {
    message("Building for WebAssembly")
    CONFIG += wasmOauth2
} else {
    message("Building for Generic")
    CONFIG += oauth2
}

message($$CONFIG)

oauth2 {
    QT += networkauth
    SOURCES += \
            src/Auth.cpp
    HEADERS += \
            src/Auth.h
    DEFINES += OAUTH2
}

wasmOauth2 {
    SOURCES += \
            src/WASMAuth.cpp
    HEADERS += \
            src/WASMAuth.h

    DEFINES += WASM_OAUTH2

    QMAKE_LFLAGS += -s ASYNCIFY=1
    QMAKE_LFLAGS += -s 'ASYNCIFY_IMPORTS=["getUser"]'
    QMAKE_LFLAGS += -s EXPORTED_FUNCTIONS="['_main','_get_config','_set_token']"
    QMAKE_LFLAGS += -g2
    QMAKE_LFLAGS += -s SAFE_HEAP=1
    QMAKE_LFLAGS += -s ERROR_ON_UNDEFINED_SYMBOLS=0

    QMAKE_CXXFLAGS += --js-library oidc-client.js
    QMAKE_CXXFLAGS += -s ASYNCIFY=1
    QMAKE_CXXFLAGS += -s 'ASYNCIFY_IMPORTS=["getUser"]'
    QMAKE_CXXFLAGS += -s EXPORTED_FUNCTIONS="['_main','_get_config','_set_token']"
    QMAKE_CXXFLAGS += -g2
    QMAKE_CXXFLAGS += -s SAFE_HEAP=1
    QMAKE_CXXFLAGS += -s ERROR_ON_UNDEFINED_SYMBOLS=0
}

# external projects
include("./external/SortFilterProxyModel/SortFilterProxyModel.pri")

android {
    message("Include OpenSSL libs for Android")
    include("./external/android_openssl/openssl.pri")
}

# The following define makes your compiler emit warnings if you use
# any Qt feature that has been marked deprecated (the exact warnings
# depend on your compiler). Refer to the documentation for the
# deprecated API to know how to port your code away from it.
DEFINES += QT_DEPRECATED_WARNINGS

# You can also make your code fail to compile if it uses deprecated APIs.
# In order to do so, uncomment the following line.
# You can also select to disable deprecated APIs only up to a certain version of Qt.
# DEFINES += QT_DISABLE_DEPRECATED_BEFORE=0x060000    # disables all the APIs deprecated before Qt 6.0.0

SOURCES += \
        src/AuthAbstract.cpp \
        src/OAuth2Config.cpp \
        src/asyncsettings.cpp \
        src/main.cpp

RESOURCES += qml.qrc \
    application.qrc

TRANSLATIONS += \
    linguist/DevOps_fr_CA.ts

# Additional import path used to resolve QML modules in Qt Creator's code model
QML_IMPORT_PATH =

# Additional import path used to resolve QML modules just for Qt Quick Designer
QML_DESIGNER_IMPORT_PATH =

# Default rules for deployment.
qnx: target.path = /tmp/$${TARGET}/bin
else: unix:!android: target.path = /opt/$${TARGET}/bin
!isEmpty(target.path): INSTALLS += target

HEADERS += \
    src/AuthAbstract.h \
    src/OAuth2Config.h \
    src/asyncsettings.h

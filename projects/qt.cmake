set(qt_url https://download.qt.io/archive/qt/6.2/6.2.0/single/qt-everywhere-src-6.2.0.tar.xz)
set(qt_SHA256 60c2dc0ee86dd338e5c5194bd95922abfc097841e3e855693dfb4f5aaf0db4db)

if(BUILD_OS_WINDOWS)
    # For some as of yet unknown reason, building Qt on Windows fails because it does not create moc targets.
    # Due to that we install the PyQt wheel into the built Python manually.
    return()
endif()

set(_qt_configure_cmd "./configure")
set(qt_options
    -release
    -prefix ${CMAKE_INSTALL_PREFIX}
    -archdatadir ${CMAKE_INSTALL_PREFIX}/lib
    -datadir ${CMAKE_INSTALL_PREFIX}/share
    -opensource
    -confirm-license
    -nomake examples
    -nomake tests
    -nomake tools
    -no-cups
    -no-sql-db2
    -no-sql-ibase
    -no-sql-mysql
    -no-sql-oci
    -no-sql-odbc
    -no-sql-psql
    -no-sql-sqlite
    -skip qtconnectivity
    -skip qtdoc
    -skip qtlocation
    -skip qtmultimedia
    -skip qtscript
    -skip qtsensors
    -skip qtwebchannel
    -skip qtwebengine
    -skip qtandroidextras
    -skip qtactiveqt
    -skip qttools
    -skip qtxmlpatterns
    -skip qt3d
    -skip qtcanvas3d
    -skip qtserialport
    -skip qtwayland
    -skip qtgamepad
    -skip qtscxml
)

if(BUILD_OS_OSX)
    list(APPEND qt_options -no-framework)
    if(CURA_OSX_SDK_VERSION)
        list(APPEND qt_options -sdk macosx${CURA_OSX_SDK_VERSION})
    endif()
    set(_qt_config_cmd ${CMAKE_SOURCE_DIR}/projects/qt-patch-macosx-target.sh && ${_qt_configure_cmd})
elseif(BUILD_OS_WINDOWS)
    list(APPEND qt_options -opengl desktop)
elseif(BUILD_OS_LINUX)
    list(APPEND qt_options
	 -rpath
	 -pkg-config
	 -opengl desktop -no-gtk
	 -fontconfig
	 -system-freetype
	 -system-zlib
	 -ssl -openssl-runtime
	 -xcb -xcb-xlib  # To build the xcb platform plug-in, found in https://forum.qt.io/topic/115827/build-on-linux-qt-xcb-option/16
	 -I "${CMAKE_INSTALL_PREFIX}/include"
	 -L "${CMAKE_INSTALL_PREFIX}/lib")
endif()

ExternalProject_Add(Qt
    URL ${qt_url}
    URL_HASH SHA256=${qt_SHA256}
    CONFIGURE_COMMAND ${_qt_configure_cmd} ${qt_options}
    BUILD_IN_SOURCE 1
    DEPENDS OpenSSL
)

set(pyqt_command "")
if(NOT BUILD_OS_WINDOWS)
    # Building PyQt on Windows is problematic due to linking against specific Windows libraries.
    # Instead, we'll use the less favourable approach of installation via Pip, which drags PyPI into the circle of trust.
    # See requirements.txt for installing on windows with pip
    # TODO: PyPi is already in out circle of trust why not use the same approach for the Linux and MacOS
    if(BUILD_OS_OSX)
        set(pyqt_command
            "DYLD_LIBRARY_PATH=${CMAKE_INSTALL_PREFIX}/lib"
            ${Python3_EXECUTABLE} configure.py
            --sysroot ${CMAKE_INSTALL_PREFIX}
            --qmake ${CMAKE_INSTALL_PREFIX}/bin/qmake
            --sip ${CMAKE_INSTALL_PREFIX}/bin/sip
            --confirm-license
        )
    else()
        set(pyqt_command
            # On Linux, PyQt configure fails because it creates an executable that does not respect RPATH
            "LD_LIBRARY_PATH=${CMAKE_INSTALL_PREFIX}/lib"
            ${Python3_EXECUTABLE} configure.py
            --sysroot ${CMAKE_INSTALL_PREFIX}
            --qmake ${CMAKE_INSTALL_PREFIX}/bin/qmake
            --sip ${CMAKE_INSTALL_PREFIX}/bin/sip
            --confirm-license
        )
    endif()

    ExternalProject_Add(PyQt
        URL https://files.pythonhosted.org/packages/63/14/342909751d8cb6931ca1548a9834f5f581c69c2bc5836e65a8aeee9f1bb7/PyQt6-6.2.0.tar.gz
        URL_HASH SHA256=142ce7fa574d7ebb13fb0a2ebd18c86087c35829f786c094a71a0749155d8fee
        CONFIGURE_COMMAND ${pyqt_command}
        BUILD_IN_SOURCE 1
    )

    SetProjectDependencies(TARGET PyQt DEPENDS Qt Sip)

endif()

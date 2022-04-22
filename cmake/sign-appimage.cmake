# Copyright (c) 2022 Ultimaker B.V.
# Cura's build system is released under the terms of the AGPLv3 or higher.

add_custom_target(signing ALL COMMENT "Create the asc file for the AppImage file.")
add_custom_command(
        TARGET
            signing
        COMMAND sha256sum ${installer_DIR}/dist/${INSTALLER_FILENAME} >> ${installer_DIR}/dist/${INSTALLER_BASE_FILENAME}.asc)
add_dependencies(signing packaging)
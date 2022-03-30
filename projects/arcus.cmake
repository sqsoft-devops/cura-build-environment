# Copyright (c) 2022 Ultimaker B.V.
# cura-build-environment is released under the terms of the AGPLv3 or higher.

GetFromEnvironmentOrCache(
		NAME
			ARCUS_BRANCH_OR_TAG
		DEFAULT
			master
		DESCRIPTION
			"The name of the tag or branch to build for Arcus")

ExternalProject_Add(Arcus
		GIT_REPOSITORY https://github.com/ultimaker/libArcus.git
		GIT_TAG origin/${ARCUS_BRANCH_OR_TAG}
		CMAKE_ARGS -DCMAKE_BUILD_TYPE=${CMAKE_BUILD_TYPE}
				   -DCMAKE_INSTALL_PREFIX=${CMAKE_INSTALL_PREFIX}
				   -DCMAKE_PREFIX_PATH=${CMAKE_INSTALL_PREFIX}
				   -DSIP_BUILD_EXECUTABLE=sip-build
				   -DPython_SITEARCH=${Python_SITEARCH}
				   -DCMAKE_TOOLCHAIN_FILE=${CMAKE_BINARY_DIR}/${CMAKE_TOOLCHAIN_FILE}
		DEPENDS Python)

# /tests/FromParentInExternalProject.cmake
#
# Find Google Mock normally (preferring a
# source build so that we download it)
# and build it as an external project. Then
# add a new external project and inject
# the Google Mock paths into its cache and
# have it build a simple test.
#
# See LICENCE.md for Copyright information.

include (CMakeUnit)

set (GTEST_PREFER_SOURCE_BUILD ON CACHE BOOL "" FORCE)
set (GMOCK_PREFER_SOURCE_BUILD ON CACHE BOOL "" FORCE)
find_package (GoogleMock REQUIRED)

set (EXTERNAL_PROJECT_CMAKELISTS_TXT_CONTENT
	 "project (External)\n"
	 "cmake_minimum_required (VERSION ${CMAKE_MINIMUM_REQUIRED_VERSION})\n")

foreach (PATH ${CMAKE_MODULE_PATH})
    set (EXTERNAL_PROJECT_CMAKELISTS_TXT_CONTENT
         "${EXTERNAL_PROJECT_CMAKELISTS_TXT_CONTENT}"
         "set (CMAKE_MODULE_PATH\n"
         "     ${PATH}\n"
         "     \${CMAKE_MODULE_PATH})\n")
endforeach ()

set (EXTERNAL_PROJECT_CMAKELISTS_TXT_CONTENT
     "${EXTERNAL_PROJECT_CMAKELISTS_TXT_CONTENT}\n"
     "find_package (GoogleMock REQUIRED)\n"
	 "include (AddSimpleGTestHelper)")

set (EXTERNAL_PROJECT_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}/External)
set (EXTERNAL_PROJECT_BINARY_DIRECTORY ${EXTERNAL_PROJECT_DIRECTORY}/build)
set (EXTERNAL_PROJECT_CMAKELISTS_TXT
	 ${EXTERNAL_PROJECT_DIRECTORY}/CMakeLists.txt)
file (MAKE_DIRECTORY ${EXTERNAL_PROJECT_DIRECTORY})
file (WRITE ${EXTERNAL_PROJECT_CMAKELISTS_TXT}
	  ${EXTERNAL_PROJECT_CMAKELISTS_TXT_CONTENT})

include (ExternalProject)

set (CACHE_DEFINITIONS)
set (PROJECT_DEPENDENCIES)
google_mock_get_cache_lines_and_deps_from_found (CACHE_DEFINITIONS
                                                 PROJECT_DEPENDENCIES)

ExternalProject_Add (ExternalLibraryUsingGTest
	                 SOURCE_DIR ${EXTERNAL_PROJECT_DIRECTORY}
	                 BINARY_DIR ${EXTERNAL_PROJECT_BINARY_DIRECTORY}
	                 CMAKE_CACHE_ARGS ${CACHE_DEFINITIONS}
	                 INSTALL_COMMAND "")

add_dependencies (ExternalLibraryUsingGTest
	                ${PROJECT_DEPENDENCIES})
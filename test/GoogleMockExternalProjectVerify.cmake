# /tests/GoogleMockExternalProjectVerify.cmake
# Tests that the test was correctly added and
# built as a result of building it
#
# See LICENCE.md for Copyright information

include (CMakeUnit)
include (GetBuildDirectorySuffixForGeneratorHelper)

set (BUILD_SUFFIX)
_get_build_directory_suffix_for_generator (BUILD_SUFFIX)

set (TEST_BINARY ${CMAKE_CURRENT_BINARY_DIR}/${BUILD_SUFFIX}/simple_test)
assert_command_executes_with_success (TEST_BINARY)
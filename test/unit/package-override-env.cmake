include(CMakePackageConfigHelpers)
include(${CPM_PATH}/testing.cmake)

set(TEST_BUILD_DIR_OFF ${CMAKE_CURRENT_BINARY_DIR}/project-override-env-off)
set(TEST_BUILD_DIR_ON ${CMAKE_CURRENT_BINARY_DIR}/project-override-env-on)

execute_process(COMMAND ${CMAKE_COMMAND} -E rm -rf ${TEST_BUILD_DIR_OFF})
execute_process(COMMAND ${CMAKE_COMMAND} -E rm -rf ${TEST_BUILD_DIR_ON})

configure_package_config_file(
  "${CMAKE_CURRENT_LIST_DIR}/local_dependency/OverrideCMakeLists.txt.in"
  "${CMAKE_CURRENT_LIST_DIR}/local_dependency/CMakeLists.txt"
  INSTALL_DESTINATION ${CMAKE_CURRENT_BINARY_DIR}/junk
)

execute_process(
  COMMAND ${CMAKE_COMMAND} -E env
          "CPM_Dependency_SOURCE=${CMAKE_CURRENT_LIST_DIR}/local_dependency/dependency"
          ${CMAKE_COMMAND} -S${CMAKE_CURRENT_LIST_DIR}/local_dependency -B${TEST_BUILD_DIR_OFF}
  RESULT_VARIABLE ret_off
)

assert_not_equal(${ret_off} "0")

execute_process(
  COMMAND ${CMAKE_COMMAND} -E env
          "CPM_Dependency_SOURCE=${CMAKE_CURRENT_LIST_DIR}/local_dependency/dependency"
          ${CMAKE_COMMAND} -S${CMAKE_CURRENT_LIST_DIR}/local_dependency -B${TEST_BUILD_DIR_ON}
          -DCPM_ENABLE_ENV=ON
  RESULT_VARIABLE ret_on
)

assert_equal(${ret_on} "0")

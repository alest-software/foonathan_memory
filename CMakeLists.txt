cmake_minimum_required(VERSION 3.15)
project(foonathan_memory)

set(CMAKE_INSTALL_PREFIX "/opt/fastdds")
set(CPACK_PACKAGING_INSTALL_PREFIX "${CMAKE_INSTALL_PREFIX}")
set(BUILD_SHARED_LIBS ON)
set(FOONATHAN_MEMORY_BUILD_EXAMPLES OFF)
set(FOONATHAN_MEMORY_BUILD_TESTS OFF)

add_subdirectory(foonathan_memory)

include(InstallRequiredSystemLibraries)

set(CPACK_PACKAGE_NAME "foonathan_memory_vendor")
set(CPACK_PACKAGE_VERSION ${FOONATHAN_MEMORY_VERSION})
set(CPACK_PACKAGE_CONTACT "you@example.com")
set(CPACK_GENERATOR "DEB")
include(CPack)


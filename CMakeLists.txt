cmake_minimum_required(VERSION 3.5)
project(hello)

set(CMAKE_CXX_STANDARD 14)
set(CMAKE_SYSTEM_NAME Windows)
set(CMAKE_EXE_LINKER_FLAGS "-static")
set(CMAKE_EXECUTABLE_SUFFIX ".exe")
set(CMAKE_BUILD_WITH_INSTALL_RPATH ON)

add_executable(hello
    src/main.cpp)

target_link_libraries(hello PRIVATE)

install(TARGETS hello DESTINATION bin)

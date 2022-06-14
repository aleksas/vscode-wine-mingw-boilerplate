cmake_minimum_required(VERSION 3.5)
project(hello)

set(CMAKE_CXX_STANDARD 14)
set(CMAKE_SYSTEM_NAME Windows)
set(CMAKE_EXE_LINKER_FLAGS "-static")
set(CMAKE_BUILD_WITH_INSTALL_RPATH ON)

add_executable(hello.exe
    src/main.cpp)

target_link_libraries(hello.exe PRIVATE
    -gstabs)

install(TARGETS hello.exe DESTINATION bin)

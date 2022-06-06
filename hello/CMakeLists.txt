cmake_minimum_required(VERSION 3.5)
project(hello)

set(CMAKE_CXX_STANDARD 14)
set(CMAKE_SYSTEM_NAME Windows)
SET(CMAKE_C_FLAGS -m32)
SET(CMAKE_CXX_FLAGS -m32)

add_executable(hello.exe
    main.cpp)

target_link_libraries(hello.exe PRIVATE
    -static-libgcc
    -static-libstdc++
    -gstabs
)

install(TARGETS hello.exe DESTINATION bin)

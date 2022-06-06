cmake_minimum_required(VERSION 3.5)
project(server)

set(CMAKE_CXX_STANDARD 14)
set(CMAKE_SYSTEM_NAME Windows)
SET(CMAKE_C_FLAGS -m32)
SET(CMAKE_CXX_FLAGS -m32)

find_package(rpclib CONFIG REQUIRED)

add_executable(server.exe
    main.cpp)

target_link_libraries(server.exe PRIVATE
    rpclib::rpc
    -lwsock32
    -lws2_32
    -static
    # -g
)

install(TARGETS server.exe DESTINATION bin)

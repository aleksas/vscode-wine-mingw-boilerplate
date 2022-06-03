cmake_minimum_required(VERSION 3.5)
project(server)

#set(CMAKE_CXX_STANDARD 14)
#set(CMAKE_SYSTEM_NAME Generic)
#set(CMAKE_SYSTEM_PROCESSOR x86)
#SET(CMAKE_C_COMPILER winegcc)
#SET(CMAKE_CXX_COMPILER wineg++)
#SET(DCMAKE_C_FLAGS -m32)
#SET(DCMAKE_CXX_FLAGS -m32)

find_package(rpclib CONFIG REQUIRED)

add_executable(server
    server/main.cpp)

target_link_libraries(server PRIVATE
    rpclib::rpc
    -static-libgcc
    -static-libstdc++
    -pthread
)

add_executable(client
client/main.cpp)

target_link_libraries(client PRIVATE
    rpclib::rpc
    -static-libgcc
    -static-libstdc++
    -pthread
)

install(TARGETS server DESTINATION bin)
install(TARGETS client DESTINATION bin)

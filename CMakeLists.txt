cmake_minimum_required(VERSION 3.5)
project(rpclib)

# if (NOT MINGW)
#     message(STATUS "client")
#     add_subdirectory(client)
# endif ()

# if (MINGW)
    message(STATUS "server")
    add_subdirectory(server)
    message(STATUS "hello")
    add_subdirectory(hello)
# endif () 

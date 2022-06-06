find_package(rpclib CONFIG REQUIRED)

set(CMAKE_CXX_STANDARD 14)
set(CMAKE_SYSTEM_NAME WINDOWS)

# include_directories(
#     "/usr/share/mingw-w64/include"
# )

add_executable(client
main.cpp)

target_link_libraries(client PRIVATE
    rpclib::rpc
    -static-libgcc
    -static-libstdc++
    -lwsock32
    -lws2_32
    -pthread
    -gstabs
)

install(TARGETS client DESTINATION bin)
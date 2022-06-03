#include <iostream>
#include <chrono>
#include <thread>

#include <rpc/client.h>

int main() {
    std::cout.setf(std::ios::unitbuf);
    std::cout << "init..." << std::endl << std::flush;
    std::this_thread::sleep_for (std::chrono::seconds(1));
    std::cout << "client" << std::endl << std::flush;
    // Creating a client that connects to the localhost on port 8080
    try {
        rpc::client client("server", 8080);

        client.call("foo");
        // Calling a function with paramters and converting the result to int
        std::cout << "adding..." << std::endl;
        auto result = client.call("add", 2, 3).as<int>();
        std::cout << "The result is: " << result << std::endl;
    } catch (const std::exception &e) {
        std::cout << e.what() << std::endl;
    }
    
    return 0;
}

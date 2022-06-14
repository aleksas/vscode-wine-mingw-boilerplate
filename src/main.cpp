#include <iostream>

int main(int argc, char *argv[]) {
    std::cout << "Hello world!" << std::endl << "Args:" << std::endl;

    for (int i = 0; i < argc; i++) {
        std::cout << "\t" << i << ": " << argv[i] << std::endl;
    }

    return 0;
}

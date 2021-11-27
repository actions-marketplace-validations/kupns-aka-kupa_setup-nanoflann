cmake_minimum_required(VERSION 3.20)

project(setup_nanoflann)

find_package(nanoflann)

set(CMAKE_CXX_STANDARD 11)

add_executable(${PROJECT_NAME} main.cpp)

target_link_libraries(${PROJECT_NAME} PRIVATE nanoflann::nanoflann)
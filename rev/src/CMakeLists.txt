cmake_minimum_required(VERSION 3.15)

project(create_degate)

set(CMAKE_CXX_STANDARD 11)
message(STATUS "Using compiler: ${CMAKE_CXX_COMPILER}")

set(CMAKE_VERBOSE_MAKEFILE true)

if (NOT DEFINED Boost_USE_STATIC_LIBS)
    set(Boost_USE_STATIC_LIBS ON)
endif()

message(STATUS "Boost static libs: ${Boost_USE_STATIC_LIBS}")

if (NOT DEFINED Boost_USE_MULTITHREADED)
    set(Boost_USE_MULTITHREADED ON)
endif()

set(LIBS "${CMAKE_CURRENT_SOURCE_DIR}/Degate/build/out/lib/libDegateCore.a")

find_package(Boost COMPONENTS filesystem system thread REQUIRED)
include_directories(${Boost_INCLUDE_DIRS})
set(LIBS ${LIBS} ${Boost_LIBRARIES})

find_package(Qt6 COMPONENTS Core Widgets Gui Xml OpenGL OpenGLWidgets Concurrent LinguistTools REQUIRED)
set(LIBS ${LIBS} Qt6::Widgets Qt6::Gui Qt6::Core Qt6::Xml Qt6::OpenGL Qt6::OpenGLWidgets Qt6::Concurrent)

include_directories("${CMAKE_CURRENT_SOURCE_DIR}/Degate/src")
include_directories("${CMAKE_CURRENT_SOURCE_DIR}/")
add_executable(create_degate main.cpp)

message(STATUS "Libs: ${LIBS}")
target_link_libraries(create_degate ${LIBS})

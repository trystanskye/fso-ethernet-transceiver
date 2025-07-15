cmake_minimum_required(VERSION 3.9)
project(MonteCarloRayTracing)

set(CMAKE_CXX_STANDARD 14)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

# Find OpenMP
find_package(OpenMP REQUIRED)

if(OpenMP_CXX_FOUND)
    message(STATUS "OpenMP found!")
    set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -Xpreprocessor -fopenmp -I/usr/local/opt/libomp/include")
    set(CMAKE_EXE_LINKER_FLAGS "${CMAKE_EXE_LINKER_FLAGS} -L/usr/local/opt/libomp/lib -lomp")
else()
    message(FATAL_ERROR "OpenMP not found!")
endif()

# Add the executable
add_executable(MonteCarloRayTracing main.cpp)

# Link OpenMP properly
target_link_libraries(MonteCarloRayTracing PRIVATE OpenMP::OpenMP_CXX)
//
// Created by Trystan Kasprick on 2/16/25.
//

#include <iostream>
#include <omp.h> //"/usr/local/opt/libomp/include/omp.h"
#include <random>
#include <cmath>
#include <thread>
#include <array>


#define N 100000000 //Number of iterations
#define D 50 //Distance to photodiode array in meters
#define PDDim 0.0003 //Photodiode array half-width in meters
#define radius 1 //Radius of Lambertian reflector ie. photodiode visible area in meters

std::array<long,2> parallelRayTrace() {
    long PDHitCount = 0;
    long iterations = 0;
    std::array<long,2> output{};

    #pragma omp parallel
    {

        //Setup random number generator
        std::random_device rd;
        int thread_id = omp_get_thread_num();
        std::mt19937 rng(rd() ^ thread_id);

        std::uniform_real_distribution<float> dist01(0.0, 1.0); // Uniform [0,1]
        std::uniform_int_distribution<int> distSign(0, 1);

        long localPDHitCount = 0;
        long localIterations = 0;

        #pragma omp for schedule(dynamic)
        for (long i = 0; i < N ; i++) {
            // Sample uniform points on a circular reflector
            float r = sqrt(dist01(rng)) * radius; //distance from center in meters
            float theta = (dist01(rng)) * 2 * M_PI - M_PI; //angle for polar coordinate [-pi,pi]
            float x = r * cos(theta); //polar to cartesian
            float y = r * sin(theta); //polar to cartesian

            // Sample Lambertian reflection angles
            //angle created with surface normal from [-pi/2,pi/2], cosine biased towards 0
            float thetax = asin((dist01(rng))) * (distSign(rng) == 0 ? 1 : -1);
            float thetaradial = (dist01(rng)) * 2 * M_PI - M_PI; //azumithal angle of reflection [-pi,pi]

            // Determine final photon landing position
            float x2 = D * tan(thetax) * cos(thetaradial) + x;
            float y2 = D * tan(thetax) * sin(thetaradial) + y;

            // Check if photon lands on photodiode array
            if (fabs(x2) <= PDDim && fabs(y2) <= PDDim) {
                localPDHitCount++;

            }
            localIterations++;

        }
        #pragma omp atomic
        PDHitCount += localPDHitCount;

        #pragma omp atomic
        iterations += localIterations;
    }

    output[0] = PDHitCount;
    output[1] = iterations;
    return output;
}


int main() {


    omp_set_num_threads(omp_get_max_threads());

    std::array<long,2> output = parallelRayTrace();

    std::cout << "Number of hits: " << output[0] << std::endl;
    std::cout << "Number of iterations: " << output[1] << std::endl;
    //std::cout << "Number of threads: " << omp_get_max_threads() << std::endl;

    return 0;
}

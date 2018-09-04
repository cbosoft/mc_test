/*
   Program to calculate pi. 
 */


#include <cmath>
#include <iomanip>
#include <iostream>
#include <boost/random/mersenne_twister.hpp>
#include <boost/random/uniform_01.hpp>
#include <boost/random/variate_generator.hpp>


int main(int argc, const char** argv) {

  int N=10000, T=10;

  if (argc > 1) {
    N = std::atoi(argv[1]);
    if (argc > 2) {
      T = std::atoi(argv[2]); 
    }
  }

  std::cout << "Starting MC simulation of "<<N<<" positions and "<<T<<" repetitions" <<  std::endl;

  boost::variate_generator<boost::mt19937, boost::uniform_01<> > generator(boost::mt19937(1), boost::uniform_01<>());

  double tot = 0;
  for (int t = 0; t < T; t++){
    int pin = 0;
    for (int n = 0; n < N; n++) {
      if (std::pow(std::pow(generator(), 2.0) + std::pow(generator(), 2.0), 0.5) < 1.0) pin += 1;
    }

    tot += 4.0 * pin / ((double) N);
  }
  std::cout << "Pi: " << tot/T << std::endl;
  return 0;
}

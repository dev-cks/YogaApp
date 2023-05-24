//
//  CPU.c
//  YogaPrototype
//
//  Created by Sergii Kutnii on 01.10.2021.
//

#include "CPU.h"

#include <sys/sysctl.h>

unsigned int cpuCoreCount(void) {
  size_t len;
  unsigned int ncpu;

  len = sizeof(ncpu);
  sysctlbyname ("hw.physicalcpu",&ncpu,&len,NULL,0);

  return ncpu;
}

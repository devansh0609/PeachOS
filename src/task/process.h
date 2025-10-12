#ifndef PROCESS_H
#define PROCESS_H
#include <stdint.h>
#include "task.h"
#include "config.h"
struct process
{
    // The process id
    uint16_t id;

    char filename[PEACHOS_MAX_PATH];

    // The main Process task
    struct task* task;

    // To keep the track of all the allocations made by the process
    // The memory (malloc) allocations of the process
    void* allocations[PEACHOS_MAX_PROGRAM_ALLOCATIONS];

    /*
     * To keep it simple we load only binary files (if it would be elf file then structure would be different)
     * for elf or mulitple files we would use Union over here.
     * The physical pointer to the process memory.
    */ 
    void* ptr;

    // The physical pointer to the stack memory.
    void* stack;

    // The size of the data pointed to by "ptr"
    uint32_t size;
};
#endif
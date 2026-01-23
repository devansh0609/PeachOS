#ifndef PROCESS_H
#define PROCESS_H
#include <stdint.h>
#include <stdbool.h>

#include "task.h"
#include "config.h"

#define PROCESS_FILETYPE_ELF 0
#define PROCESS_FILETYPE_BINARY 1
typedef unsigned char PROCESS_FILETYPE;

struct process_allocation
{
    void* ptr;
    size_t size;
};

struct process
{
    // The process id
    uint16_t id;

    char filename[PEACHOS_MAX_PATH];

    // The main Process task
    struct task* task;

    // To keep the track of all the allocations made by the process
    // The memory (malloc) allocations of the process
    struct process_allocation allocations[PEACHOS_MAX_PROGRAM_ALLOCATIONS];

    PROCESS_FILETYPE filetype;

    /*
     * To keep it simple we load only binary files (if it would be elf file then structure would be different)
     * for elf or mulitple files we would use Union over here.
     * The physical pointer to the process memory.
    */ 
    union
    {
        void* ptr;
        struct elf_file* elf_file;
    };
    

    // The physical pointer to the stack memory.
    void* stack;

    // The size of the data pointed to by "ptr"
    uint32_t size;

    struct keyboard_buffer
    {
        char buffer[PEACHOS_KEYBOARD_BUFFER_SIZE];
        int tail;
        int head;
    } keyboard;
};

int process_switch(struct process* process);
int process_load_switch(const char* filename, struct process** process);
int process_load(const char* filename, struct process** process);
int process_load_for_slot(const char* filename, struct process** process, int process_slot);
struct process* process_current();
struct process* process_get(int process_id);
void* process_malloc(struct process* process, size_t size);
void process_free(struct process* process, void* ptr);

#endif
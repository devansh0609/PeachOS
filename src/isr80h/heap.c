#include "heap.h"
#include "task/task.h"
#include "task/process.h"
#include <stddef.h>
void* isr80h_command4_malloc(struct interrupt_frame* frame)
{
    /*
     * We can't just do kmalloc over here, because if the process gets killed
     * that memory will not be freed.
     * So, we will use procces_malloc (: Allocating memory for processes) over here
     * Allocations table of process will be filled and erased when process is killed.
    */

    size_t size = (int)task_get_stack_item(task_current(), 0);
    return process_malloc(task_current()->process, size);
}

void* isr80h_command5_free(struct interrupt_frame* frame)
{
    void* ptr_to_free = task_get_stack_item(task_current(), 0);
    process_free(task_current()->process, ptr_to_free);
    return 0;
}
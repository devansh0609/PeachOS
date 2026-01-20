#include "peachos.h"

int peachos_getkeyblock()
{
    int val = 0;
    do
    {
        val = peachos_getkey();
    }
    while (val == 0);
    return val;    
}

void peachos_terminal_readline(char* out, int max, bool output_while_typing)
{
    int i = 0;
    for(i = 0; i < max; i++)
    {
        char key = peachos_getkeyblock();

        // Carriage return means we have read the line
        if (key == 13)
        {
            break;
        }

        if(output_while_typing)
        {
            peachos_putchar(key);
        }

        // backspace
        if (key == 0x08 && i > 0)
        {
            out[i-1] = 0x00;
            // -2 because we will +1 when we go to loop again.
            i -= 2;
            continue;
        }

        out[i] = key;
    }

    // Add the null terminator
    out[i] = 0x00;
}
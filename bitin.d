module bitin;

import std.bitmanip;
import std.system;
import std.conv;

struct BitIn 
{
    ubyte[] bits;
    uint[ubyte] table;
    ubyte bits_left = 8;

    this(ubyte[] bytes)
    {
        bits = bytes;
    }

    int read(ubyte[string] c_table)
    {
        // Read a bit from the bits buffer until a code word is found
        string code;
        ubyte* b = (code in c_table);
        while(b is null)
        {
            // Append the bit to the code word string and check if it is in the code table
            bits_left--;
            code ~= to!string((bits[0] >> bits_left) & 0x1);
            b = (code in c_table);

            // We need to start shifting in bits from the next byte
            if(bits_left == 0)
            {
                // If there are no more bytes left, break the loop
                if(bits.length == 1) return -1;
                bits = bits[1 .. $];
                bits_left = 8;
            }
        }

        return c_table[code];
    }

    uint[ubyte] read()
    {
        // Read the length (# of key/value pairs in the table) of the p_table
        size_t length = std.bitmanip.read!(size_t, std.system.endian, ubyte[])(bits); 

        // Read the probability values for each character one at a time from the table
        for(int i = 0; i < length; i++)
        {
            ubyte c = std.bitmanip.read!(ubyte, std.system.endian, ubyte[])(bits);
            uint p = std.bitmanip.read!(uint, std.system.endian, ubyte[])(bits);
            table[c] = p;
        }

        return table;
    }
}

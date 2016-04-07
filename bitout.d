module bitout;

import std.stdio;
import std.algorithm;
import std.bitmanip;
import std.system;
import std.conv;

struct BitOut 
{
    ubyte[] bits = [0];
    ubyte[] table;
    ubyte num_bits = 8;

    void write(ubyte[] code)
    {
        // Write the bits to bit buffer by shifting them in from the most significant bit
        foreach(ubyte b ; code)
        {
            // Append bit to bit array 
            num_bits--;
            bits[$-1] = to!ubyte(bits[$-1] | (b << num_bits));

            // If num_bits == 0 then append a new byte to the bit array 
            if(num_bits == 0)
            {
                bits ~= 0;
                num_bits = 8;
            }
        }
    }

    void write(uint[ubyte] p_table)
    {
        // Write the p_table keys and probability values into the table buffer
        // This will be the header for the compressed file
        foreach(v ; p_table.byKeyValue)
        {
            ubyte[uint.sizeof] value;
            std.bitmanip.write!(uint, std.system.endian, ubyte[])(value, v.value, 0);
            table ~= (v.key ~ value);
        }

        // Prepend the table length
        ubyte[size_t.sizeof] length;
        std.bitmanip.write!(size_t, std.system.endian, ubyte[])(length, p_table.length, 0);
        table = length ~ table;
    }
}

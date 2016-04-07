import std.stdio;
import std.getopt;

import huffman_encode : huffman_encode;
import huffman_decode : huffman_decode;

int main(string[] args)
{
    bool encode, decode;
    string in_filename, out_filename;
    auto options = getopt(args, std.getopt.config.bundling, "compress|c", &encode, "decode|x", &decode, "input|f", &in_filename, std.getopt.config.noBundling, "output|o", &out_filename);
    
    if(options.helpWanted)
    {
        defaultGetoptPrinter("Adaptive Huffman coding program", options.options);
        return 0;
    }

    if(in_filename is null || out_filename is null)
    {
        stderr.writeln("Input/Output filenames not provided");
        defaultGetoptPrinter("Adaptive Huffman coding program", options.options);
        return 1;
    }

    if((!encode && !decode) || (encode && decode))
    {
        stderr.writeln("Must specify either -c or -x");
        defaultGetoptPrinter("Adaptive Huffman coding program", options.options);
        return 1;
    }

    if(encode) huffman_encode(in_filename, out_filename);
    else huffman_decode(in_filename, out_filename); 
     
    return 0;
}

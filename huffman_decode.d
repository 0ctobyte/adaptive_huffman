module huffman_decode;

import std.stdio;
import std.conv;

import huffman : huffman_construct_tree, _huffman_create_dot, huffman_generate_codes, huffman_generate_reverse_codes;
import node : Node;
import bitin : BitIn;

void huffman_decode(string in_filename, string out_filename)
{
    auto inf = File(in_filename, "rb");
    auto outf = File(out_filename, "wb");

    // Read the raw file data 
    auto inf_buf = inf.rawRead(new ubyte[inf.size()]);
    inf.close();

    // Read the p_table from the file
    BitIn bi = BitIn(inf_buf);
    uint[ubyte] p_table = bi.read();

    // Construct the Huffman code tree
    stdout.writeln(p_table);
    Node root = huffman_construct_tree(p_table);
    _huffman_create_dot(root, "huffman_decode.dot");

    // Now create the code table
    ubyte[string] c_table = huffman_generate_reverse_codes(root);
    stdout.writeln(c_table);

    // Decode one code word at a time from the input buffer
    ubyte[] buffer;
    for(int c = bi.read(c_table); c != -1; c = bi.read(c_table)) 
    {
        stdout.write(to!char(c));
        buffer ~= to!ubyte(c);
    }

    // Write out the decoded data
    outf.rawWrite(buffer);
    outf.close();
}

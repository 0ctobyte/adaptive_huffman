module huffman_encode;

import std.stdio;

import huffman : huffman_construct_tree, _huffman_create_dot, huffman_generate_codes;
import node : Node;
import bitout : BitOut;

void huffman_encode(string in_filename, string out_filename)
{
    auto inf = File(in_filename, "rb");
    auto outf = File(out_filename, "wb");

    // Count the probability of each symbol in the file
    uint[ubyte] p_table;
    auto inf_buf = inf.rawRead(new ubyte[inf.size()]);
    foreach(ubyte c ; inf_buf) p_table[c]++;
    inf.close();

    // Construct the Huffman code tree
    stdout.writeln(p_table);
    Node root = huffman_construct_tree(p_table);
    _huffman_create_dot(root, "huffman_encode.dot");

    // Now create the code table
    ubyte[][ubyte] c_table = huffman_generate_codes(root);
    stdout.writeln(c_table);

    // Now we can go through the input file and compress it!
    BitOut bo;
    bo.write(p_table);
    foreach(ubyte c ; inf_buf) bo.write(c_table[c]);

    // Write the p_table and bits to the output file
    outf.rawWrite(bo.table);
    outf.rawWrite(bo.bits);

    outf.close();
}

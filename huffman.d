module huffman;

import std.stdio;
import std.container.binaryheap;
import std.conv;
import std.format;

import node : Node; 

void _huffman_create_dot(Node root, string filename)
{
    void _huffman_traverse_dot(Node node, File o)
    {
        if(node is null) return;
        if(node.l !is null) o.writefln("{%d [label=%d]} -- {%d [label=%d]}", node.toHash, node.p, node.l.toHash, node.l.p); 
        if(node.r !is null) o.writefln("{%d [label=%d]} -- {%d [label=%d]}", node.toHash, node.p, node.r.toHash, node.r.p); 
    
        _huffman_traverse_dot(node.l, o);
        _huffman_traverse_dot(node.r, o);
    }

  File dot = File(filename, "w");
  dot.writeln("strict graph huffman {");

  _huffman_traverse_dot(root, dot);

  dot.writeln("}");
  dot.close();
}

Node huffman_construct_tree(uint[ubyte] p_table)
{
    // Sort the huffman table in a min-heap
    Node[] nodes;
    foreach(p ; p_table.byKeyValue) nodes ~= [new Node(p.key, p.value, null, null)];
    auto heap = BinaryHeap!(Node[], "a > b")(nodes);

    // Take the two lowest probability symbols/nodes and create a new node having these two
    // nodes as children and a probability value equal to the sum of the children probabilities
    // Add this new node to the heap
    for(int i = 0; heap.length > 1; i++)
    {
        auto n0 = heap.front();
        heap.removeFront();
        auto n1 = heap.front();
        heap.removeFront();
        heap.insert(new Node(-1, n0.p+n1.p, n0, n1));
    }

    Node root = heap.front();
    heap.popFront();

    return root;
}

ubyte[][ubyte] huffman_generate_codes(Node root)
{
    ubyte[][ubyte] c_table;

    void _traverse(Node node, ubyte[] c, ubyte b)
    {
        if(node is null) return;

        // Left subtrees are assigned a bit value of 1
        // Right subtrees are assigned a bit value of 0
        ubyte[] code = c ~ b;
        _traverse(node.l, code, 1);
        _traverse(node.r, code, 0);

        // Check if node is a leaf
        if(node.c >= 0) c_table[to!ubyte(node.c)] = code;
    }

    ubyte[] code;
    _traverse(root.l, code, 1);
    _traverse(root.r, code, 0);

    return c_table;
}

ubyte[string] huffman_generate_reverse_codes(Node root)
{
    ubyte[string] c_table;

    void _traverse(Node node, string c, string b)
    {
        if(node is null) return;

        // Left subtrees are assigned a bit value of 1
        // Right subtrees are assigned a bit value of 0
        string code = c ~ b;
        _traverse(node.l, code, "1");
        _traverse(node.r, code, "0");

        // Check if node is a leaf
        if(node.c >= 0) c_table[code] = to!ubyte(node.c);
    }

    string code;
    _traverse(root.l, code, "1");
    _traverse(root.r, code, "0");

    return c_table;
}

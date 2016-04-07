module node;

import std.conv;

class Node
{
    int c;
    uint p;
    Node r, l;

    this(int c, uint p, Node r, Node l)
    {
        this.c = c;
        this.p = p;
        this.r = r;
        this.l = l;
    }

    override int opCmp(Object o)
    {
        Node rhs = cast(Node)o;
        return (to!int(p) - to!int(rhs.p));
    }
}

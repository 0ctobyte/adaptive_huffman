# Adaptive Huffman Coding

This program encodes and decodes text files using the adaptive Huffman coding algorithm.

The Huffman table is generated based on the character counts in the given text file (thus making
the algorithm "adaptive"). The table is then used to generate the Huffman coding tree and the prefix-free codes
for each unique character. The generated table is written at the beginning of the compressed file (which adds a 
fair amount of overhead).

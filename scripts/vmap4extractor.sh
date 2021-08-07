#!/bin/bash
/app/vmap4extractor
mkdir vmaps
/app/vmap4assembler Buildings vmaps
cp -r vmaps "$OUTPUT_DIR"
rm -r vmaps


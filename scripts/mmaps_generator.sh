#!/bin/bash
/app/mmaps_generator
cp -r mmaps "$OUTPUT_DIR"
rm -r mmaps

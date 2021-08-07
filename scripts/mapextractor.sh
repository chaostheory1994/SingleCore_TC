#!/bin/bash
/app/mapextractor
cp -r dbc maps gt "$OUTPUT_DIR"
rm -r dbc maps gt

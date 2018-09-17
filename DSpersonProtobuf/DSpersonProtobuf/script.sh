#!/bin/bash
\n
cd ~/Desktop
\n
protoc --proto_path=~/Desktop/Proto --objc_out=~/Desktop/Proto_OBJC keyagreement.proto base.proto
#string appendFormat:@"#!/bin/bash"];
#[string appendFormat:@"\n"];
#[string appendFormat:@"cd ~/Desktop"];
#[string appendFormat:@"\n"];
#[string appendFormat:@"protoc --proto_path="];
#[string appendFormat:@"%@", filePath];
#[string appendFormat:@" --objc_out="];

exit 5




#!/bin/bash

# Copy SguParser
cp -r ../SguParser ./

# Temporarily modify Package.swift
sed -i 's|path: "../SguParser"|path: "./SguParser"|' Package.swift

# Build Docker image
docker build -t sguparsingservice:latest .

# Revert Package.swift changes
sed -i 's|path: "./SguParser"|path: "../SguParser"|' Package.swift

# Clean up
rm -rf ./SguParser

echo "Build completed successfully!"

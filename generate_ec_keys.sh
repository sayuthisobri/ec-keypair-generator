#!/bin/bash

# Create temporary files
private_pem=$(mktemp)
private_der=$(mktemp)
public_pem=$(mktemp)
public_der=$(mktemp)

# Generate EC private key PEM
openssl ecparam -name prime256v1 -genkey -noout -out "$private_pem" 2>/dev/null

# Convert private key PEM to DER (PKCS#8)
openssl pkcs8 -topk8 -inform PEM -outform DER -in "$private_pem" -out "$private_der" -nocrypt 2>/dev/null

# Extract public key PEM from private key
openssl ec -in "$private_pem" -pubout -out "$public_pem" 2>/dev/null

# Convert public key PEM to DER (X.509)
openssl pkey -pubin -in "$public_pem" -outform DER -out "$public_der" 2>/dev/null

# Output Base64 encoded private key DER
echo "Private Key (Base64):"
base64 -i "$private_der"

echo
 echo "Public Key (Base64):"
base64 -i "$public_der"

# Clean up temporary files
rm -f "$private_pem" "$private_der" "$public_pem" "$public_der"

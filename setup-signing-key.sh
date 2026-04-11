#!/bin/bash
# Generate Flutter Signing Key untuk Android Build
# Creates RSA 2048-bit key valid for 30 years

set -e

echo "========================================" 
echo "🔐 Flutter Android Signing Key Setup"
echo "========================================"
echo ""

# Colors
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

# Configuration
KEY_DIR="$HOME/.android"
KEY_FILE="$KEY_DIR/release.keystore"
KEY_ALIAS="flutter-key"
KEY_VALIDITY=10950  # 30 years in days

# Create .android directory if not exists
mkdir -p "$KEY_DIR"

# Check if key already exists
if [ -f "$KEY_FILE" ]; then
    echo -e "${YELLOW}⚠️  Keystore already exists at: $KEY_FILE${NC}"
    echo ""
    read -p "Do you want to use existing key? (y/n) " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        echo "✅ Using existing key"
        KEY_EXISTS=true
    else
        echo "Creating new key..."
        rm "$KEY_FILE"
        KEY_EXISTS=false
    fi
else
    KEY_EXISTS=false
fi

if [ "$KEY_EXISTS" = false ]; then
    echo "📝 Generating new signing key..."
    echo ""
    echo "Please provide the following information:"
    echo "(You can use placeholder values for development)"
    echo ""
    
    # Get user input
    read -p "First and Last Name: " -e -i "Islamic App Developer" FIRSTNAME
    read -p "Organization Name: " -e -i "Islamic App" ORGANIZATION
    read -p "Organization Unit: " -e -i "Development" ORG_UNIT
    read -p "City/Locality: " -e -i "Jakarta" CITY
    read -p "State/Province: " -e -i "DKI Jakarta" STATE
    read -p "Country Code (2 letters, e.g., ID): " -e -i "ID" COUNTRY
    read -sp "Enter keystore password (min 6 chars): " PASSWORD
    echo
    read -sp "Confirm password: " PASSWORD_CONFIRM
    echo
    
    # Validate passwords match
    if [ "$PASSWORD" != "$PASSWORD_CONFIRM" ]; then
        echo -e "${RED}❌ Passwords don't match!${NC}"
        exit 1
    fi
    
    # Generate key
    keytool -genkey -v \
        -keystore "$KEY_FILE" \
        -keyalg RSA \
        -keysize 2048 \
        -validity $KEY_VALIDITY \
        -alias "$KEY_ALIAS" \
        -storepass "$PASSWORD" \
        -keypass "$PASSWORD" \
        -dname "CN=$FIRSTNAME, OU=$ORG_UNIT, O=$ORGANIZATION, L=$CITY, ST=$STATE, C=$COUNTRY"
    
    echo ""
    echo -e "${GREEN}✅ Signing key created successfully!${NC}"
fi

# Create key.properties file for Flutter
echo ""
echo "📝 Creating key.properties..."

KEY_PROPERTIES="$PWD/android/key.properties"

# Ask for password if creating key.properties for first time
if [ ! -f "$KEY_PROPERTIES" ]; then
    read -sp "Enter keystore password: " PASSWORD
    echo
else
    # If file exists, ask if user wants to update it
    read -p "Update existing key.properties? (y/n) " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        read -sp "Enter keystore password: " PASSWORD
        echo
    else
        echo "✅ key.properties already exists, skipping update"
        exit 0
    fi
fi

# Create key.properties
cat > "$KEY_PROPERTIES" << EOF
storeFile=$KEY_FILE
storePassword=$PASSWORD
keyPassword=$PASSWORD
keyAlias=$KEY_ALIAS
EOF

chmod 600 "$KEY_PROPERTIES"

echo -e "${GREEN}✅ key.properties created at: $KEY_PROPERTIES${NC}"

echo ""
echo "========================================" 
echo "✅ Signing Key Setup Complete!"
echo "========================================"
echo ""
echo -e "${BLUE}📍 Key Information:${NC}"
echo "  Keystore: $KEY_FILE"
echo "  Alias: $KEY_ALIAS"
echo "  Validity: $KEY_VALIDITY days (30 years)"
echo ""
echo -e "${BLUE}📍 Next Steps:${NC}"
echo "1. (Optional) Test build:"
echo "   flutter build apk --release"
echo ""
echo "2. Build for Google Play Console:"
echo "   flutter build appbundle --release"
echo ""
echo "3. Output will be at:"
echo "   build/app/outputs/bundle/release/app-release.aab"
echo ""

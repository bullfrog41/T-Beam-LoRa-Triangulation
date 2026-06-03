#!/bin/bash
# T-Beam Firmware Flash Script
# Simple one-command flashing for Linux/Mac

set -e

# Configuration
PORT=${1:-/dev/ttyUSB0}
BAUD=${2:-460800}

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Utility functions
log() {
    echo -e "${GREEN}[FLASH]${NC} $1"
}

error() {
    echo -e "${RED}[ERROR]${NC} $1"
    exit 1
}

warn() {
    echo -e "${YELLOW}[WARN]${NC} $1"
}

# Check if esptool is installed
if ! command -v esptool.py &> /dev/null; then
    error "esptool.py not found. Install with: pip install esptool"
fi

log "T-Beam Firmware Flasher"
log "======================="
log "Port: $PORT"
log "Baud: $BAUD"

# Check if files exist
log "Checking firmware files..."
for file in bootloader.bin partitions.bin boot_app0.bin firmware.bin; do
    if [ ! -f "$file" ]; then
        warn "Missing: $file"
    else
        log "  ✓ $file"
    fi
done

# Confirm
echo
read -p "Ready to flash? (y/n) " -n 1 -r
echo
if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    log "Cancelled"
    exit 0
fi

# Flash
log "Starting flash (this may take 30 seconds)..."
esptool.py -p $PORT -b $BAUD --before default_reset --after hard_reset \
    write_flash -z --flash_mode dio --flash_freq 80m --flash_size keep \
    0x1000 bootloader.bin \
    0x8000 partitions.bin \
    0xe000 boot_app0.bin \
    0x10000 firmware.bin

if [ $? -eq 0 ]; then
    log "✓ Firmware flashed successfully!"
    log "T-Beam will reboot automatically"
    log ""
    log "Next steps:"
    log "  1. Wait 5 seconds for T-Beam to reboot"
    log "  2. Open Serial Monitor (115200 baud)"
    log "  3. Connect to T-Beam-Setup WiFi (pwd: 12345678)"
    log "  4. Visit 192.168.4.1 to configure network"
else
    error "Flash failed. Check connection and try again."
fi
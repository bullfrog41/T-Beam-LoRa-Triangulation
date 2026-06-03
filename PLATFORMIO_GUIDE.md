# PlatformIO Installation Guide

**PlatformIO** is a professional IDE for embedded systems that simplifies ESP32 development.

## 🚀 Quick Start (5 minutes)

### 1. Install PlatformIO CLI
```bash
# macOS / Linux
pip install -U platformio

# Verify installation
pio --version
```

### 2. Clone Repository
```bash
git clone https://github.com/bullfrog41/T-Beam-LoRa-Triangulation.git
cd T-Beam-LoRa-Triangulation
```

### 3. Build Firmware
```bash
pio run -e t-beam
```

This will:
- Download esp32 platform tools
- Install all required libraries (RadioLib, TinyGPS++, U8g2, etc.)
- Compile the firmware

### 4. Upload to T-Beam
```bash
# Auto-detect serial port
pio run -e t-beam -t upload

# Or specify port explicitly
pio run -e t-beam -t upload --upload-port /dev/ttyUSB0
```

### 5. Monitor Serial Output
```bash
# In another terminal
pio device monitor -e t-beam

# Exit with: Ctrl+A Ctrl+X
```

---

## 📦 Installation Options

### Option A: PlatformIO CLI (Recommended)
**Best for:** Terminal-based development, scripting, CI/CD

```bash
pip install -U platformio
pio run -e t-beam -t upload
```

### Option B: VS Code Extension (GUI)
**Best for:** Visual development, integrated debugging

1. Install VS Code
2. Install PlatformIO IDE extension
3. Open the project folder
4. Click Build & Upload buttons in the UI

### Option C: VSCode + PlatformIO
**Best for:** Full development experience

```bash
# In VS Code terminal
pio run -e t-beam -t upload
pio device monitor
```

---

## 🔧 Project Structure

```
T-Beam-LoRa-Triangulation/
├── platformio.ini              # PlatformIO configuration
├── src/
│   └── T-Beam_LoRa_Triangulation.ino  # Main firmware
├── include/                    # Optional: header files
├── lib/                        # Optional: local libraries
├── python/
│   ├── lora_triangulation.py
│   ├── calibrate_rssi.py
│   └── config.py
├── web/
│   └── index.html             # Web dashboard
├── README.md
└── ... (documentation)
```

---

## ⚙️ Configuration

### Default Settings
The `platformio.ini` includes:
- **Board**: ESP32 Dev Module (compatible with T-Beam)
- **Upload Speed**: 460800 baud
- **Libraries**: All dependencies auto-installed
- **Build Flags**: PSRAM support enabled

### Customize for Your T-Beam
Edit `platformio.ini`:

```ini
[env:t-beam]
# Change monitor port
monitor_port = /dev/ttyUSB0

# Change upload speed (slower if issues)
upload_speed = 115200

# Add custom defines
build_flags =
    -DDEBUG=1
    -DENABLE_LOGGING=1
```

---

## 📋 Common Commands

```bash
# Build only (no upload)
pio run -e t-beam

# Build & Upload
pio run -e t-beam -t upload

# Monitor serial output (115200 baud)
pio device monitor -e t-beam

# Build with debug info
pio run -e debug

# Clean build
pio run -e t-beam --clean

# List available serial ports
pio device list

# Specific port upload
pio run -e t-beam -t upload --upload-port /dev/ttyUSB0
```

---

## 🐛 Troubleshooting

### Port Not Found
```bash
# List all available ports
pio device list

# Use specific port
pio run -e t-beam -t upload --upload-port /dev/ttyACM0
```

### Upload Fails
```bash
# Try slower baud rate
# Edit platformio.ini:
# upload_speed = 115200

pio run -e t-beam -t upload
```

### Libraries Not Installing
```bash
# Force rebuild with fresh libraries
pio run -e t-beam --clean
pio run -e t-beam
```

### Compilation Errors
```bash
# Check library versions in platformio.ini
# Update all libraries
pio pkg update

# Rebuild with verbose output
pio run -e t-beam -v
```

---

## 🔌 USB Drivers

### Linux/Mac
Usually works automatically. If not:

```bash
# Linux: Install CH340 driver
sudo apt install ch340-dkms

# macOS: Download from https://www.silabs.com/products/development-tools/software/usb-to-uart-bridge-vcp-drivers
```

### Windows
Download and install from: https://www.silabs.com/products/development-tools/software/usb-to-uart-bridge-vcp-drivers

---

## 📊 VS Code Integration

### Install Extension
1. Open VS Code
2. Extensions → Search "PlatformIO"
3. Click Install (by PlatformIO)
4. Reload VS Code

### Use in VS Code
- Build: Click checkmark icon
- Upload: Click right arrow
- Serial Monitor: Click plug icon
- Open terminal: `Ctrl+~`

---

## 🌐 Remote Upload

### SSH/Remote Host
```bash
# Build locally
pio run -e t-beam

# Upload via SSH (if SSH available)
scp .pio/build/t-beam/firmware.bin user@remote:~/
ssh user@remote esptool.py write_flash 0x10000 firmware.bin
```

---

## 📈 Project Management

### Multiple Environments
```ini
[env:t-beam]
# Production build

[env:t-beam-debug]
# Debug build with logging

[env:test]
# Testing configuration
```

Switch with: `pio run -e t-beam-debug`

---

## ✅ Verification

After upload, verify in Serial Monitor:

```
[SETUP] System starting...
[SETUP] Initializing LoRa...
[SETUP] LoRa initialized successfully
[SETUP] Initializing GPS...
[SETUP] GPS initialized
[SETUP] Initializing display...
[SETUP] Display initialized
[WIFI] Starting WiFi setup...
```

If you see these messages, **firmware is working!** ✓

---

## 🎯 Next Steps

1. **Configure WiFi**: Access 192.168.4.1 setup portal
2. **Run Python Tools**: `python3 lora_triangulation.py --help`
3. **Calibrate RSSI**: `python3 calibrate_rssi.py --port /dev/ttyUSB0`
4. **Collect Data**: Power on and walk around transmitter
5. **Analyze**: `python3 lora_triangulation.py --csv lora_data.csv`

---

**Questions?** Check the main README.md or QUICK_REFERENCE.txt!
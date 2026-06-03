# T-Beam LoRa Triangulation - Setup Methods

Choose your preferred development environment below.

## 🎯 Quick Comparison

| Feature | Arduino IDE | PlatformIO |
|---------|------------|-----------|
| **Ease** | Medium | Easy |
| **Learning Curve** | Beginner friendly | Professional |
| **Speed** | Slower builds | Fast |
| **Libraries** | Manual install | Auto-managed |
| **VS Code** | Not native | Integrated |
| **CLI** | Limited | Full CLI |
| **Cost** | Free | Free |
| **Best For** | Quick prototyping | Production/teams |

---

## 📚 Installation Guides

### Method 1: Arduino IDE (Traditional)
**Read:** `INSTALLATION_CHECKLIST.md`

```bash
1. Download Arduino IDE
2. Install 6 libraries manually
3. Select Board: ESP32 Dev Module
4. Upload T-Beam_LoRa_Triangulation.ino
```

**Pros:**
- Simple, familiar interface
- Good for beginners
- Large community support

**Cons:**
- Manual library management
- Slower compilation
- Limited CLI support

---

### Method 2: PlatformIO CLI (Recommended for Terminal Users)
**Read:** `PLATFORMIO_GUIDE.md`

```bash
pip install -U platformio
git clone https://github.com/bullfrog41/T-Beam-LoRa-Triangulation.git
cd T-Beam-LoRa-Triangulation
pio run -e t-beam -t upload
pio device monitor
```

**Pros:**
- Fast builds
- Automatic library management
- Powerful CLI
- Perfect for automation/CI-CD

**Cons:**
- Requires command line
- Steeper learning curve

---

### Method 3: VS Code + PlatformIO (Best Overall) ⭐ RECOMMENDED
**Read:** `PLATFORMIO_GUIDE.md`

```bash
1. Install VS Code
2. Install PlatformIO IDE extension
3. Clone repository
4. Click Build & Upload buttons
5. View serial monitor integrated
```

**Pros:**
- Full IDE experience
- Fast & professional
- Integrated debugging
- Great UI
- Team collaboration ready

**Cons:**
- Requires VS Code installation
- More memory usage

---

## 🚀 Recommended Path by Experience Level

### Beginner (No programming experience)
→ **Arduino IDE** (`INSTALLATION_CHECKLIST.md`)
- Easiest to learn
- Built-in UI for everything
- Large documentation

### Intermediate (Some Arduino experience)
→ **PlatformIO CLI or VS Code** (`PLATFORMIO_GUIDE.md`)
- More control & flexibility
- Better library management
- Professional workflow

### Advanced (Production/Teams)
→ **PlatformIO + VS Code** (`PLATFORMIO_GUIDE.md`)
- CI/CD integration
- Team collaboration
- Version control integration

---

## 📋 Step-by-Step Decision

**1. Do you want a GUI?**
- Yes → Arduino IDE or VS Code + PlatformIO
- No → PlatformIO CLI

**2. Do you know Python/Terminal?**
- Yes → PlatformIO (any method)
- No → Arduino IDE

**3. Do you want fastest setup?**
- Yes → PlatformIO CLI
- No → Arduino IDE

**4. Are you on a team?**
- Yes → VS Code + PlatformIO
- No → Any method

---

## 🔄 Migration Between Methods

### Arduino IDE → PlatformIO

```bash
# 1. Install PlatformIO
pip install -U platformio

# 2. Clone repo (has platformio.ini)
git clone https://github.com/bullfrog41/T-Beam-LoRa-Triangulation.git
cd T-Beam-LoRa-Triangulation

# 3. Build & upload
pio run -e t-beam -t upload
```

### PlatformIO → Arduino IDE

```bash
# 1. Download Arduino IDE
# 2. Install libraries manually:
#    - RadioLib
#    - TinyGPS++
#    - U8g2
#    - ArduinoJson
#    - AsyncTCP
#    - ESPAsyncWebServer
# 3. Open T-Beam_LoRa_Triangulation.ino
# 4. Select Board: ESP32 Dev Module
# 5. Click Upload
```

---

## ✅ Verification Checklist

After any installation:

```
Firmware upload successful:
□ "Done uploading" message
□ Device reboots
□ Serial monitor shows startup messages

Display working:
□ OLED lights up
□ Shows GPS status screen
□ Button cycles through screens

WiFi working:
□ "T-Beam-Setup" appears in WiFi networks
□ Web dashboard loads at 192.168.4.1

Data logging:
□ CSV file created on SD card
□ JSON data on serial monitor
```

---

## 🆘 Common Issues & Solutions

### "Board not found"
- Check USB cable
- Install CH340 driver (Windows/macOS)
- Try different USB port

### "Library not found"
- Arduino IDE: Use Library Manager to install
- PlatformIO: Run `pio pkg update`

### "Upload fails at 90%"
- Try slower baud rate (115200)
- Close other serial monitors
- Restart development environment

### "Compilation error"
- Clean & rebuild (remove .pio/ or sketch build folder)
- Check board selection is correct
- Verify all libraries installed

---

## 📖 Learning Resources

### Arduino IDE
- Official tutorials: https://www.arduino.cc/en/Tutorial
- T-Beam pinout: https://github.com/LilyGO/TTGO-T-Beam
- RadioLib examples: https://github.com/jgromes/RadioLib

### PlatformIO
- Official docs: https://docs.platformio.org
- ESP32 guide: https://docs.platformio.org/boards/espressif32/esp32dev.html
- Command reference: https://docs.platformio.org/cli/

---

## 🎯 What Happens After Upload

All methods upload the same firmware, so functionality is identical.

**Next steps are the same:**

1. **Configure WiFi**
   - Connect to "T-Beam-Setup" (pwd: 12345678)
   - Visit 192.168.4.1
   - Select your network

2. **Test Hardware**
   - Check each OLED screen (press button)
   - Verify GPS gets a fix (1-2 minutes outdoor)
   - Check battery level on display

3. **Start Triangulation**
   - Run `python3 calibrate_rssi.py --port /dev/ttyUSB0`
   - Collect 5-10 readings around transmitter
   - Run `python3 lora_triangulation.py --csv lora_data.csv`

---

## 💡 Pro Tips

**Arduino IDE:**
- Keep library versions updated
- Save sketches in different folders per project
- Use "Verify" button to catch errors before uploading

**PlatformIO:**
- Use `pio device monitor -e t-beam` for serial debugging
- Add `build_flags = -DDEBUG=1` for debug builds
- Create multiple environments for different configurations

**Both:**
- Keep serial monitor at 115200 baud
- Reboot T-Beam with button to restart firmware
- Check README.md for troubleshooting

---

## 📞 Getting Help

If stuck:
1. Check QUICK_REFERENCE.txt (2 min summary)
2. Read relevant guide (INSTALLATION_CHECKLIST or PLATFORMIO_GUIDE)
3. Check troubleshooting section
4. Check repository issues: https://github.com/bullfrog41/T-Beam-LoRa-Triangulation/issues

---

**Choose your method and get started!** 🚀
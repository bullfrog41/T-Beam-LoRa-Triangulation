# ESP32 T-Beam LoRa 433 MHz Signal Triangulation System

**Locate 433 MHz radio transmitters by triangulating signal strength** from a mobile GPS-enabled LoRa receiver.

## 🎯 What This Does

- **Receives** 433 MHz LoRa signals with RSSI (signal strength)
- **Logs** GPS location + RSSI to microSD card
- **Streams** real-time JSON data via USB/serial
- **Estimates** transmitter location via multilateration (3+ receiver positions)
- **Visualizes** results on a map

## 📦 What You Need

### Hardware
- **Lilygo T-Beam ESP32** with built-in LoRa 433 MHz receiver
- **Micro-SD card** (4-32 GB, FAT32 formatted)
- **USB cable** for programming and serial comms
- **433 MHz transmitter** to locate (or test beacon)

### Software
- Arduino IDE with ESP32 support
- Python 3.7+ with dependencies: `pip install -r requirements.txt`

## ⚡ Quick Start (5 minutes)

### 1. Flash T-Beam Firmware
```bash
# In Arduino IDE:
# 1. Open T-Beam_LoRa_Triangulation.ino
# 2. Install libraries: RadioLib, TinyGPS++, ArduinoJson
# 3. Select Board: "ESP32 Dev Module"
# 4. Upload to T-Beam
```

### 2. Field Procedure (10-30 minutes)
```bash
# 1. Power on T-Beam via USB (or battery)
# 2. Wait for GPS fix (monitor serial @ 115200 baud)
# 3. Walk around transmitter, collecting readings
# 4. Stop after 5-10 readings from different positions
# 5. Power off T-Beam
```

### 3. Process Data (2 minutes)
```bash
# Option A: Post-process from SD card
python3 lora_triangulation.py --mode offline --csv lora_data.csv

# Option B: Real-time streaming via USB
python3 lora_triangulation.py --mode realtime --port /dev/ttyUSB0
```

**Output**: Estimated transmitter coordinates + uncertainty map

## 📋 System Overview

```
┌─────────────────────────────────────────────────────────────────┐
│                     Field Collection Phase                       │
│  T-Beam moves around transmitter, collecting GPS + RSSI data    │
└─────────────────────────────┬───────────────────────────────────┘
                               │
                               ▼
                     SD Card (lora_data.csv)
                     or USB Serial Stream
                               │
                 ┌─────────────┴─────────────┐
                 ▼                           ▼
         Offline Processing         Real-Time Processing
       (load_csv + analyze)      (stream from serial)
                 │                           │
                 └─────────────┬─────────────┘
                               ▼
                     Trilateration Engine
                     (least-squares fit)
                               │
                 ┌─────────────┴─────────────┐
                 ▼                           ▼
          Transmitter Location      Uncertainty Estimate
          (latitude, longitude)     (±X meters)
                 │                           │
                 └─────────────┬─────────────┘
                               ▼
                        Visualization Map
                    (triangulation_result.png)
```

## 🔧 Configuration

### Default Settings (Usually OK)
- **LoRa Frequency**: 433 MHz
- **Bandwidth**: 125 kHz
- **Spreading Factor**: 9 (SF9 = moderate range)
- **Reference RSSI**: -70 dBm @ 1 meter
- **Path Loss**: 2.5 (free space)

### Customize
Edit `T-Beam_LoRa_Triangulation.ino`:
```cpp
const float REFERENCE_RSSI = -70;      // Adjust based on calibration
const float PATH_LOSS_EXPONENT = 2.5;  // 2.0-4.0 depending on environment
```

## 📊 Calibration (First Time Setup)

Your accuracy depends on **RSSI calibration**. Without it, location estimates are unreliable.

### Interactive Calibration
```bash
python3 calibrate_rssi.py --port /dev/ttyUSB0

# Prompts you to:
# 1. Place transmitter at known distances (10m, 25m, 50m, 100m)
# 2. Collect RSSI measurements at each distance
# 3. Calculate best-fit path loss model
# 4. Export to calibration.json
```

### Quick Calibration
1. **Place a 433 MHz beacon** at exactly **1 meter** from T-Beam
2. **Note the RSSI value** from serial output
3. **Update REFERENCE_RSSI** in firmware to that value
4. Repeat with 10m, 50m, 100m to verify path loss exponent

## 📈 Usage Examples

### Offline (Process saved CSV)
```bash
# Basic
python3 lora_triangulation.py --mode offline --csv lora_data.csv

# Custom path loss (urban environment)
python3 lora_triangulation.py --mode offline --csv data.csv --path-loss 3.2

# Filter specific transmitter
python3 lora_triangulation.py --csv data.csv --signal ABCD1234
```

### Real-Time (Stream from T-Beam)
```bash
# Start streaming from T-Beam via USB
python3 lora_triangulation.py --mode realtime --port /dev/ttyUSB0

# With custom reference RSSI
python3 lora_triangulation.py --mode realtime --ref-rssi -75
```

## 📍 Expected Accuracy

| Environment | Number of Readings | Typical Error |
|-------------|-------------------|-----------|
| Open field  | 5                 | ±50-100m      |
| Open field  | 10                | ±20-50m       |
| Urban       | 5                 | ±100-200m     |
| Urban       | 10                | ±50-100m      |
| Indoor      | 5-10              | ±100-500m     |

*Heavily depends on transmitter distance, multipath, and calibration accuracy*

## 🐛 Troubleshooting

### GPS won't fix
```
→ Move to open sky (away from buildings)
→ Wait 1-2 minutes for convergence
→ Check GPS antenna connection
→ Try different outdoor location
```

### No LoRa signals received
```
→ Verify transmitter is on 433 MHz
→ Check LoRa antenna is connected properly
→ Verify RadioLib SPI pins match T-Beam
→ Use RF explorer to confirm signal presence
```

### Poor triangulation results
```
→ Collect more readings (minimum 5-10)
→ Spread readings in circular pattern (avoid collinear positions)
→ Recalibrate RSSI model for your environment
→ Ensure GPS fix before each reading
→ Check for multipath (reflections) in environment
```

### SD card not working
```
→ Format as FAT32 (exFAT may not work)
→ Verify CS pin GPIO 13 is not used elsewhere
→ Try different microSD card (some are incompatible)
→ Check card speed (Class 10 recommended)
```

## 📂 Files

| File | Purpose |
|------|----------|
| `T-Beam_LoRa_Triangulation.ino` | Arduino firmware |
| `lora_triangulation.py` | Main processing engine |
| `calibrate_rssi.py` | RSSI calibration wizard |
| `config.py` | Configuration constants |
| `requirements.txt` | Python dependencies |
| `TRIANGULATION_GUIDE.md` | Detailed documentation |
| `lora_data.csv` | Generated on T-Beam SD card |

## 📚 References

- **RadioLib**: https://github.com/jgromes/RadioLib
- **Path Loss Model**: https://en.wikipedia.org/wiki/Friis_transmission_equation
- **Multilateration**: https://en.wikipedia.org/wiki/Multilateration
- **T-Beam Pinout**: https://github.com/LilyGO/TTGO-T-Beam

## 💡 Tips for Best Results

1. **Calibrate first** - Run `calibrate_rssi.py` in your environment
2. **Spread receivers** - Collect readings at least 20m apart
3. **Avoid collinearity** - Don't put all receivers in a line
4. **Multiple passes** - Make 2-3 loops around transmitter
5. **Clear sky GPS** - Ensure outdoor locations or near windows
6. **Wait for GPS fix** - Allow 30-60 seconds after power-on
7. **Line of sight** - Avoid major obstructions if possible
8. **More data = better** - 10 readings beats 3 readings always

## 🚀 Advanced Features

### Weighted Least Squares
```python
# Use SNR to weight readings (stronger signals = more reliable)
from lora_triangulation import Triangulator
triangulator.use_snr_weighting(True)
```

### Custom Distance Model
```python
# Implement non-path-loss models (machine learning, etc.)
class CustomModel:
    def rssi_to_distance(self, rssi): ...
```

### Batch Processing
```bash
# Process multiple CSV files
for file in data_*.csv; do
  python3 lora_triangulation.py --csv "$file" --signal TX$i
done
```

## 📝 License

MIT License - Free to use and modify

---

**Need help?** Check `TRIANGULATION_GUIDE.md` for detailed documentation.

**Questions?** See troubleshooting section above.

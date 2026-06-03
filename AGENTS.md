# AGENTS.md

## Cursor Cloud specific instructions

### What this repo is

Single-product **ESP32 T-Beam LoRa 433 MHz triangulation** stack: firmware (PlatformIO/Arduino) + Python analysis (`lora_triangulation.py`, `calibrate_rssi.py` per README). **As of the current `main` branch, only scaffolding is committed** (`config.py`, `platformio.ini`, flash scripts, docs). Firmware under `src/` and Python entrypoints are **not in git** yet—full `pio run` / `python3 lora_triangulation.py` will fail until those files are added.

### One-time VM prerequisites (not in update script)

- **`python3-venv`** must be installed for `.venv` creation: `sudo apt-get install -y python3.12-venv` (or `python3-venv` on your distro).
- Activate the project venv in each shell: `source /workspace/.venv/bin/activate`

### Dependency refresh (automatic)

On each Cloud Agent VM start, the **update script** recreates/refreshes `.venv` and installs Python deps + PlatformIO + esptool. See the configured update script in Cursor environment settings.

### Python analysis (when scripts exist)

```bash
source .venv/bin/activate
pip install -r requirements.txt   # also covered by update script
python3 lora_triangulation.py --mode offline --csv lora_data.csv
python3 lora_triangulation.py --mode realtime --port /dev/ttyUSB0
python3 calibrate_rssi.py --port /dev/ttyUSB0
```

**Headless plotting:** set `MPLBACKEND=Agg` (or `matplotlib.use("Agg")`) before saving figures.

**Smoke test without hardware** (uses `config.py` + scipy; script is not in repo—run from agent temp or recreate):

```bash
source .venv/bin/activate
MPLBACKEND=Agg python3 /tmp/triangulation_smoke_test.py
```

### Firmware (PlatformIO)

```bash
source .venv/bin/activate
pio run -e t-beam              # build
pio run -e t-beam -t upload    # flash (needs USB device)
pio device monitor -e t-beam   # serial @ 115200
```

**Known blockers on current `main`:**

1. **No `src/` sketch** — PlatformIO has nothing to compile.
2. **`platformio.ini` lib `mikalhart/TinyGPS++ @ ^1.0.3`** — registry lookup fails (`UnknownPackageError`). Use a resolvable TinyGPS++ package id (e.g. search `pio pkg search TinyGPS`) before builds succeed.

ESP32 platform **espressif32 @ 7.0.1** and toolchain install under `.pio/` after first `pio run` / `pio pkg install`.

### Prebuilt binary flash

```bash
source .venv/bin/activate
./flash.sh /dev/ttyUSB0   # needs bootloader.bin, partitions.bin, boot_app0.bin, firmware.bin (gitignored)
```

`flash.sh` is interactive (`read -p`); use `esptool` directly for non-interactive CI.

### Lint / tests

No lint or test targets are defined in the repository (no pytest, ruff, pre-commit, or CI workflows).

### Hardware E2E (optional, not available in Cloud VM)

Requires LilyGO T-Beam, 433 MHz transmitter, GPS sky view, and USB serial (`/dev/ttyUSB0`). Optional: microSD CSV logging, on-device WiFi dashboard (`192.168.4.1`).

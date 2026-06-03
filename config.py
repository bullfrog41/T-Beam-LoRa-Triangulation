"""
Configuration for LoRa Triangulation System
Adjust these values for your environment
"""

# ===== LoRa Radio Configuration =====
LORA_FREQUENCY = 433000000  # 433 MHz (Hz)
LORA_BANDWIDTH = 125000     # 125 kHz
LORA_SPREADING_FACTOR = 9   # SF7-SF12 (higher = longer range, lower data rate)
LORA_CODING_RATE = 7        # CR = 4/7, 4/8, 4/9 (higher = more redundancy)
LORA_OUTPUT_POWER = 17      # dBm (max 17 dBm for EU, 30 dBm for US)
LORA_PREAMBLE_LENGTH = 8    # Symbols
LORA_SYNC_WORD = 0x12       # LoRa sync word

# ===== Path Loss Model Calibration =====
# Critical for accurate distance estimation
# Adjust based on field calibration measurements

# Reference RSSI at 1 meter distance
# Default: -70 dBm (typical for 433 MHz LoRa)
# Calibrate: Measure RSSI at known 1m distance and update this value
REFERENCE_RSSI_DBM = -70

# Path loss exponent
# 2.0 = Free space (ideal conditions)
# 2.5-3.0 = Urban/suburban
# 3.0-4.0 = Dense urban/indoor
# Default: 2.5 (balanced for semi-urban)
PATH_LOSS_EXPONENT = 2.5

# ===== GPS Configuration =====
GPS_UPDATE_INTERVAL_MS = 5000  # Update GPS position every 5 seconds
GPS_MIN_FIX_SATELLITES = 4     # Minimum satellites for valid fix
GPS_TIMEOUT_MS = 5000          # Timeout for GPS read

# ===== Triangulation Algorithm =====
# Minimum readings required for trilateration
MIN_READINGS_FOR_ESTIMATE = 3

# Filter outliers (readings with distance > this multiple of median)
OUTLIER_THRESHOLD = 3.0

# Convergence criteria for least-squares optimization
MAX_ITERATIONS = 1000
CONVERGENCE_TOLERANCE = 1e-6

# ===== SD Card Logging =====
LOG_FILENAME = "/lora_data.csv"
LOG_FLUSH_INTERVAL_S = 5  # Write to SD every 5 seconds

# ===== Serial/USB =====
SERIAL_BAUDRATE = 115200
SERIAL_TIMEOUT_S = 1

# ===== Data Format =====
# CSV columns: timestamp, signalID, latitude, longitude, altitude, rssi, snr
# JSON streaming format:
# {"type":"signal","timestamp":ms,"signalID":"XX","latitude":0.0,"longitude":0.0,"altitude":0.0,"rssi":0,"snr":0.0}

# ===== Visualization =====
PLOT_DPI = 150
PLOT_FIGSIZE = (12, 10)
PLOT_COLORMAP = 'RdYlGn_r'  # Red (weak) to Green (strong)

# ===== Performance Tuning =====
# Reduce for faster processing (less accurate)
# Increase for better accuracy (slower)
POSITION_FIT_METHOD = 'least_squares'  # Options: 'least_squares', 'weighted_ls'

# Weight readings by signal strength (SNR)
WEIGHT_BY_SNR = True

# ===== Debug/Logging =====
VERBOSE = True
LOG_ALL_PACKETS = False
import numpy as np
from PIL import Image

# ---------------- CONFIG ----------------
HEX_FILE = "canny_output20.hex"   # input from RTL
OUT_IMG  = "VANAKAM_chennai23.png"

IMG_W = 256
IMG_H = 256

#borders are not ignored
VALID_W = IMG_W 
VALID_H = IMG_H 
VALID_PIXELS = VALID_W * VALID_H


# Read hex values
with open(HEX_FILE, "r") as f:
    pixels = [int(line.strip(), 16) for line in f if line.strip()]

print("Total pixels in hex file:", len(pixels))

# Take only valid region
pixels = pixels[:VALID_PIXELS]

# Convert to numpy image
img = np.array(pixels, dtype=np.uint8)
img = img.reshape((VALID_H, VALID_W))

# Save cropped image
Image.fromarray(img, mode="L").save(OUT_IMG)

print(f"✅ PNG generated: {OUT_IMG}")
print(f"Image size: {VALID_W} x {VALID_H}")

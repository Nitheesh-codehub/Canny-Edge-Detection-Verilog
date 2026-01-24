from PIL import Image

# ===============================
# EDIT THESE TWO LINES ONLY
# ===============================
png_file = "input.png"      # input image
hex_file = "output.hex"    # output hex file
# ===============================

# Open image and convert to grayscale
img = Image.open(png_file).convert("L")

# Check image size
w, h = img.size
if w != 256 or h != 256:
    raise ValueError("Image must be exactly 256x256")

# Read pixels
pixels = list(img.getdata())

# Write to hex file (1 pixel per line)
with open(hex_file, "w") as f:
    for p in pixels:
        f.write(f"{p:02x}\n")

print("PNG → HEX conversion done")
print("Image size:", w, "x", h)
print("Pixels written:", len(pixels))
print("Output file:", hex_file)
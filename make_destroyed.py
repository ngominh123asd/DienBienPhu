import sys
from PIL import Image, ImageDraw
import random

def create_destroyed_locot(in_path, out_path):
    img = Image.open(in_path).convert("RGBA")
    pixels = img.load()
    width, height = img.size
    
    # Create chunks of holes
    draw = ImageDraw.Draw(img)
    for _ in range(80):
        # Random center for a hole
        x = random.randint(0, width)
        y = random.randint(0, height)
        # Random size for hole
        r = random.randint(5, 25)
        
        # Only delete if it's hitting the non-transparent part
        # We'll just draw transparent ellipses
        draw.ellipse((x - r, y - r, x + r, y + r), fill=(0, 0, 0, 0))
    
    # Also add some jagged lines (cracks)
    for _ in range(15):
        x1 = random.randint(0, width)
        y1 = random.randint(0, height)
        x2 = x1 + random.randint(-40, 40)
        y2 = y1 + random.randint(-40, 40)
        draw.line((x1, y1, x2, y2), fill=(0, 0, 0, 0), width=random.randint(2, 6))

    img.save(out_path)

if __name__ == "__main__":
    create_destroyed_locot(sys.argv[1], sys.argv[2])

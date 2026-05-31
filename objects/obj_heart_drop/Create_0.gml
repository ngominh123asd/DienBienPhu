vspeed = 1.2; // Falls down slowly
hspeed = choose(-0.4, 0.4); // Drifts horizontally
bounce_offset = random(100); // Unique animation offset

// Scale collision mask to match visual size (640x640 scaled to ~45x45)
image_xscale = 0.07;
image_yscale = 0.07;

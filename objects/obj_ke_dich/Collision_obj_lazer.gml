// Reduce life
life = life - 1;

// Destroy the laser bullet that hit us
instance_destroy(other);

// Play hit sound
audio_play_sound(sndMeleeHit, 10, 0);

// Check if dead
if (life <= 0) {
    audio_play_sound(sndDie, 10, 0);
    instance_create_layer(x, y, "Instances", oFx_DeadPlayer);
    instance_destroy();
}
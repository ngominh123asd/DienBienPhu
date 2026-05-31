// Restore health to player
with (other) {
    if (hp < max_hp) {
        hp += 1;
    }
    // Play heal sound
    audio_play_sound(sndGetHp, 10, 0);
}

// Destroy health pickup
instance_destroy();

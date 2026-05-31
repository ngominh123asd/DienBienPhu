// Grant weapon upgrade to player
with (other) {
    bullet_upgrade = true;
    audio_play_sound(sndLevelUp, 10, 0);
}

// Destroy power-up
instance_destroy();

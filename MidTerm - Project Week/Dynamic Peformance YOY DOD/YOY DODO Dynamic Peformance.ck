//YOY - DODO
//Evertime you hit play is a diffrent performance of the song "YOY" :)

// 1. Tempo
109.0 => float bpm;
(60.0 / bpm) :: second => dur beat;
beat * 16 => dur fourBars;

// 2. My Samples
SndBuf drums => dac;
SndBuf percussion => dac;
SndBuf bass => dac;
SndBuf bassLow => dac;
SndBuf bassHigh => dac;
SndBuf subBass => dac;
SndBuf leadLow => dac;
SndBuf leadHigh => dac;
SndBuf leadReverb => dac;

me.dir() + "Samples/Drums.wav" => drums.read;
me.dir() + "Samples/Percussion.wav" => percussion.read;
me.dir() + "Samples/Bass.wav" => bass.read;
me.dir() + "Samples/Bass LOW.wav" => bassLow.read;
me.dir() + "Samples/Bass HIGH.wav" => bassHigh.read;
me.dir() + "Samples/SUB BASS.wav" => subBass.read;
me.dir() + "Samples/Lead LOW.wav" => leadLow.read;
me.dir() + "Samples/Lead HIGH.wav" => leadHigh.read;
me.dir() + "Samples/Lead w Reverb.wav" => leadReverb.read;

// 3. Volume:
0.65 => drums.gain;
0.30 => percussion.gain;
0.40 => bass.gain;
0.40 => bassLow.gain;
0.40 => bassHigh.gain;
0.30 => subBass.gain;
0.38 => leadLow.gain;
0.38 => leadHigh.gain;
0.38 => leadReverb.gain;

// Original speed and pitch.
1.0 => drums.rate;
1.0 => percussion.rate;
1.0 => bass.rate;
1.0 => bassLow.rate;
1.0 => bassHigh.rate;
1.0 => subBass.rate;
1.0 => leadLow.rate;
1.0 => leadHigh.rate;
1.0 => leadReverb.rate;

// Start silent (seek to end of each WAV)
drums.samples() => drums.pos;
percussion.samples() => percussion.pos;
bass.samples() => bass.pos;
bassLow.samples() => bassLow.pos;
bassHigh.samples() => bassHigh.pos;
subBass.samples() => subBass.pos;
leadLow.samples() => leadLow.pos;
leadHigh.samples() => leadHigh.pos;
leadReverb.samples() => leadReverb.pos;

// 4. RANDOMNESS (Smaller number = changes more often. 1 = every 4 bars).
1 => int roundsPerChange;
0 => int round;

// 5. GENERATIVE SONG
while (true)
{
    // Every 4 bars, STOP everything, including the 8-bar drums. Lead w Reverb never overlaps with drums or other leads.
    drums.samples() => drums.pos;
    percussion.samples() => percussion.pos;
    bass.samples() => bass.pos;
    bassLow.samples() => bassLow.pos;
    bassHigh.samples() => bassHigh.pos;
    subBass.samples() => subBass.pos;
    leadLow.samples() => leadLow.pos;
    leadHigh.samples() => leadHigh.pos;
    leadReverb.samples() => leadReverb.pos;

    // Pick a section. 0 = drums only, 1 = just one sound,
    // 2 = two sounds, 3 = small groove, 4 = fuller arrangement,
    // 5 = reverb lead spotlight (NO drums / other leads).
    Math.random2(0, 5) => int section;

    if (section == 0)
    {
        0 => drums.pos;
        <<< "DRUMS ONLY" >>>;
    }

    if (section == 1)
    {
        // One randomly selected sample, no drums required.
        Math.random2(0, 7) => int choice;
        if (choice == 0) { 0 => percussion.pos; }
        if (choice == 1) { 0 => bass.pos; }
        if (choice == 2) { 0 => bassLow.pos; }
        if (choice == 3) { 0 => bassHigh.pos; }
        if (choice == 4) { 0 => subBass.pos; }
        if (choice == 5) { 0 => leadLow.pos; }
        if (choice == 6) { 0 => leadHigh.pos; }
        if (choice == 7) { 0 => leadReverb.pos; }
        <<< "ONE SOUND", choice >>>;
    }

    if (section == 2)
    {
        // Two sounds: drums OR percussion, plus one bass/lead.
        if (Math.random2(0, 1) == 0) { 0 => drums.pos; }
        else { 0 => percussion.pos; }
        Math.random2(0, 5) => int choice;
        if (choice == 0) { 0 => bass.pos; }
        if (choice == 1) { 0 => bassLow.pos; }
        if (choice == 2) { 0 => bassHigh.pos; }
        if (choice == 3) { 0 => subBass.pos; }
        if (choice == 4) { 0 => leadLow.pos; }
        if (choice == 5) { 0 => leadHigh.pos; }
        <<< "TWO SOUNDS", choice >>>;
    }

    if (section == 3)
    {
        // Small groove: drums + one bass, sometimes percussion.
        0 => drums.pos;
        Math.random2(0, 2) => int choice;
        if (choice == 0) { 0 => bass.pos; }
        if (choice == 1) { 0 => bassLow.pos; }
        if (choice == 2) { 0 => bassHigh.pos; }
        if (Math.random2(0, 1) == 1) { 0 => percussion.pos; }
        <<< "SMALL GROOVE" >>>;
    }

    if (section == 4)
    {
        // Full arrangement: drums, percussion, bass, lead, optional sub.
        0 => drums.pos;
        0 => percussion.pos;
        Math.random2(0, 2) => int bassChoice;
        if (bassChoice == 0) { 0 => bass.pos; }
        if (bassChoice == 1) { 0 => bassLow.pos; }
        if (bassChoice == 2) { 0 => bassHigh.pos; }
        if (Math.random2(0, 1) == 1) { 0 => subBass.pos; }
        if (Math.random2(0, 1) == 0) { 0 => leadLow.pos; }
        else { 0 => leadHigh.pos; }
        <<< "FULL ARRANGEMENT" >>>;
    }

    if (section == 5)
    {
        // Lead with Reverb NEVER plays with Drums.wav, Lead HIGH.wav or Lead LOW.wav.
        0 => leadReverb.pos;
        if (Math.random2(0, 1) == 1) { 0 => bassLow.pos; }
        if (Math.random2(0, 2) == 0) { 0 => percussion.pos; }
        <<< "REVERB LEAD SPOTLIGHT" >>>;
    }

    // Every section begins exactly on the 109 BPM grid.
    // Drum WAV is 8 bars so intentionally play first 4 bars before choosing a new section.
    fourBars => now;
    round + 1 => round;
}

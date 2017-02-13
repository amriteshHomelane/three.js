#ifdef PROGRESSIVE_SAO_ENABLED

    float aoValue = 1.0 - min(texture2D(saoBuffer, gl_FragCoord.xy/bufferSize).r, 1.0);
    reflectedLight.indirectDiffuse  *= aoValue;
    reflectedLight.indirectSpecular *= aoValue;

#endif

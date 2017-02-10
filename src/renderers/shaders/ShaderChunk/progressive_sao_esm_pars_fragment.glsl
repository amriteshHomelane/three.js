#if defined(PROGRESSIVE_SAO_ENABLED) || defined(PROGRESSIVE_ESM_ENABLED)
    uniform vec2 bufferSize;
#endif

#ifdef PROGRESSIVE_SAO_ENABLED
    uniform sampler2D saoBuffer;
#endif

// #ifdef PROGRESSIVE_ESM_ENABLED
//     uniform sampler2D esmBuffer;
// #endif

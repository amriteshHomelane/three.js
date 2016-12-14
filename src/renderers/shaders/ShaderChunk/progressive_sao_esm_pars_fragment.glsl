#ifdef PROGRESSIVE_SAO_ENABLED
    uniform sampler2D saoBuffer;
    uniform vec2 bufferSize;
#endif

#ifdef PROGRESSIVE_ESM_ENABLED
    uniform sampler2D esmBuffer;
#endif

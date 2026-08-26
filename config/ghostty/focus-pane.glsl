void mainImage(out vec4 fragColor, in vec2 fragCoord) {
    vec2 uv = fragCoord / iResolution.xy;
    vec4 terminal = texture2D(iChannel0, uv);

    if (iFocus > 0) {
        float borderWidth = 3.0;
        bool border =
            fragCoord.x < borderWidth ||
            fragCoord.x >= iResolution.x - borderWidth ||
            fragCoord.y < borderWidth ||
            fragCoord.y >= iResolution.y - borderWidth;

        if (border) {
            vec3 cyan = vec3(0.20, 0.80, 1.00);
            vec3 green = vec3(0.00, 1.00, 0.60);
            float gradientPosition = clamp((uv.x + (1.0 - uv.y)) * 0.5, 0.0, 1.0);
            terminal = vec4(mix(cyan, green, gradientPosition), 1.0);
        }
    }

    fragColor = terminal;
}

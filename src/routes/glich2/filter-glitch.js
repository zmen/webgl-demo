import helpers from './helpers';

const glitchFilter = (ctx, imageData, {
    k, lines, max, min, rules
} = {}) => {
    if (Math.abs(k) > 10) k = Infinity;
    let cpImageData = helpers.copyImageData(ctx, imageData);
    let imgBmp = cpImageData.data;
    const LEN = cpImageData.data.length;
    const WIDTH = cpImageData.width;
    const HEIGHT = cpImageData.height;
    const BUILTIN_GENERATOR = () =>
        helpers.random(min, max) * [1, -1, 0][~~(Math.random() * 3)];
    const TRANSFORM = rules || lines.map(BUILTIN_GENERATOR);
    glitch()

    return cpImageData;

    function glitch () {
        let x = 0;
        let y = 0;
        let b = 0;
        let quadrant = {};
        let nextIndex = 0;
        const ty = isFinite(k) ? k > 0 ? HEIGHT : HEIGHT - k * WIDTH : WIDTH;
        const by = isFinite(k) && k > 0 ? -k * WIDTH : 0;
        const yAxis = lines.map(r => by + r * (ty - by));
        for (let i = 0; i < LEN; i += 4) {
            x = (i / 4) % WIDTH;
            y = ~~(i / 4 / WIDTH);
            b = isFinite(k) ? (y - k * x) : x;
            for (let j = 0; j < yAxis.length; j++) {
                if (b < yAxis[j]) {
                    quadrant = TRANSFORM[j];
                    break;
                }
            }
            if (quadrant === 0) continue;
            nextIndex = helpers.getNextPointIndex(x, y, k, quadrant, WIDTH, HEIGHT);
            if (nextIndex === -1) {
                imgBmp[i + 3] = 0;
            } else {
                imgBmp[i] = imageData.data[nextIndex];
                imgBmp[i + 1] = imageData.data[nextIndex + 1];
                imgBmp[i + 2] = imageData.data[nextIndex + 2];
                imgBmp[i + 3] = imageData.data[nextIndex + 3];
            }
        }
    }
};

export default glitchFilter;

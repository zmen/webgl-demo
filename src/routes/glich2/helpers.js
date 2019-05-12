function copyImageData (ctx, src) {
    const dst = ctx.createImageData(src.width, src.height);
    dst.data.set(src.data);
    return dst;
}

function random (min, max) {
    return ~~(Math.random() * (max - min) + min);
}

function isInRect (x, y, w, h) {
    return x >= 0 && y >= 0 && x <= w && y <= h;
}

function getNextPointIndex (x, y, k, offset, width, height) {
    let _x, _y, r;
    if (Math.abs(k) <= 10) {
        r = Math.sqrt(1 + k * k);
        _x = x + ~~(offset / r);
        _y = y + ~~(offset * k / r);
    } else {
        _x = x;
        _y = y + ~~offset;
    }
    if (!isInRect(_x, _y, width, height)) return -1;
    return (_x + _y * width) * 4;
}

export default {
    copyImageData,
    random,
    isInRect,
    getNextPointIndex
};

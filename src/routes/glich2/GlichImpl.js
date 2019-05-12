import filter from './filter-glitch';
import helpers from './helpers';

export default class GlichImpl {
    constructor(canvas, width, height, img, {k, lines, max, min, period, total} = {}) {
        this.ctx = canvas.getContext('2d');
        this.width = width;
        this.height = height;
        this.stop = false;
        this.k = k || 1;
        this.lines = lines || [0, 0.2, 0.4, 0.6, 0.8, 1];
        this.max = max || 100;
        this.min = min || 80;
        this.period = period || 100;
        this.total = total || 10000;
        this.initialRules = this.lines.map(() => helpers.random(this.min, this.max) * [1, -1, 0][~~(Math.random() * 3)]);
        this.rules = this.initialRules.slice(0);
        this.loadImage(img);
    }
    loadImage = (img) => {
        this.img = new Image();
        this.img.src = img;
        this.img.onload = () => { this.reset(); };
    }
    setFields = (field, value) => {
        this[field] = value;
        if (field === 'lines') {
            this.initialRules = this.lines.map(() => helpers.random(this.min, this.max) * [1, -1, 0][~~(Math.random() * 3)]);
            this.rules = this.initialRules.slice(0);
        }
    }
    pause = () => { this.stop = true; }
    reset = () => {
        this.stop = true;
        this.ctx.drawImage(this.img, 0, 0, this.width, this.height);
        this.imageData = this.ctx.getImageData(0, 0, this.width, this.height);
    }
    play = () => {
        this.stop = false;
        const now = Date.now();
        const frame = () => {
            const elapse = Date.now() - now;
            this.next(elapse, this.period, this.total);
            this.transform(this.rules);
            if (!this.stop) {
                requestAnimationFrame(frame);
            }
        }
        frame();
    }
    next = (elapse, period, alive) => {
        this.rules = this.initialRules.map(R => {
            if (R === 0) return 0;
            let r = Math.abs(R) * (1 - elapse / alive);
            if (r < 1) {
                this.reset();
                console.log('done');
            }
            let offset = elapse / period * Math.PI * r * 2;
            return harmonic(offset, (R < 0 ? -1 : 1) * r);
        })
        function harmonic(offset, initial) {
            let R = Math.abs(initial);
            let angel = offset / R;
            if (initial < 0) angel += Math.PI;
            return R * Math.cos(angel);
        }
    }
    transform = (rules) => {
        const transformedImageData = filter(this.ctx, this.imageData, {
            k: this.k,
            lines: this.lines,
            max: this.max,
            min: this.min,
            rules
        });
        this.ctx.putImageData(transformedImageData, 0, 0);
    }
}

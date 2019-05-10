export default class V3D12_GlichImpl {

  constructor(canvas, width, height, img, duration) {
    this.ctx = canvas.getContext('2d');
    this.width = width;
    this.height = height;
    this.duration = duration;
    this.img = new Image();
    this.img.src = img;
    this.img.onload = () => {
      this.reset();
    };
    this.concussionIds = [];
    this.animateIds = [];
  }

  reset() {
    const { animateIds, concussionIds, ctx } = this;
    if (animateIds.length) {
      animateIds.forEach(animateId => window.cancelAnimationFrame(animateId));
      this.animateIds = [];
    }
    if (concussionIds.length) {
      concussionIds.forEach(concussionId => window.cancelAnimationFrame(concussionId));
      this.concussionIds = [];
    }
    this.pausing = false;
    ctx.restore();
    ctx.clearRect(0, 0, this.width, this.height);
    ctx.drawImage(this.img, 0, 0, this.width, this.height);
  }

  pause() {
    this.pausing = !this.pausing;
  }

  animate(deg, size, startValue, endValue, glitch, index, done) {
    const { duration, animateIds } = this;
    const start = Date.now();
    const finish = start + duration;
    let time;
    let byValue = endValue - startValue;
    const tick = (ticktime) => {
      if (!this.pausing) {
        time = ticktime ? Date.now() : start;
        const currentTime = time > finish ? duration : (time - start);
        const current = startValue + byValue * currentTime / duration;
        this.drawGlitch(deg, size, current, glitch);
        if (time > finish) {
          done();
          return;
        }
      }
      animateIds[index] = window.requestAnimFrame(tick);
    };
    tick();
  }

  start = (deg, size, offset, glitch, index) => {
    let startValue = offset;
    let endValue = 0;
    const tick = () => {
      if (startValue > 0) {
        endValue = 2 - startValue;
      } else if (startValue < 0) {
        endValue = -2 - startValue;
      }
      this.animate(deg, size, startValue, endValue, glitch, index, () => {
        this.concussionIds[index] = window.requestAnimFrame(tick);
      });
      if (Number(endValue.toFixed(5)) === 0) {
        this.reset();
        return;
      }
      startValue = endValue;
    };
    tick();
  };

  translateImage(targetX, targetY, points) {
    const { width, height, img, ctx } = this;
    ctx.save();
    ctx.beginPath();
    ctx.moveTo(points[0].x, points[0].y);
    ctx.lineTo(points[1].x, points[1].y);
    ctx.lineTo(points[2].x, points[2].y);
    ctx.lineTo(points[3].x, points[3].y);
    ctx.closePath();
    ctx.clip();
    ctx.clearRect(0, 0, width, height);
    ctx.drawImage(img, targetX, targetY, width, height);
    ctx.restore();
  }

  drawGlitch(deg, size, offset, glitch) {
    if (deg < 45) {
      this.drawXGlitch(deg, size, offset, glitch);
    } else if (deg < 90) {
      this.drawYGlitch(deg, size, offset, glitch);
    } else if (deg < 135) {
      this.drawLargeYGlitch(deg, size, offset, glitch);
    } else {
      this.drawLargeXGlitch(deg, size, offset, glitch);
    }
  }

  drawXGlitch(deg, height, offsetX, glitchY) {
    let tanDeg = Math.tan(Math.PI * deg / 180);
    let offsetHeight = tanDeg * this.width;
    let points = [
      { x: 0, y: glitchY },
      { x: this.width, y: glitchY - offsetHeight },
      { x: this.width, y: glitchY - offsetHeight + height },
      { x: 0, y: glitchY + height },
    ];
    this.translateImage(offsetX, -tanDeg * offsetX, points);
  }

  drawYGlitch(deg, width, offsetY, glitchX) {
    let tanDeg = Math.tan(Math.PI * deg / 180);
    let offsetWidth = this.height / tanDeg;
    let points = [
      { x: glitchX, y: 0 },
      { x: glitchX - offsetWidth, y: this.height },
      { x: glitchX - offsetWidth + width, y: this.height },
      { x: glitchX + width, y: 0 },
    ];
    this.translateImage(-offsetY / tanDeg, offsetY, points);
  }

  drawLargeYGlitch(deg, width, offsetY, glitchX) {
    let tanDeg = Math.tan(Math.PI * (180 - deg) / 180);
    let offsetWidth = this.height / tanDeg;
    let points = [
      { x: glitchX, y: 0 },
      { x: glitchX + offsetWidth, y: this.height },
      { x: glitchX + offsetWidth + width, y: this.height },
      { x: glitchX + width, y: 0 },
    ];
    this.translateImage(offsetY / tanDeg, offsetY, points);
  }

  drawLargeXGlitch(deg, height, offsetX, glitchY) {
    let tanDeg = Math.tan(Math.PI * (180 - deg) / 180);
    let offsetHeight = tanDeg * this.width;
    let points = [
      { x: 0, y: glitchY },
      { x: this.width, y: glitchY + offsetHeight },
      { x: this.width, y: glitchY + offsetHeight + height },
      { x: 0, y: glitchY + height },
    ];
    this.translateImage(offsetX, tanDeg * offsetX, points);
  }

}

import React, { Component } from 'react';
import { Button } from 'antd';
import './filter.css';
import TestImg from './test.png';
import Test1Img from './test1.png';
import Test2Img from './test2.png';

class WrappedFilter extends Component {

  constructor(args) {
    super(args);
    this.state = {
      nowImage: 1,
    };
    this.width = 250;
    this.height = 250;
    this.imageList = [TestImg, Test1Img, Test2Img];
    this.concussionIds = [];
    this.animateIds = [];
  }

  saveRef = (canvas) => {
    if (canvas) {
      this.canvas = canvas;
      this.width = canvas.width;
      this.height = canvas.height;
    }
  };

  componentDidMount() {
    this.img = new Image();
    this.img.src = Test1Img;
    this.img.onload = () => {
      this.reset();
    };
  }

  onSetImage = index => {
    this.setState({ nowImage: index });
    this.img.src = this.imageList[index];
    this.reset();
  };

  getRndInteger = (min, max) => {
    return Math.floor(Math.random() * (max - min + 1)) + min;
  };

  getRndOne = (...numbers) => {
    return numbers[Math.floor(Math.random() * numbers.length)];
  };

  reset = () => {
    if (this.animateIds) {
      this.animateIds.forEach(animateId => window.cancelAnimationFrame(animateId));
      this.animateIds = [];
    }
    if (this.concussionIds.length) {
      this.concussionIds.forEach(concussionId => window.cancelAnimationFrame(concussionId));
      this.concussionIds = [];
    }
    this.pausing = false;
    let ctx = this.canvas.getContext('2d');
    ctx.restore();
    ctx.clearRect(0, 0, this.width, this.height);
    ctx.drawImage(this.img, 0, 0, this.width, this.height);
  };

  pause = () => {
    this.pausing = !this.pausing;
  };

  random = () => {
    this.reset();
    let number = this.getRndInteger(1, 4);
    let deg = this.getRndInteger(1, 179);
    for (let i = 1; i <= number; i++) {
      // 50 ~ 200
      let size = this.getRndInteger(5, 20);
      let glitch = this.getRndInteger(50 + 200 / number * (i - 1), 50 + 200 / number * i);
      let offset = this.getRndOne(100, -100);
      console.log(offset);
      this.start(deg, size, offset, glitch, i);
    }
  };

  animate = (deg, size, startValue, endValue, glitch, index, done) => {
    const start = Date.now();
    const duration = 30;
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
      this.animateIds[index] = window.requestAnimFrame(tick);
    };
    tick();
  };

  start = (deg, size, offset, glitch, index) => {
    let startValue = offset;
    let endValue = 0;
    const tick = () => {
      if (startValue > 0) {
        endValue = 1 - startValue;
      } else if (startValue < 0) {
        endValue = -1 - startValue;
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

  translateImage(ctx, targetX, targetY, points) {
    ctx.save();
    ctx.beginPath();
    ctx.moveTo(points[0].x, points[0].y);
    ctx.lineTo(points[1].x, points[1].y);
    ctx.lineTo(points[2].x, points[2].y);
    ctx.lineTo(points[3].x, points[3].y);
    ctx.closePath();
    ctx.clip();
    ctx.clearRect(0, 0, this.width, this.height);
    ctx.drawImage(this.img, targetX, targetY, this.width, this.height);
    ctx.restore();
  }

  drawGlitch = (deg, size, offset, glitch) => {
    if (deg < 45) {
      this.drawXGlitch(deg, size, offset, glitch);
    } else if (deg < 90) {
      this.drawYGlitch(deg, size, offset, glitch);
    } else if (deg < 135) {
      this.drawLargeYGlitch(deg, size, offset, glitch);
    } else {
      this.drawLargeXGlitch(deg, size, offset, glitch);
    }
  };

  drawXGlitch(deg, height, offsetX, glitchY) {
    let ctx = this.canvas.getContext('2d');
    let tanDeg = Math.tan(Math.PI * deg / 180);
    let offsetHeight = tanDeg * this.width;
    let points = [
      { x: 0, y: glitchY },
      { x: this.width, y: glitchY - offsetHeight },
      { x: this.width, y: glitchY - offsetHeight + height },
      { x: 0, y: glitchY + height },
    ];
    this.translateImage(ctx, offsetX, -tanDeg * offsetX, points);
  }

  drawYGlitch(deg, width, offsetY, glitchX) {
    let ctx = this.canvas.getContext('2d');
    let tanDeg = Math.tan(Math.PI * deg / 180);
    let offsetWidth = this.height / tanDeg;
    let points = [
      { x: glitchX, y: 0 },
      { x: glitchX - offsetWidth, y: this.height },
      { x: glitchX - offsetWidth + width, y: this.height },
      { x: glitchX + width, y: 0 },
    ];
    this.translateImage(ctx, -offsetY / tanDeg, offsetY, points);
  }

  drawLargeYGlitch(deg, width, offsetY, glitchX) {
    let ctx = this.canvas.getContext('2d');
    let tanDeg = Math.tan(Math.PI * (180 - deg) / 180);
    let offsetWidth = this.height / tanDeg;
    let points = [
      { x: glitchX, y: 0 },
      { x: glitchX + offsetWidth, y: this.height },
      { x: glitchX + offsetWidth + width, y: this.height },
      { x: glitchX + width, y: 0 },
    ];
    this.translateImage(ctx, offsetY / tanDeg, offsetY, points);
  }

  drawLargeXGlitch(deg, height, offsetX, glitchY) {
    let ctx = this.canvas.getContext('2d');
    let tanDeg = Math.tan(Math.PI * (180 - deg) / 180);
    let offsetHeight = tanDeg * this.width;
    let points = [
      { x: 0, y: glitchY },
      { x: this.width, y: glitchY + offsetHeight },
      { x: this.width, y: glitchY + offsetHeight + height },
      { x: 0, y: glitchY + height },
    ];
    this.translateImage(ctx, offsetX, tanDeg * offsetX, points);
  }

  render() {
    const { nowImage } = this.state;
    return (
      <div className='filter'>
        <div className='filter-t-shirt'>
          <canvas
            width={this.width}
            height={this.height}
            className='filter-canvas'
            ref={this.saveRef}
          />
        </div>
        <div className='operation-area'>
          <Button onClick={this.random} type='primary'>随机割裂</Button>
          &nbsp;&nbsp;
          <Button onClick={this.pause} type='primary'>暂停</Button>
          &nbsp;&nbsp;
          <Button onClick={this.reset}>重置</Button>
          <br />
          <div className='image-list'>
            <div className='image-list-label'>选择图片：</div>
            {this.imageList.map((image, index) => (
              <img
                key={index}
                className={nowImage === index ? 'selected' : ''}
                src={image}
                onClick={() => this.onSetImage(index)}
                alt=""
              />
            ))}
          </div>
        </div>
      </div>
    );
  }
}

export default WrappedFilter;

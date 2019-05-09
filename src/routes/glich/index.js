import React, { Component } from 'react';
import { Button, Form, InputNumber } from 'antd';
import './filter.css';
import TestImg from './test.png';
import TransparentImg from './transparent.png';

const FormItem = Form.Item;

class Filter extends Component {

  constructor(args) {
    super(args);
    this.state = {};
    this.width = 250;
    this.height = 250;
    this.intervals = [];
  }

  saveRef = (canvas) => {
    this.canvas = canvas;
    this.width = canvas.width;
    this.height = canvas.height;
  };

  componentDidMount() {
    this.img = new Image();
    this.img.src = TestImg;
    this.transparentImg = new Image();
    this.transparentImg.src = TransparentImg;
    this.img.onload = () => {
      this.reset();
    };
  }

  getRndInteger = (min, max) => {
    return Math.floor(Math.random() * (max - min + 1)) + min;
  };

  reset = () => {
    if (this.animateId) {
      window.cancelAnimationFrame(this.animateId);
      this.animateId = null;
    }
    if (this.concussionId) {
      window.cancelAnimationFrame(this.concussionId);
      this.concussionId = null;
    }
    if (this.animateTimeoutId) {
      clearTimeout(this.animateTimeoutId);
      this.animateTimeoutId = null;
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
    this.props.form.setFieldsValue(this.getRandomObject());
    this.start();
  };

  getRandomObject = () => {
    let deg = this.getRndInteger(1, 179);
    let size = this.getRndInteger(5, 20);
    let glitch = this.getRndInteger(120, 130);
    return { deg, size, offset: 50, glitch };
  };

  animate = (deg, size, startValue, endValue, glitch, done) => {
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
      this.animateId = window.requestAnimFrame(tick);
    };
    tick();
  };

  start = () => {
    this.reset();
    let values = this.props.form.getFieldsValue();
    let { offset, deg, size, glitch } = values;
    let startValue = offset;
    let endValue = 0;
    const tick = () => {
      if (startValue > 0) {
        endValue = 1 - startValue;
      } else if (startValue < 0) {
        endValue = -1 - startValue;
      }
      this.animate(deg, size, startValue, endValue, glitch, () => {
        this.concussionId = window.requestAnimFrame(tick);
      });
      if (Number(endValue.toFixed(5)) === 0) {
        this.reset();
        return;
      }
      startValue = endValue;
    };
    tick();
  };

  translateImage(ctx, targetX, targetY) {
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
    ctx.save();
    ctx.beginPath();
    ctx.moveTo(0, glitchY);
    ctx.lineTo(this.width, glitchY - offsetHeight);
    ctx.lineTo(this.width, glitchY - offsetHeight + height);
    ctx.lineTo(0, glitchY + height);
    ctx.closePath();
    ctx.clip();
    this.translateImage(ctx, offsetX, -tanDeg * offsetX);
  }

  drawYGlitch(deg, width, offsetY, glitchX) {
    let ctx = this.canvas.getContext('2d');
    let tanDeg = Math.tan(Math.PI * deg / 180);
    let offsetWidth = this.height / tanDeg;
    ctx.save();
    ctx.beginPath();
    ctx.moveTo(glitchX, 0);
    ctx.lineTo(glitchX - offsetWidth, this.height);
    ctx.lineTo(glitchX - offsetWidth + width, this.height);
    ctx.lineTo(glitchX + width, 0);
    ctx.closePath();
    ctx.clip();
    this.translateImage(ctx, -offsetY / tanDeg, offsetY);
  }

  drawLargeYGlitch(deg, width, offsetY, glitchX) {
    let ctx = this.canvas.getContext('2d');
    let tanDeg = Math.tan(Math.PI * (180 - deg) / 180);
    let offsetWidth = this.height / tanDeg;
    ctx.save();
    ctx.beginPath();
    ctx.moveTo(glitchX, 0);
    ctx.lineTo(glitchX + offsetWidth, this.height);
    ctx.lineTo(glitchX + offsetWidth + width, this.height);
    ctx.lineTo(glitchX + width, 0);
    ctx.closePath();
    ctx.clip();
    this.translateImage(ctx, offsetY / tanDeg, offsetY);
  }

  drawLargeXGlitch(deg, height, offsetX, glitchY) {
    let ctx = this.canvas.getContext('2d');
    let tanDeg = Math.tan(Math.PI * (180 - deg) / 180);
    let offsetHeight = tanDeg * this.width;
    ctx.save();
    ctx.beginPath();
    ctx.moveTo(0, glitchY);
    ctx.lineTo(this.width, glitchY + offsetHeight);
    ctx.lineTo(this.width, glitchY + offsetHeight + height);
    ctx.lineTo(0, glitchY + height);
    ctx.closePath();
    ctx.clip();
    this.translateImage(ctx, offsetX, tanDeg * offsetX);
  }

  render() {
    const {} = this.state;
    const { getFieldDecorator } = this.props.form;
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
          <Button onClick={this.random} type='primary'>随机</Button>
          &nbsp;&nbsp;
          <Button onClick={this.start} type='primary'>割裂</Button>
          &nbsp;&nbsp;
          <Button onClick={this.pause} type='primary'>暂停</Button>
          &nbsp;&nbsp;
          <Button onClick={this.reset}>重置</Button>
          <Form>
            <FormItem label='割裂角度'>
              {getFieldDecorator('deg', {
                initialValue: 30,
              })(
                <InputNumber />,
              )}
            </FormItem>
            <FormItem label='割裂大小'>
              {getFieldDecorator('size', {
                initialValue: 10,
              })(
                <InputNumber />,
              )}
            </FormItem>
            <FormItem label='割裂偏移量'>
              {getFieldDecorator('offset', {
                initialValue: 100,
              })(
                <InputNumber />,
              )}
            </FormItem>
            <FormItem label='割裂位置'>
              {getFieldDecorator('glitch', {
                initialValue: 200,
              })(
                <InputNumber />,
              )}
            </FormItem>
          </Form>
        </div>
      </div>
    );
  }
}

const WrappedFilter = Form.create()(Filter);

export default WrappedFilter;

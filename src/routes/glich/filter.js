import React, { Component } from 'react';
import './filter.scss'
import TestImg from './test.png'
import Test1Img from './test1.png'
import Test2Img from './test2.png'
import { Button } from 'antd'

class Filter extends Component {

    constructor(args){
        super(args);
        this.state = {
            nowImage: 1
        };
        this.width = 250;
        this.height = 250;
        this.imageList = [TestImg, Test1Img, Test2Img];
    }

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
        return Math.floor(Math.random() * (max - min + 1) ) + min;
    };

    reset = () => {
        let ctx = this.canvas.getContext('2d');
        ctx.clearRect(0, 0, this.width, this.height);
        ctx.drawImage(this.img, 0, 0, this.width, this.height);
    };

    random = () => {
        this.reset();
        let number = this.getRndInteger(1, 4);
        let deg = null;
        for(let i = 1; i <= number; i++) {
            // 50 ~ 200
            let values = this.getRandomObject(50 + 200 / number * (i - 1), 50 + 200 / number * i);
            if(!deg)
                deg = values.deg;
            this.drawGlitch(deg, values.size, values.offset, values.glitch);
        }
    };

    getRandomObject = (minOffset, maxOffset) => {
        let deg = this.getRndInteger(1, 179);
        let size = this.getRndInteger(5, 40);
        let offset = this.getRndInteger(-100, 100);
        let glitch = this.getRndInteger(minOffset, maxOffset);
        return { deg, size, offset, glitch };
    };

    animationTranslateImage(ctx, img, sourceX, sourceY, targetX, targetY, points, time = 100) {
        let frameTime = 25;
        let nowX = sourceX, nowY = sourceY;
        let interval = setInterval(() => {
            ctx.save();
            ctx.beginPath();
            ctx.moveTo(points[0].x, points[0].y);
            ctx.lineTo(points[1].x, points[1].y);
            ctx.lineTo(points[2].x, points[2].y);
            ctx.lineTo(points[3].x, points[3].y);
            ctx.closePath();
            ctx.clip();
            ctx.clearRect(0,0, this.width, this.height);
            ctx.drawImage(this.img, nowX, nowY, this.width, this.height);
            ctx.restore();
            nowX += (targetX - sourceX) / (time / frameTime);
            nowY += (targetY - sourceY) / (time / frameTime);
        }, frameTime);
        setTimeout(() => {
            clearInterval(interval);
        }, time);
    }

    drawGlitch = (deg, size, offset, glitch) => {
        if (deg < 45) {
            this.drawXGlitch(deg, size, offset, glitch);
        } else if(deg < 90) {
            this.drawYGlitch(deg, size, offset, glitch);
        } else if(deg < 135) {
            this.drawLargeYGlitch(deg, size, offset, glitch);
        } else {
            this.drawLargeXGlitch(deg, size, offset, glitch);
        }
    };

    drawXGlitch(deg, height, offsetX, glitchY) {
        let ctx = this.canvas.getContext('2d');
        let tanDeg =  Math.tan(Math.PI * deg / 180);
        let offsetHeight = tanDeg * this.width;
        let points = [
            {x: 0, y: glitchY},
            {x: this.width, y: glitchY - offsetHeight},
            {x: this.width, y: glitchY - offsetHeight + height},
            {x: 0, y: glitchY + height},
        ];
        this.animationTranslateImage(ctx, this.img, 0, 0, offsetX, -tanDeg * offsetX, points);
    }

    drawYGlitch(deg, width, offsetY, glitchX) {
        let ctx = this.canvas.getContext('2d');
        let tanDeg =  Math.tan(Math.PI * deg / 180);
        let offsetWidth = this.height / tanDeg;
        let points = [
            {x: glitchX, y: 0},
            {x: glitchX - offsetWidth, y: this.height},
            {x: glitchX - offsetWidth + width, y: this.height},
            {x: glitchX + width, y: 0},
        ];
        this.animationTranslateImage(ctx, this.img, 0, 0, -offsetY / tanDeg, offsetY, points);
    }

    drawLargeYGlitch(deg, width, offsetY, glitchX) {
        let ctx = this.canvas.getContext('2d');
        let tanDeg =  Math.tan(Math.PI * (180 - deg) / 180);
        let offsetWidth = this.height / tanDeg;
        let points = [
            {x: glitchX, y: 0},
            {x: glitchX + offsetWidth, y: this.height},
            {x: glitchX + offsetWidth + width, y: this.height},
            {x: glitchX + width, y: 0},
        ];
        this.animationTranslateImage(ctx, this.img, 0, 0, offsetY / tanDeg, offsetY, points);
    }

    drawLargeXGlitch(deg, height, offsetX, glitchY) {
        let ctx = this.canvas.getContext('2d');
        let tanDeg =  Math.tan(Math.PI * (180 - deg) / 180);
        let offsetHeight = tanDeg * this.width;
        let points = [
            {x: 0, y: glitchY},
            {x: this.width, y: glitchY + offsetHeight},
            {x: this.width, y: glitchY + offsetHeight + height},
            {x: 0, y: glitchY + height},
        ];
        this.animationTranslateImage(ctx, this.img, 0, 0, offsetX, tanDeg * offsetX, points);
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
                        ref={canvas => this.canvas = canvas}
                    />
                </div>
                <div className='operation-area'>
                    <Button onClick={this.random} type='primary'>随机割裂</Button>
                    &nbsp;&nbsp;
                    <Button onClick={this.reset}>重置</Button>
                    <br/>
                    <div className='image-list'>
                        <div className='image-list-label'>选择图片：</div>
                        {this.imageList.map((image ,index) => (
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

export default Filter;

import React, { useContext, useEffect, useRef, useState } from 'react';
import { Button } from 'antd';
import CanvasContext from '../../context/CanvasContext';
import V3D12_GlichImpl from '../../v3d/V3D12_GlichImpl';
import TestImg from './test.png';
import Test1Img from './test1.png';
import Test2Img from './test2.png';
import './filter.css';

function getRndInteger(min, max) {
  return Math.floor(Math.random() * (max - min + 1)) + min;
}

function getRndOne(...numbers) {
  return numbers[Math.floor(Math.random() * numbers.length)];
}

export default function Glich() {
  const canvasRef = useRef();
  const { width, height } = useContext(CanvasContext);
  const [nowImage, setNowImage] = useState(1);
  const imageList = [TestImg, Test1Img, Test2Img];

  let drawer = null;

  useEffect(() => {
    const { current } = canvasRef;
    if (current) {
      drawer = new V3D12_GlichImpl(current, width, height, imageList[nowImage], 30);
    }
    return () => {
      drawer.reset();
      drawer = null;
    };
  }, [canvasRef, width, height, nowImage]);

  function random() {
    if (drawer) {
      drawer.reset();
      const number = getRndInteger(4, 7);
      const deg = getRndInteger(1, 179);
      for (let i = 1; i <= number; i++) {
        const size = getRndInteger(5, 20);
        const glitch = getRndInteger(50 + 200 / number * (i - 1), 50 + 200 / number * i);
        const offset = getRndOne(100, -100);
        drawer.start(deg, size, offset, glitch, i);
      }
    }
  }

  function pause() {
    if (drawer) {
      drawer.pause();
    }
  }

  function reset() {
    if (drawer) {
      drawer.reset();
    }
  }

  return (
    <div className='filter'>
      <div className='filter-t-shirt'>
        <canvas
          width={width}
          height={height}
          className='filter-canvas'
          ref={canvasRef}
        />
      </div>
      <div className='operation-area'>
        <Button onClick={random} type='primary'>随机割裂</Button>
        &nbsp;&nbsp;
        <Button onClick={pause} type='primary'>暂停</Button>
        &nbsp;&nbsp;
        <Button onClick={reset}>重置</Button>
        <br />
        <div className='image-list'>
          <div className='image-list-label'>选择图片：</div>
          {
            imageList.map((image, index) => (
              <img
                key={index}
                className={nowImage === index ? 'selected' : ''}
                src={image}
                onClick={() => setNowImage(index)}
                alt=""
              />
            ))
          }
        </div>
      </div>
    </div>
  );
}

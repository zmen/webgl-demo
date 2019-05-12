import React, { useState, useContext, useEffect, useRef } from 'react';
import CanvasContext from '../../context/CanvasContext';
import GlichImpl from './GlichImpl';
import { Button, Input } from 'antd';
import './glitch2.css';

const img1 = 'pic1.png';
const img2 = 'pic2.png';

export default function Moma01() {
  const canvasRef = useRef();
  const { width, height } = useContext(CanvasContext);
  let img = img1;

  const [glitch, setGlitch] = useState(null);
  const [k, setK] = useState(2);
  const [lines, setLines] = useState([0,0.1,0.3,0.4,0.5,0.9,1]);
  const [max, setMax] = useState(100);
  const [min, setMin] = useState(80);
  const [period, setPeriod] = useState(1000);
  const [total, setTotalTime] = useState(10000);

  useEffect(() => {
    const { current } = canvasRef;
    if (current) {
      setGlitch(new GlichImpl(current, width, height, img1, {
        k, lines, max, min, period, total
      }))
    }
  }, [canvasRef, width, height]);

  const play = () => glitch.play();
  const nextFrame = () => glitch.transform();
  const reset = () => glitch.reset();
  const pause = () => glitch.pause();

  const switchImage = () =>
    glitch.loadImage(img === img1 ? img = img2 : img = img1);
  const onKchange = e => {
    e.persist();
    setK(e.target.value);
    glitch.setFields('k', +e.target.value);
  };
  const onMaxChange = e => {
    e.persist();
    setMax(+e.target.value);
    glitch.setFields('max', +e.target.value);
  }
  const onMinChange = e => {
    e.persist();
    setMin(+e.target.value);
    glitch.setFields('min', +e.target.value);
  }
  const onLinesChange = e => {
    e.persist();
    setLines(e.target.value.split(','));
    glitch.setFields('lines', e.target.value.split(','));
  }
  const onPeriodChange = e => {
    e.persist();
    setPeriod(e.target.value);
    glitch.setFields('period', +e.target.value);
  }
  const onTotalChange = e => {
    e.persist();
    setTotalTime(e.target.value);
    glitch.setFields('total', +e.target.value);
  }

  return (
      <div className="glitch2">
        <div>
          <canvas ref={canvasRef} width={width} height={height} />
        </div>
        <div className="glitch2__form">
          <p>切割斜率</p>
          <Input value={k} onChange={onKchange.bind(this)} />
          <p>切割比例</p>
          <Input value={lines.join(',')} onChange={onLinesChange.bind(this)}/>
          <p>抖动最大值</p>
          <Input value={max} onChange={onMaxChange.bind(this)} />
          <p>抖动最小值</p>
          <Input value={min} onChange={onMinChange.bind(this)}/>
          <p>抖动周期/ms</p>
          <Input value={period} onChange={onPeriodChange.bind(this)}/>
          <p>抖动时长/ms</p>
          <Input value={total} onChange={onTotalChange.bind(this)}/>
          <div className="glitch2__groups">
            <Button className="glitch2__btn" onClick={play.bind(this)} type="primary">播放</Button>
            <Button className="glitch2__btn" onClick={nextFrame.bind(this)} type="primary">单帧</Button>
            <Button className="glitch2__btn" onClick={pause.bind(this)} type="primary">暂停</Button>
            <Button className="glitch2__btn" onClick={reset.bind(this)}>重置</Button>
            <Button className="glitch2__btn" onClick={switchImage.bind(this)}>换图</Button>
          </div>
        </div>
      </div>
  );
}

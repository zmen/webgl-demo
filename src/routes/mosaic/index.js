import React, { useContext, useEffect, useRef } from 'react';
import V3D13_MosaicImpl from '../../v3d/V3D13_MosaicImpl';
import CanvasContext from '../../context/CanvasContext';

export default function Mosaic() {
  const canvasRef = useRef();
  const { width, height } = useContext(CanvasContext);

  let paint = null;

  useEffect(() => {
    const { current } = canvasRef;
    paint = new V3D13_MosaicImpl();
    if (current) {
      paint.init(current, width, height);
    }
    return () => {
      paint = null;
    }
  }, [canvasRef, width, height]);

  function changeType(type) {
    paint.changeType(type);
  }

  return (
    <React.Fragment>
      <canvas ref={canvasRef} width={width} height={height} />
      <button onClick={changeType.bind(this, 'square')} type='primary'>方</button>
      <button onClick={changeType.bind(this, 'circle')} type='primary'>圆</button>
      <button onClick={changeType.bind(this, 'round_rect')} type='primary'>圆角矩形</button>
    </React.Fragment>
  );
}

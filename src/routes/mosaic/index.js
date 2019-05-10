import React, { useContext, useEffect, useRef } from 'react';
import V3D13_MosaicImpl from '../../v3d/V3D13_MosaicImpl';
import CanvasContext from '../../context/CanvasContext';

export default function Mosaic() {
  const canvasRef = useRef();
  const { width, height } = useContext(CanvasContext);

  useEffect(() => {
    const { current } = canvasRef;
    const paint = new V3D13_MosaicImpl();
    if (current) {
      paint.init(current, width, height);
    }
  }, [canvasRef, width, height]);

  return (
    <canvas ref={canvasRef} width={width} height={height} />
  );
}

import React, { useContext, useEffect, useRef } from 'react';
import V3D02_PaintImpl from '../../v3d/V3D02_PaintImpl';
import CanvasContext from '../../context/CanvasContext';

export default function Paint() {
  const canvasRef = useRef();
  const { width, height } = useContext(CanvasContext);

  useEffect(() => {
    const { current } = canvasRef;
    const paint = new V3D02_PaintImpl();
    if (current) {
      paint.init(current, width, height);
    }
  }, [canvasRef, width, height]);

  return (
    <canvas ref={canvasRef} width={width} height={height} />
  );
}

import React, { useContext, useEffect, useRef } from 'react';
import CanvasContext from '../../context/CanvasContext';

export default function Mosaic() {
  const canvasRef = useRef();
  const { width, height } = useContext(CanvasContext);

  useEffect(() => {
    const { current } = canvasRef;
    if (current) {
    }
  }, [canvasRef, width, height]);

  return (
    <canvas ref={canvasRef} width={width} height={height} />
  );
}

import React, { useContext, useEffect, useRef } from 'react';
import CanvasContext from '../../context/CanvasContext';
import V3D16_MOMA02Impl from '../../v3d/V3D16_MOMA02Impl';

export default function Moma02() {
  const canvasRef = useRef();
  const { width, height } = useContext(CanvasContext);

  useEffect(() => {
    const { current } = canvasRef;
    const paint = new V3D16_MOMA02Impl();
    if (current) {
      paint.initWithData(current, width, height);
    }
  }, [canvasRef, width, height]);

  return (
    <canvas ref={canvasRef} width={width} height={height} />
  );
}

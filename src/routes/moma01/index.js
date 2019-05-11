import React, { useContext, useEffect, useRef } from 'react';
import CanvasContext from '../../context/CanvasContext';
import V3D15_MOMA01Impl from '../../v3d/V3D15_MOMA01Impl';

export default function Moma01() {
  const canvasRef = useRef();
  const { width, height } = useContext(CanvasContext);

  useEffect(() => {
    const { current } = canvasRef;
    // const paint = new V3D15_MOMA01Impl();
    if (current) {
      // paint.initWithData(current, width, height);
    }
  }, [canvasRef, width, height]);

  return (
    <canvas ref={canvasRef} width={width} height={height} />
  );
}

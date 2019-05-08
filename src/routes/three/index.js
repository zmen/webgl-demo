import React, { useContext, useEffect, useRef } from 'react';
import * as THREE from 'three';
import CanvasContext from '../../context/CanvasContext';

export default function Glich() {
  const canvasRef = useRef();
  const { width, height } = useContext(CanvasContext);

  useEffect(() => {
    const { current } = canvasRef;
    if (current) {
      const camera = new THREE.PerspectiveCamera(70, width / height, 0.01, 10);
      camera.position.z = 1;

      const scene = new THREE.Scene();

      const geometry = new THREE.BoxGeometry(0.2, 0.2, 0.2);
      const material = new THREE.MeshNormalMaterial();

      const mesh = new THREE.Mesh(geometry, material);
      scene.add(mesh);

      const renderer = new THREE.WebGLRenderer({ antialias: true });
      renderer.setSize(width, height);
      current.appendChild(renderer.domElement);

      function animate() {
        requestAnimationFrame(animate);

        mesh.rotation.x += 0.01;
        mesh.rotation.y += 0.02;

        renderer.render(scene, camera);

      }

      animate();
    }
  }, [canvasRef, width, height]);

  return (
    <div ref={canvasRef} style={{ width, height }} />
  );
}

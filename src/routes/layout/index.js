import React, {useContext, useEffect, useRef} from 'react';
import CanvasContext from '../../context/CanvasContext';
import './draw.css';
import imgIcon from './images/template.jpeg'
import drawHandler from './draw.js'

export default function Layout() {
    const canvasRef = useRef();
    const {width, height} = useContext(CanvasContext);

    useEffect(() => {
        const {current} = canvasRef;

        if (current) {
            let ctx = current.getContext('2d');
            console.log(ctx);
            let img = new Image();
            img.src = imgIcon;
            img.onload = function () {
                drawHandler.init(ctx, [img]);
            }
        }
    }, [canvasRef, width, height]);

    function change() {
        drawHandler.draw();
    }

    return (
        <div>
            <div>
                <button onClick={() => {
                    change()
                }}>转换
                </button>
            </div>
            <canvas className='auto-layout' ref={canvasRef} width={width} height={height}/>
        </div>
    );
}

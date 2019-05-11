function fillRoundRect(cxt, x, y, width, height, radius, fillColor) {
    if (2 * radius > width || 2 * radius > height) {
      return false;
    }
  
    cxt.save();
    cxt.translate(x, y);
    drawRoundRectPath(cxt, width, height, radius);
    cxt.fillStyle = fillColor || "#000";
    cxt.fill();
    cxt.restore();
  }
  
  function drawRoundRectPath(cxt, width, height, radius) {
    cxt.beginPath(0);
    cxt.arc(width - radius, height - radius, radius, 0, Math.PI / 2);
    cxt.lineTo(radius, height);
    cxt.arc(radius, height - radius, radius, Math.PI / 2, Math.PI);
    cxt.lineTo(0, radius);
    cxt.arc(radius, radius, radius, Math.PI, Math.PI * 3 / 2);
    cxt.lineTo(width - radius, 0);
    cxt.arc(width - radius, radius, radius, Math.PI * 3 / 2, Math.PI * 2);
    cxt.lineTo(width, height - radius);
    cxt.closePath();
  }
  
  export default fillRoundRect;
  
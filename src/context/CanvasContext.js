import React from 'react';

const CanvasContext = React.createContext({
  width: 400,
  height: 400,
});

export default CanvasContext;

export function CanvasProvider(props) {
  return (
    <CanvasContext.Provider value={{
      width: 400,
      height: 400,
    }}>
      {props.children}
    </CanvasContext.Provider>
  );
}
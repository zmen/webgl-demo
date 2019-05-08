import React from 'react';
import { Route, Switch } from 'react-router-dom';
import { CanvasProvider } from '../context/CanvasContext';
import Paint from './paint';
import Moma01 from './moma01';
import Moma02 from './moma02';
import Glich from './glich';
import Mosaic from './mosaic';
import Splash from './splash';
import Layout from './layout';
import Three from './three';

export default function Routes() {
  return (
    <CanvasProvider>
      <Switch>
        <Route exact path="/">
          <h1>WebGL Demo</h1>
        </Route>
        <Route exact path='/paint' component={Paint} />
        <Route exact path='/moma01' component={Moma01} />
        <Route exact path='/moma02' component={Moma02} />
        <Route exact path='/mosaic' component={Mosaic} />
        <Route exact path='/glich' component={Glich} />
        <Route exact path='/splash' component={Splash} />
        <Route exact path='/layout' component={Layout} />
        <Route exact path='/three' component={Three} />
      </Switch>
    </CanvasProvider>
  );
}

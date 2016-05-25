'use strict';

var Elm = require('./bundles/PersistentEcho/Main.elm');
var mountNode = document.getElementById('main');
Elm.Main.embed(mountNode);

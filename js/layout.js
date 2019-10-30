const fromJSON = require('ngraph.fromjson');
const createLayout = require('ngraph.offline.layout');
const fs = require('fs');

let rawdata = fs.readFileSync('graph.json');
let json = JSON.parse(rawdata);

var graph = fromJSON(json);

var layout = createLayout(graph);
layout.run(true);

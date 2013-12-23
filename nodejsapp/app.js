var express = require('express')
  , app = express()
  , cons = require('consolidate')
  , MongoClient = require('mongodb').MongoClient
  , ErrorHandler = require('./error').errorHandler
  , Grid = require('mongodb').Grid;

MongoClient.connect('mongodb://localhost:27017/test1', {auto_reconnect: true}, function (err, db) {
  "use strict";
  if (err) throw err;

  // Register our templating engine
  app.engine('html', cons.swig);
  app.set('view engine', 'html');
  app.use(express.bodyParser());
  app.use(express.cookieParser());

  // Application routes
  app.all('/getfile/:fileId', function (req, res) {
    "use strict";

    var grid = new Grid(db, 'fs');
    grid.get(req.params.fileId, function (err, data) {
      if (err) ErrorHandler(err, req, res);
      res.send(data);
    });

  });

  app.use(ErrorHandler);

  app.listen(3000);
  console.log('app listening on port 3000');
});

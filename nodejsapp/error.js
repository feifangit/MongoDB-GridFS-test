exports.errorHandler = function(err, req, res) {
  "use strict";
  console.error(err.message);
  console.error(err.stack);
  res.json(500, { error: err.message });
};

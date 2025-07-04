'use strict';
// BASE SETUP
// =============================================================================

// call the packages we need
const express = require('express');// call express
const app = express();// define our app using express

require('dotenv').config();

const db = require('./queries.js');
const VerifyToken = require('./verify');
const { rateLimit } = require("express-rate-limit");
const test_limit_params = {
  windowMs: 1 * 60 * 1000, // 1 minute
  limit: 200, // each IP can make up to 200 requests per `windowsMs` (1 minute)
  standardHeaders: true, // add the `RateLimit-*` headers to the response
  legacyHeaders: false, // remove the `X-RateLimit-*` headers from the response
};
const limit_params = {  
  windowMs: 1 * 60 * 1000, // 1 minute
  limit: 400, // each IP can make up to 20 requests per `windowsMs` (1 minute)
  standardHeaders: true, // add the `RateLimit-*` headers to the response
  legacyHeaders: false, // remove the `X-RateLimit-*` headers from the response  
}

var limiter;
if( process.env.DISABLE_RATE_LIMIT == null || process.env.DISABLE_RATE_LIMIT == "false" ){
  limiter = rateLimit( process.env.NODE_ENV == 'test' ? test_limit_params : limit_params );
}

const HttpStatus = require('http-status-codes');

const winston = require('winston');
const expressWinston = require('express-winston');

var port;
process.env.NODE_ENV == 'test' ? port = process.env.RUNNING_PORT_TEST || 8080 : port = process.env.RUNNING_PORT || 8080; 

//SET UP MIDDLEWARES
var verify_and_limit;
var just_limit;

limiter == null ? verify_and_limit = [VerifyToken] : verify_and_limit = [VerifyToken, limiter];
limiter == null ? just_limit = [] : just_limit = [limiter];

// ROUTES FOR OUR API
// =============================================================================
const router = express.Router();// get an instance of the express Router

router.get('/toponimspartnom', verify_and_limit, db.getToponimsPartNom);
router.get('/toponimspartnom.htm', verify_and_limit, db.getToponimsPartNom);
router.get('/tipustoponim', verify_and_limit, db.getTipusToponims);
router.get('/tipustoponim.htm', verify_and_limit, db.getTipusToponims);
router.get('/toponimsgeo', verify_and_limit, db.getToponimsGeo);
router.get('/toponimsgeo.htm', verify_and_limit, db.getToponimsGeo);
router.get('/toponim', verify_and_limit, db.getToponim);
router.get('/toponim/:id', just_limit, db.getToponimId);
router.get('/toponim.htm', verify_and_limit, db.getToponim);
router.get('/arbre', verify_and_limit, db.getArbre);
router.get('/arbre.htm', verify_and_limit, db.getArbre);
router.get('/auth', just_limit, db.getAuth);
router.get('/auth.htm', just_limit, db.getAuth);
router.get('/version',  just_limit, db.getVersion);

// ROUTES FOR V1 API
// =============================================================================
var router_v1 = express.Router();// get an instance of the express Router

router_v1.get('/sitepartname', verify_and_limit, db.getToponimsPartNom);
router_v1.get('/sitepartname.htm', verify_and_limit, db.getToponimsPartNom);
router_v1.get('/sitetype', verify_and_limit, db.getTipusToponims);
router_v1.get('/sitetype.htm', verify_and_limit, db.getTipusToponims);
router_v1.get('/sitegeo', verify_and_limit, db.getToponimsGeo);
router_v1.get('/sitegeo.htm', verify_and_limit, db.getToponimsGeo);
router_v1.get('/site', verify_and_limit, db.getToponim);
router_v1.get('/site/:id', just_limit, db.getToponimId);
router_v1.get('/site.htm', verify_and_limit, db.getToponim);
router_v1.get('/tree', verify_and_limit, db.getArbre);
router_v1.get('/tree.htm', verify_and_limit, db.getArbre);
router_v1.get('/auth', just_limit, db.getAuth);
router_v1.get('/auth.htm', just_limit, db.getAuth);
router_v1.get('/version', just_limit, db.getVersion);

// LOGGING --------------------------------------------

if(process.env.LOG_LEVEL != 'none'){
  app.use(expressWinston.logger({
    transports: [
      new winston.transports.Console()
    ],
    format:
      winston.format.combine(
        winston.format.colorize(),
        winston.format.simple()
      ),
    // eslint-disable-next-line no-unused-vars
    level: function(req, res) { return process.env.LOG_LEVEL; },
    meta: true, // optional: control whether you want to log the meta data about the request (default to true)
    msg: 'HTTP {{req.statusCode}} {{req.method}} {{req.url}}', // optional: customize the default logging message. E.g. "{{res.statusCode}} {{req.method}} {{res.responseTime}}ms {{req.url}}
    expressFormat: true, // Use the default Express/morgan request formatting. Enabling this will override any msg if true. Will only output colors with colorize set to true
    colorize: false, // Color the text and status code, using the Express/morgan color palette (text: gray, status: default green, 3XX cyan, 4XX yellow, 5XX red).
    // eslint-disable-next-line no-unused-vars
    ignoreRoute: function(req, res) { return false; } // optional: allows to skip some log messages based on request and/or response
  }));
}


// REGISTER OUR ROUTES -------------------------------
// all of our routes will be prefixed with /api
app.use('/api', router);
app.use('/api/v1', router_v1);

// ERROR LOGGING -------------------------------------

app.use(expressWinston.errorLogger({
  transports: [
    new winston.transports.Console()
  ],
  format: winston.format.combine(
    winston.format.colorize(),
    winston.format.simple()
  )
}));

var errorCodeIsHttpValid = function(code){
  for (var key in HttpStatus){
    if (code === HttpStatus[key]){
      return true;
    }
  }
  return false;
};

// ERROR HANDLERS ------------------------------------
// eslint-disable-next-line no-unused-vars
app.use(function(err, req, res, next) {
  var status = 500;
  if (errorCodeIsHttpValid(err.code)){
    status = err.code;
  }
  res.status(status)
    .json({
      success: false,
      message: err,
    });
});

// RATE LIMITING
limiter != null ? app.use(limiter) : console.log("Rate limiting disabled");

// START THE SERVER
// =============================================================================
console.log('Node env ' + process.env.NODE_ENV);
app.listen(port);
console.log('Listening on port ' + port);


module.exports = router;

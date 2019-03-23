var restify = require('restify');
var sd = require('silly-datetime');
const ENV = require('env-var');
const PID = process.pid
const PORT = ENV.get('APP_PORT', '8081').required().asIntPositive(); 
const server = restify.createServer({
  name: 'simple-app',
  version: '1.0.0'
});

server.use(restify.plugins.acceptParser(server.acceptable));
server.use(restify.plugins.queryParser());
server.use(restify.plugins.bodyParser());

function now() {
  return sd.format(new Date(), 'YYYY-MM-DD HH:mm:ss')
}

server.get('/',function(req, res, next){
  console.log('visitor info ' + req);
  var result = now() + ', your are visiting service on port(' + PORT + ') pid(' + PID + ')';
  result += '>======== you info here =======>' + req;
  res.send(result);
  return next();
}); 
server.get('/echo/:name', function (req, res, next) {
  res.send(req.params);
  return next();
});
server.get('/exit', function(req, res, next){
  res.send('app['+PORT+'] will be terminated in 3 second');
  setTimeout(() => {
    console.log(req + 'has requested to stop this app');
    process.exit(0); 
  },3000);  
});
process.on('exit', (code) => {
  setTimeout(() => {
    console.log('The app[' + PORT + '] is about to exit');
  }, 0);
}); 
server.listen(PORT, function () {
  console.log('%s listening at %s', server.name, server.url);
});




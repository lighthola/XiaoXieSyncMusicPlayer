var express = require('express');
var app = express();

var http = require('http').Server(app);
var io = require('socket.io')(http);
var bodyParser = require('body-parser');

var mongoose = require('mongoose');
var passport = require('passport');
var flash    = require('connect-flash');

var morgan       = require('morgan');
var cookieParser = require('cookie-parser');
var session      = require('express-session');

var configDB = require('./config/database.js');

var config = {
  currentDir : __dirname,
  hosturl: 'localhost',
  port:8080
};
var onlineUsers = [];
var musicList = [];
// configuration ===============================================================
mongoose.connect(configDB.url); // connect to our database

require('./config/passport')(passport); // pass passport for configuration


// set up our express application
	 app.use(morgan('dev')); // log every request to the console
	 app.use(cookieParser()); // read cookies (needed for auth)
	 app.use(bodyParser.json()); // get information from html forms
			 app.use(bodyParser.urlencoded({ extended: true }));

	 app.set('view engine', 'ejs'); // set up ejs for templating

	 // required for passport
	 app.use(session({ secret: 'ilovescotchscotchyscotchscotch' })); // session secret
	 app.use(passport.initialize());
	 app.use(passport.session()); // persistent login sessions
	 app.use(flash()); // use connect-flash for flash messages stored in session



// configure app to use bodyParser()
// this will let us get the data from a POST
app.use(bodyParser.urlencoded({ extended: true }));
app.use(bodyParser.json());
app.use(express.static('public'));
// app.use(function(req, res, next){
//     if(req.url=="/favicon.ico"){
//       console.log('////fa//vi///con//ico');
//         next();
//     }
// });


//

require('./app/socketio.js')(io,config,onlineUsers,musicList);

//routes

app.use(express.static(config.currentDir+'\\public'));
require('./app/routes.js')(app,passport,io,config,onlineUsers,musicList);


// app.listen(8080,function(){
//   console.log('Start listening 8080');
// });

// ---- 啟動伺服器 ----
http.listen(config.port, function(){
  console.log('listening on *:8080');
});

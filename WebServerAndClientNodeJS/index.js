// ---- 基本設定 ----
var express = require('express');
var app     = express();
var port    = process.env.PORT || 8080;
var http = require('http').Server(app);
var io = require('socket.io')(http);

var bodyParser = require('body-parser');

// configure app to use bodyParser()
// this will let us get the data from a POST
app.use(bodyParser.urlencoded({ extended: true }));
app.use(bodyParser.json());
app.use(express.static('public'));

var fs = require("fs");
var musicList2;
// console.log(process.argv[0]);
fs.readdir('C:\\postandsocket\\public\\music', function(err, list) {
    musicList2 = list;
    console.log(list);
});


// ---- ROUTES ----

// 舊方法
// app.get('/sample', function(req, res) {
//   res.send('this is a sample!');
// });

// Express Router

// 建立 Router 物件
var router = express.Router();

app.get('/', function(req, res){
  //res.send('<h1>Hello world</h1>');

  res.sendFile(__dirname + '/index.html');

});

app.route('/post')

  // 顯示登入表單 (GET http://localhost:8080/login)
  .get(function(req, res) {
    res.send('this is the login form');
  })

  // 處理登入表單 (POST http://localhost:8080/login)
  .post(function(req, res) {
    console.log('processing');
    // res.send('processing the login form!');
    io.emit('chat message' , "POST DATA name: "+req.body.name);

    res.json({ message: "I got your name: "+req.body.name });



  });
//----------------------------

var currentSong2 = 'nosong';
io.on('connection', function(socket){
  // console.log('connected!!!!');
  io.emit('currentSong',currentSong2);

// io.emit('chat message' , "client connected!!");
socket.on('currentSong', function(currentSong){
  currentSong2 = currentSong;
  io.emit('currentSong' , currentSong2);
});


  socket.on('chat message', function(msg){
    console.log('got something1!')
    io.emit('chat message' , msg);
  //  console.log('message: ' + msg);
  });
  io.emit('musicList',musicList2);
  socket.on('musicList', function(musicList){
    // console.log('musicList socket on');
    if(musicList!==null){
      console.log("got something!");
      io.emit('musicList',musicList2);
    }
    // io.emit('chat message' , msg);
  //  console.log('message: ' + msg);
  });


  socket.on('disconnect', function () {
    io.emit('chat message' , 'disconnect~~');
    console.log('disconnect~~');
  });

});

//******************************
// 將路由套用至應用程式
app.use('/', router);

// ---- 啟動伺服器 ----
http.listen(3162, function(){
  console.log('listening on *:3162');
});

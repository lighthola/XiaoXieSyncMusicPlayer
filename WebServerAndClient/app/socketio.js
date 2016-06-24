module.exports = function(io, config,onlineUsers,musicList) {
    var fs = require("fs");

    // console.log(process.argv[0]);

    //user
    var socketNumber = 0;
    //user end
    var currentSong2 = 'nosong';
    //有socket連線時
    io.on('connection', function(socket) {
      socketNumber++;
      if(socketNumber!=onlineUsers.length){
        onlineUsers.pop();
      }
        //通知所有線上使用者 目前歌曲 收到歌曲後給發出前端播放
        io.emit('currentSong', currentSong2);
        //收到歌曲後給發出前端播放
        socket.on('currentSong', function(currentSong) {
            currentSong2 = currentSong;
            io.emit('currentSong', currentSong2);
        });

        //現在這個socket的使用者 就是onlineUsers array 裡面的最後一個
        socket.user = onlineUsers[onlineUsers.length-1];
        io.emit('users',onlineUsers);
        // console.log('online users ++:',onlineUsers);

        socket.on('chat message', function(msg) {
            // console.log('got something1!');


            // io.emit('chat message' , msg);
            io.emit('chat message', {
                name: socket.user.google.name,
                msg: msg ,
                image:socket.user.google.image
            });

            //  console.log('message: ' + msg);
        });

        fs.readdir(config.currentDir + '\\public\\music', function(err, list) {
            musicList = list;
            io.emit('musicList', musicList);


        });

        socket.on('musicList', function(musicList) {
            console.log('got musiclist');
            // console.log('musicList socket on');
            // io.emit('chat message' , msg);
            //  console.log('message: ' + msg);
        });
        socket.on('disconnect', function() {
          if(--socketNumber===0){
            console.log('no socket!!');
          }

          if(onlineUsers!==''){
              onlineUsers.splice(onlineUsers.indexOf(socket.user),1);
          }

          io.emit('users',onlineUsers);

        });



    });
};

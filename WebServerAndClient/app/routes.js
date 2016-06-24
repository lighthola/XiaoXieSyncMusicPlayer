module.exports = function(app,passport,io,config,onlineUsers,musicList){

  app.get('/',function(req, res){
    if(req.isAuthenticated()){
res.redirect('/player');
    }
    //res.send('<h1>Hello world</h1>');
    // res.sendFile(config.currentDir+'\\public\\ha.html');
    res.render('index.ejs');
  });
  app.get('/player',isLoggedIn,function(req,res){
    console.log('req.url === ',req.url);

    onlineUsers.push(req.user);

    res.render('player.ejs', {
      user : req.user
    });

  });
  // file upload dependencies
  var multer    =   require( 'multer' );

  // var path = require('path');
  // var fs = require("fs");

      var options = multer.diskStorage({ destination : './public/music/' ,
        filename: function (req, file, cb) {
          cb(null,file.originalname);
        }
      });

      var upload= multer({ storage: options });

      app.post('/upload',upload.single('file'), function(req, res, next) {
            res.sendStatus(200);

            var fs = require("fs");

            // console.log(process.argv[0]);
            fs.readdir(config.currentDir + '\\public\\music', function(err, list) {
                musicList = list;
                console.log('read again:  ',musicList);
                io.emit('musicList',musicList);

            });

      /*
        handle files here
        req.files['file1']; //First File
        req.files['file2']; //Second File
        req.body.fieldNames;//Other Fields in the form

      */
      });


  app.get('/upload' , function(req,res){
    res.render('upload');
  });

  //file upload end

//login routes

// // show the home page (will also have our login links)
// app.get('/', function(req, res) {
//   res.render('index.ejs');
// });

// PROFILE SECTION =========================
app.get('/profile', isLoggedIn, function(req, res) {
  res.render('profile.ejs', {
    user : req.user
  });
});

// LOGOUT ==============================
app.get('/logout', function(req, res) {
  req.logout();
  res.redirect('/');
});

// =============================================================================
// AUTHENTICATE (FIRST LOGIN) ==================================================
// =============================================================================

// locally --------------------------------
  // LOGIN ===============================
  // show the login form
  app.get('/login', function(req, res) {
    console.log('req url = ',req.url);
    res.render('login.ejs', { message: req.flash('loginMessage') });
  });

  // process the login form
  app.post('/login', passport.authenticate('local-login', {
    successRedirect : '/profile', // redirect to the secure profile section
    failureRedirect : '/login', // redirect back to the signup page if there is an error
    failureFlash : true // allow flash messages
  }));

  // SIGNUP =================================
  // show the signup form
  app.get('/signup', function(req, res) {
    res.render('signup.ejs', { message: req.flash('loginMessage') });
  });

  // process the signup form
  app.post('/signup', passport.authenticate('local-signup', {
    successRedirect : '/profile', // redirect to the secure profile section
    failureRedirect : '/signup', // redirect back to the signup page if there is an error
    failureFlash : true // allow flash messages
  }));
  // google ---------------------------------

		// send to google to do the authentication
		app.get('/auth/google', passport.authenticate('google', { scope : ['profile', 'email'] }));

		// the callback after google has authenticated the user
		app.get('/auth/google/callback',
			passport.authenticate('google', {
				successRedirect : '/player',
				failureRedirect : '/'
			}));


      // =============================================================================
      // AUTHORIZE (ALREADY LOGGED IN / CONNECTING OTHER SOCIAL ACCOUNT) =============
      // =============================================================================

      	// locally --------------------------------
      		app.get('/connect/local', function(req, res) {
      			res.render('connect-local.ejs', { message: req.flash('loginMessage') });
      		});
      		app.post('/connect/local', passport.authenticate('local-signup', {
      			successRedirect : '/profile', // redirect to the secure profile section
      			failureRedirect : '/connect/local', // redirect back to the signup page if there is an error
      			failureFlash : true // allow flash messages
      		}));
          // google ---------------------------------

            // send to google to do the authentication
            app.get('/connect/google', passport.authorize('google', { scope : ['profile', 'email'] }));

            // the callback after google has authorized the user
            app.get('/connect/google/callback',
              passport.authorize('google', {
                successRedirect : '/profile',
                failureRedirect : '/'
              }));

//login routes end

/* practice

app.get('/t1',midware,function(req,res){
  res.send('t1.html'+ req.query.name);

  res.end();
});

app.get('/t2/:name' , function(req,res){
  res.send('restful:' + req.params.name);
});

function midware(req,res,next){
  next();
};
*/

// route middleware to ensure user is logged in
function isLoggedIn(req, res, next) {
	if (req.isAuthenticated())
		return next();

	res.redirect('/');
}




};

// config/auth.js

// expose our config directly to our application using module.exports
module.exports = {


	'googleAuth' : {
		'clientID' 		: '',
		'clientSecret' 	: '',
		'callbackURL' 	: 'http://localhost:8080/auth/google/callback'
	}

};

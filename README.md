What is this?
-------------

Generally speaking it's a proof of concept in using formal grammars in APIs, to implement a custom DSL.

It's worth to take note that once you learn bison implementing stuff like this is really trivial

It's a compiler that compiles strings written in a simple grammar into mongo db query parameter objects.
Its intended use is to augment nodejs REST APIs, allowing clients to easily add filters to their queries.


How can I use it?
-----------------

Ok here is an example:

Supposing that :

* You are using mongoose ore something similar
* You are handling a route that queries your APIs for users
* Your user model has an "age" field

You could write your route handler something like this:

```javascript

	var parser = require('monogram');

	//the parser expects urldecoded parameters 

	var ageParameter = parser.parse(req.param.age);

	User.find({ age : ageParameter }, function(err, users){

		//do your thing
	});

```


And so?
------

This will allow clients to query your api in this way:

(In this example query parameters are not URLencoded for clarity)


```
GET /api/user?age=36 => { age : 36 }

Get all users aged 36 (ok nothing special here)


GET /api/user?age=!36 => { age : { $ne : 36 }}

Get all user whose age is not 36


GET /api/user?age=>36|12 => { age: { $or : [ 36, 12 ]  }  }

Get users aged 36 or 12


GET /api/user?age=>-1^12 => { age : {$gte : -1, $lt : 12}} 

Get users with an age ranging from -1 to 12

```

HEY but nobody is -1 years old!
------------------------------

You can provide a custom validator function to validate or transform query values,
the previous example could be rewritten as:

```javascript

	function validAge(val){

	   //that makes no sense, but it's just an example

           return Math.abs(val);
	}


	var parser = require('monogram');
	
	var ageParameter = parser.parse(req.param.age, validAge);

	User.find({ ageParameter : age }, function(err, users){

		//do your thing
	});

```

Then the previous query will compile like this:


```javascript
GET /api/user?age=>-1^12 => { age : {$gte : 1, $lt : 12}} 

```

How much can I combine those operators?
---------------------------------------

Compiled objects can't be more than two levels deep.

You can read the grammar specification (the parser.jison file), 
and you can load it [here](https://zaach.github.io/jison/try/) and play around.

If you don't like grammar files you can take a look at the tests in the spec/ folder.

If you don't like tests, well, I don't like you and _you should leave now_.


Is this a real project?
-----------------------
Nah, it's me trying to learn context-free grammars (this thing even lacks escape sequences)
but any kind of feedback is very well accepted!









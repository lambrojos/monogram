require('./testhelper.js');
var parser = require('../index');

describe('When parsing a string:', function(){

    it('should left a simple value untouched', function(){

       expect(parser.parse('saywhat')).to.equal('saywhat');
    });	

    it('should negate a value', function(){

    	expect(parser.parse('!what')).to.deep.equal({ $ne : 'what'});
    });

    it('should OR values', function(){

    	expect(parser.parse('this|that')).to.deep.equal({ $or : ['this','that']});
    });
    
    it('should AND values', function(){

    	expect(parser.parse('this&that')).to.deep.equal({ $and : ['this','that']});
    });
    
    it('should RANGE values', function(){

    	expect(parser.parse('12^25')).to.deep.equal({ $gte : '12', $lt : '25' });
    });
    
    it('it should negate objects with not', function(){

    	expect(parser.parse('!12^25')).to.deep.equal({ $not : {  $gte : '12', $lt : '25' } } );
    });
    
    it('should pass all values through a provided function', function(){
	
	function sanitize(value){

            var str = String(value);

	    return str.replace(' ','_'); 
	};

	expect(parser.parse('!hey you|say what', sanitize))
	    .to.deep.equal({ $or: [ { '$ne': 'hey_you' }, 'say_what' ] });
    });
});

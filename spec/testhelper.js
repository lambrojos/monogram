var chai = require('chai');
 
chai.config.includeStack = true;
chai.config.showDiff = true;

global.expect = chai.expect;
global.AssertionError = chai.AssertionError;
global.Assertion = chai.Assertion;
global.assert = chai.assert;



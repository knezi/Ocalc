// Generated by CoffeeScript 1.7.1
var Result,
  __hasProp = {}.hasOwnProperty,
  __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

Result = (function(_super) {
  __extends(Result, _super);

  function Result(result, previousResult, nextResult) {
    this.result = result;
    this.previousResult = previousResult;
    this.nextResult = nextResult;
  }

  Result.prototype.getHTML = function() {
    return null;
  };

  Result.prototype.setPrevious = function() {
    return null;
  };

  Result.prototype.setNext = function() {
    return null;
  };

  Result.prototype.getValue = function() {
    return this.result;
  };

  return Result;

})(Element);
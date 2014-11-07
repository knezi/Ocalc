// Generated by CoffeeScript 1.7.1
var Operand,
  __hasProp = {}.hasOwnProperty,
  __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

Operand = (function(_super) {
  __extends(Operand, _super);

  function Operand(display, type) {
    this.display = display != null ? display : 'basic';
    this.type = type;
    Operand.__super__.constructor.apply(this, arguments);
    if (!window.HTML.hasOwnProperty(this.type)) {
      throw 'Operand (constructor): wrong type of operand';
    }
  }

  Operand.prototype.getHTML = function() {
    return Operand.__super__.getHTML.apply(this, arguments).html(window.HTML[this.type]);
  };

  Operand.prototype.getValue = function() {
    return this.type;
  };

  return Operand;

})(Element);
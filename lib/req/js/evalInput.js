evalInput = function (input) {
  var seen = []
  try {
    no_recurssion = function(key, val) {
      if (typeof val === "object" && val !== null) {
         if((val.nodeType > 0) && key !== ""){
           return "[DOM " + (val.tagName || "") + "]";
         } else if(seen.indexOf(val) < 0){
            seen.push(val);
            if (Object.getPrototypeOf(val) === Object.prototype && key !== "") {
              return "[PROTOTYPE]";
            } else {
              return val;
            }
         } else {
            return "[SEEN]";
         }
      } else if (typeof val === 'function' && val !== null) {
        if (val instanceof NodeList) {
          return Array.prototype.slice.call(val);
        } else {
          return "[Function " + val.name + " ]";
        }
      }
      return val;
    }
    return JSON.stringify(eval(input), no_recurssion, "    ");
  } catch(err) {
    return err.toString();
  }
}

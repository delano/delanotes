
window.onload = function() {
  
  var uribox = document.getElementById('uribox');
  
  //var uriboxtxt = 'http://enter.com/a/url?where=here'
  
  uribox.onfocus = function(e) {
    if (uribox.value == 'http://') {
      uribox.value = ""
      uribox.className = "uribox"
    }
  }
  uribox.onblur = function(e) {
    if (uribox.value == null || uribox.value == '') {
      uribox.value = "http://"
      uribox.className = "uribox-default"
      
    }
  }
  
  uribox.onblur()
}


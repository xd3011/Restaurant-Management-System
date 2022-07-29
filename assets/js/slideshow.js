var myIndex = 0;
carousel();

function carousel() {
  var i;
  var x = document.getElementsByClassName("content-background-slideshow");
  var left = document.querySelector(".content-button-left");
  var right = document.querySelector(".content-button-right");

  left.onclick = function() {
    for (i = 0; i < x.length; i++) {
      if (x[i].style.display == "block" && i != 0) {
        x[i].style.display = "none";  
        x[i - 1].style.display = "block";  
        break;
      }
      if (x[i].style.display == "block" && i == 0) {
        x[i].style.display = "none";  
        x[x.length - 1].style.display = "block";   
        break;
      }
    }
  }

  right.onclick = function() {
    for (i = 0; i < x.length; i++) {
      if (x[i].style.display == "block" && i != (x.length) - 1) {
        x[i].style.display = "none";  
        x[i + 1].style.display = "block";  
        break;
      }
      if (x[i].style.display == "block" && i == (x.length) - 1) {
        x[i].style.display = "none";  
        x[0].style.display = "block";   
        break;
      }
    }
  }
  for (i = 0; i < x.length; i++) {
    x[i].style.display = "none";  
  }
  myIndex++;
  if (myIndex > x.length) {myIndex = 1}    
  x[myIndex-1].style.display = "block";  
  setTimeout(carousel, 5000); // Change image every 2 seconds
}
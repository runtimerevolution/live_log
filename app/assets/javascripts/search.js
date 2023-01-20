const fileOptions = document.getElementById("fileOptions");
const logLevelOptions = document.getElementById("logLevelOptions");
const searchFile = document.getElementById("searchFile");
const logLevel = document.getElementById("logLevel");

if(logLevel && logLevelOptions) {  
  logLevel.onclick = () => {
    logLevelOptions.classList.add("show");
    logLevel.classList.add("rotate");
  }
  
  logLevel.onblur = (event) => {
    if(event.relatedTarget == null) {
      logLevelOptions.classList.remove("show");
      logLevel.classList.remove("rotate");
    }
  }
}

if(searchFile) {
  searchFile.onclick = () => {
    fileOptions.classList.add("show");
  }

  searchFile.onblur = (event) => {
    if(event.relatedTarget == null) {
      fileOptions.classList.remove("show");
    }
  }

  searchFile.onkeyup = () => {
    var form = fileOptions.getElementsByTagName("form");

    for (i = 0; i < form.length; i++) {
      txtValue = form[i][0].value || form[i][0].innerText;
      if (txtValue.toUpperCase().indexOf(searchFile.value.toUpperCase()) > -1) {
        form[i].style.display = "";
      } else {
        form[i].style.display = "none";
      }
    }
  }
}

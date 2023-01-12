var blackmoney = false;

function sleep(ms) {
    return new Promise(resolve => setTimeout(resolve, ms));
}

$(document).ready(function () {
  $(".box").show();
  $(".funk").show();
  $(".voice").show();
  $('.aduty').hide();
   $('.newmoney').hide();
  $('#aduty').hide();
  $('#d1').css("color", "#ff8000");
  window.addEventListener("message", function (event) {
    if (event.data.action == "setMoney") {
      setAnzahl(event.data.money);
      $(".money").show();
      $("money").show();
    };
    if (event.data.action == "setBlackMoney") {
      blackmoney = true;
      setAnzahle(event.data.black);
      $(".schwarzmoney").show();
      $("schwarzmoney").show();
      $(".voice" + event.data.level + "black").show();


    };
    if (event.data.action == "setpermID") {
      setAnzahlpid(event.data.permid);
      $("permid").show();
    };
    if (event.data.action == "setID") {
      setAnzahlid(event.data.id);
      $("id").show();
    };
    if (event.data.action == "setDurst") {
      document.getElementById("durst").textContent = event.data.durst;
    };
    if (event.data.action == "setHunger") {
      document.getElementById("hunger").textContent = event.data.hunger;
    };
    if (event.data.action == "show") {
        $('.funk').css("color", "#ff8000");
    };
    if (event.data.action == "hide") {
        $('.funk').css("color", "#999");
    };
    if (event.data.action == "weg") {
      $(".funk").hide();

    };
    if (event.data.action == "addMoney") {
      $('.newmoney').css("color", "green");
      document.getElementById("newcontent").textContent = "+" + event.data.addMoney + "$";
      $(".newmoney").fadeIn("slow")();
    };
    if (event.data.action == "removeMoney") {
      $('.newmoney').css("color", "red");
      document.getElementById("newcontent").textContent = "-" + event.data.removeMoney + "$";
      $(".newmoney").fadeIn("slow")();
    };
    if (event.data.action == "hideSetMoney") {
      $(".newmoney").fadeOut("slow")();
    };
    if (event.data.action == "muted") {
      if (event.data.muted == true) {
        $('.voice').css("color", "red");

      }
      if (event.data.muted == false) {
        $(".voicemuted").hide();
        $(".voicemutedblack").hide();

      }

    };
    if(event.data.action == "adminoff") {
      $(".aduty").hide();
      $("#aduty").hide();
    };
    if(event.data.action == "adminon") {
      $(".aduty").show();
      $("#aduty").show();
    };
     if (event.data.action == "hidehud") {
      setAnzahl(event.data.money);
      $(".box").hide();
    };
    if (event.data.action == "showhud") {
      setAnzahl(event.data.money);
      $(".box").show();
    };
    if (event.data.action == "nomuted") {
      $('.voice').css("color", "#999");



    };

    if (event.data.action == "setVoiceLevel") {
      console.log(event.data.level);
      if(event.data.level == 1) {
        $('#d1').css("color", "#ff8000");
        $('#d2').css("color", "#999");
        $('#d3').css("color", "#999");
      } else if (event.data.level == 2) {
        $('#d1').css("color", "#ff8000");
        $('#d2').css("color", "#ff8000");
        $('#d3').css("color", "#999");
      } else if (event.data.level == 3) {
        $('#d1').css("color", "#ff8000");
        $('#d2').css("color", "#ff8000");
        $('#d3').css("color", "#ff8000");
      }
    };
  });
});

function setAnzahl(anzahl) {
  document.getElementById("content").innerHTML = new Intl.NumberFormat('de-DE').format(anzahl);

}
function setAnzahle(anzahl) {
  document.getElementById("content2").innerHTML = new Intl.NumberFormat('de-DE').format(anzahl);

}

function setAnzahlpid(anzahl) {
  document.getElementById("permid").innerHTML = new Intl.NumberFormat('de-DE').format(anzahl);

}

function setAnzahlid(anzahl) {
  document.getElementById("id").innerHTML = new Intl.NumberFormat('de-DE').format(anzahl);

}


Date.prototype.timeNow = function() {
  return((this.getHours() < 10) ? "0" : "") + this.getHours() + ":" + ((this.getMinutes() < 10) ? "0" : "") + this.getMinutes() + ":" + ((this.getSeconds() < 10) ? "0" : "") + this.getSeconds();
}
Date.prototype.today = function() {
  return((this.getDate() < 10) ? "0" : "") + this.getDate() + "." + (((this.getMonth() + 1) < 10) ? "0" : "") + (this.getMonth() + 1) + "." + this.getFullYear();
}
$(document).ready(function() {
  $('#Clock').hide();
  setInterval(setTime, 1000)
});

function setTime() {
  var currentdate = new Date();
  $("#time").text(currentdate.today() + " - " + currentdate.timeNow());
  $('#Clock').show();
}
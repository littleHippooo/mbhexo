{%
  set js_commons = [
    'src/APlayer.min.js',
	'src/velocity.min.js',
	'src/animatelo.min.js'
  ]
%}

{% for common in js_commons %}
  <script type="text/javascript" src="{{ url_for(theme.js) }}/{{ common }}?v={{ theme.version }}"></script>
{% endfor %}
<style>

#player{
    width:70%;
    margin:10px 0px 10px 0px;
}
@media screen and (max-width:812px) {
    #player{
    width:95%;
}}    
.aplayer-narrow {
  width: 66px; }
  .aplayer-narrow .aplayer-info {
    display: none; }

.aplayer-withlrc.aplayer-narrow {
  width: 90px; }
.aplayer-withlrc.aplayer .aplayer-pic {
  height: 90px;
  width: 90px; }
.aplayer-withlrc.aplayer .aplayer-info {
  margin-left: 90px;
  height: 90px; }
.aplayer-withlrc.aplayer .aplayer-lrc {
  display: block; }
.aplayer-withlrc.aplayer .aplayer-info {
  padding: 10px 7px 0 7px; }

.aplayer-withlist.aplayer .aplayer-info {
  border-bottom: 1px solid #e9e9e9; }
.aplayer-withlist.aplayer .aplayer-list {
  display: block; }
.aplayer-withlist.aplayer .aplayer-icon-menu {
  display: none !important; }

.aplayer {
  font-family: ".SFNSText-Regular", "San Francisco", "Roboto", "Segoe UI", "Helvetica Neue", "Lucida Grande", Arial, sans-serif;
  margin: 5px;
  font-weight: 600;
  box-shadow: 0 2px 2px 0 rgba(0, 0, 0, 0.14), 0 3px 1px -2px rgba(0, 0, 0, 0.2), 0 1px 5px 0 rgba(0, 0, 0, 0.12);
  border-radius: 2px;
  overflow: hidden;
  user-select: none;
  line-height: initial; }
  .aplayer * {
    box-sizing: content-box; }
  .aplayer .aplayer-icon {
    width: 15px;
    height: 15px;
    border: none;
    background-color: transparent;
    outline: none;
    cursor: pointer;
    opacity: .8;
    vertical-align: middle;
    padding: 0;
    font-size: 12px;
    margin: 0;
    display: inline; }
    .aplayer .aplayer-icon .aplayer-fill {
      transition: all .2s ease-in-out; }
  .aplayer .aplayer-lrc-content {
    display: none; }
  .aplayer .aplayer-pic {
    position: relative;
    float: left;
    height: 80px;
    width: 80px;
    background-image: url(./default.jpg);
    background-size: 100%;
    transition: all 0.3s ease; }
    .aplayer .aplayer-pic .aplayer-button {
      position: absolute;
      border-radius: 50%;
      opacity: 0.8;
      cursor: pointer;
      text-shadow: 0 1px 1px rgba(0, 0, 0, 0.2);
      box-shadow: 0 1px 1px rgba(0, 0, 0, 0.2);
      background: rgba(0, 0, 0, 0.2);
      transition: all 0.1s ease; }
      .aplayer .aplayer-pic .aplayer-button:hover {
        opacity: 1; }
      .aplayer .aplayer-pic .aplayer-button .aplayer-fill {
        fill: #fff; }
    .aplayer .aplayer-pic .aplayer-hide {
      display: none; }
    .aplayer .aplayer-pic .aplayer-play {
      width: 26px;
      height: 26px;
      border: 2px solid #fff;
      bottom: 50%;
      right: 50%;
      margin: 0 -15px -15px 0; }
      .aplayer .aplayer-pic .aplayer-play .aplayer-icon-play {
        position: absolute;
        top: 3px;
        left: 4px;
        height: 20px;
        width: 20px; }
    .aplayer .aplayer-pic .aplayer-pause {
      width: 16px;
      height: 16px;
      border: 2px solid #fff;
      bottom: 4px;
      right: 4px; }
      .aplayer .aplayer-pic .aplayer-pause .aplayer-icon-pause {
        position: absolute;
        top: 2px;
        left: 2px;
        height: 12px;
        width: 12px; }
  .aplayer .aplayer-info {
    margin-left: 66px;
    padding: 14px 20px 0 20px;
    height: 80px;
    box-sizing: border-box; }
    .aplayer .aplayer-info .aplayer-music {
      overflow: hidden;
      white-space: nowrap;
      text-overflow: ellipsis;
      margin: 0 0 13px 5px;
      user-select: text;
      cursor: default;
      padding-bottom: 2px; }
      .aplayer .aplayer-info .aplayer-music .aplayer-title {
        font-size: 14px; }
      .aplayer .aplayer-info .aplayer-music .aplayer-author {
        font-size: 14px;
        color: #666; }
    .aplayer .aplayer-info .aplayer-controller {
      position: relative;
      display: flex; }
      .aplayer .aplayer-info .aplayer-controller .aplayer-bar-wrap {
        margin: 0 0 0 5px;
        padding: 4px 0;
        cursor: pointer !important;
        flex: 1; }
        .aplayer .aplayer-info .aplayer-controller .aplayer-bar-wrap .aplayer-bar {
          position: relative;
          height: 2px;
          width: 100%;
          background: #cdcdcd; }
          .aplayer .aplayer-info .aplayer-controller .aplayer-bar-wrap .aplayer-bar .aplayer-loaded {
            position: absolute;
            left: 0;
            top: 0;
            bottom: 0;
            background: #aaa;
            height: 2px;
            transition: all 0.5s ease; }
          .aplayer .aplayer-info .aplayer-controller .aplayer-bar-wrap .aplayer-bar .aplayer-played {
            position: absolute;
            left: 0;
            top: 0;
            bottom: 0;
            height: 2px; }
            .aplayer .aplayer-info .aplayer-controller .aplayer-bar-wrap .aplayer-bar .aplayer-played .aplayer-thumb {
              position: absolute;
              top: 0;
              right: 5px;
              margin-top: -4px;
              margin-right: -10px;
              height: 8px;
              width: 8px;
              border-radius: 50%;
              background: #fff;
              cursor: pointer !important; }
      .aplayer .aplayer-info .aplayer-controller .aplayer-time {
        position: relative;
        left: 10px;
        bottom: 8px;
        height: 17px;
        color: #999;
        font-size: 14px;
        padding-left: 7px; }
        .aplayer .aplayer-info .aplayer-controller .aplayer-time .aplayer-time-inner {
          vertical-align: middle; }
        .aplayer .aplayer-info .aplayer-controller .aplayer-time .aplayer-icon {
          cursor: pointer;
          transition: all 0.2s ease; }
          .aplayer .aplayer-info .aplayer-controller .aplayer-time .aplayer-icon .aplayer-fill {
            fill: #666; }
          .aplayer .aplayer-info .aplayer-controller .aplayer-time .aplayer-icon.aplayer-icon-mode {
            margin-right: 4px; }
          .aplayer .aplayer-info .aplayer-controller .aplayer-time .aplayer-icon:hover .aplayer-fill {
            fill: #000; }
          .aplayer .aplayer-info .aplayer-controller .aplayer-time .aplayer-icon.aplayer-icon-menu {
            display: none; }
        .aplayer .aplayer-info .aplayer-controller .aplayer-time.aplayer-time-narrow .aplayer-icon-mode {
          display: none; }
        .aplayer .aplayer-info .aplayer-controller .aplayer-time.aplayer-time-narrow .aplayer-icon-menu {
          display: none; }
      .aplayer .aplayer-info .aplayer-controller .aplayer-volume-wrap {
        position: relative;
        display: inline-block;
        margin-left: 3px;
        cursor: pointer !important; }
        .aplayer .aplayer-info .aplayer-controller .aplayer-volume-wrap:hover .aplayer-volume-bar-wrap {
          display: block; }
        .aplayer .aplayer-info .aplayer-controller .aplayer-volume-wrap .aplayer-volume-bar-wrap {
          display: none;
          position: absolute;
          bottom: 15px;
          right: -3px;
          width: 25px;
          height: 40px;
          z-index: 99; }
          .aplayer .aplayer-info .aplayer-controller .aplayer-volume-wrap .aplayer-volume-bar-wrap .aplayer-volume-bar {
            position: absolute;
            bottom: 0;
            right: 10px;
            width: 5px;
            height: 35px;
            background: #ededed; }
            .aplayer .aplayer-info .aplayer-controller .aplayer-volume-wrap .aplayer-volume-bar-wrap .aplayer-volume-bar .aplayer-volume {
              position: absolute;
              bottom: 0;
              right: 0;
              width: 5px;
              transition: all 0.1s ease; }
  .aplayer .aplayer-lrc {
    display: none;
    position: relative;
    height: 30px;
    text-align: center;
    overflow: hidden;
    margin: -10px 0 7px; }
    .aplayer .aplayer-lrc:before {
      position: absolute;
      top: 0;
      z-index: 1;
      display: block;
      overflow: hidden;
      width: 100%;
      height: 10%;
      content: ' ';
      background: -moz-linear-gradient(top, white 0%, rgba(255, 255, 255, 0) 100%);
      background: -webkit-linear-gradient(top, white 0%, rgba(255, 255, 255, 0) 100%);
      background: linear-gradient(to bottom, white 0%, rgba(255, 255, 255, 0) 100%);
      filter: progid:DXImageTransform.Microsoft.gradient( startColorstr='#ffffff', endColorstr='#00ffffff',GradientType=0 ); }
    .aplayer .aplayer-lrc:after {
      position: absolute;
      bottom: 0;
      z-index: 1;
      display: block;
      overflow: hidden;
      width: 100%;
      height: 33%;
      content: ' ';
      background: -moz-linear-gradient(top, rgba(255, 255, 255, 0) 0%, rgba(255, 255, 255, 0.8) 100%);
      background: -webkit-linear-gradient(top, rgba(255, 255, 255, 0) 0%, rgba(255, 255, 255, 0.8) 100%);
      background: linear-gradient(to bottom, rgba(255, 255, 255, 0) 0%, rgba(255, 255, 255, 0.8) 100%);
      filter: progid:DXImageTransform.Microsoft.gradient( startColorstr='#00ffffff', endColorstr='#ccffffff',GradientType=0 ); }
    .aplayer .aplayer-lrc p {
      font-size: 12px;
      color: #666;
      line-height: 16px !important;
      height: 16px !important;
      padding: 0 !important;
      margin: 0 !important;
      transition: all 0.5s ease-out;
      opacity: 0.4;
      overflow: hidden; }
      .aplayer .aplayer-lrc p.aplayer-lrc-current {
        opacity: 1;
        overflow: visible;
        height: initial !important; }
    .aplayer .aplayer-lrc .aplayer-lrc-contents {
      width: 100%;
      transition: all 0.5s ease-out;
      user-select: text;
      cursor: default; }
  .aplayer .aplayer-list {
    overflow: auto;
    transition: all 0.5s ease;
    will-change: height;
    display: none; }
    .aplayer .aplayer-list.aplayer-list-hide {
      height: 0 !important; }
    .aplayer .aplayer-list::-webkit-scrollbar {
      width: 5px; }
    .aplayer .aplayer-list::-webkit-scrollbar-track {
      background-color: #f9f9f9; }
    .aplayer .aplayer-list::-webkit-scrollbar-thumb {
      border-radius: 3px;
      background-color: #eee; }
    .aplayer .aplayer-list::-webkit-scrollbar-thumb:hover {
      background-color: #ccc; }
    .aplayer .aplayer-list ol {
      list-style-type: none;
      margin: 0;
      padding: 0; }
      .aplayer .aplayer-list ol li {
        position: relative;
        height: 40px;
        line-height: 40px;
        padding: 0 15px;
        font-size: 14px;
        border-top: 1px solid #e9e9e9;
        cursor: pointer;
        transition: all 0.2s ease;
        overflow: hidden; }
        .aplayer .aplayer-list ol li:first-child {
          border-top: none; }
        .aplayer .aplayer-list ol li:hover {
          background:  rgba(237,237,237,0.6);}
        .aplayer .aplayer-list ol li.aplayer-list-light {
          background: rgba(237,237,237,0.6); }
          .aplayer .aplayer-list ol li.aplayer-list-light .aplayer-list-cur {
            display: inline-block; }
        .aplayer .aplayer-list ol li .aplayer-list-cur {
          display: none;
          width: 3px;
          height: 29px;
          position: absolute;
          left: 0;
          top: 5px;
          cursor: pointer; }
        .aplayer .aplayer-list ol li .aplayer-list-index {
          color: #666;
          margin-right: 12px;
          cursor: pointer; }
        .aplayer .aplayer-list ol li .aplayer-list-author {
          color: #666;
          float: right;
          cursor: pointer; }

@keyframes aplayer-roll {
  0% {
    left: 0; }
  100% {
    left: -100%; } }

/*# sourceMappingURL=style.css.map */

</style>
<style>
.main-inner{
	margin-top:40px !important;
}
    @-webkit-keyframes cursor-blink {
  0% {
    opacity: 0;
  }
  50% {
    opacity: 1;
  }
  100% {
    opacity: 0;
  }
}
@-moz-keyframes cursor-blink {
  0% {
    opacity: 0;
  }
  50% {
    opacity: 1;
  }
  100% {
    opacity: 0;
  }
}
@keyframes cursor-blink {
  0% {
    opacity: 0;
  }
  50% {
    opacity: 1;
  }
  100% {
    opacity: 0;
  }
}

.four-oh-four {
  position: relative;
  top: 0;
  left: 0;
  min-height: 100vh;
  min-width: 100vw;
  z-index: 2;
  background-color: black;
  transition: opacity 300ms ease-out;
  background-position: center center;
  background-repeat: no-repeat;
}
.four-oh-four .dJAX_internal {
  opacity: 0.0;
}
.four-oh-four form, .four-oh-four input {
  position: fixed;
  top: 0;
  left: 0;
  opacity: 0;
  background-color: black;
}

   
.terminal .prompt {
  color: #888 !important;
  display: block;
  font-family: 'Lato', "PingFang SC", "Microsoft YaHei", sans-serif;
  font-weight: normal;
  text-transform: uppercase;
  letter-spacing: 0.15em;
  font-weight: 600;
  white-space: pre-wrap;
  line-height: 1;
  margin-bottom: 0.75em;
}

@media screen and (min-width:1400px) {
    .terminal .prompt {
        font-size: 14px; 
        line-height: 1.2em;
    }    
}    
@media screen and (max-width:1399px) {
    .terminal .prompt {
        font-size: 12px; 
        line-height: 1.2em;
    }    
} 
.terminal .prompt:before {
  content: '> ';
  display: inline-block;
}
.terminal .new-output {
  display: inline-block;
}
.terminal .new-output:after {
  display: inline-block;
  vertical-align: -0.15em;
  width: 0.15em;
  height: 1.1em;
  margin-left: 5px;
  background: #777;
  -webkit-animation: cursor-blink 1.25s steps(1) infinite;
  -moz-animation: cursor-blink 1.25s steps(1) infinite;
  animation: cursor-blink 1.25s steps(1) infinite;
  content: '';
}

.kittens p {
  letter-spacing: 0;
  opacity: 0;
  line-height: 1rem;
}

.kitten-gif {
  margin: 20px;
  max-width: 300px;
}

.four-oh-four-form {
  opacity: 0;
  position: fixed;
  top: 0;
  left: 0;
}
.terminal{
  font-size:12px;
  position: relative;
  padding: 52px 10px 10px;
  border-radius: 4px;
  background: #fefefe;
  border: 1px solid #f9f9f9;
}
.terminal:before {
    display: block;
    content: ' ';
    height: 38px;
    position: absolute;
    top: 0;
    left: 0;
    right: 0;
    background-color: #f9f9f9;
    padding: 0 10px;
    border-top-left-radius: 4px;
    border-top-right-radius: 4px;
}
.terminal:after {
    content: " ";
    position: absolute;
    border-radius: 50%;
    background: #fc625d;
    width: 12px;
    height: 12px;
    top: 0;
    left: 20px;
    margin-top: 13px;
    -webkit-box-shadow: 20px 0 #fdbc40, 40px 0 #35cd4b;
    box-shadow: 20px 0 #fdbc40, 40px 0 #35cd4b;
}
@media screen and (max-width:812px) {
.container{
    padding: 0;
}}
</style>
<div class="container">
  <form class="four-oh-four-form">
    <input type="text" class="music-input">
  </form>

  <div class="terminal">
      <p class="prompt">hi man,please enter <span style="color:#FF9966;font:inherit">music</span> to install music plugin.</p>
      <p class="prompt">or enter <span style='color:#FF9966;font:inherit'>help</span> for help.</p>
      <p class="prompt output new-output"></p>
  </div>
</div>
<script>
function DetectIsIE() {
    var ua = window.navigator.userAgent;
    var msie = ua.indexOf('MSIE ');
    if (msie > 0) {
        return parseInt(ua.substring(msie + 5, ua.indexOf('.', msie)), 10);
    }
    var trident = ua.indexOf('Trident/');
    if (trident > 0) {
        var rv = ua.indexOf('rv:');
        return parseInt(ua.substring(rv + 3, ua.indexOf('.', rv)), 10);
    }
    var edge = ua.indexOf('Edge/');
    if (edge > 0) {
        return parseInt(ua.substring(edge + 5, ua.indexOf('.', edge)), 10);
    }
    return false;
}
var browser = DetectIsIE();
var inputReady = true;
var input = $('.music-input');
input.focus();
$('.container').on('click', function(e) {
  input.focus();
});

input.on('keyup', function(e) {
  $('.new-output').text(input.val());
});

$('.four-oh-four-form').on('submit', function(e) {
  e.preventDefault();
  var val = $(this).children($('.music-input')).val().toLowerCase();
  var href;

  if (val === 'music') {
    showMusic();
  }
  else if ( val === 'help') {
    showHelp();  
  }
  else if ( val === 'home') {
     goHome(); 
  }
  else {
    resetForm();
  }
});

function resetForm(withKittens) {
  var message = "oops that command is not recognized.enter <span style='color:#FF9966;font:inherit'>help</span> for help"
  var input = $('.music-input');

  if (withKittens) {
    $('.kittens').removeClass('kittens');
    message = "(ง •_•)ง"
  }

  $('.new-output').removeClass('new-output');
  input.val('');
  $('.terminal').append('<p class="prompt">' + message + '</p><p class="prompt output new-output"></p>');
}
function goHome(){
    window.location.href = "http://mrbird.cc";
}
function showHelp() {
  var message = "<span >ENTER <span style='color:#FF9966;font:inherit'>MUSIC</span> TO INSTALL MUSIC PLUGIN.\n</span> &nbsp;<span style='line-height:30px;'> ENTER <span style='color:#FF9966;font:inherit'>HOME</span> TO VISIT HOME PAGE.</span>";
  var input = $('.music-input');
  $('.new-output').removeClass('new-output');
  input.val('');
  $('.terminal').append('<p class="prompt">' + message + '</p><p class="prompt output new-output"></p>');
}
function showMusic() {
  $('.terminal').append("<div class='kittens'>" +
    "<p class='prompt'>please wait...</p>" +
    "<p class='prompt'>The music plugin is being installed...</p>" +
    "<p class='prompt'>The installation is complete!</p>" +
    "<p class='prompt'>Enjoy the music!</p></div>");

  var lines = $('.kittens p');
  $.each(lines, function(index, line) {
    setTimeout(function() {
      $(line).css({
        "opacity": 1
      });

      textEffect($(line))
    }, index * 100);
  });

  $('.new-output').velocity(
    'liner'
  ), {
    duration: 100
  }

  setTimeout(function() {
	$('.terminal').append('<div id="player" class="aplayer"></div>');
	if(!browser){
	    window.animatelo.pulse('#player');
	}
	var mrbird = new APlayer({
        element: document.getElementById('player'),
        narrow: false,
        autoplay: true,
        showlrc: false,
        mutex: true,
        theme: '#FF9966',
        mode: 'order',
        music: [
		   {"title":"Nerve","author":"Half Moon Run","url":"https://m1.jixun.moe/18303210/320000/a1b3796e1bb5f15d7d1ddd1c11286f607320eade027140e5dceeb2c1250203b4","pic":"../images/239b4dc0a176a1c8d21ce64f1d9774e5.jpg"},
		   {"title":"Weather","author":"Novo Amor","url":"https://m1.jixun.moe/28381440/320000/b1bf207f5a3b0cd967cd2452b3163873eb58b3e5310eeea95268fda0a33d1256","pic":"../images/14fb9673bc50bac0126dae96929d4028.jpg"},
       {"title":"Yellow","author":"Jem","url":"https://m1.jixun.moe/5133273/320000/ad746648e4b9f3eff4a0db882ce67d8f436f3f195104fed41a3ce530601130b8","pic":"../images/eee249ac328a4f9172bfdcaae1293e59.png"},
       {"title":"I Won't Fight It (Hushed)","author":"Andrew Belle","url":"https://m1.jixun.moe/29483186/320000/736ec191543f609e8e7c50ec03efe6dc386ecbd333bd7a9c9e8b457c65697bc9","pic":"../images/a636c31895d80283fe7933d4cbe5f60e.jpg"},
       {"title":"You There","author":"Aquilo","url":"https://m1.jixun.moe/28391404/320000/4c30b217899a9580ae2e30874ada10e4c996fa652914794b49102038af51fe88","pic":"../images/9e96aecb226efc6f0c067a2abe5923ac.jpg"},
       {"title":"I Gave It All","author":"Aquilo","url":"https://m1.jixun.moe/29722689/320000/9af672362be89461fd1db0131b325de326f3e1c0bcb6213c536807e21c6a95a7","pic":"../images/be216fe6e9cba6297058ab936d102f1c.jpg"},
       {"title":"Best Of Us Go Down","author":"Aquilo","url":"https://m1.jixun.moe/402070265/320000/1a0c19d2f8c3cb96f47c68a4d391c5b6a4ae05d2feed50c78cb85f176bb547be","pic":"../images/e9c067c3bd301152d1fec4e6ede9c855.jpg"},
       {"title":"Anchor","author":"Novo Amor","url":"https://m1.jixun.moe/35956873/320000/1cbead7f8f270d035615feccbcfa294715f8ee66f38a6a3c6927dfb8aba0e7cb","pic":"../images/9a5a9f405de3e3d2320ca466a143b471.jpg"},
       {"title":"This Woman's Work","author":"Greg Laswell","url":"https://m1.jixun.moe/18016001/320000/7cdaf57e6558c182f96d7bb9888af9ce688c7b6942ae32fd7cc12060fb65df28","pic":"../images/4255cbef0ca3a977afb4fae52b4bc9ec.jpg"},

       {"title":"Karate (Original Mix)","author":"Porsches","url":"https://m1.jixun.moe/35618204/320000/73325d542b6d5ce397906be230bb59e26e4db4e38cdc834fcd1968d6afd4343f","pic":"../images/5a28b33af8493842ddd9d3c27548fd93.jpg"},



        ]
    });
    resetForm(true);
  }, (lines.length * 100) + 1000);
}

function textEffect(line) {
  var alpha = [';', '.', ',', ':', ';', '~', '`'];
  var animationSpeed = 10;
  var index = 0;
  var string = line.text();
  var splitString = string.split("");
  var copyString = splitString.slice(0);

  var emptyString = copyString.map(function(el) {
    return [alpha[Math.floor(Math.random() * (alpha.length))], index++];
  })

  emptyString = shuffle(emptyString);

  $.each(copyString, function(i, el) {
    var newChar = emptyString[i];
    toUnderscore(copyString, line, newChar);

    setTimeout(function() {
      fromUnderscore(copyString, splitString, newChar, line);
    }, i * animationSpeed);
  })
}

function toUnderscore(copyString, line, newChar) {
  copyString[newChar[1]] = newChar[0];
  line.text(copyString.join(''));
}

function fromUnderscore(copyString, splitString, newChar, line) {
  copyString[newChar[1]] = splitString[newChar[1]];
  line.text(copyString.join(""));
}

function shuffle(o) {
  for (var j, x, i = o.length; i; j = Math.floor(Math.random() * i), x = o[--i], o[i] = o[j], o[j] = x);
  return o;
};


</script>
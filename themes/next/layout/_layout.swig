<!doctype html>

{% set html_class = 'theme-next ' + theme.scheme %}
{% if theme.use_motion %}
  {% set html_class = html_class + ' use-motion' %}
{% endif %}

<html class="{{ html_class | lower }}" lang="{{ config.language }}">
<head>
  <link href="{{ url_for(theme.css) }}/animsition.min.css" rel="stylesheet" type="text/css" />
  <script src="https://code.jquery.com/jquery-3.0.0.min.js"></script>
	<script>
		window.jQuery || document.write('<script type="text/javascript" src="{{ url_for(theme.js) }}/jquery-1.11.3.min.js"><\/script>');
	</script>
  <script src="http://at.alicdn.com/t/font_7t5uxv1tbjhbbj4i.js"></script>
  {% include '_partials/head.swig' %}
  <title>{% block title %}{% endblock %}</title>
</head>

<body ondragstart="return false;" class="animsition" itemscope itemtype="http://schema.org/WebPage" lang="{{ page.lang || page.language || config.language }}">
<script type="text/javascript" src="{{ url_for(theme.js) }}/animsition.min.js"></script>
<script>
	console.log("::::::::::::::::::::::::::::::\n::::::::::::::::,:,:,,,:::::::\n:::::::::::::::,,..::...,:::::\n::::::::::::::,.v@B@B@@L.,,:::\n:::,,.,,:,:,,..M@F, , FBZ ,,::\n:::.B@r......vB@..,@BE iBM,,,:\n:::.@B@BMqqO@@q.,.:0ML.  B@q::\n::,.BG ;10ZP7..,::,,... O@ki,:\n:::.LB: ....,,:::::,,..F@ .,::\n::::.ZBL ..,,:,:,:,,..E@r.,:::\n::::,.5B@v.........:qB@:.,::::\n::::::..Z@B@PYY12OB@BL.,,:::::\n:::::::,..r20B@P@Gr...,:::::::\n:::::::::,.. @: BJ.,,:::::::::\n:::::::::::,.L,.L:,:::::::::::\n::::::::::::,:,:,:::::::::::::");
	console.log("- Welcome to MrBird's blog -");
	$("a").not(".nav-link,.cloud-tie-join-count").addClass("animsition-link");
	 $("body").animsition({
			inClass: 'fade-in',
			outClass: 'fade-out',
			inDuration: 400,
			outDuration: 400,
			linkElement: '.animsition-link',
			loading: true,
			loadingParentElement: 'html', //animsition wrapper element
			loadingClass: 'line-scale-pulse-out-rapid',
			loadingInner: '',
			timeout: false,
			timeoutCountdown: 5000,
			onLoadEvent: true,
			browser: [ 'animation-duration', '-webkit-animation-duration'],
			overlay : false,
			overlayClass : 'animsition-overlay-slide',
			overlayParentElement : 'html',
			transition: function(url){ window.location.href = url; }
		  });
</script>
  {% include '_third-party/analytics/index.swig' %}

  {% set container_class = "container " %}
  {% if theme.sidebar.position %}
    {% set container_class = container_class + 'sidebar-position-' + theme.sidebar.position %}
  {% endif %}

  <div class="{{ container_class }} {% block page_class %}{% endblock %} ">
    <div class="headband"></div>

    <header id="header" class="header" itemscope itemtype="http://schema.org/WPHeader">
      <div class="header-inner"> {%- include '_partials/header.swig' %} </div>
    </header>

    <main id="main" class="main">
      <div class="main-inner">
        <div class="content-wrap">
          <div id="content" class="content">
            {% block content %}{% endblock %}
          </div>
          {% include '_third-party/duoshuo-hot-articles.swig' %}
          {% include '_partials/comments.swig' %}
        </div>
        {% if theme.sidebar.display !== 'remove' %}
          {% block sidebar %}{% endblock %}
        {% endif %}
      </div>
    </main>

    <footer id="footer" class="footer">
      <div class="footer-inner">
        {% include '_partials/footer.swig' %}
        {% include '_third-party/analytics/busuanzi-counter.swig' %}
        {% block footer %}{% endblock %}
      </div>
    </footer>

    {% if not theme.sidebar.b2t %}
      <div class="back-to-top">
        <span style="font-family: 'Source Sans Pro','Helvetica Neue',Arial,sans-serif;font-size:1.2em;font-weight:600;">TOP</span>
        {% if theme.sidebar.scrollpercent %}
          <span id="scrollpercent"><span>0</span>%</span>
        {% endif %}
      </div>
    {% endif %}

  </div>

  {% include '_scripts/vendors.swig' %}
  {% include '_scripts/commons.swig' %}

  {% set scheme_script = '_scripts/schemes/' + theme.scheme | lower + '.swig' %}
  {% include scheme_script %}

  {% block script_extra %}
    {% include '_scripts/pages/post-details.swig' %}
  {% endblock %}

  {% include '_scripts/boostrap.swig' %}

  {% include '_third-party/comments/index.swig' %}
  {% include '_third-party/search/index.swig' %}
  {% include '_third-party/analytics/lean-analytics.swig' %}
  {% include '_third-party/seo/baidu-push.swig' %}
  {% include '_third-party/rating.swig' %}
  {% include '_third-party/mathjax.swig' %}
  {% include '_third-party/scroll-cookie.swig' %}
  {% include '_third-party/exturl.swig' %}
</body>
</html>

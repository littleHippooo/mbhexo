<!doctype html>

{% set html_class = 'theme-next ' + theme.scheme %}
{% if theme.use_motion %}
  {% set html_class = html_class + ' use-motion' %}
{% endif %}

<html class="{{ html_class | lower }}" lang="{{ config.language }}">
<head>
  <meta name="google-site-verification" content="7Tau9WyVgxnsEY9oYedu9g0U6_8akOX3wiKbaYcrg9A" />
  <meta name="baidu-site-verification" content="EVwLiaxdxX" />
  <link href="{{ url_for(theme.css) }}/animsition.min.css" rel="stylesheet" type="text/css" />
  <link href="{{ url_for(theme.css) }}/xps13.css" rel="stylesheet" type="text/css" />
  <link href="{{ url_for(theme.css) }}/message.css" rel="stylesheet" type="text/css" />
  <script type="text/javascript" src="{{ url_for(theme.js) }}/jquery-1.11.3.min.js"></script>
  {% include '_partials/head.swig' %}
  <title>{% block title %}{% endblock %}</title>
</head>

<body ondragstart="return false;" class="animsition" lang="{{ page.lang || page.language || config.language }}" style="overflow-x: hidden;padding-right: 290px">
<script type="text/javascript" src="{{ url_for(theme.js) }}/animsition.min.js"></script>
 <script type="text/javascript" src="{{ url_for(theme.js) }}/mo.min.js"></script>
<script>
$("body").animsition({inClass:"fade-in",outClass:"fade-out",inDuration:300,outDuration:300,linkElement:".animsition-link",loading:true,loadingParentElement:"html",loadingClass:"{{ theme.loading_class }}",loadingInner:"",timeout:false,timeoutCountdown:50,onLoadEvent:true,browser:["animation-duration","-webkit-animation-duration"],overlay:false,overlayClass:"animsition-overlay-slide",overlayParentElement:"html",transition:function(url){window.location.href=url}});
</script>
  {% include '_third-party/analytics/index.swig' %}

  {% set container_class = "container " %}
  {% if theme.sidebar.position %}
    {% set container_class = container_class + 'sidebar-position-' + theme.sidebar.position %}
  {% endif %}

  <div class="{{ container_class }} {% block page_class %}{% endblock %} ">
    <div class="headband"></div>

    <header id="header" class="header" >
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

    <footer id="footer" class="footer" onselectstart="return false">
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
<script>
  $(function(){$("a").not(".nav-link,.cloud-tie-join-count,.ignore-href,.jstree-anchor").addClass("animsition-link");});var burst1 = new mojs.Burst({left: 0, top: 0,radius: { 5: 40 },children: {shape: 'circle',fill: ['red', 'cyan', 'orange' ],fillOpacity: .8,radiusX: 3.5,radiusY: 3.5}});document.addEventListener('click', function (e) {if(e.target.href != null || e.target.className=='footer' || e.target.className=='copyright' || e.target.className=='author__urls social-icons' || e.target.className=='author__avatar' || e.target.className=='sidebar sidebar-active') return; burst1.tune({ x: e.pageX, y: e.pageY }).generate().replay();});

</script>
<script type="text/javascript" src="{{ url_for(theme.js) }}/message.js"></script>
</html>

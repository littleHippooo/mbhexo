{% extends '_layout.swig' %}
{% import '_macro/post.swig' as post_template %}
{% import '_macro/sidebar.swig' as sidebar_template %}


{% block title %}{{ page.title }} | {{ config.title }}{% endblock %}

{% block page_class %}page-post-detail{% endblock %}


{% block content %}
  <div id="posts" class="posts-expand">
    {{ post_template.render(page) }}
    <div id="container"></div>
    <div class="post-spread">
      {% if theme.jiathis %}
        {% include '_partials/share/jiathis.swig' %}
      {% elseif theme.baidushare %}
        {% include '_partials/share/baidushare.swig' %}
      {% elseif theme.add_this_id %}
        {% include '_partials/share/add-this.swig' %}
      {% elseif theme.duoshuo_shortname and theme.duoshuo_share %}
        {% include '_partials/share/duoshuo_share.swig' %}
      {% endif %}
      {% if theme.gitment.enable %} 
        <link rel="stylesheet" href="https://imsun.github.io/gitment/style/default.css">
        <script src="https://imsun.github.io/gitment/dist/gitment.browser.js"></script>
        <script>
          var gitment = new Gitment({
            owner: '{{ theme.gitment.owner }}',
            repo: '{{ theme.gitment.repo }}',
            oauth: {
              client_id: '{{ theme.gitment.client_id }}',
              client_secret: '{{ theme.gitment.client_secret }}'
            }
          })
          gitment.render('container')
        </script>
      {% endif %}
    </div>
  </div>

{% endblock %}

{% block sidebar %}
  {{ sidebar_template.render(true) }}
{% endblock %}


{% block script_extra %}
  {% include '_scripts/pages/post-details.swig' %}
{% endblock %}
 console.log("::::::::::::::::::::::::::::::\n::::::::::::::::,:,:,,,:::::::\n:::::::::::::::,,..::...,:::::\n::::::::::::::,.v@B@B@@L.,,:::\n:::,,.,,:,:,,..M@F, , FBZ ,,::\n:::.B@r......vB@..,@BE iBM,,,:\n:::.@B@BMqqO@@q.,.:0ML.  B@q::\n::,.BG ;10ZP7..,::,,... O@ki,:\n:::.LB: ....,,:::::,,..F@ .,::\n::::.ZBL ..,,:,:,:,,..E@r.,:::\n::::,.5B@v.........:qB@:.,::::\n::::::..Z@B@PYY12OB@BL.,,:::::\n:::::::,..r20B@P@Gr...,:::::::\n:::::::::,.. @: BJ.,,:::::::::\n:::::::::::,.L,.L:,:::::::::::\n::::::::::::,:,:,:::::::::::::");
  console.log("- Welcome to {{$.blogInfo.Title}} -");
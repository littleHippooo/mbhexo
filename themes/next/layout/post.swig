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
        <link href="{{ url_for(theme.css) }}/gitment.css" rel="stylesheet" type="text/css" />
        <link href="{{ url_for(theme.css) }}/sweetalert.css" rel="stylesheet" type="text/css" />
        <script type="text/javascript" src="{{ url_for(theme.js) }}/gitment.js"></script>
        <script type="text/javascript" src="{{ url_for(theme.js) }}/sweetalert.min.js"></script>
        <script type="text/javascript" src="{{ url_for(theme.js) }}/activate-power-mode.js"></script>
        <script>
          POWERMODE.colorful = true; 
          POWERMODE.shake = false; 
          document.body.addEventListener('input', POWERMODE);
          var gitment = new Gitment({
            id: window.location.pathname,
            owner: '{{ theme.gitment.owner }}',
            repo: '{{ theme.gitment.repo }}',
            oauth: {
              client_id: '{{ theme.gitment.client_id }}',
              client_secret: '{{ theme.gitment.client_secret }}'
            }
          });
          gitment.render('container');
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
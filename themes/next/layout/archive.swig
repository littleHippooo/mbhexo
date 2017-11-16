{% extends '_layout.swig' %}
{% import '_macro/post-collapse.swig' as post_template %}
{% import '_macro/sidebar.swig' as sidebar_template %}

{% block title %}{{ __('title.archive') }} | {{ config.title }}{% endblock %}

{% block page_class %} page-archive {% endblock %}

{% block content %}

  <section id="posts" class="posts-collapse">
    <span class="archive-move-on"></span>

    <span class="archive-page-counter">
     There are <span style="font-weight:600;opacity:1">{{ site.posts.length }}</span> posts in total till now
    </span>
    {% for post in page.posts %}

      {# Show year #}
      {% set year %}
      {% set post.year = date(post.date, 'YYYY') %}

      {% if post.year !== year %}
        {% set year = post.year %}
        <div class="collection-title">
          <h2 class="archive-year motion-element" id="archive-year-{{ year }}">{{ year }}</h2>
        </div>
      {% endif %}
      {# endshow #}
    {% endfor %}
    <div class="post-header-div">
    {% for post in page.posts %}

      
      
      {{ post_template.render(post) }}
     
    {% endfor %}
   </div>
  </section>

  {% include '_partials/pagination.swig' %}

{% endblock %}

{% block sidebar %}
  {{ sidebar_template.render(false) }}
{% endblock %}


{% block script_extra %}
<script type="text/javascript" src="{{ url_for(theme.js) }}/src/scrollspy.js?v={{ theme.version }}"></script>
<script type="text/javascript" src="{{ url_for(theme.js) }}/src/post-details.js?v={{ theme.version }}"></script>
  {% if theme.use_motion %}
    <script type="text/javascript" id="motion.page.archive">
      $('.archive-year').velocity('transition.slideLeftIn');
    </script>
  {% endif %}
{% endblock %}
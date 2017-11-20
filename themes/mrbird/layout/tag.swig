{% extends '_layout.swig' %}
{% import '_macro/post-collapse.swig' as post_template %}
{% import '_macro/sidebar.swig' as sidebar_template %}

{% block title %}{{ __('title.tag') }}: {{ page.tag }} | {{ config.title }}{% endblock %}

{% block content %}

  <div id="posts" class="posts-collapse">
    <div class="collection-tag-title">
      <{% if theme.seo %}h2{% else %}h1{% endif %}>{#
      #}{{ page.tag }}{#
      #}
      </{% if theme.seo %}h2{% else %}h1{% endif %}>
    </div>
    <div class="collection-tag-title-div">
	    {% for post in page.posts %}
	      {{ post_template.render(post) }}
	    {% endfor %}
    </div>
  </div>

  {% include '_partials/pagination.swig' %}
{% endblock %}

{% block sidebar %}
  {{ sidebar_template.render(false) }}
{% endblock %}

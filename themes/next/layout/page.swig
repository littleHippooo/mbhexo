{% extends '_layout.swig' %}
{% import '_macro/sidebar.swig' as sidebar_template %}

  {% block title %}{#
  #}{% set page_title_suffix = ' | ' + config.title %}{#

  #}{% if page.type === "categories" and not page.title %}{#
    #}{{ __('title.category') + page_title_suffix }}{#
  #}{% elif page.type === "tags" and not page.title %}{#
    #}{{ __('title.tag') + page_title_suffix }}{#
  #}{% else %}{#
    #}{{ page.title + page_title_suffix }}{#
  #}{% endif %}{#
#}{% endblock %}

{% block page_class %}page-post-detail{% endblock %}

{% block content %}

  <div id="posts" class="posts-expand">
  {% include '_partials/page-header.swig' %}
    {# tagcloud page support #}
    {% if page.type === "tags" %}
      <div class="tag-cloud">
        <div class="tag-cloud-title">
           There are {{ site.tags.length }} tags in total till now
        </div>
        <div class="tag-cloud-tags">
          {{ tagcloud({min_font: 14, max_font: 15, amount: 40000, color: true, start_color: '#111', end_color: '#111'}) }}
        </div>
      </div>
	{% elif page.type === "friends" %}
	<script>
		document.title = "友链 | MrBird's blog"
		$(".post-header").hide();
	</script>
	<link href="{{ url_for(theme.css) }}/friends.css" rel="stylesheet" type="text/css" />	
	  <div class="friends-model">
        Let us be friends, g<span style="color:rgba(255,153,102,0.9);"><s>a</s></span>uys
	  </div>
	  <div class="friends-href">
		<a href="https://32mb.space/" target="_blank"><i class="fa fa-fw fa-star"></i>32mb space</a>
		<a href="http://blog.leanote.com/jint" target="_blank"><i class="fa fa-fw fa-star"></i>jint's blog</a>
		<a href="http://ltsc.leanote.com/" target="_blank"><i class="fa fa-fw fa-star"></i>ltcs's blog</a>
		<a href="http://blog.leanote.com/althars" target="_blank"><i class="fa fa-fw fa-star"></i>Althars's blog</a>
		<a href="https://libisky.com/" target="_blank"><i class="fa fa-fw fa-star"></i>LiBiSky's blog</a>
		<a href="http://hao.iyangqiong.com/" target="_blank"><i class="fa fa-fw fa-star"></i>HaoWeb navigation</a>
	  </div>
  <hr>
  <div class="friends-model">
        Looking forward to your comments 🎉
  </div>
    {% if theme.gitment.enable %} 
  	<div id="container"></div>
    <link rel="stylesheet" href="https://imsun.github.io/gitment/style/default.css">
    <script src="https://imsun.github.io/gitment/dist/gitment.browser.js"></script>
    <script>
      var gitment = new Gitment({
        id: window.location.pathname,
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
	{% elif page.type === "music" %}
	
	<script>
		document.title = "音乐 | MrBird's blog"
		$(".post-header").hide();
	</script>
	{% include 'music.swig' %}	
	{% elif page.type === "error" %}
	
	<script>
		document.title = "ಠ_ಠ 404 | MrBird's blog"
		$(".post-header").hide();
	</script>
	{% include 'error.swig' %}	
    {% elif page.type === 'categories' %}
      <div class="category-all-page">
        <div class="category-all-title">
            {{ _p('counter.categories', site.categories.length) }}
        </div>
        <div class="category-all">
          {{ list_categories() }}
        </div>
      </div>
    {% else %}
      {{ page.content }}
    {% endif %}
  </div>

{% endblock %}

{% block sidebar %}
  {{ sidebar_template.render(true) }}
{% endblock %}

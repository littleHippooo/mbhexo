<div class="site-brand-wrapper">
  <div class="site-meta {% if theme.custom_logo.enabled %}custom-logo{% endif %}">
    {% if theme.custom_logo.image and theme.scheme === 'Muse' %}
      <div class="site-meta-headline">
        <a>
          <img class="custom-logo-image" src="{{ theme.custom_logo.image }}"
               alt="{{ config.title }}"/>
        </a>
      </div>
    {% endif %}
    <style>
    	@font-face {font-family: 'Lucida_Handwritdf74cd7e117c83';
    	src: url('//cdn.webfont.youziku.com/webfonts/nomal/97411/47284/59f029dff629d81194592a90.gif?r=57305183482');
    	src: url('//cdn.webfont.youziku.com/webfonts/nomal/97411/47284/59f029dff629d81194592a90.gif?r=57305183482?#iefix') format('embedded-opentype'),     url('//cdn.webfont.youziku.com/webfonts/nomal/97411/47284/59f029dff629d81194592a90.bmp?r=57305183482') format('woff'),     url('//cdn.webfont.youziku.com/webfonts/nomal/97411/47284/59f029dff629d81194592a90.jpg?r=57305183482') format('truetype'),     url('//cdn.webfont.youziku.com/webfonts/nomal/97411/47284/59f029dff629d81194592a90.png#Lucida_Handwriting') format('svg');   }.cssdf74cd7e117c83{font-family: 'Lucida_Handwritdf74cd7e117c83';}
    </style>
    <div class="custom-logo-site-title">
      <a href="{{ config.root }}"  class="brand" rel="start">
        <span class="logo-line-before"><i></i></span>
        <span class="site-title cssdf74cd7e117c83">MrBird</span>
        <span class="logo-line-after"><i></i></span>
      </a>
    </div>
      {% if theme.seo %}
        <h1 class="site-subtitle" itemprop="description">{{ config.subtitle }}</h1>
      {% else %}
        <p class="site-subtitle">{{ config.subtitle }}</p>
      {% endif %}
  </div>

  <div class="site-nav-toggle">
    <button>
      <span class="btn-bar"></span>
      <span class="btn-bar"></span>
      <span class="btn-bar"></span>
    </button>
  </div>
</div>

<nav class="site-nav">
  {% set hasSearch = theme.swiftype_key || theme.algolia_search.enable || theme.tinysou_Key || theme.local_search.enable %}

  {% if theme.menu %}
    <ul id="menu" class="menu">
      {% for name, path in theme.menu %}
        {% set itemName = name.toLowerCase() %}
			<li class="menu-item menu-item-{{ itemName }}">
          <a href="{{ url_for(path) }}" rel="section">
            {% if theme.menu_icons.enable %}
              <!--<i class="menu-item-icon fa fa-fw fa-{{theme.menu_icons[itemName] | default('question-circle') | lower }}"></i> <br />-->
            {% endif %}
            {{ __('menu.' + name) }}
          </a>
        </li>
      {% endfor %}
	    <div class="sidebar-toggle" style="display:none">
			<div class="sidebar-toggle-line-wrap">
			  <span class="sidebar-toggle-line sidebar-toggle-line-first"></span>
			  <span class="sidebar-toggle-line sidebar-toggle-line-middle"></span>
			  <span class="sidebar-toggle-line sidebar-toggle-line-last"></span>
			</div>
		  </div>
    </ul>
  {% endif %}

  {% if hasSearch %}
    <div class="site-search">
      {% include 'search.swig' %}
    </div>
  {% endif %}
</nav>

{% include '../_custom/header.swig' %}

{% macro render(is_post) %}



  <aside id="sidebar" class="sidebar" onselectstart="return false">
    
	<div class="sidebar-inner">

      {% set display_toc = is_post and theme.toc.enable or is_page and theme.toc.enable %}

      {% if display_toc and toc(page.content).length > 1 %}
        <ul class="sidebar-nav motion-element">
          <li class="sidebar-nav-toc sidebar-nav-active" data-target="post-toc-wrap" >
            {{ __('sidebar.toc') }}
          </li>
          <li class="sidebar-nav-overview" data-target="site-overview">
            {{ __('sidebar.overview') }}
          </li>
        </ul>
      {% endif %}

      <section class="site-overview sidebar-panel{% if not display_toc or toc(page.content).length <= 1 %} sidebar-panel-active{% endif %}">
	  <!--
        <div class="site-author motion-element" itemprop="author" itemscope itemtype="http://schema.org/Person">
          <img class="site-author-image" itemprop="image"
               src="{{ url_for( theme.avatar | default(theme.images + '/avatar.gif') ) }}"
               alt="{{ theme.author }}" />
          <p class="site-author-name" itemprop="name">{{ theme.author }}</p>
           {% if theme.seo %}
              <p class="site-description motion-element" itemprop="description">{{ theme.signature }}</p>
           {% else %}
              <p class="site-description motion-element" itemprop="description">{{ theme.description }}</p>
          {% endif %}
        </div>
        <nav class="site-state motion-element">

          {% if config.archive_dir != '/' %}
            <div class="site-state-item site-state-posts">
              <a href="{{ url_for(theme.menu.archives) }}">
                <span class="site-state-item-count">{{ site.posts.length }}</span>
                <span class="site-state-item-name">{{ __('state.posts') }}</span>
              </a>
            </div>
          {% endif %}

          {% if site.categories.length > 0 %}
            {% set categoriesPageQuery = site.pages.find({type: 'categories'}, {lean: true}) %}
            {% set hasCategoriesPage = categoriesPageQuery.length > 0 %}
            <div class="site-state-item site-state-categories">
              {% if hasCategoriesPage %}<a href="{{ url_for(categoriesPageQuery[0].path) }}">{% endif %}
                <span class="site-state-item-count">{{ site.categories.length }}</span>
                <span class="site-state-item-name">{{ __('state.categories') }}</span>
              {% if hasCategoriesPage %}</a>{% endif %}
            </div>
          {% endif %}

          {% if site.tags.length > 0 %}
            {% set tagsPageQuery = site.pages.find({type: 'tags'}, {lean: true}) %}
            {% set hasTagsPage = tagsPageQuery.length > 0 %}
            <div class="site-state-item site-state-tags">
              {% if hasTagsPage %}<a href="{{ url_for(tagsPageQuery[0].path) }}">{% endif %}
                <span class="site-state-item-count">{{ site.tags.length }}</span>
                <span class="site-state-item-name">{{ __('state.tags') }}</span>
              {% if hasTagsPage %}</a>{% endif %}
            </div>
          {% endif %}

        </nav>

        {% if theme.rss %}
          <div class="feed-link motion-element">
            <a href="{{ url_for(theme.rss) }}" rel="alternate">
              <i class="fa fa-rss"></i>
              RSS
            </a>
          </div>
        {% endif %}

        <div class="links-of-author motion-element">
          {% if theme.social %}
            {% for name, link in theme.social %}
              <span class="links-of-author-item">
                <a href="{{ link }}" target="_blank" title="{{ name }}">
                  {% if theme.social_icons.enable %}
                    <i class="fa fa-fw fa-{{ theme.social_icons[name] | default('diamond') | lower }}"></i>
                  {% endif %}
                  {{ name }}
                </a>
              </span>
            {% endfor %}
          {% endif %}
        </div>

        {% set cc = {'by': 1, 'by-nc': 1, 'by-nc-nd': 1, 'by-nc-sa': 1, 'by-nd': 1, 'by-sa': 1, 'zero': 1} %}
        {% if theme.creative_commons in cc %}
          <div class="cc-license motion-element" itemprop="license">
            <a href="https://creativecommons.org/{% if theme.creative_commons === 'zero' %}publicdomain/zero/1.0{% else %}licenses/{{ theme.creative_commons }}/4.0{% endif %}/" class="cc-opacity" target="_blank">
              <img src="{{ url_for(theme.images) }}/cc-{{ theme.creative_commons }}.svg" alt="Creative Commons" />
            </a>
          </div>
        {% endif %}

        {# Blogroll #}
        {% if theme.links %}
          <div class="links-of-blogroll motion-element {{ "links-of-blogroll-" + theme.links_layout | default('inline') }}">
            <div class="links-of-blogroll-title">
              <i class="fa  fa-fw fa-{{ theme.links_icon | default('star') | lower }}"></i>
              {{ theme.links_title }}
            </div>
            <ul class="links-of-blogroll-list">
              {% for name, link in theme.links %}
                <li class="links-of-blogroll-item">
                  <a href="{{ link }}" title="{{ name }}" target="_blank">{{ name }}</a>
                </li>
              {% endfor %}
            </ul>
          </div>
        {% endif %}

        {% include '../_custom/sidebar.swig' %}
		 -->
		
		<div class="sidebar-sticky sticky">
		  <div itemscope="" itemtype="http://schema.org/Person">
			<div class="author__avatar">
			  <img src="{{ url_for( theme.avatar | default(theme.images + '/avatar.gif') ) }}" class="author__avatar" alt="MrBird" itemprop="image"></div>
			<div class="author__content">
			  <h3 class="author__name" itemprop="name">MrBird's Blog</h3>
			  <p class="author__bio" itemprop="description">A simple blog, code repository, just keep blogging</p></div>
			<div class="author__urls-wrapper">
			  <button class="btn btn--inverse">Follow</button>
			  <ul class="author__urls social-icons">
				<li>
				  <a href="http://map.baidu.com/?newmap=1&s=s%26wd%3D%E7%A6%8F%E5%B7%9E%E5%B8%82%26c%3D300&from=alamap&tpl=mapcity" target="_blank" itemprop="url" class="ignore-href">
					<i class="fa fa-fw fa-map-marker" aria-hidden="true"></i>&nbsp;&nbsp;FuZhou,CN</a>
				</li>  
				<li>
				  <a href="http://mrbird.leanote.com" target="_blank" itemprop="url" class="ignore-href">
					<i class="fa fa-fw fa-chain" aria-hidden="true"></i>&nbsp;&nbsp;Website</a>
				</li>
				<li>
				  <a href="/atom.xml" target="_blank" itemprop="url" class="ignore-href">
					<i class="fa fa-fw fa-rss" aria-hidden="true"></i>&nbsp;&nbsp;RSS</a>
				</li>
				<li>
				  <a href="/images/wechat.png" target="_blank" itemprop="sameAs" class="ignore-href">
					<i class="fa fa-fw fa-weixin" aria-hidden="true"></i>&nbsp;&nbsp;WeChat</a>
				</li>
				<li>
				  <a href="https://www.facebook.com/mrbirdleanote" target="_blank" itemprop="sameAs" class="ignore-href">
					<i class="fa fa-fw fa-facebook-square" aria-hidden="true"></i>&nbsp;&nbsp;Facebook</a>
				</li>
				<li>
				  <a href="http://weibo.com/mrbird123" target="_blank" itemprop="sameAs" class="ignore-href">
					<i class="fa fa-fw fa-weibo" aria-hidden="true"></i>&nbsp;&nbsp;Weibo</a>
				</li>
				<li>
				  <a href="https://github.com/wuyouzhuguli" target="_blank" itemprop="sameAs" class="ignore-href">
					<i class="fa fa-fw fa-github-alt" aria-hidden="true"></i>&nbsp;&nbsp;GitHub</a>
				</li>
         <li>
            <a href="javascript:;" class="popup-trigger">
            <i class="fa fa-fw fa-search" aria-hidden="true"></i>&nbsp;&nbsp;{{ __('menu.search') }}
          </a>
        </li>
				<!-- <li>
				<a href="http://link-to-whatever-social-network.com/user/" itemprop="sameAs">
				<i class="fa fa-fw" aria-hidden="true"></i> Custom Social Profile Link
				</a>
				</li>
				-->
			  </ul>
			</div>
		  </div>
		</div>
		<script>
var $urls=$(".author__urls").find("a");$urls.each(function(){var $a=$(this);$a.mouseenter(function(){$a.css({"color":"#414547"})});$a.mouseleave(function(){$a.css({"color":""})})});
    </script>
      </section>
      {% if display_toc and toc(page.content).length > 1 %}
      <!--noindex-->
        <section class="post-toc-wrap motion-element sidebar-panel sidebar-panel-active" style="padding-right:20px;">
          <div class="post-toc">

            {% if page.toc_number === undefined %}
              {% set toc = toc(page.content, { "class": "nav", list_number: theme.toc.number }) %}
            {% else %}
              {% set toc = toc(page.content, { "class": "nav", list_number: page.toc_number }) %}
            {% endif %}

            {% if toc.length <= 1 %}
              <p class="post-toc-empty">{{ __('post.toc_empty') }}</p>
            {% else %}
              <div class="post-toc-content">{{ toc }}</div>
            {% endif %}

          </div>
        </section>
      <!--/noindex-->
      {% endif %}

      {% if theme.sidebar.b2t %}
        <div class="back-to-top">
          <i class="fa fa-arrow-up"></i>
          {% if theme.sidebar.scrollpercent %}
            <span id="scrollpercent"><span>0</span>%</span>
          {% endif %}
        </div>
      {% endif %}

    </div>
	<!--
	 -->
  </aside>
{% endmacro %}

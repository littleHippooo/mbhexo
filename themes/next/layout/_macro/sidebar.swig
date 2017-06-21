{% macro render(is_post) %}



  <aside id="sidebar" class="sidebar">
    
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
			  <img src="https://mmistakes.github.io/minimal-mistakes/assets/images/michael-rose.jpg" class="author__avatar" alt="Michael Rose" itemprop="image"></div>
			<div class="author__content">
			  <h3 class="author__name" itemprop="name">Michael Rose</h3>
			  <p class="author__bio" itemprop="description">Just another boring, tattooed, time traveling, designer.</p></div>
			<div class="author__urls-wrapper">
			  <button class="btn btn--inverse">Follow</button>
			  <ul class="author__urls social-icons">
				<li>
				  <a href="https://mademistakes.com" itemprop="url">
					<i class="fa fa-fw fa-map-marker" aria-hidden="true"></i>FuZhou,CN</a>
				</li>  
				<li>
				  <a href="https://mademistakes.com" itemprop="url">
					<i class="fa fa-fw fa-chain" aria-hidden="true"></i>Website</a>
				</li>
				<li>
				  <a href="https://twitter.com/mmistakes" itemprop="sameAs">
					<i class="fa fa-fw fa-twitter-square" aria-hidden="true"></i>Twitter</a>
				</li>
				<li>
				  <a href="https://www.facebook.com/michaelrose" itemprop="sameAs">
					<i class="fa fa-fw fa-facebook-square" aria-hidden="true"></i>Facebook</a>
				</li>
				<li>
				  <a href="https://instagram.com/mmistakes" itemprop="sameAs">
					<i class="fa fa-fw fa-instagram" aria-hidden="true"></i>Instagram</a>
				</li>
				<li>
				  <a href="https://github.com/mmistakes" itemprop="sameAs">
					<i class="fa fa-fw fa-github" aria-hidden="true"></i>GitHub</a>
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
		
		
      </section>
      {% if display_toc and toc(page.content).length > 1 %}
      <!--noindex-->
        <section class="post-toc-wrap motion-element sidebar-panel sidebar-panel-active">
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

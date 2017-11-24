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
      {% if theme.gitment.enable && !page.password%} 
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
      {% if theme.valine.enable && !page.password %}
        <div id="comment-div"></div>
        <style>
        	.valine .vwrap .vcontrol .col.col-60 {
			   text-align: left;
			}
			.valine .vlist .vcard .vhead, .valine .vlist .vcard section .vfooter {
				text-align: left;
			}
			.vname {
				color: #42b983 !important;
			}
			.valine .vinfo .col {
				text-align: left;
    			margin-left: -27rem;
			}
			div#comment-div {
			    margin-bottom: -8rem;
			}
			.valine .vlist .vcard .vcontent .code, .valine .vlist .vcard .vcontent code, .valine .vlist .vcard .vcontent pre {
				background: #fbfbfb;
			}
			.valine .vlist .vcard .vcontent a {
				color: #42b983;
			}
			.valine .vlist .vcard .vimg {
				border-radius: 3px;
			}
			.valine .vbtn {
				border-radius: 2px;
				padding: .3rem 1.25rem;
			}
			.valine .vbtn:active,.valine .vbtn:hover {
				color: #42b983;
				border-color: #42b983;
				background-color: #fff
			}
			.valine .vwrap .vheader .vinput:focus {
				border-bottom-color: #42b983;
			}
			.valine .vlist .vcard .vcontent.expand:before {
				background: -webkit-gradient(linear,left top,left bottom,from(hsla(0,0%,100%,0)),to(hsla(0,0%,100%,.2)));
				background: linear-gradient(180deg,hsla(0,0%,100%,0),hsla(0,0%,100%,.2))
			}

			.valine .vlist .vcard .vcontent.expand:after {
				content: "点击展开";
				font-size: .4rem;
				text-align: right;				
				left: -1rem;
				background: hsla(0,0%,100%,.2)
			}
			.valine .vlist .vcard section .vfooter .vat {
				color: #b3b3b3;
			}
			.valine .vlist .vcard section .vfooter .vat:hover {
				color: #42b983;
			}
			.vcontent img {
				margin: 0px;
			}
			.valine .info {
				display: none;
			}
        </style>
        <script type="text/javascript" src="{{ url_for(theme.js) }}/av.min.js"></script>
        <script type="text/javascript" src="{{ url_for(theme.js) }}/Valine.min.js"></script>
    	<script>
    	new Valine({
		    el: '#comment-div' ,
		    notify: true, 
		    verify: false, 
		    appId: '{{ theme.valine.app_id}}',
		    appKey: '{{ theme.valine.app_key}}',
		    placeholder: '',
		    path: window.location.pathname, 
		    avatar: 'monsterid',
		    guest_info:  ['nick','link']
		});
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
<div class="copyright" >
  {% set current = date(Date.now(), "YYYY") %}
  &copy; {% if theme.since and theme.since != current %} {{ theme.since }} - {% endif %}
  <span itemprop="copyrightYear">{{ current }}</span>&nbsp;&nbsp;
 
  <span class="author" itemprop="copyrightHolder">{{ config.author }}</span>&nbsp;<span> Prowered &nbsp;by <a href="https://hexo.io/" target="_blank" style="color:#42b983">&nbsp;Hexo</a></span>
</div>
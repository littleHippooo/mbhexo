<div class="copyright">
  {% set current = date(Date.now(), "YYYY") %}
  &copy; {% if theme.since and theme.since != current %} {{ theme.since }} - {% endif %}
  <span itemprop="copyrightYear">{{ current }}</span>&nbsp;&nbsp;
 
  <span class="author" itemprop="copyrightHolder">{{ config.author }}</span>
</div>
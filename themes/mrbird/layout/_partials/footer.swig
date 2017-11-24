<div class="copyright" >
  {% set current = date(Date.now(), "YYYY") %}
  &copy; {% if theme.since and theme.since != current %} {{ theme.since }} - {% endif %}
  <span itemprop="copyrightYear">{{ current }}</span>&nbsp;&nbsp;
 
  <span class="author" itemprop="copyrightHolder">{{ config.author }}</span>&nbsp;-&nbsp;<span>Hosted &nbsp;by &nbsp;<a href="https://pages.coding.me" style="color:#42b983" target="_blank" class="ignore-href">Coding Pages</a></span>
</div>
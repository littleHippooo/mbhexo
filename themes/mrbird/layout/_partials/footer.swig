<div class="copyright" style="margin-left:13rem">
  {% set current = date(Date.now(), "YYYY") %}
  &copy; {% if theme.since and theme.since != current %} {{ theme.since }} - {% endif %}
  <span itemprop="copyrightYear">{{ current }}</span>&nbsp;&nbsp;
 
  <span class="author" itemprop="copyrightHolder">{{ config.author }}</span>&nbsp;&nbsp;<span style="color:#f9f9f9">Hosted &nbsp;by &nbsp;<a href="https://pages.coding.me" style="color:#f9f9f9;cursor:default" target="_blank" class="ignore-href" >Coding Pages</a></span>
</div>
{% if page.prev or page.next %}
  <nav class="pagination">
    {{
      paginator({
        prev_text: '<i class="fa fa-angle-left"></i>',
        next_text: '<i class="fa fa-angle-right"></i>',
        mid_size: 1
      })
    }}
  </nav>
{% endif %}
<span style="display:none">Hosted &nbsp;by &nbsp;<a href="https://pages.coding.me" style="color:#f9f9f9;cursor:default" target="_blank" class="ignore-href" >Coding Pages</a></span>
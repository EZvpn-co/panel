<footer class="ui-footer">
    <div class="container">
        &copy;{date("Y")} | <a href="www.ezvpn.co">EZvpn.co</a>
        {if $config['enable_analytics_code'] === true}{include file='analytics.tpl'}{/if}
    </div>
</footer>

<!-- js -->
<script src="//cdn.jsdelivr.net/npm/jquery/dist/jquery.min.js"></script>
<script src="/theme/tabler/js/base.min.js"></script>
<script src="/theme/tabler/js/project.min.js"></script>

</body>
{include file='live_chat.tpl'}
</html>
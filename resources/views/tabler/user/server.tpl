{include file="user/tabler_header.tpl"}

<div class="page-wrapper">
    <div class="container-xl">
        <div class="page-header d-print-none text-white">
            <div class="row align-items-center">
                <div class="col">
                    <h2 class="page-title">
                         <span class="home-title">Node List</span>
                    </h2>
                    <div class="page-pretitle my-3">
                         <span class="home-subtitle">Check node online</span>
                    </div>
                </div>
            </div>
        </div>
    </div>
    <div class="page-body">
        <div class="container-xl">
            <div class="row row-cards">
                <div class="col-12">
                    <div class="card">
                        <div class="card-body">
                            <div class="m-0 my-2">
                                <p>The description is respectively expressed as: the number of online users of this node, the traffic multiplier of this node, and the type of this node</p>
                                <p>The green indicator light indicates normal operation; the yellow indicator indicates that the current month's traffic is exhausted; the orange indicator indicates that the configuration is not successful; the red indicator indicates that it is offline and cannot be used</p>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="col-12">
                    <div class="card">
                        <div class="card-body">
                            <div class="tab-content">
                                <div class="row row-cards">
                                    {foreach $servers as $server}
                                        {if $user->class < $server["class"]}
                                        <div class="col-lg-12">
                                            <div class="card bg-primary-lt">
                                                {if $server["class"] == 0}
                                                <div class="ribbon bg-red">Free</div>
                                                {else}
                                                <div class="ribbon bg-red">LV. {$server["class"]}</div>
                                                {/if}
                                                <div class="card-body">
                                                    <p class="text-muted">
                                                        <i class="ti ti-info-circle icon text-blue"></i>
                                                        Your current account level is lower than the node level listed below, so it cannot be used. can go to
                                                         <a href="/user/shop">Shop</a>
                                                         Order the corresponding level package
                                                    </p>
                                                </div>
                                            </div>
                                        </div>
                                        {/if}
                                        <div class="col-lg-4 col-md-6 col-sm-12">
                                            <div class="card">
                                                {if $server["class"] == 0}
                                                <div class="ribbon bg-red">Free</div>
                                                {else}
                                                <div class="ribbon bg-red">LV. {$server["class"]}</div>
                                                {/if}
                                                <div class="card-body">
                                                    <div class="row g-3 align-items-center">
                                                        <div class="col-auto">
                                                            <span
                                                                class="status-indicator
                                                                {if $server["traffic_limit"] != '0' && $server["traffic_used"] >= $server["traffic_limit"]}
                                                                status-yellow 
                                                                {elseif $server["online"] == "1"}
                                                                status-green 
                                                                {elseif $server["online"] == "0"}
                                                                status-orange 
                                                                {else}
                                                                status-red 
                                                                {/if}
                                                                status-indicator-animated">
                                                                <span class="status-indicator-circle"></span>
                                                                <span class="status-indicator-circle"></span>
                                                                <span class="status-indicator-circle"></span>
                                                            </span>
                                                        </div>
                                                        <div class="col">
                                                            <h2 class="page-title" style="font-size: 16px;">
                                                                {$server["name"]}&nbsp;
                                                                <span class="card-subtitle my-2"
                                                                    style="font-size: 10px;">
                                                                    {if $server["traffic_limit"] == "0"}
                                                                        {round($server["traffic_used"])} GB /
                                                                        Unlimited
                                                                    {else}
                                                                        {round($server["traffic_used"])} GB /
                                                                        {round($server["traffic_limit"])} GB
                                                                    {/if}
                                                                </span>
                                                            </h2>
                                                            <div class="text-muted">
                                                                <ul class="list-inline list-inline-dots mb-0">
                                                                    <li class="list-inline-item">
                                                                        <i class="ti ti-users"></i>&nbsp;
                                                                        {$server["online_user"]}
                                                                    </li>
                                                                    <li class="list-inline-item">
                                                                        <i class="ti ti-rocket"></i>&nbsp;
                                                                        {$server["traffic_rate"]} times
                                                                    </li>
                                                                    <li class="list-inline-item">
                                                                        <i class="ti ti-server-2"></i>&nbsp;
                                                                        {if $server['sort'] == 0}
                                                                        Shadowsocks
                                                                        {elseif $server['sort'] == 9}
                                                                        Shadowsocksr
                                                                        {elseif $server['sort'] == 11}
                                                                        V2ray
                                                                        {elseif $server['sort'] == 14}
                                                                        Trojan
                                                                        {/if}
                                                                    </li>
                                                                </ul>
                                                            </div>
                                                        </div>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                    {/foreach}
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <script>
        var clipboard = new ClipboardJS(".ti-copy");
        clipboard.on("success", function(e) {
            $("#success-message").text("Has been copied to the clipboard");
            $("#success-dialog").modal("show");
        });
    </script>
    
{include file="user/tabler_footer.tpl"}

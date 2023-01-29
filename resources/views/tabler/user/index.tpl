{include file='user/tabler_header.tpl'}

<div class="page-wrapper">
    <div class="container-xl">
        <div class="page-header d-print-none text-white">
            <div class="row align-items-center">
                <div class="col">
                    <h2 class="page-title">
                        <span class="home-title">The user center</span>
                    </h2>
                    <div class="page-pretitle my-3">
                        <span class="home-subtitle">Check the account information and the latest announcement here</span>
                    </div>
                </div>
            </div>
        </div>
    </div>
    <div class="page-body">
        <div class="container-xl">
            <div class="row row-deck row-cards">
                <div class="col-12">
                    <div class="row row-cards">
                        <div class="col-sm-6 col-lg-3">
                            <div class="card card-sm">
                                <div class="card-body">
                                    <div class="row align-items-center">
                                        <div class="col-auto">
                                            <span class="bg-blue text-white avatar">
                                                <i class="ti ti-star icon"></i>
                                            </span>
                                        </div>
                                        <div class="col">
                                            <div class="font-weight-medium">
                                                Account level
                                            </div>
                                            <div class="text-muted">
                                                LV. {$user->class}
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                        <div class="col-sm-6 col-lg-3">
                            <div class="card card-sm">
                                <div class="card-body">
                                    <div class="row align-items-center">
                                        <div class="col-auto">
                                            <span class="bg-green text-white avatar">
                                                <i class="ti ti-coin icon"></i>
                                            </span>
                                        </div>
                                        <div class="col">
                                            <div class="font-weight-medium">
                                                The account balance
                                            </div>
                                            <div class="text-muted">
                                                {$user->money}
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                        <div class="col-sm-6 col-lg-3">
                            <div class="card card-sm">
                                <div class="card-body">
                                    <div class="row align-items-center">
                                        <div class="col-auto">
                                            <span class="bg-twitter text-white avatar">
                                                <i class="ti ti-devices-pc icon"></i>
                                            </span>
                                        </div>
                                        <div class="col">
                                            <div class="font-weight-medium">
                                                At the same time to connectIPlimit
                                            </div>
                                            <div class="text-muted">
                                                {if $user->node_iplimit !== 0}
                                                    {$user->node_iplimit}
                                                {else}
                                                    Don't limit
                                                {/if}
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                        <div class="col-sm-6 col-lg-3">
                            <div class="card card-sm">
                                <div class="card-body">
                                    <div class="row align-items-center">
                                        <div class="col-auto">
                                            <span class="bg-facebook text-white avatar">
                                                <i class="ti ti-rocket icon"></i>
                                            </span>
                                        </div>
                                        <div class="col">
                                            <div class="font-weight-medium">
                                                The speed limit
                                            </div>
                                            <div class="text-muted">
                                                {if $user->node_speedlimit !== 0.0}
                                                    {$user->node_speedlimit}</code> Mbps
                                                {else}
                                                    Don't limit
                                                {/if}
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="col-lg-6">
                    <div class="row row-cards">
                        <div class="col-12">
                            <div class="card">
                                <ul class="nav nav-tabs nav-fill" data-bs-toggle="tabs">
                                    <li class="nav-item">
                                        <a href="#sub" class="nav-link active" data-bs-toggle="tab">
                                            <i class="ti ti-rss icon"></i>
                                            &nbsp;General subscription
                                        </a>
                                    </li>
                                    <li class="nav-item">
                                        <a href="#traditional-sub" class="nav-link" data-bs-toggle="tab">
                                            <i class="ti ti-rss icon"></i>
                                            &nbsp;Traditional subscription
                                        </a>
                                    </li>
                                    <li class="nav-item">
                                        <a href="#windows" class="nav-link" data-bs-toggle="tab">
                                            <i class="ti ti-brand-windows icon"></i>
                                            &nbsp;Windows
                                        </a>
                                    </li>
                                    <li class="nav-item">
                                        <a href="#macos" class="nav-link" data-bs-toggle="tab">
                                            <i class="ti ti-brand-finder icon"></i>
                                            &nbsp;Macos
                                        </a>
                                    </li>
                                    <li class="nav-item">
                                        <a href="#android" class="nav-link" data-bs-toggle="tab">
                                            <i class="ti ti-brand-android icon"></i>
                                            &nbsp;Android
                                        </a>
                                    </li>
                                    <li class="nav-item">
                                        <a href="#ios" class="nav-link" data-bs-toggle="tab">
                                            <i class="ti ti-brand-apple icon"></i>
                                            &nbsp;IOS
                                        </a>
                                    </li>
                                    <li class="nav-item">
                                        <a href="#linux" class="nav-link" data-bs-toggle="tab">
                                            <i class="ti ti-brand-redhat icon"></i>
                                            &nbsp;Linux
                                        </a>
                                    </li>
                                    <li class="nav-item">
                                        <a href="#config" class="nav-link" data-bs-toggle="tab">
                                            <i class="ti ti-file-text icon"></i>
                                            &nbsp;Config
                                        </a>
                                    </li>
                                </ul>
                                <div class="card-body">
                                    <div class="tab-content">
                                        <div class="tab-pane active show" id="sub">
                                            <div>
                                                <p>
                                                    General subscribe (json):<code>{$getUniversalSub}/json</code>
                                                </p>
                                                <p>
                                                    General subscribe (clash):<code>{$getUniversalSub}/clash</code>
                                                </p>
                                                <div class="btn-list justify-content-start">
                                                    <a data-clipboard-text="{$getUniversalSub}/json"
                                                        class="copy btn btn-primary">
                                                        Copy the general subscribe (json)
                                                    </a>
                                                    <a data-clipboard-text="{$getUniversalSub}/clash"
                                                        class="copy btn btn-primary">
                                                        Copy the general subscribe (clash）
                                                    </a>
                                                </div>
                                            </div>
                                        </div>
                                        <div class="tab-pane show" id="traditional-sub">
                                            <div>
                                                <p>
                                                    Traditional subscription (Shadowsocks):<code>{$getTraditionalSub}?sub=2</code>
                                                </p>
                                                <p>
                                                    Traditional subscription (V2Ray):<code>{$getTraditionalSub}?sub=3</code>
                                                </p>
                                                <p>
                                                    Traditional subscription (Trojan):<code>{$getTraditionalSub}?sub=4</code>
                                                </p>
                                                <div class="btn-list justify-content-start">
                                                    <a data-clipboard-text="{$getTraditionalSub}?sub=2"
                                                        class="copy btn btn-primary">
                                                        Copy the traditional subscription (Shadowsocks)
                                                    </a>
                                                    <a data-clipboard-text="{$getTraditionalSub}?sub=3"
                                                        class="copy btn btn-primary">
                                                        Copy the tra)itional subscription (V2Ray）
                                                    </a>
                                                    <a data-clipboard-text="{$getTraditionalSub}?sub=4"
                                                        class="copy btn btn-primary">
                                                        Copy the traditional subscription (Trojan）
                                                    </a>
                                                    <a href="/clients/v2rayN-Core.zip"
                                                        class="btn btn-primary">
                                                        download (2rayN（Windows）
                                                    </a>
                                                    <a href="/clients/v2rayNG.apk"
                                                        class="btn btn-primary">
                                                        download v2rayNG(Android）
                                                    </a>
                                                </div>
                                            </div>
                                        </div>
                                        <div class="tab-pane" id="windows">
                                            <div>
                                                <p>
                                                    Apply to Clash Subscriptions:<code>{$getUniversalSub}/clash</code>
                                                </p>
                                                <div class="btn-list justify-content-start">
                                                    <a data-clipboard-text="{$getUniversalSub}/clash"
                                                        class="copy btn btn-primary">
                                                        copy Clash
                                                    </a>
                                                    <a href="/clients/Clash-Windows.exe"
                                                        class="btn btn-primary">
                                                        download Clash for Windows
                                                    </a>
                                                    <a href="clash://install-config?url={$getUniversalSub}/clash&name={$config['appName']}"
                                                        class="btn btn-primary">
                                                        The import Clash
                                                    </a>
                                                </div>
                                            </div>
                                        </div>
                                        <div class="tab-pane" id="macos">
                                            <p>
                                                Apply to CSubscriptions: The subscription：<code>{$getUniversalSub}/clash</code>
                                            </p>
                                            <div class="btn-list justify-content-start">
                                                <a data-clipboard-text="{$getUniversalSub}/clash"
                                                    class="copy btn btn-primary">
                                                    copy Clash
                                                </a>
                                                <a href="/clients/Clash-Windows.dmg"
                                                    class="btn btn-primary">
                                                    download Clash for Windows
                                                </a>
                                                <a href="clash://install-config?url={$getUniversalSub}/clash&name={$config['appName']}"
                                                    class="btn btn-primary">
                                                    The import Clash
                                                </a>
                                            </div>
                                        </div>
                                        <div class="tab-pane" id="android">
                                            <p>
                                                Apply to Clash Subscriptions:<code>{$getUniversalSub}/clash</code>
                                            </p>
                                            <div class="btn-list justify-content-start">
                                                <a data-clipboard-text="{$getUniversalSub}/clash"
                                                    class="copy btn btn-primary">
                                                    copy Clash
                                                </a>
                                                <a href="/clients/Clash-Android.apk"
                                                    class="btn btn-primary">
                                                    download Clash for Android
                                                </a>
                                                <a href="clash://install-config?url={$getUniversalSub}/clash&name={$config['appName']}"
                                                    class="btn btn-primary">
                                                    The import Clash
                                                </a>
                                            </div>
                                        </div>
                                        <div class="tab-pane" id="ios">
                                            <p>
                                                Apply to Shadowrocket Subscriptions:<code>{$getUniversalSub}/clash</code>
                                            </p>
                                            <p>
                                                In the purchase and Later, simplyallation Shadowrocket Later, simply <span style="color: red;">use Safari
                                                    The browser</span> Click the button below, then click in a pop-up window <b>Open the</b>, can quickly complete the subscription Settings
                                            </p>
                                            <p style="color: red;">
                                                If prompt unable to open, because of the need to install the corresponding first APP, and then you can import
                                            </p>
                                            <div class="btn-list justify-content-start">
                                                <a href="https://apps.apple.com/us/app/shadowrocket/id932747118"
                                                    class="btn btn-primary">
                                                    buy Shadowrocket
                                                </a>
                                                <a data-clipboard-text="{$getUniversalSub}/clash"
                                                    class="copy btn btn-primary">
                                                    copy Shadowrocket
                                                </a>
                                                <a href="sub://{base64_encode("{$getUniversalSub}/clash")}"
                                                    class="btn btn-primary">
                                                    The import Shadowrocket
                                                </a>
                                            </div>
                                        </div>
                                        <div class="tab-pane" id="linux">
                                            <p>
                                                Apply to Clash Subscriptions:<code>{$getUniversalSub}/clash</code>
                                            </p>
                                            <div class="btn-list justify-content-start">
                                                <a data-clipboard-text="{$getUniversalSub}/clash"
                                                    class="copy btn btn-primary">
                                                    copy Clash
                                                </a>
                                                <a href="/clients/Clash-Windows.tar.gz"
                                                    class="btn btn-primary">
                                                    download Clash for Windows
                                                </a>
                                                <a href="clash://install-config?url={$getUniversalSub}/clash&name={$config['appName']}"
                                                    class="btn btn-primary">
                                                    The import Clash
                                                </a>
                                            </div>
                                        </div>
                                        <div class="tab-pane" id="config">
                                            <p>Your connection information:</p>
                                            <div class="table-responsive">
                                                <table class="table table-vcenter card-table">
                                                    <tbody>
                                                    <tr>
                                                        <td><strong>port</strong></td>
                                                        <td>{$user->port}</td>
                                                    </tr>
                                                    <tr>
                                                        <td><strong>Connect the password</strong></td>
                                                        <td>{$user->passwd}</td>
                                                    </tr>
                                                    <tr>
                                                        <td><strong>UUID</strong></td>
                                                        <td>{$user->uuid}</td>
                                                    </tr>
                                                    <tr>
                                                        <td><strong>A custom encryption</strong></td>
                                                        <td>{$user->method}</td>
                                                    </tr>
                                                    </tbody>
                                                </table>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="col-lg-6 col-sm-12">
                    <div class="card">
                        <div class="card-body">
                            <h3 class="card-title">Dosage of traffic</h3>
                            <div class="progress progress-separated mb-3">
                                {if $user->LastusedTrafficPercent() < '1'}
                                    <div class="progress-bar bg-primary" role="progressbar" style="width: 1%"></div>
                                {else}
                                    <div class="progress-bar bg-primary" role="progressbar"
                                        style="width: {$user->LastusedTrafficPercent()}%">
                                    </div>
                                {/if}
                                {if $user->TodayusedTrafficPercent() < '1'}
                                    <div class="progress-bar bg-success" role="progressbar" style="width: 1%"></div>
                                {else}
                                    <div class="progress-bar bg-success" role="progressbar"
                                        style="width: {$user->TodayusedTrafficPercent()}%"></div>
                                {/if}
                            </div>
                            <div class="row">
                                <div class="col-auto d-flex align-items-center pe-2">
                                    <span class="legend me-2 bg-primary"></span>
                                    <span>Dosage of the past {$user->LastusedTraffic()}</span>
                                </div>
                                <div class="col-auto d-flex align-items-center px-2">
                                    <span class="legend me-2 bg-success"></span>
                                    <span>Today the dosage {$user->TodayusedTraffic()}</span>
                                </div>
                                <div class="col-auto d-flex align-items-center ps-2">
                                    <span class="legend me-2"></span>
                                    <span>The remaining traffic {$user->unusedTraffic()}</span>
                                </div>
                            </div>
                            <p class="my-3">
                                {if time() > strtotime($user->class_expire)}
                                    Your package is out of date, can gThe storeto <a href="/user/shop">The store</a> Purchase plan
                                {else}
                                    {$diff = round((strtotime($user->class_expire) - time()) / 86400)}
                                    your LV. {$user->class} Set about {$diff} Day maturity ({$user->class_expire}）
                                {/if}
                            </p>
                        </div>
                    </div>
                </div>
                <div class="col-lg-6 col-sm-12">
                    <div class="card">
                        <div class="ribbon ribbon-top bg-yellow">
                            <i class="ti ti-bell-ringing icon"></i>
                        </div>
                        <div class="card-body">
                            <h3 class="card-title">The latest announcement 
                            {if $ann !== null}
                            <span class="card-subtitle">{$ann->date}</span>
                            {/if}
                            </h3>
                            <p class="text-muted">
                            {if $ann !== null}
                                {$ann->content}
                            {else}
                                No announcement
                            {/if}
                            </p>
                        </div>
                    </div>
                </div>
                {if $config['enable_checkin'] == true}
                    <div class="col-lg-6 col-sm-12">
                        <div class="card">
                            <div class="card-stamp">
                                <div class="card-stamp-icon bg-green">
                                    <i class="ti ti-check"></i>
                                </div>
                            </div>
                            <div class="card-body">
                                <h3 class="card-title">Daily check</h3>
                                <p class="text-muted">
                                    Sign in to get
                                    {if $config['checkinMin'] !== $config['checkinMax']}
                                        &nbsp;<code>{$config['checkinMin']} MB</code> to <code>{$config['checkinMax']} MB</code>
                                        Within the scope of the flow,
                                    {else}
                                        <code>{$config['checkinMin']} MB</code>
                                    {/if}
                                </p>
                                <p class="text-muted">
                                    The last check-in time:<code>{$user->lastCheckInTime()}</code>
                                </p>
                            </div>
                            <div class="card-footer">
                                <div class="d-flex">
                                    {if !$user->isAbleToCheckin()}
                                    <button id="check-in" class="btn btn-primary ms-auto" disabled>Already signed in</button>
                                    {else}
                                    {if $config['enable_checkin_captcha'] === true && $config['captcha_provider'] === 'turnstile'}
                                    <div class="cf-turnstile" data-sitekey="{$captcha['turnstile_sitekey']}" data-theme="light"></div>
                                    {/if}
                                    {if $config['enable_checkin_captcha'] === true && $config['captcha_provider'] === 'geetest'}
                                    <div id="geetest"></div>
                                    {/if} 
                                    <button id="check-in" class="btn btn-primary ms-auto">Sign in</button>
                                    {/if}
                                </div>
                            </div>
                        </div>
                    </div>
                {/if}
                
            </div>
        </div>
    </div>

    <script>
        var clipboard = new ClipboardJS('.copy');
        clipboard.on('success', function(e) {
            $('#success-message').text('Has been copied to the clipboard');
            $('#success-dialog').modal('show');
        });

        $("#check-in").click(function() {
            $.ajax({
                type: "POST",
                url: "/user/checkin",
                dataType: "json",              
                data: {
                    {if $config['enable_checkin_captcha'] === true && $config['captcha_provider'] === 'turnstile'}
                    turnstile: turnstile.getResponse(),
                    {/if}
                    {if $config['enable_checkin_captcha'] === true && $config['captcha_provider'] === 'geetest'}
                    geetest: geetest_result,
                    {/if}
                },
                success: function(data) {
                    if (data.ret == 1) {
                        $('#success-message').text(data.msg);
                        $('#success-dialog').modal('show');
                    } else {
                        $('#fail-message').text(data.msg);
                        $('#fail-dialog').modal('show');
                    }
                }
            })
        });
    </script>

    {if $config['enable_checkin_captcha'] === true && $config['captcha_provider'] === 'turnstile'}
    <script src="https://challenges.cloudflare.com/turnstile/v0/api.js?compat=recaptcha" async defer></script>
    {/if}
    {if $config['enable_checkin_captcha'] === true && $config['captcha_provider'] === 'geetest'}
    <script src="http://static.geetest.com/v4/gt4.js"></script>
    <script>
        var geetest_result = '';
        initGeetest4({
            captchaId: '{$captcha['geetest_id']}',
            product: 'float',
            language: "zho",
            riskType:'slide'
        }, function (geetest) {
            geetest.appendTo("#geetest");
            geetest.onSuccess(function() {
                geetest_result = geetest.getValidate();
            });
        });
    </script>
    {/if}
{include file='user/tabler_footer.tpl'}

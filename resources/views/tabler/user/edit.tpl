{include file='user/tabler_header.tpl'}

<div class="page-wrapper">
    <div class="container-xl">
        <div class="page-header d-print-none text-white">
            <div class="row align-items-center">
                <div class="col">
                    <h2 class="page-title">
                        <span class="home-title">Data modification</span>
                    </h2>
                    <div class="page-pretitle my-3">
                        <span class="home-subtitle">Modify part of account information</span>
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
                        <ul class="nav nav-tabs nav-fill" data-bs-toggle="tabs" role="tablist">
                            <li class="nav-item" role="presentation">
                                <a href="#personal_information" class="nav-link active" data-bs-toggle="tab"
                                    aria-selected="true" role="tab">
                                    <i class="ti ti-chart-candle icon"></i>&nbsp;
                                    data
                                </a>
                            </li>
                            <li class="nav-item" role="presentation">
                                <a href="#login_security" class="nav-link" data-bs-toggle="tab" aria-selected="true"
                                    role="tab">
                                    <i class="ti ti-shield-lock icon"></i>&nbsp;
                                    The login
                                </a>
                            </li>
                            <li class="nav-item" role="presentation">
                                <a href="#use_safety" class="nav-link" data-bs-toggle="tab" aria-selected="false"
                                    tabindex="-1" role="tab">
                                    <i class="ti ti-brand-telegram icon"></i>&nbsp;
                                    use
                                </a>
                            </li>
                            <li class="nav-item" role="presentation">
                                <a href="#other_settings" class="nav-link" data-bs-toggle="tab" aria-selected="false"
                                    tabindex="-1" role="tab">
                                    <i class="ti ti-settings icon"></i>&nbsp;
                                    other
                                </a>
                            </li>
                        </ul>
                        <div class="card-body">
                            <div class="tab-content">
                                <div class="tab-pane active show" id="personal_information" role="tabpanel">
                                    <div class="row row-cards">
                                        <div class="col-sm-12 col-md-6">
                                            <div class="card">
                                                <div class="card-body">
                                                    <h3 class="card-title">The login email</h3>
                                                    <p>Current email:<code>{$user->email}</code></p>
                                                    <div class="mb-3">
                                                        <input id="new-email" type="email" class="form-control"
                                                            placeholder="The new email" {if $config['enable_change_email'] == false}disabled=""{/if}>
                                                    </div>
                                                    {if $config['enable_email_verify'] == true && $config['enable_change_email'] == true}
                                                    <div class="mb-3">
                                                        <input id="email-code" type="text" class="form-control"
                                                            placeholder="Verification code">
                                                    </div>
                                                    {/if}
                                                </div>
                                                <div class="card-footer">
                                                    <div class="d-flex">
                                                        {if $config['enable_email_verify'] == true && $config['enable_change_email'] == true}
                                                        <a id="email-verify" class="btn btn-link">Get verification code</a>
                                                        <button id="modify-email"
                                                            class="btn btn-primary ms-auto">Modify the</button>
                                                        {elseif $config['enable_change_email'] == true}
                                                        <button id="modify-email"
                                                            class="btn btn-primary ms-auto">Modify the</button>
                                                        {else}
                                                        <button id="modify-email" class="btn btn-primary ms-auto"
                                                            disabled>Not allowed to change</button>
                                                        {/if}
                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                        <div class="col-sm-12 col-md-6">
                                            <div class="card">
                                                <div class="card-body">
                                                    <h3 class="card-title">contact</h3>
                                                    <div class="mb-3">
                                                        <select id="imtype" class="form-select">
                                                            <option value="1" {if $user->im_type == '1'}selected{/if}>
                                                                WeChat</option>
                                                            <option value="2" {if $user->im_type == '2'}selected{/if}>
                                                                QQ</option>
                                                            <option value="3" {if $user->im_type == '3'}selected{/if}>
                                                                Facebook</option>
                                                            <option value="4" {if $user->im_type == '4'}selected{/if}>
                                                                Telegram</option>
                                                            <option value="5" {if $user->im_type == '5'}selected{/if}>
                                                                Discord</option>
                                                        </select>
                                                    </div>
                                                    <div class="mb-3">
                                                        <input id="imvalue" type="text" class="form-control" 
                                                            {if $user->im_type == '4'} disabled="" {/if}
                                                            value="{$user->im_value}" placeholder="Social account">
                                                    </div>
                                                </div>
                                                <div class="card-footer">
                                                    <div class="d-flex">
                                                        <a id="modify-im" class="btn btn-primary ms-auto">Modify the</a>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                        <div class="col-sm-12 col-md-6">
                                            <div class="card">
                                                <div class="card-body">
                                                    <h3 class="card-title">The user name</h3>
                                                    <p>The current user name:<code>{$user->user_name}</code></p>
                                                    <div class="mb-3">
                                                        <input id="new-nickname" type="text" class="form-control"
                                                        placeholder="A new user name" autocomplete="off">
                                                    </div>
                                                </div>
                                                <div class="card-footer">
                                                    <div class="d-flex">
                                                        <a id="modify-username" class="btn btn-primary ms-auto">Modify the</a>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                        {if $config['enable_telegram'] == true}
                                        <div class="col-sm-12 col-md-6">
                                            {if $user->telegram_id != 0}
                                            <div class="card">
                                                <div class="card-body">
                                                    <h3 class="card-title">unbundling Telegram</h3>
                                                    <p>The binding of Telegram Account:
                                                        {if $user->im_value === "User name is not set"}
                                                        <code>{$user->telegram_id}</code>
                                                        {else}
                                                        <a href="https://t.me/{$user->im_value}">@{$user->im_value}</a>
                                                        {/if}
                                                    </p>
                                                </div>
                                                <div class="card-footer">
                                                    <div class="d-flex">
                                                        <a href="/user/telegram_reset"
                                                            class="btn btn-red ms-auto">unbundling</a>
                                                    </div>
                                                </div>
                                            </div>
                                            {else}
                                            <div class="card">
                                                <div class="card-body">
                                                    <h3 class="card-title">The binding Telegram</h3>
                                                    <div class="row">
                                                        <div class="col-6 col-sm-2 col-md-2 col-xl mb-3">
                                                            Mobile tablet computer has been installed Telegram clickable
                                                        </div>
                                                        <div class="col-6 col-sm-2 col-md-2 col-sm mb-3">
                                                            <a href="https://t.me/{$telegram_bot}?start={$bind_token}"
                                                                class="btn btn-primary w-100">
                                                                A key bindings
                                                            </a>
                                                        </div>
                                                    </div>
                                                    <div class="row">
                                                        <div class="col-6 col-sm-2 col-md-2 col-xl mb-3">
                                                            To the robot <a
                                                                href="https://t.me/{$telegram_bot}">@{$telegram_bot}</a>
                                                            Send verification code binding
                                                        </div>
                                                        <div class="col-6 col-sm-2 col-md-2 col-sm mb-3">
                                                            <button data-clipboard-text="{$bind_token}"
                                                                class="copy btn btn-primary w-100">
                                                                Copy the verification code
                                                            </button>
                                                        </div>
                                                    </div>
                                                </div>
                                            </div>
                                            {/if}
                                        </div>
                                        {/if}
                                    </div>
                                </div>
                                <div class="tab-pane" id="login_security" role="tabpanel">
                                    <div class="row row-cards">
                                        <div class="col-sm-12 col-md-6">
                                            <div class="card">
                                                <div class="card-body">
                                                    <h3 class="card-title">Two step certification</h3>
                                                    <div class="col-md-12">
                                                        <div class="col-sm-6 col-md-6">
                                                            <p>
                                                                <i class="ti ti-brand-apple"></i>
                                                                <a target="view_window"
                                                                    href="https://apps.apple.com/us/app/google-authenticator/id388497605">Apple's client
                                                                </a>
                                                                &nbsp;&nbsp;&nbsp;
                                                                <i class="ti ti-brand-android"></i>
                                                                <a target="view_window"
                                                                    href="https://play.google.com/store/apps/details?id=com.google.android.apps.authenticator2&hl=zh&gl=US">The android client
                                                                </a>
                                                            </p>
                                                        </div>
                                                    </div>
                                                    <div class="row">
                                                        <div class="col-md-3">
                                                            <p id="qrcode"></p>
                                                        </div>
                                                        <div class="col-md-9">
                                                            <div class="mb-3">
                                                                <select id="ga-enable" class="form-select">
                                                                    <option value="0">Do not use</option>
                                                                    <option value="1"
                                                                        {if $user->ga_enable == '1'}selected{/if}>
                                                                        Using two-step authentication to log in
                                                                    </option>
                                                                </select>
                                                            </div>
                                                            <div class="mb-3">
                                                                <input id="2fa-test-code" type="text"
                                                                    class="form-control" placeholder="Testing two steps certification authentication code">
                                                            </div>
                                                            <div class="col-md-12">
                                                                <p>Keys:<code>{$user->ga_token}</code></p>
                                                            </div>
                                                        </div>
                                                    </div>
                                                </div>
                                                <div class="card-footer">
                                                    <div class="d-flex">
                                                        <a id="reset-2fa" class="btn btn-link">reset</a>
                                                        <a id="test-2fa" class="btn btn-link">test</a>
                                                        <a id="save-2fa" class="btn btn-primary ms-auto">Set up the</a>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                        <div class="col-sm-12 col-md-6">
                                            <div class="card">
                                                <div class="card-body">
                                                    <h3 class="card-title">Modify the login password</h3>
                                                    <div class="mb-3">
                                                        <form>
                                                            <input id="password" type="password" class="form-control"
                                                                placeholder="The current password" autocomplete="off">
                                                        </form>
                                                    </div>
                                                    <div class="mb-3">
                                                        <form>
                                                            <input id="new-password" type="password"
                                                                class="form-control" placeholder="Enter a new password"
                                                                autocomplete="off">
                                                        </form>
                                                    </div>
                                                    <div class="mb-3">
                                                        <form>
                                                            <input id="again-new-password" type="password"
                                                                class="form-control" placeholder="To enter a new password again"
                                                                autocomplete="off">
                                                        </form>
                                                    </div>
                                                </div>
                                                <div class="card-footer">
                                                    <div class="d-flex">
                                                        <a id="modify-login-passwd"
                                                            class="btn btn-primary ms-auto">Modify the</a>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                                <div class="tab-pane" id="use_safety" role="tabpanel">
                                    <div class="row row-cards">
                                        <div class="col-sm-12 col-md-6">
                                            <div class="card">
                                                <div class="card-body">
                                                    <h3 class="card-title">Change the encryption</h3>
                                                    <p>Different client support encryption methods may be different, please refer to the client support list Settings</p>
                                                    <div class="mb-3">
                                                        <select id="user-method" class="form-select">
                                                            {foreach $methods as $method}
                                                            <option value="{$method}"
                                                                {if $user->method == $method}selected{/if}
                                                            >{$method}
                                                            </option>
                                                            {/foreach}
                                                        </select>
                                                    </div>
                                                </div>
                                                <div class="card-footer">
                                                    <div class="d-flex">
                                                        <a id="modify-user-method" class="btn btn-primary ms-auto">Modify the</a>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                        <div class="col-sm-12 col-md-6">
                                            <div class="card">
                                                <div class="card-body">
                                                    <h3 class="card-title">Replace the subscription address</h3>
                                                    <p>After replace the subscription address, the old subscription address will not be able to access the configuration, but you still can use your node configuration.If you want the old node configuration can't use, please modify the connection password operation</p>
                                                </div>
                                                <div class="card-footer">
                                                    <div class="d-flex">
                                                        <a id="reset-sub-url"
                                                            class="btn btn-primary ms-auto bg-red">replace</a>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                        <div class="col-sm-12 col-md-6">
                                            <div class="card">
                                                <div class="card-body">
                                                    <h3 class="card-title">Change the connection</h3>
                                                    <p>Randomly assigned to a connection port, this will be used Shadowsocks The client</p>
                                                    <p>The current port is：<code>{$user->port}</code></p>
                                                </div>
                                                <div class="card-footer">
                                                    <div class="d-flex">
                                                        <a id="reset-client-port" class="btn btn-red ms-auto">replace</a>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                        <div class="col-sm-12 col-md-6">
                                            <div class="card">
                                                <div class="card-body">
                                                    <h3 class="card-title">Password reset link</h3>
                                                    <p>Reset the pa, need to update subscription after a reset, can continue to usectionUUID , need to update subscription after a reset, can continue to use</p>
                                                    <p>The current connection password:<code>{$user->passwd}</code></p>
                                                    <p>The currentUUID:<code>{$user->uuid}</code></p>
                                                </div>
                                                <div class="card-footer">
                                                    <div class="d-flex">
                                                        <a id="reset-passwd"
                                                            class="btn btn-primary ms-auto bg-red">reset</a>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                                <div class="tab-pane" id="other_settings" role="tabpanel">
                                    <div class="row row-cards">
                                        <div class="col-sm-12 col-md-6">
                                            <div class="card">
                                                <div class="card-body">
                                                    <h3 class="card-title">Daily dosage of push</h3>
                                                    <div class="mb-3">
                                                        <select id="daily-report" class="form-select">
                                                            <option value="0"
                                                                {if $user->sendDailyMail == '0'}selected{/if}>Don't send
                                                            </option>
                                                            <option value="1"
                                                                {if $user->sendDailyMail == '1'}selected{/if}>Receive emails
                                                            </option>
                                                            <option value="2"
                                                                {if $user->sendDailyMail == '2'}selected{/if}>Telegram
                                                                Bot receive
                                                            </option>
                                                        </select>
                                                    </div>
                                                </div>
                                                <div class="card-footer">
                                                    <div class="d-flex">
                                                        <a id="modify-daily-report"
                                                            class="btn btn-primary ms-auto">Modify the</a>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                        <div class="col-sm-12 col-md-6">
                                            <div class="card">
                                                <div class="card-body">
                                                    <h3 class="card-title">Modify the theme</h3>
                                                    <div class="mb-3">
                                                        <select id="user-theme" class="form-select">
                                                            {foreach $themes as $theme}
                                                                <option value="{$theme}"
                                                                    {if $user->theme == $theme}selected{/if}>{$theme}
                                                                </option>
                                                            {/foreach}
                                                        </select>
                                                    </div>
                                                </div>
                                                <div class="card-footer">
                                                    <div class="d-flex">
                                                        <a id="modify-user-theme" class="btn btn-primary ms-auto">Modify the</a>
                                                    </div>
                                                </div>
                                            </div>   
                                        </div>
                                        {if $config['enable_kill'] == true}
                                        <div class="col-sm-12 col-md-6">
                                            <div class="card">
                                                <div class="card-stamp">
                                                    <div class="card-stamp-icon bg-red">
                                                        <i class="ti ti-circle-x"></i>
                                                    </div>
                                                </div>
                                                <div class="card-body">
                                                    <h3 class="card-title">Delete the account data</h3>
                                                </div>    
                                                <div class="card-footer">
                                                    <a href="#" class="btn btn-red d-none d-sm-inline-block" data-bs-toggle="modal"
                                                        data-bs-target="#destroy-account">
                                                        <i class="ti ti-trash icon"></i>
                                                        Confirm the deletion
                                                    </a>
                                                </div>
                                            </div>  
                                        </div>
                                        {/if}
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    {if $config['enable_kill'] == true}
    <div class="modal modal-blur fade" id="destroy-account" tabindex="-1" role="dialog" aria-hidden="true">
        <div class="modal-dialog modal-sm modal-dialog-centered" role="document">
            <div class="modal-content">
                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                <div class="modal-status bg-danger"></div>
                <div class="modal-body text-center py-4">
                    <i class="ti ti-alert-circle icon mb-2 text-danger icon-lg" style="font-size:3.5rem;"></i>
                    <h3>Delete confirmation</h3>
                    <div class="text-muted">Please confirm whether really want to delete your account, this operation cannot be withdrawn, all of your account data will be completely deleted from the server</div>
                    <div class="py-3">
                        <form>
                            <input id="confirm-passwd" type="password" class="form-control" placeholder="Enter login password"
                                autocomplete="off">
                        </form>
                    </div>
                </div>
                <div class="modal-footer">
                    <div class="w-100">
                        <div class="row">
                            <div class="col">
                                <a href="#" class="btn w-100" data-bs-dismiss="modal">
                                    cancel
                                </a>
                            </div>
                            <div class="col">
                                <a href="#" id="confirm-destroy" class="btn btn-danger w-100" data-bs-dismiss="modal">
                                    confirm
                                </a>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <div class="modal modal-blur fade" id="destroy-account-success" tabindex="-1" role="dialog" aria-hidden="true">
        <div class="modal-dialog modal-sm modal-dialog-centered" role="document">
            <div class="modal-content">
                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                <div class="modal-status bg-success"></div>
                <div class="modal-body text-center py-4">
                    <i class="ti ti-circle-check icon mb-2 text-green icon-lg" style="font-size:3.5rem;"></i>
                    <h3>Delete the success</h3>
                    <p id="success-message" class="text-muted">Delete the success</p>
                </div>
                <div class="modal-footer">
                    <div class="w-100">
                        <div class="row">
                            <div class="col">
                                <a href="#" class="btn w-100" data-bs-dismiss="modal">
                                    good
                                </a>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <div class="modal modal-blur fade" id="destroy-account-fail" tabindex="-1" role="dialog" aria-hidden="true">
        <div class="modal-dialog modal-sm modal-dialog-centered" role="document">
            <div class="modal-content">
                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                <div class="modal-status bg-danger"></div>
                <div class="modal-body text-center py-4">
                    <i class="ti ti-circle-x icon mb-2 text-danger icon-lg" style="font-size:3.5rem;"></i>
                    <h3>Delete failed</h3>
                    <p id="error-message" class="text-muted">Delete failed</p>
                </div>
                <div class="modal-footer">
                    <div class="w-100">
                        <div class="row">
                            <div class="col">
                                <a href="#" class="btn btn-danger w-100" data-bs-dismiss="modal">
                                    confirm
                                </a>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
    {/if}

    <script>
        var qrcode = new QRCode('qrcode', {
            text: "{$user->getGAurl()}",
            width: 128,
            height: 128,
            colorDark: '#000000',
            colorLight: '#ffffff',
            correctLevel: QRCode.CorrectLevel.H
        });

        var clipboard = new ClipboardJS('.copy');
        clipboard.on('success', function(e) {
            $('#success-message').text('Has been copied to the clipboard');
            $('#success-dialog').modal('show');
        });

        $("#modify-email").click(function() {
            $.ajax({
                type: "POST",
                url: "/user/email",
                dataType: "json",
                data: {
                    {if $config['enable_email_verify'] == true}
                        emailcode: $('#email-code').val(),
                    {/if}
                    newemail: $('#new-email').val()
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

        $("#email-verify").click(function() {
            $.ajax({
                type: "POST",
                url: "/user/send",
                dataType: "json",
                data: {
                    email: $('#new-email').val()
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

        $("#modify-username").click(function() {
            $.ajax({
                type: "POST",
                url: "/user/username",
                dataType: "json",
                data: {
                    newusername: $('#new-nickname').val()
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

        $("#modify-user-method").click(function() {
            $.ajax({
                type: "POST",
                url: "/user/method",
                dataType: "json",
                data: {
                    method: $('#user-method').val()
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

        $("#reset-sub-url").click(function() {
            $.ajax({
                type: "POST",
                url: "/user/url_reset",
                dataType: "json",
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

        $("#modify-user-theme").click(function() {
            $.ajax({
                type: "POST",
                url: "/user/theme",
                dataType: "json",
                data: {
                    theme: $('#user-theme').val()
                },
                success: function(data) {
                    if (data.ret == 1) {
                        $('#success-message').text(data.msg);
                        $('#success-dialog').modal('show');
                        window.setTimeout("location.reload()", {$config['jump_delay']});
                    } else {
                        $('#fail-message').text(data.msg);
                        $('#fail-dialog').modal('show');
                    }
                }
            })
        });

        $("#modify-daily-report").click(function() {
            $.ajax({
                type: "POST",
                url: "/user/mail",
                dataType: "json",
                data: {
                    mail: $('#daily-report').val()
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

        $("#reset-client-port").click(function() {
            $.ajax({
                type: "POST",
                url: "/user/port",
                dataType: "json",
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

        $("#reset-passwd").click(function() {
            $.ajax({
                type: "POST",
                url: "/user/sspwd",
                dataType: "json",
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

        $("#modify-login-passwd").click(function() {
            $.ajax({
                type: "POST",
                url: "/user/password",
                dataType: "json",
                data: {
                    pwd: $('#new-password').val(),
                    repwd: $('#again-new-password').val(),
                    oldpwd: $('#password').val()
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

        $("#modify-im").click(function() {
            $.ajax({
                type: "POST",
                url: "/user/contact_update",
                dataType: "json",
                data: {
                    imtype: $('#imtype').val(),
                    imvalue: $('#imvalue').val()
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

        $("#reset-2fa").click(function() {
            $.ajax({
                type: "POST",
                url: "/user/gareset",
                dataType: "json",
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

        $("#test-2fa").click(function() {
            $.ajax({
                type: "POST",
                url: "/user/gacheck",
                dataType: "json",
                data: {
                    code: $('#2fa-test-code').val()
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

        $("#save-2fa").click(function() {
            $.ajax({
                type: "POST",
                url: "/user/gaset",
                dataType: "json",
                data: {
                    enable: $('#ga-enable').val()
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
        
        {if $config['enable_kill'] == true}
        $("#confirm-destroy").click(function() {
            $.ajax({
                type: "POST",
                url: "/user/kill",
                dataType: "json",
                data: {
                    passwd: $('#confirm-passwd').val(),
                },
                success: function(data) {
                    if (data.ret == 1) {
                        $('#success-message').text(data.msg);
                        $('#destroy-account-success').modal('show');
                    } else {
                        $('#error-message').text(data.msg);
                        $('#destroy-account-fail').modal('show');
                    }
                }
            })
        });
        {/if}
    </script>
    
{include file='user/tabler_footer.tpl'}
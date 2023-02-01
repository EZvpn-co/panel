{include file='tabler_header.tpl'}

<body class="border-top-wide border-primary d-flex flex-column">
    <div class="page page-center">
        <div class="container-tight py-4">
            <div class="text-center mb-4">
                <a href="#" class="navbar-brand navbar-brand-autodark">
                    <img src="/images/ez-logo-round_96x96.png" height="64" alt="">
                </a>
            </div>
            <div class="card card-md">
                {if $config['register_mode'] != 'close'}
                    <div class="card-body">
                        <h2 class="card-title text-center mb-4">Register</h2>
                        <div class="mb-3">
                            <input id="name" type="text" class="form-control" placeholder="Fullname">
                        </div>
                        <div class="mb-3">
                            <input id="email" type="email" class="form-control" placeholder="Email">
                        </div>
                        <div class="mb-3">
                            <div class="input-group input-group-flat">
                                <input id="passwd" type="password" class="form-control" placeholder="Password">
                            </div>
                        </div>
                        <div class="mb-3">
                            <div class="input-group input-group-flat">
                                <input id="repasswd" type="password" class="form-control" placeholder="Repeat password">
                            </div>
                        </div>
                        {if $config['enable_reg_im'] == true}
                            <div class="mb-3">
                                <select id="im_type" class="col form-select">
                                    <option value="0">Please select a social media</option>
                                    <option value="1">WeChat</option>
                                    <option value="2">QQ</option>
                                    <option value="4">Telegram</option>
                                    <option value="5">Discord</option>
                                </select>
                            </div>
                            <div class="mb-3">
                                <div class="input-group input-group-flat">
                                    <input id="im_value" type="text" class="form-control" placeholder="Social account">
                                </div>
                            </div>
                        {/if}
                        {if $config['register_mode'] != 'close' }
                            <div class="mb-3">
                                <div class="input-group input-group-flat">
                                    <input id="code" type="text" class="form-control" placeholder="Invitation code{if $config['register_mode'] == 'open'}(optional){else}(required){/if}" value="{$code}">
                                </div>
                            </div>
                        {/if}
                        {if $config['enable_email_verify'] == true}
                            <div class="mb-3">
                                <div class="input-group mb-2">
                                    <input id="emailcode" type="text" class="form-control" placeholder="Email verification code">
                                    <button id="email-verify" class="btn text-blue" type="button">To obtain</button>
                                </div>
                            </div>
                        {/if}
                        <div class="mb-3">
                            <label class="form-check">
                                <input id="tos" type="checkbox" class="form-check-input" />
                                <span class="form-check-label">
                                    I agree with <a href="/tos" tabindex="-1" target="_blank> The terms of service and privacy policy </a>
                                </span>
                            </label>
                        </div>
                        {if $config['enable_reg_captcha'] === true && $config['captcha_provider'] === 'turnstile'}
                        <div class="mb-3">
                            <div class="input-group mb-2">
                                <div class="cf-turnstile" data-sitekey="{$captcha['turnstile_sitekey']}" data-theme="light"></div>
                            </div>
                        </div>
                        {/if}
                        {if $config['enable_reg_captcha'] === true && $config['captcha_provider'] === 'geetest'}
                        <div class="mb-2">
                            <div class="input-group mb-2">
                                <div id="geetest"></div>
                            </div>
                        </div>
                        {/if}
                        <div class="form-footer">
                            <button id="confirm-register" type="submit" class="btn btn-primary w-100">Create account</button>
                        </div>
                    </div>
                {else}
                    <div class="card-body">
                        <p>Registration is closed, back later</p>
                    </div>
                {/if}
            </div>
            <div class="text-center text-muted mt-3">
                Have an account? <a href="/auth/login" tabindex="-1">Login</a>
            </div>
        </div>
    </div>

    <script>
        {if $config['enable_email_verify'] == true}
            $("#email-verify").click(function() {
                $.ajax({
                    type: 'POST',
                    url: '/auth/send',
                    dataType: "json",
                    data: {
                        email: $('#email').val(),
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
        {/if}

        $("#confirm-register").click(function() {
            $.ajax({
                type: 'POST',
                url: '/auth/register',
                dataType: "json",
                data: {
                    {if $config['enable_reg_im'] == true}
                        im_value: $('#im_value').val(),
                        im_type: $('#im_type').val(),
                    {/if}
                    {if $config['enable_email_verify'] == true}
                        emailcode: $('#emailcode').val(),
                    {/if}
                    tos: $('#tos').prop('checked'), // true / false (string)
                    code: $('#code').val(),
                    name: $('#name').val(),
                    email: $('#email').val(),
                    passwd: $('#passwd').val(),
                    repasswd: $('#repasswd').val(),
                    {if $config['enable_reg_captcha'] === true && $config['captcha_provider'] === 'turnstile'}
                    turnstile: turnstile.getResponse(),
                    {/if}
                    {if $config['enable_reg_captcha'] === true && $config['captcha_provider'] === 'geetest'}
                    geetest: geetest_result,
                    {/if}
                },
                success: function(data) {
                    if (data.ret == 1) {
                        $('#success-message').text(data.msg);
                        $('#success-dialog').modal('show');
                        window.setTimeout("location.href='/user'", {$config['jump_delay']});
                    } else {
                        $('#fail-message').text(data.msg);
                        $('#fail-dialog').modal('show');
                    }
                }
            })
        });
    </script>

    {if $config['enable_reg_captcha'] === true && $config['captcha_provider'] === 'turnstile'}
    <script src="https://challenges.cloudflare.com/turnstile/v0/api.js?compat=recaptcha" async defer></script>
    {/if}
    {if $config['enable_reg_captcha'] === true && $config['captcha_provider'] === 'geetest'}
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
{include file='tabler_footer.tpl'}

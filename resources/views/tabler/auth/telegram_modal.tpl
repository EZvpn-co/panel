<div class="card auth-tg cust-model">
    <div class="card-main">
        <nav class="tab-nav margin-top-no margin-bottom-no">
            <ul class="nav nav-justified">
                <li class="active">
                    <a class="waves-attach" data-toggle="tab" href="#number_login">A key/Verification code to log in</a>
                </li>
                <li>
                    <a class="waves-attach" data-toggle="tab" href="#qrcode_login">Qr code to log in</a>
                </li>
            </ul>
        </nav>
        <div class="tab-pane fade active in" id="number_login">
            <div class="card-header">
                <div class="card-inner">
                    <h1 class="card-heading" style=" text-align:center;font-weight:bold;">Telegram The login</h1>
                </div>
            </div>
            <div class="card-inner">
                <div class="text-center">
                    <p>A key to land</p>
                </div>
                <p id="telegram-alert">loading Telegram, if long time not shown please refresh the page or check the agent</p>
                <div class="text-center" id="telegram-login-box"></div>
                <p>Or add bots <a href="https://t.me/{$telegram_bot}">@{$telegram_bot}</a>And send the Numbers below to it.
                </p>
                <div class="text-center">
                    <h2><code id="code_number">{$login_number}</code></h2>
                </div>
            </div>
        </div>
        <div class="tab-pane fade" id="qrcode_login">
            <div class="card-header">
                <div class="card-inner">
                    <h1 class="card-heading" style=" text-align:center;font-weight:bold;">TelegramSweep the login code</h1>
                </div>
            </div>
            <div class="card-inner">
                <p>Add bots <a href="https://t.me/{$telegram_bot}">@{$telegram_bot}</a>Send it, take a picture of this qr code below.
                </p>
                <div class="form-group form-group-label">
                    <div class="text-center qr-center">
                        <div id="telegram-qr"></div>
                    </div>
                </div>

            </div>
        </div>
    </div>
</div>
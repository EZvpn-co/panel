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
                <div class="card-body">
                    <h2 class="card-title text-center mb-4">Set new password</h2>
                    <p class="text-muted mb-4">
                        Set up new password below
                    </p>
                    <div class="mb-3">
                        <label class="form-label">New password</label>
                        <input id="password" type="password" class="form-control" placeholder="New password">
                    </div>
                    <div class="mb-3">
                        <label class="form-label">Repeat new password</label>
                        <input id="repasswd" type="password" class="form-control" placeholder="Repeat new password">
                    </div>
                    <div class="form-footer">
                        <button id="reset" class="btn btn-primary w-100">
                        <i class="ti ti-key icon"></i>
                            Reset
                        </button>
                    </div>
                </div>
            </div>
        </div>
        <div class="text-center text-muted mt-3">
            Have an account? <a href="/auth/login" tabindex="-1">Login</a>
        </div>
    </div>

    <script>
        $("#reset").click(function() {
            $.ajax({
                type: 'POST',
                url: location.pathname,
                dataType: "json",
                data: {
                    password: $('#password').val(),
                    repasswd: $('#repasswd').val(),
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

        $("#success-confirm").click(function() {
            window.location.href = '/auth/login';
        });
    </script>

{include file='tabler_footer.tpl'}

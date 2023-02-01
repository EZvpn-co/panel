{include file='user/tabler_header.tpl'}

<div class="page-wrapper">
    <div class="container-xl">       
        <div class="page-header d-print-none text-white">
            <div class="row align-items-center">
                <div class="col">
                    <h2 class="page-title">
                        <span class="home-title">Invitation to register</span>
                    </h2>
                    <div class="page-pretitle my-3">
                        <span class="home-subtitle">Check the invitation registration link and invite rebate record</span>
                    </div>
                </div>
            </div>
        </div>
    </div>
    <div class="page-body">
        <div class="container-xl">
            <div class="row row-deck">
                <div class="col-lg-6">
                    <div class="card">
                        <div class="card-body">
                            <h3 class="card-title">Invite rules</h3>
                            <ul>
                                <li>Invite registered user confirmed to the bill, you can get the bill amount <code>{$config['code_payback'] * 100} %</code>
                                    As a rebate</li>
                                <li>Specific please see the announcement invited rebate rules, or ask the administrator by work order system</li>
                                <li>Part of the goods of the rebate rate may not follow the above</li>
                            </ul>
                            <p>Your current total rebate by inviting friends <code>{$paybacks_sum}</code> $</p>
                        </div>
                    </div>
                </div>
                <div class="col-lg-6">
                    <div class="card">
                        <div class="card-body">
                            <h3 class="card-title">Invite link</h3>
                            {if $user->invite_num >= 0}
                                <p>Invite link number available:<code>{$user->invite_num}</code></p>
                            {/if}
                            <input class="form-control" value="{$invite_url}" disabled />
                        </div>
                        <div class="card-footer">
                            <div class="d-flex">
                                <a id="reset-url" class="btn text-red btn-link">reset</a>
                                <a data-clipboard-text="{$invite_url}" class="copy btn btn-primary ms-auto">copy</a>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="col-12">
                    <div class="card">
                        <div class="card-header">
                            <h3 class="card-title">Rebate record</h3>
                        </div>
                        {if $paybacks->count() != '0'}
                            <div class="table-responsive">
                                <table class="table card-table table-vcenter text-nowrap datatable">
                                    <thead>
                                        <tr>
                                            <th>#</th>
                                            <th>Invite the user nickname</th>
                                            <th>The rebate amount</th>
                                            <th>Settlement audit</th>
                                            <th>Rebate time</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        {foreach $paybacks as $payback}
                                            <tr>
                                                <td>{$payback->id}</td>
                                                {if $payback->user()!=null}
                                                    <td>{$payback->user()->user_name}</td>
                                                {else}
                                                    <td>Has been cancelled</td>
                                                {/if}
                                                <td>{$payback->ref_get}$</td>
                                                <td>{$payback->fraud_detect}</td>
                                                <td>{$payback->datetime}</td>
                                            </tr>
                                        {/foreach}
                                    </tbody>
                                </table>
                            </div>
                        {else}
                            <div class="card-body">
                                <p>Found no record</p>
                            </div>
                        {/if}
                    </div>
                </div>
            </div>
        </div>
    </div>

    <script>
        $("td:contains('through')").css("color", "green");
        $("td:contains('fraud')").css("color", "red");

        var clipboard = new ClipboardJS('.copy');
        clipboard.on('success', function(e) {
            $('#success-message').text('Has been copied to the clipboard');
            $('#success-dialog').modal('show');
        });

        $("#reset-url").click(function() {
            $.ajax({
                type: "PUT",
                url: "/user/invite",
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
    </script>

{include file='user/tabler_footer.tpl'}
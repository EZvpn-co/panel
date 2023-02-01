{include file='user/main.tpl'}

<main class="content">
    <div class="content-header ui-content-header">
        <div class="container">
            <h1 class="content-heading">top-up</h1>
        </div>
    </div>
    <div class="container">
        <section class="content-inner margin-top-no">
            <div class="row">
                <div class="col-lg-12 col-md-12">
                    <div class="card margin-bottom-no">
                        <div class="card-main">
                            <div class="card-inner">
                                <div class="card-inner">
                                    <p class="card-heading">Matters needing attention</p>
                                    <p>Prepaid phone after the completion of the need to refresh the page to view the balance, usually arrive within one minute.Was not completed due to insufficient automatic renewal, in enough balance automatically draw a renewal.</p>
                                    {if $config['enable_admin_contact'] == true}
                                        <p class="card-heading">If prepaid phone did not arrive, please contact:</p>
                                        {if $config['admin_contact1'] != ''}
                                            <li>{$config['admin_contact1']}</li>
                                        {/if}
                                        {if $config['admin_contact2'] != ''}
                                            <li>{$config['admin_contact2']}</li>
                                        {/if}
                                        {if $config['admin_contact3'] != ''}
                                            <li>{$config['admin_contact3']}</li>
                                        {/if}
                                    {/if}
                                    <br/>
                                    <p><i class="mdi mdi-currency-usd icon-lg"></i>Current balance:<font color="#399AF2" size="5">{$user->money}</font> $</p>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
                {if count($payments) > 0}
                    {foreach from=$payments item=payment}
                        <div class="col-lg-12 col-md-12">
                            <div class="card margin-bottom-no">
                                <div class="card-main" id="card-{$payment::_name()}">
                                    <div class="card-inner">
                                        {$payment::getPurchaseHTML()}
                                    </div>
                                </div>
                            </div>
                        </div>
                    {/foreach}
                {/if}
                <div class="col-lg-12 col-md-12">
                    <div class="card margin-bottom-no">
                        <div class="card-main">
                            <div class="card-inner">
                                <div class="card-inner">
                                    <div class="cardbtn-edit">
                                        <div class="card-heading">Top-up code</div>
                                        <button class="btn btn-flat" id="code-update">
                                            <span class="mdi mdi-check"></span>
                                        </button>
                                    </div>
                                    <div class="form-group form-group-label">
                                        <label class="floating-label" for="code">Top-up code</label>
                                        <input class="form-control maxwidth-edit" id="code" type="text">
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="col-lg-12 col-md-12">
                    <div class="card margin-bottom-no">
                        <div class="card-main">
                            <div class="card-inner">
                                <div class="card-table">
                                    <div class="table-responsive table-user">
                                        {$render}
                                        <table class="table table-hover">
                                            <tr>
                                                <!--<th>ID</th> -->
                                                <th>code</th>
                                                <th>type</th>
                                                <th>operation</th>
                                                <th>Use your time</th>
                                            </tr>
                                            {foreach $codes as $code}
                                                {if $code->type!=-2}
                                                    <tr>
                                                        <!--	<td>#{$code->id}</td>  -->
                                                        <td>{$code->code}</td>
                                                        {if $code->type==-1}
                                                            <td>The amount of prepaid phone</td>
                                                        {/if}
                                                        {if $code->type==10001}
                                                            <td>Traffic top-up</td>
                                                        {/if}
                                                        {if $code->type==10002}
                                                            <td>The user to renew</td>
                                                        {/if}
                                                        {if $code->type>=1&&$code->type<=10000}
                                                            <td>Level of renewal - level{$code->type}</td>
                                                        {/if}
                                                        {if $code->type==-1}
                                                            <td>top-up {$code->number} $</td>
                                                        {/if}
                                                        {if $code->type==10001}
                                                            <td>top-up {$code->number} GB traffic</td>
                                                        {/if}
                                                        {if $code->type==10002}
                                                            <td>Extending the account {$code->number} day</td>
                                                        {/if}
                                                        {if $code->type>=1&&$code->type<=10000}
                                                            <td>Extending the level {$code->number} day</td>
                                                        {/if}
                                                        <td>{$code->usedatetime}</td>
                                                    </tr>
                                                {/if}
                                            {/foreach}
                                        </table>
                                        {$render}
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
                <div aria-hidden="true" class="modal modal-va-middle fade" id="readytopay" role="dialog" tabindex="-1">
                    <div class="modal-dialog modal-xs">
                        <div class="modal-content">
                            <div class="modal-heading">
                                <a class="modal-close" data-dismiss="modal">×</a>
                                <h2 class="modal-title">Payment gateway is connected</h2>
                            </div>
                            <div class="modal-inner">
                                <p id="title">Thank you for your support to us, please be patient</p>
                            </div>
                        </div>
                    </div>
                </div>
                {include file='dialog.tpl'}
            </div>
        </section>
    </div>
</main>
<script>
    $(document).ready(function () {
        $("#code-update").click(function () {
            $.ajax({
                type: "POST",
                url: "code",
                dataType: "json",
                data: {
                    code: $$getValue('code')
                },
                success: (data) => {
                    if (data.ret) {
                        $("#result").modal();
                        $$.getElementById('msg').innerHTML = data.msg;
                        window.setTimeout("location.href=window.location.href", {$config['jump_delay']});
                    } else {
                        $("#result").modal();
                        $$.getElementById('msg').innerHTML = data.msg;
                        window.setTimeout("location.href=window.location.href", {$config['jump_delay']});
                    }
                },
                error: (jqXHR) => {
                    $("#result").modal();
{literal}
                    $$.getElementById('msg').innerHTML = `An error occurred:${jqXHR.status}`;
{/literal}
                }
            })
        })
    })
</script>

{include file='user/footer.tpl'}

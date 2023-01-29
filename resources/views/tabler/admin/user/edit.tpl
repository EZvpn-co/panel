{include file='admin/tabler_header.tpl'}

<div class="page-wrapper">
    <div class="container-xl">
        <div class="page-header d-print-none text-white">
            <div class="row align-items-center">
                <div class="col">
                    <h2 class="page-title">
                        <span class="home-title">The user #{$edit_user->id}</span>
                    </h2>
                    <div class="page-pretitle my-3">
                        <span class="home-subtitle">The user to edit</span>
                    </div>
                </div>
                <div class="col-auto ms-auto d-print-none">
                    <div class="btn-list">
                        <a id="save_changes" href="#" class="btn btn-primary d-none d-sm-inline-block">
                            <i class="icon ti ti-device-floppy"></i>
                            save
                        </a>
                        <a id="save_changes" href="#" class="btn btn-primary d-sm-none btn-icon">
                            <i class="icon ti ti-device-floppy"></i>
                        </a>
                    </div>
                </div>
            </div>
        </div>
    </div>
    <div class="page-body">
        <div class="container-xl">
            <div class="row row-deck row-cards">
                <div class="col-md-4 col-sm-12">
                    <div class="card">
                        <div class="card-header card-header-light">
                            <h3 class="card-title">Basic information</h3>
                        </div>
                        <div class="card-body">
                            <div class="form-group mb-3 row">
                                <label class="form-label col-3 col-form-label">Registered mail</label>
                                <div class="col">
                                    <input id="email" type="email" class="form-control" value="{$edit_user->email}">
                                </div>
                            </div>
                            <div class="form-group mb-3 row">
                                <label class="form-label col-3 col-form-label">The user name</label>
                                <div class="col">
                                    <input id="user_name" type="text" class="form-control"
                                        value="{$edit_user->user_name}">
                                </div>
                            </div>
                            <div class="form-group mb-3 row">
                                <label class="form-label col-3 col-form-label">note</label>
                                <div class="col">
                                    <input id="remark" type="text" class="form-control" value="{$edit_user->remark}"
                                        placeholder="The administrator only the visible">
                                </div>
                            </div>
                            <div class="form-group mb-3 row">
                                <label class="form-label col-3 col-form-label">The account password</label>
                                <div class="col">
                                    <input id="pass" type="text" class="form-control"
                                        placeholder="If need for users to reset the password, Fill in this column">
                                </div>
                            </div>
                            <div class="form-group mb-3 row">
                                <label class="form-label col-3 col-form-label">The account balance</label>
                                <div class="col">
                                    <input id="money" type="number" step="0.1" class="form-control"
                                        value="{$edit_user->money}">
                                </div>
                            </div>
                            <div class="hr-text">
                                <span>Set the time</span>
                            </div>
                            <div class="form-group mb-3 row">
                                <label class="form-label col-4 col-form-label">Grade expiration time</label>
                                <div class="col">
                                    <input id="class_expire" type="text" class="form-control"
                                        value="{$edit_user->class_expire}">
                                </div>
                            </div>
                            <div class="form-group mb-3 row">
                                <label class="form-label col-4 col-form-label">Account expiration time</label>
                                <div class="col">
                                    <input id="expire_in" type="text" class="form-control"
                                        value="{$edit_user->expire_in}">
                                </div>
                            </div>
                            <div class="form-group mb-3 row">
                                <label class="form-label col-4 col-form-label">Reset user traffic for free</label>
                                <div class="col">
                                    <input id="auto_reset_day" type="text" class="form-control"
                                        value="{$edit_user->auto_reset_day}">
                                </div>
                            </div>
                            <div class="form-group mb-3 row">
                                <label class="form-label col-4 col-form-label">
                                Reset the free flow(GB)
                                </label>
                                <div class="col">
                                    <input id="auto_reset_bandwidth" type="text" class="form-control"
                                        value="{$edit_user->auto_reset_bandwidth}">
                                </div>
                            </div>
                            <div class="hr-text">
                                <span>Advanced options</span>
                            </div>
                            <div class="form-group mb-3 row">
                                <span class="col">The administrator</span>
                                <span class="col-auto">
                                    <label class="form-check form-check-single form-switch">
                                        <input id="is_admin" class="form-check-input" type="checkbox"
                                            {if $edit_user->is_admin == 1}checked="" {/if}>
                                    </label>
                                </span>
                            </div>
                            <div class="form-group mb-3 row">
                                <span class="col">Two step certification</span>
                                <span class="col-auto">
                                    <label class="form-check form-check-single form-switch">
                                        <input id="ga_enable" class="form-check-input" type="checkbox"
                                            {if $edit_user->ga_enable == 1}checked="" {/if}>
                                    </label>
                                </span>
                            </div>
                            <div class="form-group mb-3 row">
                                <span class="col">Using a new system of the store</span>
                                <span class="col-auto">
                                    <label class="form-check form-check-single form-switch">
                                        <input id="use_new_shop" class="form-check-input" type="checkbox"
                                            {if $edit_user->use_new_shop == 1}checked="" {/if}>
                                    </label>
                                </span>
                            </div>
                            <div class="form-group mb-3 row">
                                <span class="col">Banned users</span>
                                <span class="col-auto">
                                    <label class="form-check form-check-single form-switch">
                                        <input id="is_banned" class="form-check-input" type="checkbox"
                                            {if $edit_user->is_banned == 1} checked=""{/if}>
                                    </label>
                                </span>
                            </div>
                            <div class="form-group mb-3 row">
                                <span class="col">Manual banned reason</span>
                                <span class="col-auto">
                                    <input id="banned_reason" type="text" class="form-control"
                                        value="{$edit_user->banned_reason}">
                                </span>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="col-md-4 col-sm-12">
                    <div class="card">
                        <div class="card-header card-header-light">
                            <h3 class="card-title">Other information</h3>
                        </div>
                        <div class="card-body">
                            <div class="form-group mb-3 row">
                                <label class="form-label col-4 col-form-label">Traffic restrictions (GB)</label>
                                <div class="col">
                                    <input id="transfer_enable" type="text" class="form-control"
                                        value="{$edit_user->enableTrafficInGB()}">
                                </div>
                            </div>
                            <div class="form-group mb-3 row">
                                <label class="form-label col-4 col-form-label">Have used traffic (GB)</label>
                                <div class="col">
                                    <input id="usedTraffic" type="text" class="form-control"
                                        value="{$edit_user->usedTraffic()}" disabled />
                                </div>
                            </div>
                            <div class="hr-text">
                                <span>Invitation to register</span>
                            </div>
                            <div class="form-group mb-3 row">
                                <label class="form-label col-4 col-form-label">Number of available invitation</label>
                                <div class="col">
                                    <input id="invite_num" type="text" class="form-control"
                                        value="{$edit_user->invite_num}">
                                </div>
                            </div>
                            <div class="form-group mb-3 row">
                                <label class="form-label col-4 col-form-label">inviter</label>
                                <div class="col">
                                    <input id="ref_by" type="text" class="form-control" value="{$edit_user->ref_by}">
                                </div>
                            </div>
                            <div class="hr-text">
                                <span>Division and use restrictions</span>
                            </div>
                            <div class="form-group mb-3 col-12">
                                    <label class="form-label col-12 col-form-label">Node group</label>
                                    <div class="col">
                                        <input id="node_group" type="text" class="form-control"
                                            value="{$edit_user->node_group}">
                                    </div>
                                </div>
                                <div class="form-group mb-3 col-12">
                                    <label class="form-label col-12 col-form-label">Account level</label>
                                    <div class="col">
                                        <input id="class" type="text" class="form-control" value="{$edit_user->class}">
                                    </div>
                                </div>
                                <div class="form-group mb-3 col-12">
                                    <label class="form-label col-12 col-form-label">The speed limit (Mbps)</label>
                                    <div class="col">
                                        <input id="node_speedlimit" type="text" class="form-control"
                                            value="{$edit_user->node_speedlimit}">
                                    </div>
                                </div>
                                <div class="form-group mb-3 col-12">
                                    <label class="form-label col-12 col-form-label">Link device limitations</label>
                                    <div class="col">
                                        <input id="node_connector" type="text" class="form-control"
                                            value="{$edit_user->node_connector}">
                                    </div>
                                </div>
                        </div>
                    </div>
                </div>
                <div class="col-md-4 col-sm-12">
                    <div class="card">
                        <div class="card-header card-header-light">
                            <h3 class="card-title">Connection Settings</h3>
                        </div>
                        <div class="card-body">
                            <div class="form-group mb-3 row">
                                <label class="form-label col-3 col-form-label">port</label>
                                <div class="col">
                                    <input id="port" type="text" class="form-control" value="{$edit_user->port}">
                                </div>
                            </div>
                            <div class="form-group mb-3 row">
                                <label class="form-label col-3 col-form-label">password</label>
                                <div class="col">
                                    <input id="passwd" type="text" class="form-control" value="{$edit_user->passwd}">
                                </div>
                            </div>
                            <div class="form-group mb-3 row">
                                <label class="form-label col-3 col-form-label">encryption</label>
                                <div class="col">
                                    <input id="method" type="text" class="form-control" value="{$edit_user->method}">
                                </div>
                            </div>
                            <div class="hr-text">
                                <span>Access restrictions</span>
                            </div>
                            <div class="form-group mb-3 row">
                                <label class="form-label col-3 col-form-label">IP / CIDR</label>
                                <div class="col">
                                    <textarea id="forbidden_ip" class="col form-control"
                                        rows="2">{$edit_user->forbidden_ip}</textarea>
                                </div>
                            </div>
                            <div class="form-group mb-3 row">
                                <label class="form-label col-3 col-form-label">PORT</label>
                                <div class="col">
                                    <textarea id="forbidden_port" class="col form-control"
                                        rows="2">{$edit_user->forbidden_port}</textarea>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

<script>
    $("#save_changes").click(function() {
        $.ajax({
            url: '/admin/user/{$edit_user->id}',
            type: 'PUT',
            dataType: "json",
            data: {
                {foreach $update_field as $key}
                {$key}: $('#{$key}').val(),
                {/foreach}
                is_admin: $("#is_admin").is(":checked"),
                is_banned: $("#enable").is(":checked"),
                ga_enable: $("#ga_enable").is(":checked"),
            },
            success: function(data) {
                if (data.ret == 1) {
                    $('#success-message').text(data.msg);
                    $('#success-dialog').modal('show');
                    window.setTimeout("location.href=top.document.referrer", {$config['jump_delay']});
                } else {
                    $('#fail-message').text(data.msg);
                    $('#fail-dialog').modal('show');
                }
            }
        })
    });
</script>

{include file='admin/tabler_footer.tpl'}
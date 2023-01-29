{include file='admin/tabler_header.tpl'}

<div class="page-wrapper">
    <div class="container-xl">
        <div class="page-header d-print-none text-white">
            <div class="row align-items-center">
                <div class="col">
                    <h2 class="page-title">
                        <span class="home-title">goods #{$product->id}</span>
                    </h2>
                    <div class="page-pretitle my-3">
                        <span class="home-subtitle">Edit the commodity information</span>
                    </div>
                </div>
                <div class="col-auto ms-auto d-print-none">
                    <div class="btn-list">
                        <a id="save-product" href="#" class="btn btn-primary">
                            <i class="icon ti ti-device-floppy"></i>
                            save
                        </a>
                    </div>
                </div>
            </div>
        </div>
    </div>
    <div class="page-body">
        <div class="container-xl">
            <div class="row row-deck row-cards">
                <div class="col-md-6 col-sm-12">
                    <div class="card">
                        <div class="card-header card-header-light">
                            <h3 class="card-title">Basic information</h3>
                        </div>
                        <div class="card-body">
                            <div class="form-group mb-3 row">
                                <label class="form-label col-3 col-form-label">The name of the</label>
                                <div class="col">
                                    <input id="name" type="text" class="form-control" 
                                        value="{$product->name}">
                                </div>
                            </div>
                            <div class="form-group mb-3 row">
                                <label class="form-label col-3 col-form-label">The price</label>
                                <div class="col">
                                    <input id="price" type="text" class="form-control" 
                                        value="{$product->price}">
                                </div>
                            </div>
                            <div class="form-group mb-3 row">
                                <label class="form-label col-3 col-form-label">inventory</label>
                                <div class="col">
                                    <input id="stock" type="text" class="form-control" 
                                        value="{$product->stock}">
                                </div>
                            </div>
                            <div class="form-group mb-3 row">
                                <label class="form-label col-3 col-form-label">Sales status</label>
                                <div class="col">
                                    <select id="status" class="col form-select">
                                        <option value="1" {if $product->status === 1}selected{/if}>normal</option>
                                        <option value="0" {if $product->status === 0}selected{/if}>The shelves</option>
                                    </select>
                                </div>
                            </div>
                            <div class="form-group mb-3 row">
                                <label class="form-label col-3 col-form-label">type</label>
                                <div class="col">
                                    <select id="type" class="col form-select">
                                        <option value="tabp" {if $product->type === "tabp"}selected{/if}>Time flow package</option>
                                        <option value="time" {if $product->type === "time"}selected{/if}>Time to pack</option>
                                        <option value="bandwidth" {if $product->type === "bandwidth"}selected{/if}>Traffic package</option>
                                    </select>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="col-md-6 col-sm-12">
                    <div class="card">
                        <div class="card-header card-header-light">
                            <h3 class="card-title">Commodity content</h3>
                        </div>
                        <div class="card-body">
                            <div class="form-group mb-3 row">
                                <label class="form-label col-3 col-form-label">The goods time (day)</label>
                                <div class="col">
                                    <input id="time" type="text" class="form-control" 
                                        value="{$content['time']}">
                                </div>
                            </div>
                            <div class="form-group mb-3 row">
                                <label class="form-label col-3 col-form-label">level</label>
                                <div class="col">
                                    <input id="class" type="text" class="form-control" 
                                        value="{$content['class']}">
                                </div>
                            </div>
                            <div class="form-group mb-3 row">
                                <label class="form-label col-3 col-form-label">Rank the length (day)</label>
                                <div class="col">
                                    <input id="class_time" type="text" class="form-control" 
                                        value="{$content['class_time']}">
                                </div>
                            </div>
                            <div class="form-group mb-3 row">
                                <label class="form-label col-3 col-form-label">The available flow (GB)</label>
                                <div class="col">
                                    <input id="bandwidth" type="text" class="form-control" 
                                        value="{$content['bandwidth']}">
                                </div>
                            </div>
                            <div class="form-group mb-3 row">
                                <label class="form-label col-3 col-form-label">The user group</label>
                                <div class="col">
                                    <input id="node_group" type="text" class="form-control" 
                                        value="{$content['node_group']}">
                                </div>
                            </div>
                            <div class="form-group mb-3 row">
                                <label class="form-label col-3 col-form-label">Rate limit (Mbps)</label>
                                <div class="col">
                                    <input id="speed_limit" type="text" class="form-control"
                                        value="{$content['speed_limit']}">
                                </div>
                            </div>
                            <div class="form-group mb-3 row">
                                <label class="form-label col-3 col-form-label">At the same time to connectIPlimit</label>
                                <div class="col">
                                    <input id="ip_limit" type="text" class="form-control"
                                        value="{$content['ip_limit']}">
                                </div>
                            </div>
                            <div class="hr-text">
                                <span>Buying restrictions</span>
                            </div>
                            <div class="form-group mb-3 row">
                                <label class="form-label col-3 col-form-label">User level requirements</label>
                                <div class="col">
                                    <input id="class_requried" type="text" class="form-control"
                                        value="{$limit['class_required']}">
                                </div>
                            </div>
                            <div class="form-group mb-3 row">
                                <label class="form-label col-3 col-form-label">Users are node group</label>
                                <div class="col">
                                    <input id="node_group_requried" type="text" class="form-control"
                                        value="{$limit['node_group_required']}">
                                </div>
                            </div>
                            <div class="mb-3">
                                <label class="row">
                                    <span class="col">New users to buy only</span>
                                    <span class="col-auto">
                                        <label class="form-check form-check-single form-switch">
                                            <input id="new_user_requried" class="form-check-input" type="checkbox" 
                                                {if $limit['new_user_required'] === 1}checked="" {/if}>
                                        </label>
                                    </span>
                                </label>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

<script>
    $("#save-product").click(function() {
        $.ajax({
            url: '/admin/product/{$product->id}',
            type: 'PUT',
            dataType: "json",
            data: {
                {foreach $update_field as $key}
                {$key}: $('#{$key}').val(),
                {/foreach}
                new_user_required: $("#new_user_required").is(":checked"),
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

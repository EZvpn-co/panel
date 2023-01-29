{include file='admin/main.tpl'}

<main class="content">
    <div class="content-header ui-content-header">
        <div class="container">
            <h1 class="content-heading">Edit commodity</h1>
        </div>
    </div>
    <div class="container">
        <div class="col-lg-12 col-sm-12">
            <section class="content-inner margin-top-no">
                <div class="card">
                    <div class="card-main">
                        <div class="card-inner">
                            <div class="form-group form-group-label">
                                <label class="floating-label" for="name">The name of the</label>
                                <input class="form-control maxwidth-edit" id="name" type="text" value="{$shop->name}">
                            </div>
                            <div class="form-group form-group-label">
                                <label class="floating-label" for="price">The price</label>
                                <input class="form-control maxwidth-edit" id="price" type="text" value="{$shop->price}">
                            </div>
                            <div class="form-group form-group-label">
                                <label class="floating-label" for="auto_renew">Automatically renew the number of days</label>
                                <input class="form-control maxwidth-edit" id="auto_renew" type="text"
                                       value="{$shop->auto_renew}">
                                <p class="form-control-guide"><i class="mdi mdi-information"></i>0To not allow automatic renewal, as in so many other days will automatically delimit money deduction from the user's account
                                </p>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="card">
                    <div class="card-main">
                        <div class="card-inner">
                            <div class="form-group form-group-label">
                                <label class="floating-label" for="bandwidth">Flow (GB)</label>
                                <input class="form-control maxwidth-edit" id="bandwidth" type="text"
                                       value="{$shop->bandwidth()}">
                            </div>
                            <div class="form-group form-group-label">
                                <div class="checkbox switch">
                                    <label for="auto_reset_bandwidth">
                                        <input {if $shop->auto_reset_bandwidth==1}checked{/if} class="access-hide"
                                               id="auto_reset_bandwidth" type="checkbox"><span
                                                class="switch-toggle"></span>Continue time consuming automatic reset user flow for the above flow value
                                    </label>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="card">
                    <div class="card-main">
                        <div class="card-inner">
                            <div class="form-group form-group-label">
                                <label class="floating-label" for="traffic-package-min">Minimum can buy user level</label>
                                <input class="form-control maxwidth-edit" id="traffic-package-min" type="text"
                                value="{if $shop->trafficPackage()}{$shop->content['traffic_package']['class']['min']}{else}0{/if}">
                            </div>
                            <div class="form-group form-group-label">
                                <label class="floating-label" for="traffic-package-max">Could buy user level</label>
                                <input class="form-control maxwidth-edit" id="traffic-package-max" type="text"
                                value="{if $shop->trafficPackage()}{$shop->content['traffic_package']['class']['max']}{else}0{/if}">
                            </div>
                            <div class="form-group form-group-label">
                                <div class="checkbox switch">
                                    <label for="traffic-package-enable">
                                        <input {if $shop->trafficPackage()}checked{/if} class="access-hide" id="traffic-package-enable" type="checkbox">
                                        <span class="switch-toggle"></span>Whether to set up this goods for traffic overlay package
                                    </label>
                                    <p class="form-control-guide">
                                        <i class="mdi mdi-information"></i>
                                        After the bag is set to flow superposition except get traffic when buying setting is invalid
                                    </p>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="card">
                    <div class="card-main">
                        <div class="card-inner">
                            <div class="form-group form-group-label">
                                <label class="floating-label" for="expire">Validity of account number</label>
                                <input class="form-control maxwidth-edit" id="expire" type="text"
                                       value="{$shop->expire()}">
                            </div>
                        </div>
                    </div>
                </div>
                <div class="card">
                    <div class="card-main">
                        <div class="card-inner">
                            <div class="form-group form-group-label">
                                <label class="floating-label" for="class">level</label>
                                <input class="form-control maxwidth-edit" id="class" type="text"
                                       value="{$shop->userClass()}">
                            </div>
                            <div class="form-group form-group-label">
                                <label class="floating-label" for="class_expire">Rating validity days</label>
                                <input class="form-control maxwidth-edit" id="class_expire" type="text"
                                       value="{$shop->classExpire()}">
                            </div>
                            <p class="form-control-guide"><i class="mdi mdi-information"></i>If you want to use level function, at the same time, please fill out the grade and level days validity 】 【 】 the two projects</p>
                        </div>
                    </div>
                </div>
                <div class="card">
                    <div class="card-main">
                        <div class="card-inner">
                            <div class="form-group form-group-label">
                                <label class="floating-label" for="reset_exp">How many days</label>
                                <input class="form-control maxwidth-edit" id="reset_exp" type="number"
                                       value="{$shop->resetExp()}">
                            </div>
                            <div class="form-group form-group-label">
                                <label class="floating-label" for="reset">How many days per</label>
                                <input class="form-control maxwidth-edit" id="reset" type="number"
                                       value="{$shop->reset()}">
                            </div>
                            <div class="form-group form-group-label">
                                <label class="floating-label" for="reset_value">How much for reset flowG</label>
                                <input class="form-control maxwidth-edit" id="reset_value" type="number"
                                       value="{$shop->resetValue()}">
                            </div>
                        </div>
                    </div>
                </div>
                <div class="card">
                    <div class="card-main">
                        <div class="card-inner">
                            <div class="form-group form-group-label">
                                <label class="floating-label" for="speedlimit">Port speed limit</label>
                                <input class="form-control maxwidth-edit" id="speedlimit" type="number"
                                       value="{$shop->speedlimit()}">
                            </div>
                            <div class="form-group form-group-label">
                                <label class="floating-label" for="connector">IPlimit</label>
                                <input class="form-control maxwidth-edit" id="connector" type="number"
                                       value="{$shop->connector()}">
                            </div>
                        </div>
                    </div>
                </div>
                <div class="card">
                    <div class="card-main">
                        <div class="card-inner">
                            <div class="form-group form-group-label">
                                <label class="floating-label" for="content_extra">Service support</label>
                                <input class="form-control maxwidth-edit" id="content_extra" type="text"
                                       value="{foreach $shop->contentExtra() as $service}{$service[0]}-{$service[1]}{if $service@last}{else};{/if}{/foreach}">
                                <p class="form-control-guide"><i class="mdi mdi-information"></i>Ex. :<code>check-Global node distribution;clear-Quick customer response</co, a minus sign is on the leftOn the left foriconCode name for the text on the right,In order to;separated
                                </p>
                                <p class="form-control-guide">iconCode refer to:<a
                                            href="https://materialdesignicons.com/">Material Design Icons</a>
                                </p>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="card">
                    <div class="card-main">
                        <div class="card-inner">

                            <div class="form-group">
                                <div class="row">
                                    <div class="col-md-10 col-md-push-1">
                                        <button id="submit" type="submit"
                                                class="btn btn-block btn-brand waves-attach waves-light">save
                                        </button>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
                {include file='dialog.tpl'}
        </div>
    </div>
</main>

{include file='admin/footer.tpl'}

<script>
    window.addEventListener('load', () => {
        function submit() {
            if ($$.getElementById('auto_reset_bandwidth').checked) {
                var auto_reset_bandwidth = 1;
            } else {
                var auto_reset_bandwidth = 0;
            }
            let contentExtra = $$getValue('content_extra');
            if (contentExtra === '' || contentExtra === '-') {
                contentExtra = 'check-Global node distribution;check-Quick customer response;check-The platform to the client';
            }
            let data = {
                name: $$getValue('name'),
                auto_reset_bandwidth,
                price: $$getValue('price'),
                auto_renew: $$getValue('auto_renew'),
                bandwidth: $$getValue('bandwidth'),
                speedlimit: $$getValue('speedlimit'),
                connector: $$getValue('connector'),
                expire: $$getValue('expire'),
                class: $$getValue('class'),
                class_expire: $$getValue('class_expire'),
                reset: $$getValue('reset'),
                reset_value: $$getValue('reset_value'),
                reset_exp: $$getValue('reset_exp'),
                content_extra: contentExtra,
            }
            if ($$.getElementById('traffic-package-enable').checked) {
                data.traffic_package = {
                    class: {
                        min: $$getValue('traffic-package-min'),
                        max: $$getValue('traffic-package-max')
                    }
                }
            }
            $.ajax({
                type: "PUT",
                url: "/admin/shop/{$shop->id}",
                dataType: "json",
                data,
                success: data => {
                    if (data.ret) {
                        $("#result").modal();
                        $$.getElementById('msg').innerHTML = data.msg;
                        window.setTimeout("location.href='/admin/shop'", {$config['jump_delay']});
                    } else {
                        $("#result").modal();
                        $$.getElementById('msg').innerHTML = data.msg;
                    }
                },
                error: jqXHR => {
                    $("#result").modal();
                    $$.getElementById('msg').innerHTML = `An error occurred:${
                            jqXHR.status
                            }`;
                }
            });
        }
        $("html").keydown(event => {
            if (event.keyCode === 13) {
                login();
            }
        });
        $$.getElementById('submit').addEventListener('click', submit);
    })
</script>

{include file='user/tabler_header.tpl'}

<div class="page-wrapper">
    <div class="container-xl">        
        <div class="page-header d-print-none text-white">
            <div class="row align-items-center">
                <div class="col">                   
                    <h2 class="page-title">
                        <span class="home-title">The billing details</span>
                    </h2>
                    <div class="page-pretitle my-3">
                        <span class="home-subtitle">Here to view the bill details</span>
                    </div>
                </div>
            </div>
        </div>
    </div>
    <div class="page-body">
        <div class="container-xl">
            <div class="card card-md">
                <div class="card-stamp">
                    {if time() > $order->expired_at && $order->order_status != 'paid' && $order->order_status != 'abnormal'}
                        <div class="card-stamp-icon bg-red">
                            <svg xmlns="http://www.w3.org/2000/svg" class="icon icon-tabler icon-tabler-x" width="24"
                                height="24" viewBox="0 0 24 24" stroke-width="2" stroke="currentColor" fill="none"
                                stroke-linecap="round" stroke-linejoin="round">
                                <path stroke="none" d="M0 0h24v24H0z" fill="none"></path>
                                <line x1="18" y1="6" x2="6" y2="18"></line>
                                <line x1="6" y1="6" x2="18" y2="18"></line>
                            </svg>
                        </div>
                    {else}
                        {if time() < $order->expired_at && $order->order_status != 'paid'}
                            <div class="card-stamp-icon bg-yellow">
                                <svg xmlns="http://www.w3.org/2000/svg" class="icon icon-tabler icon-tabler-clock" width="24"
                                    height="24" viewBox="0 0 24 24" stroke-width="2" stroke="currentColor" fill="none"
                                    stroke-linecap="round" stroke-linejoin="round">
                                    <path stroke="none" d="M0 0h24v24H0z" fill="none"></path>
                                    <circle cx="12" cy="12" r="9"></circle>
                                    <polyline points="12 7 12 12 15 15"></polyline>
                                </svg>
                            </div>
                        {/if}
                    {/if}
                    {if $order->order_status == 'paid'}
                        <div class="card-stamp-icon bg-green">
                            <svg xmlns="http://www.w3.org/2000/svg" class="icon icon-tabler icon-tabler-check" width="24"
                                height="24" viewBox="0 0 24 24" stroke-width="2" stroke="currentColor" fill="none"
                                stroke-linecap="round" stroke-linejoin="round">
                                <path stroke="none" d="M0 0h24v24H0z" fill="none"></path>
                                <path d="M5 12l5 5l10 -10"></path>
                            </svg>
                        </div>
                    {/if}
                    {if $order->order_status == 'abnormal'}
                        <div class="card-stamp-icon bg-red">
                            <svg xmlns="http://www.w3.org/2000/svg" class="icon icon-tabler icon-tabler-ban" width="24"
                                height="24" viewBox="0 0 24 24" stroke-width="2" stroke="currentColor" fill="none"
                                stroke-linecap="round" stroke-linejoin="round">
                                <path stroke="none" d="M0 0h24v24H0z" fill="none"></path>
                                <circle cx="12" cy="12" r="9"></circle>
                                <line x1="5.7" y1="5.7" x2="18.3" y2="18.3"></line>
                            </svg>
                        </div>
                    {/if}
                </div>
                <div class="card-body">
                    <div class="row">
                        <div class="col-12 my-2">
                            <h1>Invoice #{$order->no}</h1>
                        </div>
                    </div>
                    <table class="table table-transparent table-responsive">
                        <thead>
                            <tr>
                                <th class="text-center" style="width: 1%">#</th>
                                <th>goods</th>
                                <th class="text-center" style="width: 10%">The number of</th>
                                <th class="text-end" style="width: 1%">The unit price</th>
                                <th class="text-end" style="width: 1%">The total price</th>
                            </tr>
                        </thead>
                        <tr>
                            <td class="text-center">1</td>
                            <td>
                                <p class="strong mb-1">{$order->product_name}</p>
                                <div class="text-muted">{$order->product_content}</div>
                            </td>
                            <td class="text-center">
                                1
                            </td>
                            <td class="text-end">{sprintf("%.2f", $order->product_price / 100)}</td>
                            <td class="text-end">{sprintf("%.2f", $order->product_price / 100)}</td>
                        </tr>
                        {if $order->order_coupon != null}
                            <tr>
                                <td colspan="4" class="strong text-end">coupons</td>
                                <td class="text-end"><code>{$order->order_coupon}</code></td>
                            </tr>
                            <tr>
                                <td colspan="4" class="strong text-end">discount</td>
                                <td class="text-end">{sprintf("%.2f", ($order->order_price - $order->product_price) / 100)}
                                </td>
                            </tr>
                        {/if}
                        {if $order->balance_payment != '0'}
                            <tr>
                                <td colspan="4" class="strong font-weight-bold text-uppercase text-end">The balance of deduction</td>
                                <td class="font-weight-bold text-end">
                                    -&nbsp;{sprintf("%.2f", $order->balance_payment / 100)}
                                </td>
                            </tr>
                            <tr>
                                <td colspan="4" class="strong font-weight-bold text-uppercase text-end">To cope with</td>
                                <td class="font-weight-bold text-end">
                                    {sprintf("%.2f", ($order->order_price - $order->balance_payment) / 100)}
                                </td>
                            </tr>
                        {else}
                            <tr>
                                <td colspan="4" class="strong font-weight-bold text-uppercase text-end">To cope with</td>
                                <td class="font-weight-bold text-end">
                                    {sprintf("%.2f", $order->order_price / 100)}
                                </td>
                            </tr>
                        {/if}
                    </table>
                    {if time() > $order->expired_at && $order->order_status != 'paid'}
                        {if $order->order_status != 'abnormal'}
                            <div class="row">
                                <div class="col-12">
                                    <div class="mb-3 my-5">
                                        <div class="card">
                                            <div class="card-status-top bg-danger"></div>
                                            <div class="card-body">
                                                <h3 class="card-title">The bill has been overdue</h3>
                                                <p class="text-muted">This bill is out of date.If necessary, please check <a href="/user/product">The store</a> To place the order</p>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        {else}
                            <div class="row">
                                <div class="col-12">
                                    <div class="mb-3 my-5">
                                        <div class="card">
                                            <div class="card-status-top bg-danger"></div>
                                            <div class="card-body">
                                                <h3 class="card-title">Bill exception</h3>
                                                <p class="text-muted">
                                                    The bill is abnormal.Reason is to create a more pen using the balance against bill, and pay more copies of the bill.Please submit the repair order, contact your administrator to apply for a refund for this bill</p>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        {/if}
                    {else}
                        {if time() < $order->expired_at && $order->order_status != 'paid'}
                            <div class="row">
                                <div class="col-12">
                                    <div class="mb-3">
                                        <div class="col-12 my-3">
                                            <h1>Method of payment</h1>
                                        </div>
                                        <div class="form-selectgroup form-selectgroup-boxes d-flex flex-column">
                                            {if $order->product_type != 'recharge'}
                                                <label class="form-selectgroup-item flex-fill">
                                                    <input value="balance" type="radio" name="payment-method"
                                                        class="form-selectgroup-input" checked="">
                                                    <div class="form-selectgroup-label d-flex align-items-center p-3">
                                                        <div class="me-3">
                                                            <span class="form-selectgroup-check"></span>
                                                        </div>
                                                        <div>
                                                            The account balance
                                                        </div>
                                                    </div>
                                                </label>
                                            {/if}
                                            {foreach $config['active_payments'] as $key => $value}
                                                {if $value['enable'] == true}
                                                    {if ($value['visible_range'] == true && $user->id >= $value['visible_min_range'] && $user->id <= $value['visible_max_range']) || $value['visible_range'] == false}
                                                        <label class="form-selectgroup-item flex-fill">
                                                            <input value="{$key}" class="form-selectgroup-input" id="payment-method"
                                                                type="radio" name="payment-method">
                                                            <div class="form-selectgroup-label d-flex align-items-center p-3">
                                                                <div class="me-3">
                                                                    <span class="form-selectgroup-check"></span>
                                                                </div>
                                                                <div>
                                                                    {$value['name']}
                                                                </div>
                                                            </div>
                                                        </label>
                                                    {/if}
                                                {/if}
                                            {/foreach}
                                        </div>
                                    </div>
                                    <div>
                                        <button id="submit-payment" href="#" class="btn btn-primary w-100">
                                            pay
                                        </button>
                                    </div>
                                </div>
                            </div>
                        {/if}
                    {/if}
                    {if $order->order_status == 'paid'}
                        <div class="row">
                            <div class="col-12">
                                <div class="mb-3 my-5">
                                    <div class="card">
                                        <div class="card-status-top bg-green"></div>
                                        <div class="card-body">
                                            <h3 class="card-title">The bill has been paid</h3>
                                            <p class="text-muted">Commodity content has been added to your account</p>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    {/if}
                </div>
            </div>
        </div>
    </div>

    <div class="modal modal-blur fade" id="waiting-dialog" tabindex="-1" role="dialog" aria-hidden="true">
        <div class="modal-dialog modal-sm modal-dialog-centered" role="document">
            <div class="modal-content">
                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                <div class="modal-status bg-yellow"></div>
                <div class="modal-body">
                    <div>
                        <p id="qrcode"></p>
                        <p id="waiting-message" class="text-muted">Waiting for the</p>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <script>
        function getOrderStatus() {
            $.ajax({
                method: 'GET',
                url: '/user/order/status/{$order->no}',
                dataType: "json",
                success: function(data) {
                    if (data.status == 'paid') {
                        clearInterval(cycle);
                        $('#success-message').text('The order was confirmed');
                        $('#waiting-dialog').modal('hide');
                        $('#success-dialog').modal('show');
                    }
                }
            });
        }

        $("#submit-payment").click(function() {
            payment = $('input:radio:checked').val();
            $("#submit-payment").attr('disabled', true);
            $('#submit-payment').text('Are dealing with');

            $.ajax({
                url: '/user/order',
                type: 'PUT',
                dataType: "json",
                data: {
                    order_no: '{$order->no}',
                    method: payment,
                },
                success: function(data) {
                    if (data.ret == 1) {
                        if (data.type == 'qrcode') {
                            var qrcode = new QRCode('qrcode', {
                                text: data.qrcode,
                                width: 150,
                                height: 150,
                                colorDark: '#000000',
                                colorLight: '#ffffff',
                                correctLevel: QRCode.CorrectLevel.H
                            });
                            $('#waiting-message').text(data.msg);
                            $('#waiting-dialog').modal('show');
                            cycle = setInterval(getOrderStatus, 1500);
                        }
                        if (data.type == 'link') {
                            window.location.href = data.link;
                        }
                    } else {
                        if (data.ret == 0) {
                            $('#fail-message').text(data.msg);
                            $('#fail-dialog').modal('show');
                        } else {
                            $('#success-message').text(data.msg);
                            $('#success-dialog').modal('show');
                        }
                    }
                }
            })
        });

        $("#success-confirm").click(function() {
            location.reload();
        });

        $('#waiting-dialog').on('hide.bs.modal', function() {
            $('#qrcode').html('');
            clearInterval(cycle);
            $("#submit-payment").attr('disabled', false);
            $('#submit-payment').text('To pay for');
        });

        $('#fail-dialog').on('hide.bs.modal', function() {
            $('#qrcode').html('');
            $("#submit-payment").attr('disabled', false);
            $('#submit-payment').text('To pay for');
        });
    </script>
    
{include file='user/tabler_footer.tpl'}
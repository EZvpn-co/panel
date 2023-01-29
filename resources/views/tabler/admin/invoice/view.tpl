{include file='admin/tabler_header.tpl'}

<div class="page-wrapper">
    <div class="container-xl">
        <div class="page-header d-print-none text-white">
            <div class="row align-items-center">
                <div class="col">
                    <h2 class="page-title">
                        <span class="home-title my-3">bill #{$invoice->id}</span>
                    </h2>
                    <div class="page-pretitle">
                        <span class="home-subtitle">The billing details</span>
                    </div>
                </div>
                <div class="col-auto ms-auto d-print-none">
                    <div class="btn-list">
                        {if $invoice->status !== 'paid_gateway' && $invoice->status !== 'paid_balance' && $invoice->status !== 'paid_admin'}
                        <button href="#" class="btn btn-primary d-none d-sm-inline-block" data-bs-toggle="modal"
                            data-bs-target="#mark_paid_confirm_dialog">
                            <i class="icon ti ti-checklist"></i>
                            Marked as payment
                        </button>
                        <button href="#" class="btn btn-primary d-sm-none btn-icon" data-bs-toggle="modal"
                            data-bs-target="#mark_paid_confirm_dialog">
                            <i class="icon ti ti-checklist"></i>
                        </button>
                        {/if}
                    </div>
                </div>
            </div>
        </div>
    </div>
    <div class="page-body">
        <div class="container-xl">
            <div class="card">
                <div class="card-header">
                    <h3 class="card-title">The basic information</h3>
                </div>
                <div class="card-body">
                    <div class="datagrid">
                        <div class="datagrid-item">
                            <div class="datagrid-title">Submitted to the user</div>
                            <div class="datagrid-content">{$invoice->user_id}</div>
                        </div>
                        <div class="datagrid-item">
                            <div class="datagrid-title">The orderID</div>
                            <div class="datagrid-content">{$invoice->order_id}</div>
                        </div>
                        <div class="datagrid-item">
                            <div class="datagrid-title">The order amount</div>
                            <div class="datagrid-content">{$invoice->price}</div>
                        </div>
                        <div class="datagrid-item">
                            <div class="datagrid-title">The order status</div>
                            <div class="datagrid-content">{$invoice->status}</div>
                        </div>
                        <div class="datagrid-item">
                            <div class="datagrid-title">Creation time</div>
                            <div class="datagrid-content">{$invoice->create_time}</div>
                        </div>
                        <div class="datagrid-item">
                            <div class="datagrid-title">Update time</div>
                            <div class="datagrid-content">{$invoice->update_time}</div>
                        </div>
                        <div class="datagrid-item">
                            <div class="datagrid-title">Payment time</div>
                            <div class="datagrid-content">{$invoice->pay_time}</div>
                        </div>
                    </div>
                </div>
            </div>
            <div class="card my-3">
                <div class="card-header">
                    <h3 class="card-title">The billing details</h3>
                </div>
                <div class="card-body">
                    <div class="table-responsive">
                        <table id="invoice_content_table" class="table table-vcenter card-table">
                            <thead>
                                <tr>
                                    <th>The name of the</th>
                                    <th>The price</th>
                                </tr>
                            </thead>
                            <tbody>
                                {foreach $invoice_content as $invoice_content_detail}
                                <tr>
                                    <td>{$invoice_content_detail['name']}</td>
                                    <td>{$invoice_content_detail['price']}</td>
                                </tr>
                                {/foreach}
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <div class="modal modal-blur fade" id="mark_paid_confirm_dialog" tabindex="-1" role="dialog" aria-hidden="true">
        <div class="modal-dialog modal-dialog-centered modal-dialog-scrollable" role="document">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title">Marked as payment</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <div class="modal-body">
                    <div class="mb-3">
                        <p>
                            Confirm will mark the bill for payment?
                        <p>
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn me-auto" data-bs-dismiss="modal">cancel</button>
                    <button id="confirm_mark_paid" type="button" class="btn btn-primary" data-bs-dismiss="modal">confirm</button>
                </div>
            </div>
        </div>
    </div>

    <script>
        $("#confirm_mark_paid").click(function() {
            $.ajax({
                url: "/admin/invoice/{$invoice->id}/mark_paid",
                type: 'POST',
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

        $("#success-confirm").click(function() {
            location.reload();
        });
    </script>

{include file='admin/tabler_footer.tpl'}

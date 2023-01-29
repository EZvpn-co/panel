{include file='user/tabler_header.tpl'}

<div class="page-wrapper">
    <div class="container-xl">       
        <div class="page-header d-print-none text-white">
            <div class="row align-items-center">
                <div class="col">                   
                    <h2 class="page-title">
                        <span class="home-title my-3">The bill list</span>
                    </h2>
                    <div class="page-pretitle">
                        <span class="home-subtitle">Check the bill list here</span>
                    </div>
                </div>
                <div class="col-auto ms-auto d-print-none">
                    <div class="btn-list">
                        <a href="#" class="btn btn-primary d-none d-sm-inline-block" data-bs-toggle="modal"
                            data-bs-target="#redeem-dialog">
                            <svg xmlns="http://www.w3.org/2000/svg" class="icon icon-tabler icon-tabler-gift" width="24"
                                height="24" viewBox="0 0 24 24" stroke-width="2" stroke="currentColor" fill="none"
                                stroke-linecap="round" stroke-linejoin="round">
                                <path stroke="none" d="M0 0h24v24H0z" fill="none"></path>
                                <rect x="3" y="8" width="18" height="4" rx="1"></rect>
                                <line x1="12" y1="8" x2="12" y2="21"></line>
                                <path d="M19 12v7a2 2 0 0 1 -2 2h-10a2 2 0 0 1 -2 -2v-7"></path>
                                <path
                                    d="M7.5 8a2.5 2.5 0 0 1 0 -5a4.8 8 0 0 1 4.5 5a4.8 8 0 0 1 4.5 -5a2.5 2.5 0 0 1 0 5">
                                </path>
                            </svg>
                            Cash gift CARDS
                        </a>
                        <a href="#" class="btn btn-primary d-sm-none btn-icon" data-bs-toggle="modal"
                            data-bs-target="#redeem-dialog">
                            <svg xmlns="http://www.w3.org/2000/svg" class="icon icon-tabler icon-tabler-gift" width="24"
                                height="24" viewBox="0 0 24 24" stroke-width="2" stroke="currentColor" fill="none"
                                stroke-linecap="round" stroke-linejoin="round">
                                <path stroke="none" d="M0 0h24v24H0z" fill="none"></path>
                                <rect x="3" y="8" width="18" height="4" rx="1"></rect>
                                <line x1="12" y1="8" x2="12" y2="21"></line>
                                <path d="M19 12v7a2 2 0 0 1 -2 2h-10a2 2 0 0 1 -2 -2v-7"></path>
                                <path
                                    d="M7.5 8a2.5 2.5 0 0 1 0 -5a4.8 8 0 0 1 4.5 5a4.8 8 0 0 1 4.5 -5a2.5 2.5 0 0 1 0 5">
                                </path>
                            </svg>
                        </a>
                    </div>
                </div>
            </div>
        </div>
    </div>
    <div class="page-body">
        <div class="container-xl">
            <div class="row row-deck row-cards">
                <div class="col-12">
                    <div class="card">
                        <div class="table-responsive">
                            <table id="data_table" class="table card-table table-vcenter text-nowrap datatable">
                                <thead>
                                    <tr>
                                        <th>operation</th>
                                        <th>Name of commodity</th>
                                        <th>The billing state</th>
                                        <th>Method of payment</th>
                                        <th>The bill number</th>
                                        <th>Commodity type</th>
                                        <th>Commodity price</th>
                                        <th>Promo code</th>
                                        <th>The bill amount</th>
                                        <th>Creation time</th>
                                        <th>Payment time</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    {foreach $orders as $order}
                                        <tr>
                                            <td>
                                                <a href="/user/order/{$order->no}">details</a>
                                            </td>
                                            <td>{$order->product_name}</td>
                                            <td>{$order->judgmentOrderStatus($order->order_status, $order->expired_at, true)}</td>
                                            <td>{$order->order_payment}</td>
                                            <td>{$order->no}</td>
                                            <td>{$order->product_type}</td>
                                            <td>{sprintf("%.2f", $order->product_price / 100)}</td>
                                            <td>{(empty($order->order_coupon)) ? 'null' : $order->order_coupon}</td>
                                            <td>{sprintf("%.2f", $order->order_price / 100)}</td>
                                            <td>{date('Y-m-d H:i:s', $order->created_at)}</td>
                                            {if $order->order_status == 'paid'}
                                                <td>{date('Y-m-d H:i:s', $order->paid_at)}</td>
                                            {else}
                                                <td>null</td>
                                            {/if}
                                        </tr>
                                    {/foreach}
                                </tbody>
                            </table>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <div class="modal modal-blur fade" id="redeem-dialog" tabindex="-1" role="dialog" aria-hidden="true">
        <div class="modal-dialog modal-dialog-centered modal-dialog-scrollable" role="document">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title">Cash gift CARDS</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <div class="modal-body">
                    <div class="form-group mb-3 row">
                        <label class="form-label col-3 col-form-label">The gift card</label>
                        <div class="col">
                            <input id="card" type="text" class="form-control" placeholder="Enter or paste the gift code here">
                        </div>
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn me-auto" data-bs-dismiss="modal">cancel</button>
                    <button id="redeem-button" type="button" class="btn btn-primary" data-bs-dismiss="modal">exchange</button>
                </div>
            </div>
        </div>
    </div>

    <script>
        $('#data_table').DataTable({
            'iDisplayLength': 25,
            'scrollX': true,
            'order': [
                [9, 'desc']
            ],
            "dom": "<'row px-3 py-3'<'col-sm-12 col-md-6'l><'col-sm-12 col-md-6'f>>" +
                "<'row'<'col-sm-12'tr>>" +
                "<'row card-footer d-flex align-items-center'<'col-sm-12 col-md-5'i><'col-sm-12 col-md-7'p>>",
            language: {
                "sProcessing": "In the processing...",
                "sLengthMenu": "According articleo _MENU_ article",
                "sZeroRecords": "No matching results",
                "sInfo": "According to the first _START_ to _END_ A result, altogether _TOTAL_itemitem",
                "sInfoEmpty": "According to the first 0 to 0 A result, altogether 0 item",
                "sInfoFiltered": "(by _MAX_In the filterThe filter)",
                "sInfoPostFix": "",
                "sSearch": "<i class=\"ti ti-search\"></i> ",
                "sUrl": "",
                "sEmptyTable": "The data in the table is empty",
                "sLoadingRecords": "In the load...",
                "sInfoThousands": ",",
                "oPaginate": {
                    "sFirst": "Home page",
                    "sPrevious": "<i class=\"ti ti-arrow-left\"></i>",
                    "sNext": "<i class=\"ti ti-arrow-right\"></i>",
                    "sLast": "At the end of the page"
                },
                "oAria": {
                    "sSortAscending": ": In ascending order",
                    "sSortDescending": ": In descending order"
                }
            },
            fnRowCallback: adjustStyle,
        });

        $("#redeem-button").click(function() {
            $.ajax({
                type: "POST",
                url: "/user/redeem",
                dataType: "json",
                data: {
                    card: $('#card').val()
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
            location.reload();
        });

        function adjustStyle() {
            $("td:contains('Have to pay')").css("color", "green");
            $("td:contains('abnormal')").css("color", "red");
            $("td:contains('Waiting for the payment')").css("color", "orange");
            $("td:contains('null')").css("font-style", "italic");
        }
    </script>

{include file='user/tabler_footer.tpl'}
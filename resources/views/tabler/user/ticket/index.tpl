{include file='user/tabler_header.tpl'}

<div class="page-wrapper">
    <div class="container-xl">
        <div class="page-header d-print-none text-white">
            <div class="row align-items-center">
                <div class="col">
                    <h2 class="page-title">
                        <span class="home-title my-3">Workers single-row table</span>
                    </h2>
                    <div class="page-pretitle">
                        <span class="home-subtitle">Here you can contact the administrator for support</span>
                    </div>
                </div>
                <div class="col-auto ms-auto d-print-none">
                    <div class="btn-list">
                        <a href="#" class="btn btn-primary d-none d-sm-inline-block" data-bs-toggle="modal"
                            data-bs-target="#create-ticket">
                            <i class="icon ti ti-plus"></i>
                            Create a work order
                        </a>
                        <a href="#" class="btn btn-primary d-sm-none btn-icon" data-bs-toggle="modal"
                            data-bs-target="#create-ticket">
                            <i class="icon ti ti-plus"></i>
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
                    <div class="row row-cards row-deck">
                        {if $tickets !== 0}
                            {foreach $tickets as $ticket}
                                <div class="col-md-4 col-sm-12">
                                    <div class="card">
                                        <div class="card-body">
                                            <div class="card-stamp">
                                                {if $ticket->status !== 'closed'}
                                                <div class="card-stamp-icon bg-yellow">
                                                    <i class="ti ti-clock"></i>
                                                </div>
                                                {else}
                                                <div class="card-stamp-icon bg-green">
                                                    <i class="ti ti-check"></i>
                                                </div>
                                                {/if}
                                            </div>
                                            <h3 class="card-title" style="font-size: 20px;">
                                                #{$ticket->id}
                                            </h3>
                                            <p class="text-muted text-truncate" style="height: 100px;">
                                                {$ticket->title}
                                            </p>
                                        </div>
                                        <div class="card-footer">
                                            <div class="d-flex">
                                                <!-- Work order status label -->
                                                <span class="status status-grey">{$ticket->status}</span>
                                                <!-- Work order type label -->
                                                <span class="status status-grey">{$ticket->type}</span>
                                                <a href="/user/ticket/{$ticket->id}/view"
                                                    class="btn btn-primary ms-auto">To view</a>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            {/foreach}
                        {else}
                        <div class="card">
                            <div class="card-header">
                                <h3 class="card-title">No work order</h3>
                            </div>
                            <div class="card-body">If you need help, please click the button to open new work order</div>
                        </div>
                        {/if}
                    </div>
                </div>
            </div>
        </div>
    </div>

    <div class="modal modal-blur fade" id="create-ticket" tabindex="-1" role="dialog" aria-hidden="true">
        <div class="modal-dialog modal-dialog-centered modal-dialog-scrollable" role="document">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title">Create a work order</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <div class="modal-body">
                    <div class="mb-3">
                        <select id="ticket-type" class="form-select">
                            <option value="0">Please choose work order type</option>
                            <option value="howto">use</option>
                            <option value="billing">financial</option>
                            <option value="account">account</option>
                            <option value="other">other</option>
                        </select>
                    </div>
                    <div class="mb-3">
                        <input id="ticket-title" type="text" class="form-control" placeholder="Please enter a single theme">
                    </div>
                    <div class="mb-3">
                        <textarea id="ticket-comment" class="form-control" rows="12" placeholder="Please enter a work order"></textarea>
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn me-auto" data-bs-dismiss="modal">cancel</button>
                    <button id="create-ticket-button" type="button" class="btn btn-primary"
                        data-bs-dismiss="modal">create</button>
                </div>
            </div>
        </div>
    </div>

    <script>
        $("#create-ticket-button").click(function() {
            $.ajax({
                type: "POST",
                url: "/user/ticket",
                dataType: "json",
                data: {
                    title: $('#ticket-title').val(),
                    comment: $('#ticket-comment').val(),
                    type: $('#ticket-type').val(),
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
    </script>

{include file='user/tabler_footer.tpl'}
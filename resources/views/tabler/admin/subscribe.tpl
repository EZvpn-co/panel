{include file='admin/tabler_header.tpl'}

<div class="page-wrapper">
    <div class="container-xl">
        <div class="page-header d-print-none text-white">
            <div class="row align-items-center">
                <div class="col">
                    <h2 class="page-title">
                        <span class="home-title my-3">Subscribe to the record</span>
                    </h2>
                    <div class="page-pretitle">
                        <span class="home-subtitle">Check the user subscription record</span>
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
                                        {foreach $details['field'] as $key => $value}
                                            <th>{$value}</th>
                                        {/foreach}
                                    </tr>
                                </thead>
                            </table>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <script>
        var table = $('#data_table').DataTable({
            "serverSide": true,
            "searching": false,
            "ordering": false,
            ajax: {
                url: '/admin/subscribe/ajax',
                type: 'POST',
                dataSrc: 'subscribes.data'
            },
            "autoWidth":false,
            'iDisplayLength': 10,
            'scrollX': true,
            'order': [
                [0, 'desc']
            ],
            columns: [
                {foreach $details['field'] as $key => $value}
                { data: '{$key}' },
                {/foreach}
            ],
            "dom": "<'row px-3 py-3'<'col-sm-12 col-md-6'l><'col-sm-12 col-md-6'f>>" +
                "<'row'<'col-sm-12'tr>>" +
                "<'row card-footer d-flex d-flexalign-items-center'<'col-sm-12 col-md-5'i><'col-sm-12 col-md-7'p>>",
            language: {
                "sProcessing": "In the processing...",
                "sLengthMenu": "According articleo _MENU_ article",
                "sZeroRecords": "No matching results",
                "sInfo": "The first _START_ to _END_ A result, altogether _TOTAL_item",
                "sInfoEmpty": "The first 0 to 0 A result, altogether 0 item",
                "sInfoFiltered": "(in _MAX_ Find the item)",
                "sInfoPostFix": "",
                "sSearch": "<i class=\"ti ti-search\"></i> ",
                "sUrl": "",
                "sEmptyTable": "The data in the table is empty",
                "sLoadingRecords": "In the load...",
                "sInfoThousands": ",",
                "oPaginate": {
                    "sFirst": "Home page",
                    "sPrevious": "<i class=\"titi-arrow-left\"></i>",
                    "sNext": "<i class=\"ti ti-arrow-right\"><i>",
                    "sLast": "At the end of the page"
                },
                "oAria": {
                    "sSortAscending": ": In ascending order",
                    "sSortDescending": ": In descending order"
                }
            },
        });

        function loadTable() {
            table;
        }

        loadTable();
    </script>

{include file='admin/tabler_footer.tpl'}

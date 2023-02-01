{include file='user/tabler_header.tpl'}

<div class="page-wrapper">
    <div class="container-xl">
        <div class="page-header d-print-none text-white">
            <div class="row align-items-center">
                <div class="col">
                    <h2 class="page-title">
                        <span class="home-title">Announcement</span>
                    </h2>
                    <div class="page-pretitle my-3">
                        <span class="home-subtitle">All of the announcement</span>
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
                            <table class="table table-vcenter card-table">
                                <thead>
                                    <tr>
                                        <th>ID</th>
                                        <th>Publish date</th>
                                        <th>Content</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    {foreach $anns as $ann}
                                        <tr>
                                            <td>{$ann->id}</td>
                                            <td>{$ann->date}</td>
                                            <td>{$ann->content}</td>
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

{include file='user/tabler_footer.tpl'}
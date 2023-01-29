{include file='user/tabler_header.tpl'}

<div class="page-wrapper">
    <div class="container-xl">
        <div class="page-header d-print-none text-white">
            <div class="row align-items-center">
                <div class="col">
                    <h2 class="page-title">
                        <span class="home-title">Audit records</span>
                    </h2>
                    <div class="page-pretitle my-3">
                        <span class="home-subtitle">All audit records in the system</span>
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
                                        <th>nodeID</th>
                                        <th>The name of the node</th>
                                        <th>The rulesID</th>
                                        <th>The name of the</th>
                                        <th>describe</th>
                                        <th>Regular expressions</th>
                                        <th>type</th>
                                        <th>time</th>
                                    </tr>
                                </thead>
                                <tbody>
                                {foreach $logs as $log}
                                    {assign var="rule" value=$log->rule()}
                                    {if $rule != null}
                                        <tr>
                                            <td>#{$log->id}</td>
                                            <td>{$log->node_id}</td>
                                            <td>{$log->Node()->name}</td>
                                            <td>{$log->list_id}</td>
                                            <td>{$rule->name}</td>
                                            <td>{$rule->text}</td>
                                            <td>{$rule->regex}</td>
                                            {if $rule->type == 1}
                                                <td>Packet plaintext matches</td>
                                            {/if}
                                            {if $rule->type == 2}
                                                <td>The packet hex matching</td>
                                            {/if}
                                            <td>{date('Y-m-d H:i:s',$log->datetime)}</td>
                                        </tr>
                                    {/if}
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

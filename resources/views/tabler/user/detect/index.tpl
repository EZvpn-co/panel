{include file='user/tabler_header.tpl'}

<!-- Auditing rules are used to preventDMCAandSpam, not to give the user to build a wall to use, do not think that the "illegal websites" wall, was caught prison sentence even less of a day -->
<div class="page-wrapper">
    <div class="container-xl">
        <div class="page-header d-print-none text-white">
            <div class="row align-items-center">
                <div class="col">
                    <h2 class="page-title">
                        <span class="home-title">Auditing rules</span>
                    </h2>
                    <div class="page-pretitle my-3">
                        <span class="home-subtitle">Used in the current site audit rules</span>
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
                        <div class="card-body">
                            <div class="m-0 my-2">
                                <p>In order to prevent abuse and to ensure that the site can stable operation, formulated the following filtering rules, when you use node performs these actions, your communication will be truncated.</p>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="col-12">
                    <div class="card">
                        <div class="table-responsive">
                            <table class="table table-vcenter card-table">
                                <thead>
                                    <tr>
                                        <th>ID</th>
                                        <th>The name of the</th>
                                        <th>describe</th>
                                        <th>Regular expressions</th>
                                        <th>type</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    {foreach $rules as $rule}
                                    <tr>
                                        <td>#{$rule->id}</td>
                                        <td>{$rule->name}</td>
                                        <td>{$rule->text}</td>
                                        <td>{$rule->regex}</td>
                                        {if $rule->type == 1}
                                            <td>Packet plaintext matches</td>
                                        {/if}
                                        {if $rule->type == 2}
                                            <td>The packet hex matching</td>
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
    
{include file='user/tabler_footer.tpl'}

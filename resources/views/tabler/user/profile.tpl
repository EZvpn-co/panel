{include file='user/tabler_header.tpl'}

<div class="page-wrapper">
    <div class="container-xl">  
        <div class="page-header d-print-none text-white">
            <div class="row align-items-center">
                <div class="col">     
                    <h2 class="page-title">
                        <span class="home-title">Account information</span>
                    </h2>
                    <div class="page-pretitle my-3">
                        <span class="home-subtitle">Browse the latest login and use the records</span>
                    </div>
                </div>
            </div>
        </div>
    </div>
    <div class="page-body">
        <div class="container-xl">
            <div class="row row-deck">
                <div class="col-sm-6 col-lg-3">
                    <div class="card">
                        <div class="card-body">
                            <div class="d-flex align-items-center">
                                <div class="subheader">Email</div>
                            </div>
                            <div class="h1 mb-3">{$user->email}</div>
                        </div>
                    </div>
                </div>
                <div class="col-sm-6 col-lg-3">
                    <div class="card">
                        <div class="card-body">
                            <div class="d-flex align-items-center">
                                <div class="subheader">Nickname</div>
                            </div>
                            <div class="h1 mb-3">{$user->user_name}</div>
                        </div>
                    </div>
                </div>
                <div class="col-sm-6 col-lg-3">
                    <div class="card">
                        <div class="card-body">
                            <div class="d-flex align-items-center">
                                <div class="subheader">Registration time</div>
                            </div>
                            <div class="h1 mb-3">{$user->reg_date}</div>
                        </div>
                    </div>
                </div>
                <div class="col-sm-6 col-lg-3">
                    <div class="card">
                        <div class="card-body">
                            <div class="d-flex align-items-center">
                                <div class="subheader">Total traffic</div>
                            </div>
                            <div class="h1 mb-3">{round($user->transfer_total / 1073741824,2)} GB</div>
                        </div>
                    </div>
                </div>
            </div>
            <div class="row row-deck my-3">
                <div class="col-md-6 com-sm-12">
                    <div class="card">
                        <div class="card-header">
                            <h3 class="card-title">Recent login</h3>
                        </div>
                        <div class="table-responsive">
                            <table class="table table-vcenter text-nowrap card-table">
                                <thead>
                                    <tr>
                                        <th>IP</th>
                                        <th>Time</th>
                                        <th>Attribution</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    {foreach $userloginip as $login}
                                        <tr>
                                            <td>{$login->ip}</td>
                                            <td>{date('Y-m-d H:i:s', $login->datetime)}</td>
                                            <td></td>
                                            <!-- <td>{Tools::getIpInfo($login->ip)}</td> -->
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
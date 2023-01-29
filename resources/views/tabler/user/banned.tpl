{include file='user/tabler_header.tpl'}

<div class="page-wrapper">
    <div class="container-xl">
        <div class="page-header d-print-none text-white">
            <div class="row align-items-center">
                <div class="col">
                    <h2 class="page-title">
                        <span class="home-title">Account has been banned</span>
                    </h2>
                    <div class="page-pretitle my-3">
                        <span class="home-subtitle">Your account form has been disabled, and banned visitors center</span>
                    </div>
                </div>
            </div>
        </div>
    </div>
    <div class="page-body">
        <div class="container-xl">
            <div class="row row-deck row-cards">
                <div class="col-sm-12 col-lg-12">
                    <div class="card">
                        <div class="empty">
                            <div class="empty-img">
                                <i class="ti ti-circle-x icon mb-2 text-danger icon-lg" style="font-size:3.5rem;"></i>
                            </div>
                            {if $banned_reason == null}
                            <p class="empty-title">The system account</p>
                            <p class="empty-subtitle text-muted">Your account is automatically banned, please contact your administrator</p>
                            {else}
                            <p class="empty-title">The following is the reason why you were banned</p>
                            <p class="empty-subtitle text-muted">{$banned_reason}</p>
                            {/if}
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
    
{include file='user/tabler_footer.tpl'}
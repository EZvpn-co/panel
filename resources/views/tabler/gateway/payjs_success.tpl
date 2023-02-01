{include file='user/main.tpl'}

<main class="content">
    <div class="content-header ui-content-header">
        <div class="container">
            <h1 class="content-heading">Top-up results</h1>
        </div>
    </div>
    <div class="container">
        <section class="content-inner margin-top-no">
            <div class="col-lg-12 col-md-12">
                <div class="card margin-bottom-no">
                    <div class="card-main">
                        <div class="card-inner">
                            {if ($success == 1)}
                                <p>Have top-up success {$money}$!Please enter the <a href="/user/shop">Plan to buy</a> Page to choose your meal.</p>
                            {else}
                                <p>Is processing your payment, please wait a moment.This page will automatically refresh, or you can choose to shut down the page, the balance will automatically to the bill</p>
                                <script>
                                    setTimeout('window.location.reload()', 5000);
                                </script>
                            {/if}
                        </div>
                    </div>
                </div>
            </div>
        </section>
    </div>
</main>

{include file='user/footer.tpl'}
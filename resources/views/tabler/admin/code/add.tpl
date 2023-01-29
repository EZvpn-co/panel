{include file='admin/main.tpl'}

<main class="content">
    <div class="content-header ui-content-header">
        <div class="container">
            <h1 class="content-heading">Add a prepaid phone code</h1>
        </div>
    </div>
    <div class="container">
        <div class="col-lg-12 col-md-12">
            <section class="content-inner margin-top-no">
                <div class="card">
                    <div class="card-main">
                        <div class="card-inner">
                            <div class="form-group form-group-label">
                                <label class="floating-label" for="amount">The number of</label>
                                <input class="form-control maxwidth-edit" id="amount" type="text" value="1">
                            </div>
                            <div class="form-group form-group-label">
                                <label class="floating-label" for="face_value">denomination</label>
                                <input class="form-control maxwidth-edit" id="face_value" type="text">
                            </div>
                            <div class="form-group form-group-label">
                                <div class="form-group form-group-label">
                                    <label class="floating-label" for="code_length">Top-up code length</label>
                                    <select id="code_length" class="form-control maxwidth-edit" name="code_length">
                                        <option value="12">12 position</option>    
                                        <option value="18" selected>18 position</option>
                                        <option value="24">24 position</option>
                                        <option value="30">30 position</option>
                                        <option value="36">36 position</option>
                                    </select>
                                </div>
                            </div>
                            <p class="form-control-guide"><i class="mdi mdi-information"></i>Generate top-up code will be sent to your mailbox (need to mail a letter parameters have been set, ahead of schedule and test mail to succeed)</p>
                        </div>
                    </div>
                </div>
                <div class="card">
                    <div class="card-main">
                        <div class="card-inner">
                            <div class="form-group">
                                <div class="row">
                                    <div class="col-md-10 col-md-push-1">
                                        <button id="submit" type="submit"
                                            class="btn btn-block btn-brand waves-attach waves-light">add
                                        </button>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
                {include file='dialog.tpl'}
            </section>
        </div>
    </div>
</main>

{include file='admin/footer.tpl'}

<script>
    window.addEventListener('load', () => {
        function submit() {
            $.ajax({
                type: "POST",
                url: "/admin/code",
                dataType: "json",
                data: {
                    amount: $$getValue('amount'),
                    face_value: $$getValue('face_value'),
                    code_length: $$getValue('code_length'),
                },
                success: data => {
                    if (data.ret) {
                        $("#result").modal();
                        $$.getElementById('msg').innerHTML = data.msg;
                        window.setTimeout("location.href=top.document.referrer", 1500);
                    } else if (data.ret == 0) {
                        $("#result").modal();
                        $$.getElementById('msg').innerHTML = data.msg;
                    } else {
                        $("#msg-error").hide(10);
                        $("#msg-error").show(100);
                        $$.getElementById('msg').innerHTML = `${ldelim}data.msg{rdelim} An error occurred.`;
                    }
                },
                error: jqXHR => {
                    $("#result").modal();
                    $$.getElementById('msg').innerHTML = `An error occurred:${
                        jqXHR.status
                    }`;
                }
            });
        }
        $("html").keydown(event => {
            if (event.keyCode === 13) {
                submit();
            }
        });
        $$.getElementById('submit').addEventListener('click', submit);
    })
</script>
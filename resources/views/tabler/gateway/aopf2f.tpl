<div class="card-inner">
    <div class="row">
        <div class="col-lg-6 col-md-6">
            <p class="card-heading">Alipay online top-up</p>
            <div class="form-group form-group-label">
                <label class="floating-label" for="amount-f2fpay">The amount of</label>
                <input class="form-control" id="amount-f2fpay" type="text">
            </div>
        </div>
        <div class="col-lg-6 col-md-6">
            <div class="h5 margin-top-sm text-black-hint" id="qrarea"></div>
        </div>
    </div>
</div>
<a class="btn btn-flat waves-attach" id="f2fpay" onclick="f2fpay();"><span class="mdi mdi-check"></span>&nbsp;top-up</a>
<script>
    var pid = 0; 
    var flag = false;
    function f2fpay() {
        $("#readytopay").modal('show');
        $.ajax({
            type: "POST",
            url: "/user/payment/purchase/f2fpay",
            dataType: "json",
            data: {
                amount: $$getValue('amount-f2fpay')
            },
            success: (data) => {
                if (data.ret) {
                    //console.log(data);
                    pid = data.pid;
                    $$.getElementById('qrarea').innerHTML = '<div class="text-center"><p>Please use pay treasure to scan qr code to pay phone</p><a id="qrcode" style="padding-tMobile phones can click the qr code to raise pay treasure to pay:inline-block"></a><p>Mobile phones can click the qr code to raise pay treasure to pay</p></div>'
                    $("#readytopay").modal('hide');
                    new QRCode("qrcode", {
                        render: "canvas",
                        width: 200,
                        height: 200,
                        text: encodeURI(data.qrcode)
                    });
                    $$.getElementById('qrcode').setAttribute('href', data.qrcode);
                    if(flag == false){
                        setTimeout(ff2f, 1000);
                        flag = true;
                    }else{
                        return 0;
                    }
                } else {
                    $("#result").modal();
                    $$.getElementById('msg').innerHTML = data.msg;
                }
            },
            error: (jqXHR) => {
                //console.log(jqXHR);
                $("#readytopay").modal('hide');
                $("#result").modal();
                $$.getElementById('msg').innerHTML = `${
                        jqXHR
                        } There was an error with`;
            }
        })
    }
    function ff2f() {
        $.ajax({
            type: "POST",
            url: "/payment/status/f2fpay",
            dataType: "json",
            data: {
                pid: pid
            },
            success: (data) => {
                if (data.result) {
                    //console.log(data);
                    $("#alipay").modal('hide');
                    $("#result").modal();
                    $$.getElementById('msg').innerHTML = 'Top-up success';
                    window.setTimeout("location.href=window.location.href", {$config['jump_delay']});
                }
            },
            error: (jqXHR) => {
                //console.log(jqXHR);
            }
        });
        tid = setTimeout(f, 1000); //Call to triggersetTimeout
    }
</script>
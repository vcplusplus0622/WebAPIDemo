<%@ Page Title="Secugen-Demo1" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeFile="Demo1.aspx.cs" Inherits="Demo1" %>
<asp:Content ID="BodyContent" ContentPlaceHolderID="MainContent" runat="server">


<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <title>Demo1</title>
</head>
<body>
    <div class="row">
        <div class="col-md-8">
            <h6>
                <p>
                    <b>HTML page showing single fingerprint scanning.   You can easily retrieve the image data, template, serial number, NFIQ value and other relevant information in a single call.</b>
                </p>
            </h6>
        </div>
    </div>
    <div class="row">
        <table width="1012" border="0" align="center" cellpadding="0" cellspacing="0">      
            <tr>
                <td class="style2">
                    &nbsp;</td>
                <td class="style3" align="left"><span class="download_href"> 
                   <center>
            <img border="2" id="FPImage1" alt="Fingerpint Image" height=300 width=210 src="" > <br>
            <input type="button" value="Click to Scan" onclick="captureFP()"><br>
            <br>
            <div style=" color:black; padding:20px;">
            <p id="result"> </p>
            </div>
            </center>
        .</span></td>
                <td>
                    &nbsp;</td>
            </tr>
            <tr>
                <td class="style2">
                    &nbsp;</td>
                <td class="style3">&nbsp;</td>
                <td>
                    &nbsp;</td>
            </tr>
        </table>
    </div>

<script type="text/javascript">

function captureFP() {
    CallSGIFPGetData(SuccessFunc, ErrorFunc);
}

/* 
    This functions is called if the service sucessfully returns some data in JSON object
 */
function SuccessFunc(result) {
    if (result.ErrorCode == 0) {
        /* 	Display BMP data in image tag
            BMP data is in base 64 format 
        */
        if (result != null && result.BMPBase64.length > 0) {
            document.getElementById("FPImage1").src = "data:image/bmp;base64," + result.BMPBase64;
        }
        var tbl = "<table border=1>";
        tbl += "<tr>";
        tbl += "<td> Serial Number of device </td>";
        tbl += "<td> <b>" + result.SerialNumber + "</b> </td>";
        tbl += "</tr>";
        tbl += "<tr>";
        tbl += "<td> Image Height</td>";
        tbl += "<td> <b>" + result.ImageHeight + "</b> </td>";
        tbl += "</tr>";
        tbl += "<tr>";
        tbl += "<td> Image Width</td>";
        tbl += "<td> <b>" + result.ImageWidth + "</b> </td>";
        tbl += "</tr>";
        tbl += "<tr>";
        tbl += "<td> Image Resolution</td>";
        tbl += "<td> <b>" + result.ImageDPI + "</b> </td>";
        tbl += "</tr>";
        tbl += "<tr>";
        tbl += "<td> Image Quality (1-100)</td>";
        tbl += "<td> <b>" + result.ImageQuality + "</b> </td>";
        tbl += "</tr>";
        tbl += "<tr>";
        tbl += "<td> NFIQ (1-5)</td>";
        tbl += "<td> <b>" + result.NFIQ + "</b> </td>";
        tbl += "</tr>";
        tbl += "<tr>";
        tbl += "<td> Template(base64)</td>";
        tbl += "<td> <b> <textarea rows=8 cols=50>" + result.TemplateBase64 + "</textarea></b> </td>";
        tbl += "</tr>";
        tbl += "</table>";
        document.getElementById('result').innerHTML = tbl;
    }
    else {
        alert("Fingerprint Capture ErrorCode " + result.ErrorCode)
    }
}

function ErrorFunc(status) {

    /* 	
        If you reach here, user is probabaly not running the 
        service. Redirect the user to a page where he can download the
        executable and install it. 
    */
    alert("Check if SGIBIOSRV is running ");

}


function CallSGIFPGetData(successCall, failCall) {
    var uri = "http://localhost:8000/SGIFPCapture";

    var xmlhttp = new XMLHttpRequest();
    xmlhttp.onreadystatechange = function () {
        if (xmlhttp.readyState == 4 && xmlhttp.status == 200) {
            fpobject = JSON.parse(xmlhttp.responseText);
            successCall(fpobject);
        }
        else if (xmlhttp.status == 404) {
            failCall(xmlhttp.status)
        }
    }
    xmlhttp.onerror = function () {
        failCall(xmlhttp.status);
    }
    xmlhttp.open("POST", uri, true);
    xmlhttp.send();
}


</script>
</body>
</html>
</asp:Content>
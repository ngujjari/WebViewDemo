package com.syf.unifidemoandroid

import android.content.Context
import android.content.Intent
import android.graphics.Bitmap
import android.net.Uri
import android.os.Bundle
import android.util.Log
import android.webkit.*
import androidx.appcompat.app.AppCompatActivity

class SyfPageActivity : AppCompatActivity() {
    private val TAG = "SyfPageActivity"
    // private val url = "https://ppdpone.syfpos.com/mit/?widgetload=y&amount=100&flowType=pdp&partnerId=PI53421676&calcLoadTime=N";
   // private val url = "https://ppdpone.syfpos.com/mpp/mpp?partnerId=PI53421676&amount=800&syfToken=MPP16706334026627PI53421676&productCategoryNames=&flowType=PDP&cid=unifitest&adobe_mc=MCMID%3D11699604732310737292115892261680123387%7CMCORGID%3D22602B6956FAB4777F000101%2540AdobeOrg%7CTS%3D1670633403&_ga=2.172105827.1545651286.1670631858-1876618331.1669861855"
    private val url = "http://192.168.86.25"

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_syf_page)
        // Custom code..
        val syfWebView = findViewById<WebView>(R.id.syfWebView)
        val webSettings = syfWebView.settings
        webSettings.javaScriptEnabled = true
        webSettings.allowFileAccess = true
        webSettings.domStorageEnabled = true
        webSettings.javaScriptCanOpenWindowsAutomatically = true
        webSettings.supportMultipleWindows()

        Log.v(TAG, "onCreate url=" + url);
        syfWebView.loadUrl(url)
        syfWebView.addJavascriptInterface(UnifiAndroidJavascriptIntf(this), "UnifiAndroidJSIntf")

        syfWebView.webViewClient = UnifiWebViewClient()
        WebView.setWebContentsDebuggingEnabled(false)
    }

    private inner class UnifiWebViewClient : WebViewClient() {
        override fun shouldOverrideUrlLoading(view: WebView, url: String): Boolean {
            Log.v(TAG, "shouldOverrideUrlLoading url=" + url);
            return if (url != null && (url.startsWith("https://dpdpone.syfpos.com/cs/")
                        || url.startsWith("https://www.synchrony.com/"))) {
                view.context.startActivity(
                    Intent(Intent.ACTION_VIEW, Uri.parse(url))
                )
                true
            } else {
                false // open in-app
            }
        }
        override fun onPageStarted(view: WebView, url: String?, favicon: Bitmap?) {
           // showProgress(true)
            Log.v(TAG, "onPageStarted url=" + url);
            var jsonPayloadScript = "var jsonObj = {syfPartnerId:\"PI53421676\"," +
                    "tokenId:\"1850ed2d835PI5342167614545\"," +
                    "encryptKey:\"\",modalType:\"\",childMid:\"\",childPcgc:\"\",childTransType:\"\",pcgc:\"\",partnerCode:\"\",clientToken:\"\",postbackid:\"d979e5b7-6382-4e4e-b269-aab027bbed58\",clientTransId:\"\",cardNumber:\"\",custFirstName:\"\",custLastName:\"\",expMonth:\"\",expYear:\"\",custZipCode:\"\",custAddress1:\"\",phoneNumb:\"\",appartment:\"\",emailAddr:\"\",custCity:\"\",upeProgramName:\"\",custState:\"\",transPromo1:\"\",iniPurAmt:\"\",mid:\"\",productCategoryNames:\"\",transAmount1:\"700\",transAmounts:\"\",initialAmount:\"\",envUrl:\"https://dpdpone.syfpos.com/mitservice/\",productAttributes:\"\",processInd:\"3\"}"
            view.evaluateJavascript(jsonPayloadScript, null)
            super.onPageStarted(view, url, favicon)
        }
        override fun onPageFinished(view: WebView, url: String) {
            // TODO Auto-generated method stub
            super.onPageFinished(view, url)
            Log.v(TAG, "onPageFinished url=" + url);
        }
        override fun onReceivedError(
            view: WebView,
            request: WebResourceRequest,
            error: WebResourceError
        ) {
            val errorMessage = "Got Error! $error"
            Log.v(TAG, "onReceivedError =" + errorMessage);
            super.onReceivedError(view, request, error)
        }
    }

    private inner class UnifiAndroidJavascriptIntf(private val context: Context) {
        private val TAG = "UnifiAndroidJavascriptI"
        @JavascriptInterface
        fun setStatusMessageFromJS(message: String) {
           // Toast.makeText(context, message, Toast.LENGTH_SHORT).show()
            Log.v(TAG, "receiveMessage =" + message);
            val intent = Intent(context, MainActivity::class.java)
            context.startActivity(intent)
        }
    }
}

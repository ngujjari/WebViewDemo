package com.syf.unifidemoandroid

import android.content.Intent
import android.net.Uri
import android.os.Bundle
import android.util.Log
import android.webkit.WebView
import android.webkit.WebViewClient
import androidx.appcompat.app.AppCompatActivity

class MerchantPageActivity : AppCompatActivity() {
    private val TAG = "MerchantPageActivity"
    private val url = "https://ppdpone.syfpos.com/mit/?externalLogin=Y";

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_merchant_page)

        val mWebView = findViewById<WebView>(R.id.webview)

        val webSettings = mWebView.settings
        webSettings.javaScriptEnabled = true
        webSettings.allowFileAccess = true
        webSettings.domStorageEnabled = true
        webSettings.javaScriptCanOpenWindowsAutomatically = true
        webSettings.supportMultipleWindows()

        Log.v(TAG, "onCreate url=" + url);
        mWebView.loadUrl(url)
        mWebView.webViewClient = MyWebViewClient()
        WebView.setWebContentsDebuggingEnabled(false)
    }

    private inner class MyWebViewClient : WebViewClient() {
        override fun shouldOverrideUrlLoading(view: WebView, url: String): Boolean {
            Log.v(TAG, "shouldOverrideUrlLoading Murl=" + url);
            val intent = Intent(Intent.ACTION_VIEW, Uri.parse(url))
            startActivity(intent)
            return true
        }
        override fun onPageFinished(view: WebView, url: String) {
            // TODO Auto-generated method stub
            super.onPageFinished(view, url)
            Log.v(TAG, "onPageFinished Murl=" + url);
        }

    }
}
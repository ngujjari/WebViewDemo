package com.syf.unifidemoandroid

import android.content.Intent
import androidx.appcompat.app.AppCompatActivity
import android.os.Bundle
import android.widget.Button

class MainActivity : AppCompatActivity() {
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_main)

        // get reference to button
        val buttonClick = findViewById(R.id.button_merchant_page) as Button
        // set on-click listener
        buttonClick.setOnClickListener {
            val intent = Intent(this, MerchantPageActivity::class.java)
            startActivity(intent)
        }

        // get reference to button
        val syfButtonClick = findViewById(R.id.button_syf) as Button
        // set on-click listener
        syfButtonClick.setOnClickListener {
            val intent = Intent(this, SyfPageActivity::class.java)
            startActivity(intent)
        }


    }
}
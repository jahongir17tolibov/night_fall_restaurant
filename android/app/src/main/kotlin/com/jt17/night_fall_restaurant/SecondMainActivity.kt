package com.jt17.night_fall_restaurant

import android.content.Intent
import android.os.Bundle
import android.os.Handler
import androidx.appcompat.app.AppCompatActivity

class SecondMainActivity : AppCompatActivity() {

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.second_activity)
        Handler(mainLooper).postDelayed({
            startActivity(Intent(this, MainActivity::class.java))
        }, 3000)
    }
}
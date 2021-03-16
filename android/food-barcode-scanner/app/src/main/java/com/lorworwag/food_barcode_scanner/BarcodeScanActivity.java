package com.lorworwag.food_barcode_scanner;

import androidx.annotation.Nullable;
import androidx.appcompat.app.AppCompatActivity;
import androidx.core.app.ActivityCompat;

import android.Manifest;
import android.content.Intent;
import android.content.pm.PackageManager;
import android.os.Bundle;
import android.view.View;
import android.widget.Button;
import android.widget.TextView;
import android.widget.Toast;

//import com.google.mlkit.vision.barcode.Barcode;
//import com.google.mlkit.vision.barcode.BarcodeScanner;
//import com.google.mlkit.vision.barcode.BarcodeScannerOptions;
//import com.google.mlkit.vision.barcode.BarcodeScanning;

import com.google.zxing.integration.android.IntentIntegrator;
import com.google.zxing.integration.android.IntentResult;

public class BarcodeScanActivity extends AppCompatActivity {

    private Button btnScan;
    private Button btnGoToHome;
    private TextView txtViewBarcode;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_barcode_scan);

        btnScan = findViewById(R.id.btnScan);
        btnGoToHome = findViewById(R.id.btnGoToHome);
        txtViewBarcode = findViewById(R.id.txtViewBarcode);

        ActivityCompat.requestPermissions(this, new String[] {Manifest.permission.CAMERA }, PackageManager.PERMISSION_GRANTED);

        btnScan.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                scanButton(v);
            }
        });

        btnGoToHome.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                Intent intent = new Intent(BarcodeScanActivity.this, HomeActivity.class);
                startActivity(intent);
            }
        });
    }

    public void scanButton(View view) {
        IntentIntegrator intentIntegrator = new IntentIntegrator(this);
        intentIntegrator.initiateScan();
    }

    @Override
    protected void onActivityResult(int requestCode, int resultCode, @Nullable Intent data) {
        IntentResult intentResult = IntentIntegrator.parseActivityResult(requestCode, resultCode, data);
        if (intentResult != null) {
            if (intentResult.getContents() == null) {
                //Toast.makeText(BarcodeScanActivity.this, "Cancelled", Toast.LENGTH_SHORT).show();
                txtViewBarcode.setText("Cancelled");
            } else {
                Toast.makeText(BarcodeScanActivity.this, intentResult.getContents().toString(), Toast.LENGTH_LONG).show();
                txtViewBarcode.setText("abc");
            }
        }
        super.onActivityResult(requestCode, resultCode, data);
    }

}
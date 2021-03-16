package com.lorworwag.food_barcode_scanner;

import androidx.annotation.Nullable;
import androidx.appcompat.app.AppCompatActivity;

import android.content.Intent;
import android.os.Bundle;
import android.view.View;
import android.widget.Button;
import android.widget.TextView;
import android.widget.Toast;

import com.google.firebase.auth.FirebaseAuth;
import com.google.firebase.auth.FirebaseUser;
import com.google.zxing.integration.android.IntentIntegrator;
import com.google.zxing.integration.android.IntentResult;


public class HomeActivity extends AppCompatActivity {

    private static final String TAG = "HomeActivity";
    private FirebaseAuth mAuth;

    private Button btnScanBarcode;
    private TextView txtBarcode;
    private Button btnSignOut;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_home);

        mAuth = FirebaseAuth.getInstance();

        btnScanBarcode = findViewById(R.id.btnScanBarcode);
        txtBarcode = findViewById(R.id.txtBarcode);
        btnSignOut = findViewById(R.id.btnSignOut);

        btnScanBarcode.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                scanBarcode(v);
            }
        });

        btnSignOut.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                FirebaseUser user = mAuth.getCurrentUser();
                Toast.makeText(HomeActivity.this, "Sign out from " + user.getEmail().toString(), Toast.LENGTH_LONG).show();

                mAuth.signOut();
                Intent intent = new Intent(HomeActivity.this, MainActivity.class);
                startActivity(intent);
            }
        });
    }

    @Override
    public void onResume() {
        super.onResume();
        txtBarcode.setText("abc");
    }

    @Override
    public void onPause() {
        super.onPause();
    }


    public void scanBarcode(View view) {
        IntentIntegrator intentIntegrator = new IntentIntegrator(this);
        intentIntegrator.initiateScan();
    }

    @Override
    protected void onActivityResult(int requestCode, int resultCode, @Nullable Intent data) {
        IntentResult intentResult = IntentIntegrator.parseActivityResult(requestCode, resultCode, data);
        if (intentResult != null) {
            if (intentResult.getContents() == null) {
                Toast.makeText(HomeActivity.this, "Cancelled", Toast.LENGTH_SHORT).show();
                txtBarcode.setText("Cancelled");
            } else {
                Toast.makeText(HomeActivity.this, intentResult.getContents().toString(), Toast.LENGTH_LONG).show();
                txtBarcode.setText("abc");
            }
        }
        super.onActivityResult(requestCode, resultCode, data);
    }


    private void signOut() {
//        mAuth.signOut();
//        updateUI(null);
    }


}

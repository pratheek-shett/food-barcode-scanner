package com.lorworwag.food_barcode_scanner;

import androidx.annotation.Nullable;
import androidx.appcompat.app.AlertDialog;
import androidx.appcompat.app.AppCompatActivity;
import androidx.recyclerview.widget.GridLayoutManager;
import androidx.recyclerview.widget.LinearLayoutManager;
import androidx.recyclerview.widget.RecyclerView;

import android.content.DialogInterface;
import android.content.Intent;
import android.os.Bundle;
import android.view.View;
import android.widget.Button;
import android.widget.TextView;
import android.widget.Toast;

import com.google.firebase.auth.FirebaseAuth;
import com.google.firebase.auth.FirebaseUser;
import com.google.firebase.database.DataSnapshot;
import com.google.firebase.database.DatabaseError;
import com.google.firebase.database.DatabaseReference;
import com.google.firebase.database.FirebaseDatabase;
import com.google.firebase.database.ValueEventListener;
import com.google.zxing.integration.android.IntentIntegrator;
import com.google.zxing.integration.android.IntentResult;


public class HomeActivity extends AppCompatActivity {

    private static final String TAG = "HomeActivity";
    private FirebaseAuth mAuth;

    private Button btnScanBarcode;
    private TextView txtBarcode;
    private Button btnSignOut;
    private RecyclerView recyclerViewIngredients;
    private TextView txtIngredients;
    private RecyclerView recyclerViewNutritionFacts;
    private TextView txtNutritionFacts;
    private TextView txtProductName;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_home);

        mAuth = FirebaseAuth.getInstance();

        btnScanBarcode = findViewById(R.id.btnScanBarcode);
        txtBarcode = findViewById(R.id.txtBarcode);
        recyclerViewIngredients = findViewById(R.id.recyclerViewIngredients);
        txtIngredients = findViewById(R.id.txtIngredients);
        btnSignOut = findViewById(R.id.btnSignOut);
        recyclerViewNutritionFacts = findViewById(R.id.recyclerViewNutritionFacts);
        txtNutritionFacts = findViewById(R.id.txtNutritionFacts);
        txtProductName = findViewById(R.id.txtProductName);

        txtBarcode.setVisibility(View.INVISIBLE);
        txtIngredients.setVisibility(View.INVISIBLE);
        txtNutritionFacts.setVisibility(View.INVISIBLE);
        txtProductName.setVisibility(View.INVISIBLE);

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
//        txtBarcode.setText("abc");
    }

    @Override
    public void onPause() {
        super.onPause();
    }


    public void scanBarcode(View view) {
        IntentIntegrator intentIntegrator = new IntentIntegrator(HomeActivity.this);
        intentIntegrator.setPrompt("For flash use volume up key");
        intentIntegrator.setBeepEnabled(true);
        intentIntegrator.setOrientationLocked(true);
        intentIntegrator.setCaptureActivity(Capture.class);
        intentIntegrator.initiateScan();
    }

    @Override
    protected void onActivityResult(int requestCode, int resultCode, @Nullable Intent data) {
        super.onActivityResult(requestCode, resultCode, data);

        IntentResult intentResult = IntentIntegrator.parseActivityResult(requestCode, resultCode, data);

        if (intentResult.getContents() != null) {
//            txtBarcode.setText(intentResult.getContents());
            fetchData(intentResult.getContents());
//            AlertDialog.Builder builder = new AlertDialog.Builder(HomeActivity.this);
//            builder.setTitle("Result");
//            builder.setMessage(intentResult.getContents());
//            builder.setPositiveButton("OK", new DialogInterface.OnClickListener() {
//                @Override
//                public void onClick(DialogInterface dialog, int which) {
//                    dialog.dismiss();
//                }
//            });
//            builder.show();
        } else {
            Toast.makeText(getApplicationContext(), "OOPS... You did not scan anything", Toast.LENGTH_LONG).show();

//                txtBarcode.setText("abc");
        }

    }

    private void fetchData(String barcode) {
        FirebaseDatabase database = FirebaseDatabase.getInstance();
        DatabaseReference myRef = database.getReference("barcodes").child(barcode);


        // Read from the database
        myRef.addValueEventListener(new ValueEventListener() {
            @Override
            public void onDataChange(DataSnapshot dataSnapshot) {
                // This method is called once with the initial value and again
                // whenever data at this location is updated.
                BarcodeDataTemplate data = dataSnapshot.getValue(BarcodeDataTemplate.class);
//                txtBarcode.setText(data.getNutritionFacts().get("totalFat"));
//                txtBarcode.setText(dataSnapshot.child("productName").getValue(String.class));

                txtProductName.setText(data.getProductName());
                txtProductName.setVisibility(View.VISIBLE);

                txtBarcode.setText("Barcode No.: " + barcode);
                txtBarcode.setVisibility(View.VISIBLE);

                txtIngredients.setVisibility(View.VISIBLE);
                IngredientsRecyclerViewAdapter adapter = new IngredientsRecyclerViewAdapter();
                adapter.setIngredients(data.getIngredients());
                recyclerViewIngredients.setAdapter(adapter);
                recyclerViewIngredients.setLayoutManager(new GridLayoutManager(HomeActivity.this, 2));

                txtNutritionFacts.setVisibility(View.VISIBLE);
                NutritionFactsRecyclerViewAdapter nutritionFactsAdapter = new NutritionFactsRecyclerViewAdapter();
                nutritionFactsAdapter.setNutritionFacts(data.getNutritionFacts());
                recyclerViewNutritionFacts.setAdapter(nutritionFactsAdapter);
                recyclerViewNutritionFacts.setLayoutManager(new LinearLayoutManager(HomeActivity.this));
            }

            @Override
            public void onCancelled(DatabaseError error) {
                // Failed to read value
                Toast.makeText(HomeActivity.this, "OOPS... You did not scan anything", Toast.LENGTH_LONG).show();
            }
        });
    }

    private void signOut() {
//        FirebaseAuth.getInstance().signOut();
//        mAuth.signOut();
//        updateUI(null);
    }


}

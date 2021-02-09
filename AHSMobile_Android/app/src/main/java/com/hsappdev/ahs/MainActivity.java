package com.hsappdev.ahs;

import android.app.Activity;
import android.os.Bundle;
import android.view.MenuItem;
import android.view.View;

import com.google.android.material.bottomnavigation.BottomNavigationView;
import com.hsappdev.ahs.misc.FullScreenActivity;
import com.hsappdev.ahs.ui.dashboard.DashboardFragment;
import com.hsappdev.ahs.ui.notifications.NotificationsFragment;

import androidx.annotation.NonNull;
import androidx.appcompat.app.AppCompatActivity;
import androidx.fragment.app.Fragment;
import androidx.fragment.app.FragmentManager;
import androidx.fragment.app.FragmentTransaction;
import androidx.navigation.NavController;
import androidx.navigation.Navigation;
import androidx.navigation.ui.AppBarConfiguration;
import androidx.navigation.ui.NavigationUI;

public class MainActivity extends FullScreenActivity {

    final News_Activity home = new News_Activity();
    final DashboardFragment dash = new DashboardFragment();
    final NotificationsFragment notif = new NotificationsFragment();

    Fragment current = home;

    final FragmentManager fm = getSupportFragmentManager();

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);
        View nav_host_fragment2 = findViewById(R.id.nav_host_fragment);


        fm.beginTransaction()
                .add(R.id.nav_host_fragment, notif, "3").hide(notif)
                .add(R.id.nav_host_fragment, dash, "2").hide(dash)
                .add(R.id.nav_host_fragment,home, "1")
                .commit();
        BottomNavigationView navView = findViewById(R.id.nav_view);

        navView.setOnNavigationItemSelectedListener(new BottomNavigationView.OnNavigationItemSelectedListener() {

            @Override
            public boolean onNavigationItemSelected(@NonNull MenuItem item) {
                switch (item.getItemId()) {
                    case R.id.navigation_home:
                        fm.beginTransaction().hide(current).setTransition(FragmentTransaction.TRANSIT_FRAGMENT_FADE).commit();
                        fm.beginTransaction().show(home).setTransition(FragmentTransaction.TRANSIT_FRAGMENT_FADE).commit();
                        current = home;

                        return true;

                    case R.id.navigation_notifications:
                        fm.beginTransaction().hide(current).setTransition(FragmentTransaction.TRANSIT_FRAGMENT_FADE).commit();
                        fm.beginTransaction().show(notif).setTransition(FragmentTransaction.TRANSIT_FRAGMENT_FADE).commit();
                        current = notif;

                        return true;

                    case R.id.navigation_dashboard:
                        fm.beginTransaction().hide(current).setTransition(FragmentTransaction.TRANSIT_FRAGMENT_FADE).commit();
                        fm.beginTransaction().show(dash).setTransition(FragmentTransaction.TRANSIT_FRAGMENT_FADE).commit();
                        current = dash;

                        return true;
                }
                return false;
            }
        });
//
//        AppBarConfiguration appBarConfiguration = new AppBarConfiguration.Builder(
//                R.id.navigation_home, R.id.navigation_dashboard, R.id.navigation_notifications)
//                .build();
//
//        NavController navController = Navigation.findNavController(this, R.id.nav_host_fragment);
//        //NavigationUI.setupActionBarWithNavController(this, navController, appBarConfiguration);
//        NavigationUI.setupWithNavController(navView, navController);
    }


}
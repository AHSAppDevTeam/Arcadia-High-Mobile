package com.example.ahsapptest3;

import android.app.Activity;
import android.content.Context;
import android.content.SharedPreferences;
import android.widget.Toast;

import androidx.annotation.NonNull;

import com.google.android.gms.tasks.OnCompleteListener;
import com.google.android.gms.tasks.Task;
import com.google.firebase.messaging.FirebaseMessaging;


public class Settings {
    public static final String TEXT_SIZE_SETTING = "font_setting";
    public static final String TEXT_SIZE = "1";

    public static final String NOTIF_SETTING = "notif settings";
    public static final String GENERAL_SETTING = "1";
    public static final String SPORTS_SETTING = "2";
    public static final String ASB_SETTING = "3";
    public static final String DISTRICT_SETTING = "4";
    public static final String BULLETIN_SETTING = "5";
    public static final String MANDATORY_SETTING = "0";

    public enum TextSizeOption {
        SMALL("Small", 0), DEFAULT("Default", 1), LARGE("Large", 2), MASSIVE("MASSIVE", 3);

        private String name;
        private int numCode;
        TextSizeOption(String name, int numCode) {
            this.name = name;
            this.numCode = numCode;
        }
        public String getName() {
            return name;
        }
        public int getNumCode() {
            return numCode;
        }
        public static TextSizeOption getOptionFromNumCode(int numCode) {
            for(TextSizeOption option: values()) {
                if(option.getNumCode() == numCode)
                    return option;
            }
            return null;
        }

    }
    public enum NotifOption {
        GENERAL(GENERAL_SETTING), SPORTS(SPORTS_SETTING), ASB(ASB_SETTING), DISTRICT(DISTRICT_SETTING), BULLETIN(BULLETIN_SETTING), MANDATORY(MANDATORY_SETTING);

        private String fileKey;
        NotifOption(String fileKey) {
            this.fileKey = fileKey;
        }
        public String getFileKey() {
            return fileKey;
        }
        private boolean currentSetting;
        public boolean getCurrentSetting() {
            return currentSetting;
        }
        public void setCurrentSetting(boolean currentSetting) {
            this.currentSetting = currentSetting;
        }
    }

    private static TextSizeOption currentOption;
    public static TextSizeOption getCurrentTextSizeOption() {
        return currentOption;
    }
    public static float convertTextSize(float originalSize) {
        switch(currentOption) {
            case SMALL:
                return originalSize - 2;
            case LARGE:
                return originalSize + 3;
            case MASSIVE:
                return originalSize + 6;
            default:
            case DEFAULT:
                return originalSize;
        }
    }


    private Context context;
    private OnTextSizeOptionChanged optionChanged;
    private OnNotifOptionChanged notifOptionChanged;

    public Settings(Context context) {
        this.context = context;
        currentOption = getTextSizeOption();
        for(NotifOption notifOption: NotifOption.values()) {
            notifOption.setCurrentSetting(isNotifSettingsSelected(notifOption));
        }
    }

    public Settings(Context context, OnTextSizeOptionChanged optionChanged) {
        this(context);
        this.optionChanged = optionChanged;
    }

    public Settings(Context context, OnNotifOptionChanged notifOptionChanged) {
        this(context);
        this.notifOptionChanged = notifOptionChanged;
    }

    public Settings(Context context, OnTextSizeOptionChanged optionChanged, OnNotifOptionChanged notifOptionChanged) {
        this(context);
        this.optionChanged = optionChanged;
        this.notifOptionChanged = notifOptionChanged;
    }

    public void updateTextSize(TextSizeOption option) {
        if(currentOption != option) {
            currentOption = option;
            saveTextSizeOption(option);
            if(optionChanged != null)
                optionChanged.run();
        }
    }

    public float convertPXtoSP(float px) {
        return px/context.getResources().getDisplayMetrics().scaledDensity;
    }

    private TextSizeOption getTextSizeOption() {
        SharedPreferences sharedPrefs = context.getSharedPreferences(TEXT_SIZE_SETTING,Activity.MODE_PRIVATE);
        return TextSizeOption.getOptionFromNumCode(sharedPrefs.getInt(TEXT_SIZE, 1));
    }

    private void saveTextSizeOption(TextSizeOption option) {
        SharedPreferences.Editor editor = context.getSharedPreferences(TEXT_SIZE_SETTING, Activity.MODE_PRIVATE).edit();
        editor.putInt(Settings.TEXT_SIZE, option.getNumCode()).apply();
    }

    public boolean isNotifSettingsSelected(NotifOption option) {
        SharedPreferences sharedPrefs = context.getSharedPreferences(NOTIF_SETTING,Activity.MODE_PRIVATE);
        return sharedPrefs.getBoolean(option.getFileKey(), true);
    }

    public void updateNotifSettings(NotifOption option, boolean newSetting, boolean makeSuccessToast) {
        if(option.getCurrentSetting() != newSetting) {
            if(option == NotifOption.GENERAL)
            {
                updateNotifSettings(NotifOption.ASB, newSetting, false);
                updateNotifSettings(NotifOption.SPORTS, newSetting, false);
                updateNotifSettings(NotifOption.DISTRICT, newSetting, false);
                updateNotifSettings(NotifOption.BULLETIN, newSetting, false);
            }
            SharedPreferences.Editor editor = context.getSharedPreferences(NOTIF_SETTING, Activity.MODE_PRIVATE).edit();
            editor.putBoolean(option.getFileKey(), newSetting).apply();
            option.setCurrentSetting(newSetting);
            updateTopicSubscription(option, newSetting, makeSuccessToast);
        }

    }

    public void updateTopicSubscription(final NotifOption option, boolean subscribe, final boolean makeSuccessToast) {
        if(option == NotifOption.GENERAL)
            return;
        int stringResourceID = -1;

        switch (option) {
            case ASB:
                stringResourceID = R.string.fb_topic_asb;
                break;
            case SPORTS:
                stringResourceID = R.string.fb_topic_sports;
                break;
            case DISTRICT:
                stringResourceID = R.string.fb_topic_district;
                break;
            case BULLETIN:
                stringResourceID = R.string.fb_topic_bulletin;
                break;
            case MANDATORY:
                stringResourceID = R.string.fb_topic_mandatory;
                break;
        }
        if(stringResourceID != -1){
            if(subscribe)
                FirebaseMessaging.getInstance().subscribeToTopic(context.getResources().getString(stringResourceID))
                    .addOnCompleteListener(new OnCompleteListener<Void>() {
                        @Override
                        public void onComplete(@NonNull Task<Void> task) {
                            if(makeSuccessToast) {
                                Toast.makeText(context, "Successfully subscribed to " + option.toString(), Toast.LENGTH_SHORT).show();

                                // change this later
                            }
                            if(notifOptionChanged != null)
                                notifOptionChanged.onOptionChanged(option, true);
                        }
                    });
            else
                FirebaseMessaging.getInstance().unsubscribeFromTopic(context.getResources().getString(stringResourceID))
                    .addOnCompleteListener(new OnCompleteListener<Void>() {
                        @Override
                        public void onComplete(@NonNull Task<Void> task) {
                            if(makeSuccessToast) {
                                Toast.makeText(context, "Successfully unsubscribed to " + option.toString(), Toast.LENGTH_SHORT).show();

                                // change this later
                            }
                            if(notifOptionChanged != null)
                                notifOptionChanged.onOptionChanged(option, false);
                        }
                    });
        }
    }

    public void resubscribeToAll() {
        for(NotifOption option: NotifOption.values()) {
            if(option != NotifOption.GENERAL) {
                updateTopicSubscription(option, isNotifSettingsSelected(option), true);
            }
        }
    }

    public interface OnTextSizeOptionChanged {
        void run();
    }

    public interface OnNotifOptionChanged {
        void onOptionChanged(NotifOption option, boolean currentValue);
    }
}

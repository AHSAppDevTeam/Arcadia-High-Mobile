package com.example.ahsapptest3;

import androidx.core.content.ContextCompat;

public class Asb_News extends News_Template {
    @Override
    String[][] getData() {
        return new String[][]
                {
                        {"Lorem Ipsum a Very Long Title", "hello world what a nice day!"},
                        {"ASB NEWS Title2", "summaryText2. This is a long sample summary. This should cut off at two lines, with an ellipsis."},
                        {"Title3", "summaryText3"},
                        {"Title4", "summaryText4"},
                        {"Title5", "summaryText5"},
                        {"Title6", "summaryText6"}
                };
    }

    @Override
    String getTitleText() {
        return "ASB NEWS";
    }

    @Override
    int getBarColor() {
        return ContextCompat.getColor(getContext(),R.color.Crimson_992938__HOME);
    }
}

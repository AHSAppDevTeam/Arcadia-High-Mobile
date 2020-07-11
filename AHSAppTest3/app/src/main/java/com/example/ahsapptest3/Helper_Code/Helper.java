package com.example.ahsapptest3.Helper_Code;

import android.content.Intent;
import android.view.View;

import android.widget.ImageView;
import android.widget.TextView;

import androidx.core.content.res.ResourcesCompat;

import com.bumptech.glide.Glide;
import com.example.ahsapptest3.Article;
import com.example.ahsapptest3.ArticleActivity;
import com.example.ahsapptest3.ArticleDatabase;
import com.example.ahsapptest3.R;

import java.io.File;


import java.text.SimpleDateFormat;

import java.util.Date;
import java.util.Locale;
import java.util.concurrent.TimeUnit;


// Alex Dang 2020
public class Helper {

    /**
    * Kind of unnecessary, but just for symmetry purposes
    * */
    public static void setText_toView(TextView view, String text)
    {
        view.setText(text);
    }

    /**
     *  Load image from the internet into an Image view (includes ImageButton, which extends ImageView)
     * */
    public static void setImage_toView_fromUrl(ImageView view, String url)
    {
        /*Picasso.with(view.getContext()).load(url).fit().centerInside().into(view, new Callback() {
            @Override
            public void onSuccess() {

            }

            @Override
            public void onError() {
                System.out.println("Picasso crashed");
            }
        });
        // possibly centerinside(), centercrop() options
        // you need fit() before centerinside(), centercrop() otherwise the app crashes with no logcat output*/
        Glide
                .with(view.getContext())
                .load(url)
                .error(R.drawable.article_display_template__rounded_darkgray)
                .centerInside()
                .into(view);
    }

    /**
     * Load image from internal storage into Image view
     * */
    public static void setImage_toView_fromStorage(ImageView view, String filePath)
    {
        /*Picasso.with(view.getContext()).load(new File(filePath)).into(view);*/
        Glide
                .with(view.getContext())
                .load(new File(filePath))
                .error(R.drawable.article_display_template__rounded_darkgray)
                .centerInside()
                .into(view);
    }

    /**
     * Sets onClick listener to a view, opening a corresponding Article Activity
     * */
    public static void setArticleListener_toView(final View view, final Article article)
    {
        view.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                Intent intent = new Intent(view.getContext(), ArticleActivity.class);
                intent.putExtra("data", article);
                view.getContext().startActivity(intent);


            }
        });
    }

    /**
     *  Sets the proper image background to an imageView that displays the bookmark
     *  Ideally, this would be unnecessary; rather the bookmark view would have a selector as a background
     *  But that kinda requires a TODO: BookmarkButton Fragment
     * */
    public static void setBookmarked_toView(ImageView view, boolean is_bookmarked)
    {
        if(is_bookmarked)
        {
            view.setImageDrawable(ResourcesCompat.getDrawable(view.getContext().getResources(), R.drawable.bookmarked_icon_active, null));
        }
        else
        {
            view.setImageDrawable(ResourcesCompat.getDrawable(view.getContext().getResources(), R.drawable.bookmarked_icon_inactive, null));
        }

    }

    /**
     *  Set an onClick listener to a bookmark view based on the current status of the article
     *  TODO: call a BookmarkHandler that updates the internal files
     * */
    public static void setBookMarkListener_toView(final ImageView view, final Article article)
    {
        final ArticleDatabase articleDatabase = new ArticleDatabase(view.getContext(), ArticleDatabase.Option.BOOKMARK);

        view.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                article.swapBookmark();
                setBookmarked_toView(view,article.isBookmarked());
                if(!articleDatabase.alreadyAdded(article.getID()))
                        articleDatabase.add(article);
                else
                    articleDatabase.delete(article);
                ArticleDatabase.setBookmarkChanged();
            }
        });
    }


    /*
     *  Sets time in a given unit to a TextView, formatted
     * */
    public static void setTimeText_toView(TextView view, long time)
    {
        TimeUnit unit = getLogicalTimeUnit(time);
        long time_val = unit.convert(time, TimeUnit.MILLISECONDS);
        if(unit.equals(TimeUnit.MINUTES))
        {
            view.setText(view.getContext().getString(R.string.time_minutes_updated_placeholder, time_val));
        }
        else if(unit.equals(TimeUnit.HOURS))
        {
            view.setText(view.getContext().getString(R.string.time_hours_updated_placeholder, time_val));
        }
        else if(unit.equals(TimeUnit.DAYS))
        {
            view.setText(view.getContext().getString(R.string.time_days_updated_placeholder, time_val));
        }

    }

    /*
     *  Gets difference between time parameter passed and the time right now
     * */
    public static long TimeFromNow(long time)
    {
        Date currentTime = new Date();
        return currentTime.getTime()-time*1000L; // for interesting reasons, Date() uses seconds not milliseconds
    }

    /*
     *  Because I forget how to use SimpleDateFormat()
     * */
    public static String DateFromTime(String pattern, long time)
    {
        return new SimpleDateFormat(pattern, Locale.US).format(time*1000L);
    }

    /**
     * Converts a long time to a time unit based on the reasonable unit for the length of time
     * to avoid overly large number of hours, minutes, etc.
     * @param time_difference The long time to be converted
     * @return the proper TimeUnit in Hours, minutes, etc.
     */
    public static TimeUnit getLogicalTimeUnit(long time_difference)
    {
        TimeUnit unit = TimeUnit.DAYS; // most reasonale to start with this
        int time_in_units = (int) unit.convert(time_difference, TimeUnit.MILLISECONDS);
        if(time_in_units < 1) // less than one day, use hours
        {
            unit = TimeUnit.HOURS;
            time_in_units = (int) unit.convert(time_difference, TimeUnit.MILLISECONDS);
            if(time_in_units < 1) // fresh! less than one hour!
            {
                return TimeUnit.MINUTES; // stop here, unreasonable to go below this unit
            }
            return TimeUnit.HOURS;
        }
        return TimeUnit.DAYS;
    }

}
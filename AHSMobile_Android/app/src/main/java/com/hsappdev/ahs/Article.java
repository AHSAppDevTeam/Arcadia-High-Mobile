package com.hsappdev.ahs;
import android.os.Parcel;
import android.os.Parcelable;

import androidx.annotation.NonNull;

import com.google.firebase.database.DatabaseReference;
import com.google.firebase.database.FirebaseDatabase;

public class Article implements Parcelable {

    private final String ID;
    private final long timestamp;
    private final String title;
    private final String author;
    private final String body;
    private final String [] imageURLs;
    private final String [] videoIDS;
    private int views;
    private final Type type;

    public Article(
        @NonNull
        String ID,
        long timestamp,
        @NonNull
        String title,
        @NonNull
        String author,
        @NonNull
        String body,
        String[] imageURLs,
        String[] videoIDS,
        Type type,
        int views
    )
    {
        this.ID = ID;
        this.timestamp = timestamp;
        this.title = title;
        this.author = author;
        this.body = body;
        this.imageURLs = imageURLs;
        this.videoIDS = videoIDS;
        this.type = type;
        this.views = views;
    }
    
    
    public Article(
        @NonNull
        String ID,
        long timestamp,
        @NonNull
        String title,
        @NonNull
        String author,
        @NonNull
        String body,
        String[] imageURLs,
        String[] videoIDS,
        Type type
    )
    {
        this.ID = ID;
        this.timestamp = timestamp;
        this.title = title;
        this.author = author;
        this.body = body;
        this.imageURLs = imageURLs;
        this.videoIDS = videoIDS;
        this.type = type;
        this.views = 0;
    }

    public static final Creator<Article> CREATOR = new Creator<Article>() {
        @Override
        public Article createFromParcel(Parcel in) {
            return new Article(in);
        }

        @Override
        public Article[] newArray(int size) {
            return new Article[size];
        }
    };

    public String getID() {return ID;}
    public long getTimestamp()
    {
        return timestamp;
    }
    public int getViews()
    {
        return views;
    }
    public String getTitle()
    {
        return title;
    }
    public String getAuthor() {return author;}
    public String getBody()
    {
        return body;
    }
    public String[] getImageURLs()
    {
        return imageURLs;
    }
    public String[] getVideoIDS() {return videoIDS;}

    public Type getType() { return type;}

    @NonNull
    @Override
    public String toString()
    {
        return "ID::\t" + ID + "\n" +
        "time::\t" + timestamp + "\n" +
        "title::\t" + title + "\n" +
        "author::\t" + author + "\n" +
        "body::\t" + ((body.length() > 40) ? body.substring(0,40) : body) + "\n" + // so output might not be overly long
        "type::\t" + type.toString() +
                "views::\t" + views;
    }

    // The following methods are for the purpose of extending Parcelable
    // make sure to update methods should a new field be added
    protected Article(Parcel in) {
        ID = in.readString();
        timestamp = in.readLong();
        title = in.readString();
        author = in.readString();
        body = in.readString();
        imageURLs = in.createStringArray();
        videoIDS = in.createStringArray();
        type = (Type) in.readSerializable();
        views = in.readInt();
    }

    @Override
    public int describeContents() {
        return 0;
    }

    @Override
    public void writeToParcel(Parcel dest, int flags) {
        dest.writeString(ID);
        dest.writeLong(timestamp);
        dest.writeString(title);
        dest.writeString(author);
        dest.writeString(body);
        dest.writeStringArray(imageURLs);
        dest.writeStringArray(videoIDS);
        dest.writeSerializable(type);
        dest.writeInt(views);
    }

    /**
     * Be extremely!!! careful when changing these types! May cause problems with type conversion in ArticleDatabase
     * Need to be careful even when refactoring
     */
    public enum Type {
        GENERAL_INFO("General Info", 3), DISTRICT("District", 2),  ASB("ASB", 1),;
        private final String name;
        private final int numCode;
        Type(String name, int numCode){
            this.name =  name;
            this.numCode = numCode;
        }
        public String getName() {
            return name;
        }

        public int getNumCode() {
            return numCode;
        }
        public static Type getTypeFromNumCode(int numCode) {
            for(Type type:  values()) {
                if(type.getNumCode() == numCode)
                    return type;
            }
            return null;
        }
    }
}

package com.example.goodspick.entity;

import org.springframework.data.annotation.Id;
import org.springframework.data.mongodb.core.mapping.Document;

@Document(collection = "needs")
public class Need {

    @Id
    private String id;

    private String goodsName;
    private String goodsDescription;
    private Boolean inPersonTransaction;
    private String imagePath;
    private String userId; // New field to store the ID of the user who posted the need

    public Need() {}

    public Need(String goodsName, String goodsDescription, Boolean inPersonTransaction, String imagePath, String userId) {
        this.goodsName = goodsName;
        this.goodsDescription = goodsDescription;
        this.inPersonTransaction = inPersonTransaction;
        this.imagePath = imagePath;
        this.userId = userId;
    }

    // Existing constructor updated
    public Need(String goodsName, String goodsDescription, Boolean inPersonTransaction, String imagePath) {
        this(goodsName, goodsDescription, inPersonTransaction, imagePath, null); // Default userId to null if not provided
    }

    // Existing constructor updated
    public Need(String goodsName, String goodsDescription, Boolean inPersonTransaction) {
        this(goodsName, goodsDescription, inPersonTransaction, null, null); // Default imagePath and userId to null
    }

    public String getId() {
        return id;
    }

    public void setId(String id) {
        this.id = id;
    }

    public String getGoodsName() {
        return goodsName;
    }

    public void setGoodsName(String goodsName) {
        this.goodsName = goodsName;
    }

    public String getGoodsDescription() {
        return goodsDescription;
    }

    public void setGoodsDescription(String goodsDescription) {
        this.goodsDescription = goodsDescription;
    }

    public Boolean getInPersonTransaction() {
        return inPersonTransaction;
    }

    public void setInPersonTransaction(Boolean inPersonTransaction) {
        this.inPersonTransaction = inPersonTransaction;
    }

    public String getImagePath() {
        return imagePath;
    }

    public void setImagePath(String imagePath) {
        this.imagePath = imagePath;
    }

    public String getUserId() {
        return userId;
    }

    public void setUserId(String userId) {
        this.userId = userId;
    }

    @Override
    public String toString() {
        return "Need{" +
                "id='" + id + '\'' +
                ", goodsName='" + goodsName + '\'' +
                ", goodsDescription='" + goodsDescription + '\'' +
                ", inPersonTransaction=" + inPersonTransaction +
                ", imagePath='" + imagePath + '\'' +
                ", userId='" + userId + '\'' +
                '}';
    }
}

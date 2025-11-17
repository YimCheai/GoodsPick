package com.example.goodspick.entity;

import org.springframework.data.annotation.Id;
import org.springframework.data.mongodb.core.mapping.Document;

@Document(collection = "provides")
public class Provide {

    @Id
    private String id;

    private String goodsName;
    private String goodsDescription;
    private Boolean inPersonTransaction;
    private String imagePath;
    private String userId;
    private Integer price; // Changed type from Double to Integer

    public Provide() {
    }

    public Provide(String goodsName, String goodsDescription, Boolean inPersonTransaction, String imagePath, String userId, Integer price) { // Changed price type
        this.goodsName = goodsName;
        this.goodsDescription = goodsDescription;
        this.inPersonTransaction = inPersonTransaction;
        this.imagePath = imagePath;
        this.userId = userId;
        this.price = price;
    }

    // Existing constructors updated to include price with default values
    public Provide(String goodsName, String goodsDescription, Boolean inPersonTransaction, String imagePath, String userId) {
        this(goodsName, goodsDescription, inPersonTransaction, imagePath, userId, null);
    }

    public Provide(String goodsName, String goodsDescription, Boolean inPersonTransaction, String imagePath) {
        this(goodsName, goodsDescription, inPersonTransaction, imagePath, null, null);
    }

    public Provide(String goodsName, String goodsDescription, Boolean inPersonTransaction) {
        this(goodsName, goodsDescription, inPersonTransaction, null, null, null);
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

    public Integer getPrice() { // Changed return type
        return price;
    }

    public void setPrice(Integer price) { // Changed parameter type
        this.price = price;
    }
}

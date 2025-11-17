package com.example.goodspick.repository;

import com.example.goodspick.entity.Need;
import java.util.List;
import org.springframework.data.mongodb.repository.MongoRepository;

public interface NeedRepository extends MongoRepository<Need, String> {
    List<Need> findByUserId(String userId);
    List<Need> findByGoodsNameContainingIgnoreCase(String goodsName);
}

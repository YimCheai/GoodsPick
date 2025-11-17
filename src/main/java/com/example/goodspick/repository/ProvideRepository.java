package com.example.goodspick.repository;

import com.example.goodspick.entity.Provide;
import java.util.List;
import org.springframework.data.mongodb.repository.MongoRepository;

public interface ProvideRepository extends MongoRepository<Provide, String> {
    List<Provide> findByUserId(String userId);
    List<Provide> findByGoodsNameContainingIgnoreCase(String goodsName);
}

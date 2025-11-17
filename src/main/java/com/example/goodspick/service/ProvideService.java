package com.example.goodspick.service;

import com.example.goodspick.entity.Provide;
import com.example.goodspick.repository.ProvideRepository;
import com.example.goodspick.storage.FileSystemStorageService;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;

import java.util.List;

@Service
public class ProvideService {

    private final ProvideRepository provideRepository;
    private final FileSystemStorageService storageService;

    public ProvideService(ProvideRepository provideRepository, FileSystemStorageService storageService) {
        this.provideRepository = provideRepository;
        this.storageService = storageService;
    }

    public Provide registerProvide(Provide provide, String userId, Integer price) {
        provide.setUserId(userId);
        provide.setPrice(price);
        return provideRepository.save(provide);
    }

    public List<Provide> getAllProvides() {
        return provideRepository.findAll();
    }

    public List<Provide> getProvidesByUserId(String userId) {
        return provideRepository.findByUserId(userId);
    }

    public String storeImage(MultipartFile image) {
        return storageService.store(image);
    }

    public Provide saveProvide(Provide provide) {
        return provideRepository.save(provide);
    }

    public Provide getProvideById(String id) {
        return provideRepository.findById(id).orElse(null); // Return null if not found
    }

    public List<Provide> getProvidesByGoodsNameContaining(String query) {
        return provideRepository.findByGoodsNameContainingIgnoreCase(query);
    }

    public void deleteProvide(String id) {
        // Optional: Add logic here to delete the associated image file from storage
        provideRepository.deleteById(id);
    }

    public Provide updateProvide(String id, String goodsName, String goodsDescription, int price, boolean inPersonTransaction, MultipartFile image) {
        Provide existingProvide = getProvideById(id);
        if (existingProvide == null) {
            return null;
        }

        existingProvide.setGoodsName(goodsName);
        existingProvide.setGoodsDescription(goodsDescription);
        existingProvide.setPrice(price);
        existingProvide.setInPersonTransaction(inPersonTransaction);

        if (image != null && !image.isEmpty()) {
            String newImagePath = storageService.store(image);
            existingProvide.setImagePath(newImagePath);
        }

        return provideRepository.save(existingProvide);
    }
}

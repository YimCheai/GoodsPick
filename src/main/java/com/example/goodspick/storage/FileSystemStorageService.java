package com.example.goodspick.storage;

import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;
import java.io.IOException;
import java.io.InputStream;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.nio.file.StandardCopyOption;
import java.util.UUID;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

@Service
public class FileSystemStorageService {

    private static final Logger log = LoggerFactory.getLogger(FileSystemStorageService.class);

    private final Path rootLocation;

    public FileSystemStorageService() {
        // Store files in a directory named 'uploads' at the project root
        this.rootLocation = Paths.get("uploads");
        try {
            Files.createDirectories(rootLocation);
        } catch (IOException e) {
            String absolutePath = rootLocation.toAbsolutePath().toString();
            throw new RuntimeException("Could not initialize storage directory at: " + absolutePath, e);
        }
    }

    public String store(MultipartFile file) {
        log.debug("Attempting to store file: {}", file.getOriginalFilename());
        try {
            if (file.isEmpty()) {
                log.debug("File is empty, throwing RuntimeException.");
                throw new RuntimeException("Failed to store empty file.");
            }
            
            String originalFilename = file.getOriginalFilename();
            String extension = "";
            if (originalFilename != null && originalFilename.contains(".")) {
                extension = originalFilename.substring(originalFilename.lastIndexOf("."));
            }
            String filename = UUID.randomUUID().toString() + extension;
            log.debug("Generated filename: {}", filename);
            
            Path destinationFile = this.rootLocation.resolve(Paths.get(filename))
                    .normalize().toAbsolutePath();
            log.debug("Resolved destination file path: {}", destinationFile);

            if (!destinationFile.getParent().equals(this.rootLocation.toAbsolutePath())) {
                log.debug("Security check failed: Attempt to store file outside root location.");
                throw new RuntimeException(
                        "Cannot store file outside current directory.");
            }
            try (InputStream inputStream = file.getInputStream()) {
                Files.copy(inputStream, destinationFile,
                    StandardCopyOption.REPLACE_EXISTING);
                log.debug("File copied successfully to: {}", destinationFile);
            }
            log.debug("Returning image path: /uploads/{}", filename);
            return "/uploads/" + filename;
        } catch (IOException e) {
            log.error("Failed to store file due to IOException: {}", e.getMessage(), e);
            throw new RuntimeException("Failed to store file.", e);
        } catch (RuntimeException e) {
            log.error("Runtime error during file storage: {}", e.getMessage(), e);
            throw e; // Re-throw the specific runtime exception
        }
    }
}

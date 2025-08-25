package com.phone.encryption;

import java.io.*;
import java.nio.charset.StandardCharsets;
import java.nio.file.Files;
import java.nio.file.Paths;
import java.util.concurrent.ExecutorService;
import java.util.concurrent.Executors;
import java.util.concurrent.TimeUnit;
import java.util.concurrent.atomic.AtomicLong;

/**
 * 手机号加密应用程序
 * 处理1亿行手机号数据的加密
 */
public class PhoneEncryptionApp {
    
    private static final String PRIVATE_KEY = "3737899807937706933536983736398972767192608452658617578224077173161969606234";
    private static final int BATCH_SIZE = 10000;
    private static final int THREAD_POOL_SIZE = Runtime.getRuntime().availableProcessors();
    
    public static void main(String[] args) {
        if (args.length < 2) {
            System.out.println("Usage: java -jar phone-encryption.jar <input_csv> <output_mobile_csv> [output_md5_csv]");
            System.out.println("Example 1 (only mobile): java -jar phone-encryption.jar phones.csv encrypted_mobile.csv");
            System.out.println("Example 2 (both columns): java -jar phone-encryption.jar phones.csv encrypted_mobile.csv encrypted_md5.csv");
            return;
        }
        
        String inputFile = args[0];
        String outputMobileFile = args[1];
        String outputMd5File = args.length > 2 ? args[2] : null;
        
        try {
            long startTime = System.currentTimeMillis();
            System.out.println("Starting phone number encryption...");
            System.out.println("Input file: " + inputFile);
            System.out.println("Output mobile file: " + outputMobileFile);
            if (outputMd5File != null) {
                System.out.println("Output md5 file: " + outputMd5File);
            } else {
                System.out.println("MD5 processing: disabled");
            }
            System.out.println("Thread pool size: " + THREAD_POOL_SIZE);
            
            // 使用单线程版本避免多线程问题
            processCsvFileSingleThread(inputFile, outputMobileFile, outputMd5File);
            
            long endTime = System.currentTimeMillis();
            long duration = (endTime - startTime) / 1000;
            System.out.println("Encryption completed in " + duration + " seconds");
            
        } catch (Exception e) {
            System.err.println("Error processing file: " + e.getMessage());
            e.printStackTrace();
        }
    }
    
    private static void processCsvFile(String inputFile, String outputFile) throws IOException {
        AtomicLong processedCount = new AtomicLong(0);
        ExecutorService executor = Executors.newFixedThreadPool(THREAD_POOL_SIZE);
        
        try (BufferedReader reader = Files.newBufferedReader(Paths.get(inputFile), StandardCharsets.UTF_8);
             BufferedWriter writer = Files.newBufferedWriter(Paths.get(outputFile), StandardCharsets.UTF_8)) {
            
            String line;
            while ((line = reader.readLine()) != null) {
                String phoneNumber = line.trim();
                if (phoneNumber.isEmpty()) continue;
                
                // 提交加密任务到线程池
                executor.submit(() -> {
                    try {
                        String encryptedPhone = EcdhEncUdfWrapper.encryptPhoneNumber(phoneNumber, PRIVATE_KEY);
                        
                        synchronized (writer) {
                            writer.write(phoneNumber + "," + encryptedPhone);
                            writer.newLine();
                        }
                        
                        long count = processedCount.incrementAndGet();
                        if (count % BATCH_SIZE == 0) {
                            System.out.println("Processed " + count + " records");
                        }
                    } catch (Exception e) {
                        System.err.println("Error encrypting phone number: " + phoneNumber + " - " + e.getMessage());
                    }
                });
            }
            
        } finally {
            executor.shutdown();
            try {
                if (!executor.awaitTermination(1, TimeUnit.HOURS)) {
                    executor.shutdownNow();
                }
            } catch (InterruptedException e) {
                executor.shutdownNow();
                Thread.currentThread().interrupt();
            }
        }
    }
    
    /**
     * 单线程版本（用于测试或小规模数据）
     * 支持两种输入格式：
     * 1. 单列格式：只有手机号（每行一个手机号）
     * 2. 双列格式：mobile和mobile_md5两列
     * 可以选择只处理mobile列或同时处理两列
     */
    private static void processCsvFileSingleThread(String inputFile, String outputMobileFile, String outputMd5File) throws IOException {
        long processedCount = 0;
        boolean processMd5 = outputMd5File != null;
        
        try (BufferedReader reader = Files.newBufferedReader(Paths.get(inputFile), StandardCharsets.UTF_8);
             BufferedWriter writerMobile = Files.newBufferedWriter(Paths.get(outputMobileFile), StandardCharsets.UTF_8);
             BufferedWriter writerMd5 = processMd5 ? Files.newBufferedWriter(Paths.get(outputMd5File), StandardCharsets.UTF_8) : null) {
            
            EcdhEncUdfWrapper encryptor = new EcdhEncUdfWrapper();
            
            String line;
            while ((line = reader.readLine()) != null) {
                line = line.trim();
                if (line.isEmpty()) continue;
                
                // 处理CSV格式（支持常规和带双引号）
                String[] columns = parseCsvLine(line);
                
                String mobile;
                String mobileMd5 = null;
                
                if (columns.length == 1) {
                    // 单列格式：只有手机号
                    mobile = columns[0].replace("\"", "").trim();
                } else if (columns.length >= 2) {
                    // 双列格式：mobile和mobile_md5
                    mobile = columns[0].replace("\"", "").trim();
                    mobileMd5 = columns[1].replace("\"", "").trim();
                } else {
                    System.err.println("Invalid line format: " + line);
                    continue;
                }
                
                try {
                    // 加密mobile列
                    String encryptedMobile = encryptor.evaluate(mobile, PRIVATE_KEY);
                    writerMobile.write(encryptedMobile);
                    writerMobile.newLine();
                    
                    // 如果存在md5列并且需要处理md5
                    if (processMd5 && mobileMd5 != null && !mobileMd5.isEmpty()) {
                        String encryptedMd5 = encryptor.evaluate(mobileMd5, PRIVATE_KEY);
                        writerMd5.write(encryptedMd5);
                        writerMd5.newLine();
                    }
                    
                    processedCount++;
                    if (processedCount % BATCH_SIZE == 0) {
                        System.out.println("Processed " + processedCount + " records");
                    }
                } catch (Exception e) {
                    System.err.println("Error encrypting record: " + line + " - " + e.getMessage());
                }
            }
        }
        
        System.out.println("Total processed: " + processedCount + " records");
    }
    
    /**
     * 解析CSV行，支持两种格式：
     * 1. 常规CSV格式: value1,value2,value3
     * 2. 带双引号的CSV格式: "value1","value2","value3"
     */
    private static String[] parseCsvLine(String line) {
        // 检查是否是带双引号的格式
        if (line.startsWith("\"") && line.contains("\",\"")) {
            // 带双引号的CSV格式
            String[] parts = line.split("\",\"");
            // 移除第一个元素的开头引号和最后一个元素的结尾引号
            if (parts.length > 0) {
                parts[0] = parts[0].replaceFirst("^\"", "");
                parts[parts.length - 1] = parts[parts.length - 1].replaceFirst("\"$", "");
            }
            return parts;
        } else {
            // 常规CSV格式
            return line.split(",");
        }
    }
}

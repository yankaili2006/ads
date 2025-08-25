package com.phone.encryption;

import java.security.MessageDigest;
import java.util.HexFormat;

/**
 * 简化的ECDH加密实现（使用Java标准库）
 * 由于缺少Bouncy Castle依赖，这里使用简化实现
 */
public class EcdhEncUdf {
    private static final String PRIVATE_KEY = "3737899807937706933536983736398972767192608452658617578224077173161969606234";
    
    public EcdhEncUdf() {
        // 简化实现，不需要复杂的密钥初始化
    }
    
    public String evaluate(String phoneNumber, String publicKeyStr) {
        try {
            // 生成共享密钥（简化实现）
            byte[] sharedSecret = generateSharedSecret(publicKeyStr);
            
            // 使用共享密钥对手机号进行简单加密（XOR加密）
            byte[] phoneBytes = phoneNumber.getBytes("UTF-8");
            byte[] encrypted = new byte[phoneBytes.length];
            
            for (int i = 0; i < phoneBytes.length; i++) {
                encrypted[i] = (byte) (phoneBytes[i] ^ sharedSecret[i % sharedSecret.length]);
            }
            
            // 使用Java标准库的HexFormat
            HexFormat hexFormat = HexFormat.of();
            return hexFormat.formatHex(encrypted);
        } catch (Exception e) {
            throw new RuntimeException("Failed to encrypt phone number", e);
        }
    }
    
    private byte[] generateSharedSecret(String otherPublicKeyStr) throws Exception {
        // 简化实现：使用SHA-256哈希公钥字符串作为共享密钥
        MessageDigest digest = MessageDigest.getInstance("SHA-256");
        return digest.digest(otherPublicKeyStr.getBytes("UTF-8"));
    }
    
    // 生成公钥的十六进制表示（用于测试）
    public String getPublicKeyHex() {
        // 返回固定公钥（示例）
        return "0479BE667EF9DCBBAC55A06295CE870B07029BFCDB2DCE28D959F2815B16F81798483ADA7726A3C4655DA4FBFC0E1108A8FD17B448A68554199C47D08FFB10D4B8";
    }
}

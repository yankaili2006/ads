package com.phone.encryption;

import com.alibaba.dt.adex.common.udf.EcdhEncUdf;

/**
 * EcdhEncUdf包装类，用于调用lib jar中的加密功能
 */
public class EcdhEncUdfWrapper {
    private final EcdhEncUdf ecdhEncUdfInstance;
    
    public EcdhEncUdfWrapper() {
        this.ecdhEncUdfInstance = new EcdhEncUdf();
    }
    
    public String evaluate(String phoneNumber, String publicKeyStr) {
        return ecdhEncUdfInstance.evaluate(phoneNumber, publicKeyStr);
    }
    
    /**
     * 静态方法加密手机号
     */
    public static String encryptPhoneNumber(String phoneNumber, String publicKeyStr) {
        EcdhEncUdf encryptor = new EcdhEncUdf();
        return encryptor.evaluate(phoneNumber, publicKeyStr);
    }
}

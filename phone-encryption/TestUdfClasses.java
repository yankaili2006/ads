import com.alibaba.dt.adex.common.udf.EcdhPrivateKeyGenerateUdf;
import com.alibaba.dt.adex.common.udf.EcdhEncUdf;

public class TestUdfClasses {
    public static void main(String[] args) {
        try {
            // Test EcdhPrivateKeyGenerateUdf
            EcdhPrivateKeyGenerateUdf keyGenerator = new EcdhPrivateKeyGenerateUdf();
            
            // Try to generate a private key - we need to figure out the method signature
            // Based on the class name pattern, it might be evaluate() method
            String privateKey = keyGenerator.evaluate();
            System.out.println("Generated Private Key: " + privateKey);
            
            // Test EcdhEncUdf with the generated key
            EcdhEncUdf encryptor = new EcdhEncUdf();
            String testPhone = "13800138000";
            String encrypted = encryptor.evaluate(testPhone, privateKey);
            System.out.println("Original: " + testPhone);
            System.out.println("Encrypted: " + encrypted);
            
        } catch (Exception e) {
            System.out.println("Error: " + e.getMessage());
            e.printStackTrace();
        }
    }
}

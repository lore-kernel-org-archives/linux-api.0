From: Tadeusz Struk <tadeusz.struk@intel.com>
Subject: [PATCH v4 6/7] crypto: KEYS - add generic handlers to symmetric key
 type
Date: Thu, 31 Mar 2016 18:38:20 -0700
Message-ID: <20160401013819.16799.38454.stgit@tstruk-mobl1>
References: <20160401013745.16799.91093.stgit@tstruk-mobl1>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20160401013745.16799.91093.stgit@tstruk-mobl1>
Sender: linux-kernel-owner@vger.kernel.org
To: herbert@gondor.apana.org.au
Cc: tadeusz.struk@intel.com, smueller@chronox.de, linux-api@vger.kernel.org, marcel@holtmann.org, linux-kernel@vger.kernel.org, dhowells@redhat.com, keyrings@vger.kernel.org, linux-crypto@vger.kernel.org, dwmw2@infradead.org, davem@davemloft.net
List-Id: linux-api@vger.kernel.org

This adds generic sign, verify, encrypt, decrypt accessor
functions to the asymmetric key type. These will be defined by
asymmetric subtypes, similarly to how public_key currently defines
the verify_signature function.

Signed-off-by: Tadeusz Struk <tadeusz.struk@intel.com>
---
 crypto/asymmetric_keys/asymmetric_type.c |   88 ++++++++++++++++++++++++++++++
 include/keys/asymmetric-subtype.h        |   10 +++
 include/keys/asymmetric-type.h           |   15 ++++-
 3 files changed, 110 insertions(+), 3 deletions(-)

diff --git a/crypto/asymmetric_keys/asymmetric_type.c b/crypto/asymmetric_keys/asymmetric_type.c
index 9f2165b..d9416df 100644
--- a/crypto/asymmetric_keys/asymmetric_type.c
+++ b/crypto/asymmetric_keys/asymmetric_type.c
@@ -416,6 +416,94 @@ void unregister_asymmetric_key_parser(struct asymmetric_key_parser *parser)
 }
 EXPORT_SYMBOL_GPL(unregister_asymmetric_key_parser);
 
+/**
+ * asymmetric_key_encrypt - invoke encrypt operation on a key
+ *			    of the asymmetric subtype
+ * @key: key from the system keyring
+ * @input: data to be encrypted
+ * @insize: size of data to encrypt
+ * @output: output buffer
+ * @outsize: size of the output buffer. This will be updated to the actual
+ *	     size of encrypted data.
+ *
+ * return: 0 on success or errno on failure
+ */
+int asymmetric_key_encrypt(const struct key *key, char *input, u32 insize,
+			   char *output, u32 *outsize)
+{
+	struct asymmetric_key_subtype *subtype = asymmetric_key_subtype(key);
+
+	if (subtype && subtype->encrypt)
+		return subtype->encrypt(key, input, insize, output, outsize);
+
+	return -EOPNOTSUPP;
+}
+EXPORT_SYMBOL_GPL(asymmetric_key_encrypt);
+
+/**
+ * asymmetric_key_decrypt - invoke decrypt operation on a key
+ *			    of the asymmetric subtype
+ * @key: key from the system keyring
+ * @input: data to be decrypted
+ * @insize: size of data to decrypt
+ * @output: output buffer
+ * @outsize: size of the output buffer. This will be updated to the actual
+ *	     size of decrypted data.
+ *
+ * return: 0 on success or errno on failure
+ */
+int asymmetric_key_decrypt(const struct key *key, char *input, u32 insize,
+			   char *output, u32 *outsize)
+{
+	struct asymmetric_key_subtype *subtype = asymmetric_key_subtype(key);
+
+	if (subtype && subtype->decrypt)
+		return subtype->decrypt(key, input, insize, output, outsize);
+
+	return -EOPNOTSUPP;
+}
+EXPORT_SYMBOL_GPL(asymmetric_key_decrypt);
+
+/**
+ * asymmetric_key_verify_signature - invoke verify signature operation on a key
+ *			             of the asymmetric subtype
+ * @key: key from the system keyring
+ * @sig: signature to verify
+ *
+ * return: 0 on success or errno on failure
+ */
+int asymmetric_key_verify_signature(const struct key *key,
+				    const struct public_key_signature *sig)
+{
+	struct asymmetric_key_subtype *subtype = asymmetric_key_subtype(key);
+
+	if (subtype && subtype->verify_signature)
+		return subtype->verify_signature(key, sig);
+
+	return -EOPNOTSUPP;
+}
+EXPORT_SYMBOL_GPL(asymmetric_key_verify_signature);
+
+/**
+ * asymmetric_key_create_signature - invoke create signature operation on a key
+ *			             of the asymmetric subtype
+ * @key: key from the system keyring
+ * @sig: output signature
+ *
+ * return: 0 on success or errno on failure
+ */
+int asymmetric_key_create_signature(const struct key *key, char *data, u32 size,
+				    const struct public_key_signature **sig)
+{
+	struct asymmetric_key_subtype *subtype = asymmetric_key_subtype(key);
+
+	if (subtype && subtype->create_signature)
+		return subtype->create_signature(key, data, size, sig);
+
+	return -EOPNOTSUPP;
+}
+EXPORT_SYMBOL_GPL(asymmetric_key_create_signature);
+
 /*
  * Module stuff
  */
diff --git a/include/keys/asymmetric-subtype.h b/include/keys/asymmetric-subtype.h
index 4915d40..30f673a 100644
--- a/include/keys/asymmetric-subtype.h
+++ b/include/keys/asymmetric-subtype.h
@@ -37,6 +37,16 @@ struct asymmetric_key_subtype {
 	/* Verify the signature on a key of this subtype (optional) */
 	int (*verify_signature)(const struct key *key,
 				const struct public_key_signature *sig);
+
+	/* Sign data using key and return the signature (optional) */
+	int (*create_signature)(const struct key *key, char *data, u32 size,
+				const struct public_key_signature **sig);
+
+	int (*encrypt)(const struct key *key, char *input, u32 insize,
+		       char *output, u32 *outsize);
+
+	int (*decrypt)(const struct key *key, char *input, u32 insize,
+		       char *output, u32 *outsize);
 };
 
 /**
diff --git a/include/keys/asymmetric-type.h b/include/keys/asymmetric-type.h
index 59c1df9..7a571be 100644
--- a/include/keys/asymmetric-type.h
+++ b/include/keys/asymmetric-type.h
@@ -68,14 +68,23 @@ extern struct asymmetric_key_id *asymmetric_key_generate_id(const void *val_1,
 							    size_t len_1,
 							    const void *val_2,
 							    size_t len_2);
+/*
+ * The payload is at the discretion of the subtype.
+ */
 static inline
 const struct asymmetric_key_ids *asymmetric_key_ids(const struct key *key)
 {
 	return key->payload.data[asym_key_ids];
 }
 
-/*
- * The payload is at the discretion of the subtype.
- */
+struct public_key_signature;
 
+int asymmetric_key_encrypt(const struct key *key, char *input, u32 insize,
+			   char *output, u32 *outsize);
+int asymmetric_key_decrypt(const struct key *key, char *input, u32 insize,
+			   char *output, u32 *outsize);
+int asymmetric_key_verify_signature(const struct key *key,
+				    const struct public_key_signature *sig);
+int asymmetric_key_create_signature(const struct key *key, char *data, u32 size,
+				    const struct public_key_signature **sig);
 #endif /* _KEYS_ASYMMETRIC_TYPE_H */

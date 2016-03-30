From: Tadeusz Struk <tadeusz.struk@intel.com>
Subject: [PATCH v3 6/7] crypto: KEYS - add public_key info query
Date: Tue, 29 Mar 2016 17:57:26 -0700
Message-ID: <20160330005726.25410.62293.stgit@tstruk-mobl1>
References: <20160330005649.25410.70508.stgit@tstruk-mobl1>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20160330005649.25410.70508.stgit@tstruk-mobl1>
Sender: linux-kernel-owner@vger.kernel.org
To: herbert@gondor.apana.org.au
Cc: tadeusz.struk@intel.com, smueller@chronox.de, linux-api@vger.kernel.org, marcel@holtmann.org, linux-kernel@vger.kernel.org, dhowells@redhat.com, keyrings@vger.kernel.org, linux-crypto@vger.kernel.org, dwmw2@infradead.org, davem@davemloft.net
List-Id: linux-api@vger.kernel.org

It is needed to query the key capabilities and how to use the key correctly.
In case of a key stored in HW (TPM) it can not be passed to the crypto API.
For now it the public_key_info only contains information about where the key
is stored, which is needed to prevent other modules, like AF_ALG, using
a key that can not be accessed by software. Later, when support for hardware
based public keys will be added this can be extended to describe other
characteristic of the key, like information on what operations the key
supports, size of data is supported, whether a password is
required to unlock it, etc.

Signed-off-by: Tadeusz Struk <tadeusz.struk@intel.com>
---
 crypto/asymmetric_keys/x509_cert_parser.c |    1 +
 include/crypto/public_key.h               |   31 +++++++++++++++++++++++++++++
 2 files changed, 32 insertions(+)

diff --git a/crypto/asymmetric_keys/x509_cert_parser.c b/crypto/asymmetric_keys/x509_cert_parser.c
index 4a29bac..4d44724 100644
--- a/crypto/asymmetric_keys/x509_cert_parser.c
+++ b/crypto/asymmetric_keys/x509_cert_parser.c
@@ -107,6 +107,7 @@ struct x509_certificate *x509_cert_parse(const void *data, size_t datalen)
 		goto error_decode;
 
 	cert->pub->keylen = ctx->key_size;
+	cert->pub->info.stored = KEY_INFO_STOR_SW;
 
 	/* Generate cert issuer + serial number key ID */
 	kid = asymmetric_key_generate_id(cert->raw_serial,
diff --git a/include/crypto/public_key.h b/include/crypto/public_key.h
index aa730ea..1ca1a93 100644
--- a/include/crypto/public_key.h
+++ b/include/crypto/public_key.h
@@ -29,6 +29,26 @@ enum key_being_used_for {
 extern const char *const key_being_used_for[NR__KEY_BEING_USED_FOR];
 
 /*
+ * Info indicating where a key is stored.
+ * For instance if the key is stored in software, then it can be accessed
+ * by SW. If the key is stored in hardware e.g. (TPM) then it can not be
+ * directly accessed by SW.
+ */
+enum public_key_info_storage {
+	KEY_INFO_STOR_HW,
+	KEY_INFO_STOR_SW
+};
+
+/*
+ * Information describing public_key.
+ * Struct sotres information about the key i.e.
+ * where key is stored, what operation it supports, etc.
+ */
+struct public_key_info {
+	enum public_key_info_storage stored;
+};
+
+/*
  * Cryptographic data for the public-key subtype of the asymmetric key type.
  *
  * Note that this may include private part of the key as well as the public
@@ -39,6 +59,7 @@ struct public_key {
 	u32 keylen;
 	const char *id_type;
 	const char *pkey_algo;
+	struct public_key_info info;
 };
 
 extern void public_key_destroy(void *payload);
@@ -55,6 +76,16 @@ struct public_key_signature {
 	const char *hash_algo;
 };
 
+static inline bool public_key_query_sw_key(struct public_key *pkey)
+{
+	return pkey->info.stored == KEY_INFO_STOR_SW;
+}
+
+static inline bool public_key_query_hw_key(struct public_key *pkey)
+{
+	return pkey->info.stored == KEY_INFO_STOR_HW;
+}
+
 extern struct asymmetric_key_subtype public_key_subtype;
 struct key;
 extern int verify_signature(const struct key *key,

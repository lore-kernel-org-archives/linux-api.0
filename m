From: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Subject: [PATCH v2 2/3] crypto: add entry for sm3-256
Date: Fri, 30 Oct 2015 13:35:08 +0200
Message-ID: <1446204910-29948-3-git-send-email-jarkko.sakkinen@linux.intel.com>
References: <1446204910-29948-1-git-send-email-jarkko.sakkinen@linux.intel.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1446204910-29948-1-git-send-email-jarkko.sakkinen@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Peter Huewe <peterhuewe@gmx.de>, Marcel Selhorst <tpmdd@selhorst.net>, Mimi Zohar <zohar@linux.vnet.ibm.com>, David Howells <dhowells@redhat.com>
Cc: tpmdd-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org, keyrings@vger.kernel.org, chris.j.arges@canonical.com, seth.forshee@canonical.com, colin.king@canonical.com, josh@joshtriplett.org, Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>, Herbert Xu <herbert@gondor.apana.org.au>, "David S. Miller" <davem@davemloft.net>, "open list:CRYPTO API" <linux-crypto@vger.kernel.org>, "open list:ABI/API" <linux-api@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

Added entry for sm3-256 to the following tables:

* hash_algo_name
* hash_digest_size

Needed for TPM 2.0 trusted key sealing.

Signed-off-by: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
---
 crypto/hash_info.c             | 2 ++
 include/crypto/hash_info.h     | 3 +++
 include/uapi/linux/hash_info.h | 1 +
 3 files changed, 6 insertions(+)

diff --git a/crypto/hash_info.c b/crypto/hash_info.c
index 3e7ff46..7b1e0b1 100644
--- a/crypto/hash_info.c
+++ b/crypto/hash_info.c
@@ -31,6 +31,7 @@ const char *const hash_algo_name[HASH_ALGO__LAST] = {
 	[HASH_ALGO_TGR_128]	= "tgr128",
 	[HASH_ALGO_TGR_160]	= "tgr160",
 	[HASH_ALGO_TGR_192]	= "tgr192",
+	[HASH_ALGO_SM3_256]	= "sm3-256",
 };
 EXPORT_SYMBOL_GPL(hash_algo_name);
 
@@ -52,5 +53,6 @@ const int hash_digest_size[HASH_ALGO__LAST] = {
 	[HASH_ALGO_TGR_128]	= TGR128_DIGEST_SIZE,
 	[HASH_ALGO_TGR_160]	= TGR160_DIGEST_SIZE,
 	[HASH_ALGO_TGR_192]	= TGR192_DIGEST_SIZE,
+	[HASH_ALGO_SM3_256]	= SM3256_DIGEST_SIZE,
 };
 EXPORT_SYMBOL_GPL(hash_digest_size);
diff --git a/include/crypto/hash_info.h b/include/crypto/hash_info.h
index e1e5a3e..56f217d 100644
--- a/include/crypto/hash_info.h
+++ b/include/crypto/hash_info.h
@@ -34,6 +34,9 @@
 #define TGR160_DIGEST_SIZE 20
 #define TGR192_DIGEST_SIZE 24
 
+/* not defined in include/crypto/ */
+#define SM3256_DIGEST_SIZE 32
+
 extern const char *const hash_algo_name[HASH_ALGO__LAST];
 extern const int hash_digest_size[HASH_ALGO__LAST];
 
diff --git a/include/uapi/linux/hash_info.h b/include/uapi/linux/hash_info.h
index ca18c45..ebf8fd8 100644
--- a/include/uapi/linux/hash_info.h
+++ b/include/uapi/linux/hash_info.h
@@ -31,6 +31,7 @@ enum hash_algo {
 	HASH_ALGO_TGR_128,
 	HASH_ALGO_TGR_160,
 	HASH_ALGO_TGR_192,
+	HASH_ALGO_SM3_256,
 	HASH_ALGO__LAST
 };
 
-- 
2.5.0

From: Stephan Mueller <smueller@chronox.de>
Subject: [PATCH v2 5/5] crypto: algif_akcipher - enable compilation
Date: Sun, 18 Oct 2015 12:49:03 +0200
Message-ID: <3228278.hONuqQtS6Z@myon.chronox.de>
References: <1831785.BBs8Hj3CxY@myon.chronox.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Return-path: <linux-crypto-owner@vger.kernel.org>
In-Reply-To: <1831785.BBs8Hj3CxY@myon.chronox.de>
Sender: linux-crypto-owner@vger.kernel.org
To: herbert@gondor.apana.org.au
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org, linux-api@vger.kernel.org
List-Id: linux-api@vger.kernel.org

Add the Makefile and Kconfig updates to allow algif_akcipher to be
compiled.

Signed-off-by: Stephan Mueller <smueller@chronox.de>
---
 crypto/Kconfig  | 9 +++++++++
 crypto/Makefile | 1 +
 2 files changed, 10 insertions(+)

diff --git a/crypto/Kconfig b/crypto/Kconfig
index fc93444..aa5d3aa 100644
--- a/crypto/Kconfig
+++ b/crypto/Kconfig
@@ -1632,6 +1632,15 @@ config CRYPTO_USER_API_AEAD
 	  This option enables the user-spaces interface for AEAD
 	  cipher algorithms.
 
+config CRYPTO_USER_API_AKCIPHER
+	tristate "User-space interface for asymmetric key cipher algorithms"
+	depends on NET
+	select CRYPTO_AKCIPHER2
+	select CRYPTO_USER_API
+	help
+	  This option enables the user-spaces interface for asymmetric
+	  key cipher algorithms.
+
 config CRYPTO_HASH_INFO
 	bool
 
diff --git a/crypto/Makefile b/crypto/Makefile
index d897e0b..3aaa914 100644
--- a/crypto/Makefile
+++ b/crypto/Makefile
@@ -120,6 +120,7 @@ obj-$(CONFIG_CRYPTO_USER_API_HASH) += algif_hash.o
 obj-$(CONFIG_CRYPTO_USER_API_SKCIPHER) += algif_skcipher.o
 obj-$(CONFIG_CRYPTO_USER_API_RNG) += algif_rng.o
 obj-$(CONFIG_CRYPTO_USER_API_AEAD) += algif_aead.o
+obj-$(CONFIG_CRYPTO_USER_API_AKCIPHER) += algif_akcipher.o
 
 #
 # generic algorithms and the async_tx api
-- 
2.5.0

From: Stephan Mueller <smueller@chronox.de>
Subject: [PATCH v7 2/2] crypto: AF_ALG: enable AEAD interface compilation
Date: Fri, 02 Jan 2015 15:42:11 +0100
Message-ID: <1717677.8jRUsSBs35@tachyon.chronox.de>
References: <6964260.mNa1jtPz7Z@tachyon.chronox.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <6964260.mNa1jtPz7Z@tachyon.chronox.de>
Sender: linux-kernel-owner@vger.kernel.org
To: 'Herbert Xu' <herbert@gondor.apana.org.au>
Cc: Daniel Borkmann <dborkman@redhat.com>, 'Quentin Gouchet' <quentin.gouchet@gmail.com>, linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org, ABI/API <linux-api@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

Enable compilation of the AEAD AF_ALG support and provide a Kconfig
option to compile the AEAD AF_ALG support.

Signed-off-by: Stephan Mueller <smueller@chronox.de>
---
 crypto/Kconfig  | 9 +++++++++
 crypto/Makefile | 1 +
 2 files changed, 10 insertions(+)

diff --git a/crypto/Kconfig b/crypto/Kconfig
index 50f4da4..41a3fc5 100644
--- a/crypto/Kconfig
+++ b/crypto/Kconfig
@@ -1523,6 +1523,15 @@ config CRYPTO_USER_API_RNG
 	  This option enables the user-spaces interface for random
 	  number generator algorithms.
 
+config CRYPTO_USER_API_AEAD
+	tristate "User-space interface for AEAD cipher algorithms"
+	depends on NET
+	select CRYPTO_AEAD
+	select CRYPTO_USER_API
+	help
+	  This option enables the user-spaces interface for AEAD
+	  cipher algorithms.
+
 config CRYPTO_HASH_INFO
 	bool
 
diff --git a/crypto/Makefile b/crypto/Makefile
index ba19465..97b7d3a 100644
--- a/crypto/Makefile
+++ b/crypto/Makefile
@@ -100,6 +100,7 @@ obj-$(CONFIG_CRYPTO_USER_API) += af_alg.o
 obj-$(CONFIG_CRYPTO_USER_API_HASH) += algif_hash.o
 obj-$(CONFIG_CRYPTO_USER_API_SKCIPHER) += algif_skcipher.o
 obj-$(CONFIG_CRYPTO_USER_API_RNG) += algif_rng.o
+obj-$(CONFIG_CRYPTO_USER_API_AEAD) += algif_aead.o
 
 #
 # generic algorithms and the async_tx api
-- 
2.1.0

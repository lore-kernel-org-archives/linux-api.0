From: Tadeusz Struk <tadeusz.struk@intel.com>
Subject: [PATCH v8 4/6] crypto: algif_akcipher - enable compilation
Date: Thu, 23 Jun 2016 15:55:47 -0700
Message-ID: <146672254783.23101.1848548518373325343.stgit@tstruk-mobl1.ra.intel.com>
References: <146672252642.23101.15972023870303797249.stgit@tstruk-mobl1.ra.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <146672252642.23101.15972023870303797249.stgit@tstruk-mobl1.ra.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
To: dhowells@redhat.com
Cc: herbert@gondor.apana.org.au, tadeusz.struk@intel.com, smueller@chronox.de, linux-api@vger.kernel.org, marcel@holtmann.org, mathew.j.martineau@linux.intel.com, linux-kernel@vger.kernel.org, keyrings@vger.kernel.org, linux-crypto@vger.kernel.org, dwmw2@infradead.org, davem@davemloft.net
List-Id: linux-api@vger.kernel.org

From: Stephan Mueller <smueller@chronox.de>

Add the Makefile and Kconfig updates to allow algif_akcipher to be
compiled.

Signed-off-by: Stephan Mueller <smueller@chronox.de>
Signed-off-by: Tadeusz Struk <tadeusz.struk@intel.com>
---
 crypto/Kconfig  |    9 +++++++++
 crypto/Makefile |    1 +
 2 files changed, 10 insertions(+)

diff --git a/crypto/Kconfig b/crypto/Kconfig
index 1d33beb..3c6113e 100644
--- a/crypto/Kconfig
+++ b/crypto/Kconfig
@@ -1627,6 +1627,15 @@ config CRYPTO_USER_API_AEAD
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
index 4f4ef7e..c51ac16 100644
--- a/crypto/Makefile
+++ b/crypto/Makefile
@@ -121,6 +121,7 @@ obj-$(CONFIG_CRYPTO_USER_API_HASH) += algif_hash.o
 obj-$(CONFIG_CRYPTO_USER_API_SKCIPHER) += algif_skcipher.o
 obj-$(CONFIG_CRYPTO_USER_API_RNG) += algif_rng.o
 obj-$(CONFIG_CRYPTO_USER_API_AEAD) += algif_aead.o
+obj-$(CONFIG_CRYPTO_USER_API_AKCIPHER) += algif_akcipher.o
 
 #
 # generic algorithms and the async_tx api

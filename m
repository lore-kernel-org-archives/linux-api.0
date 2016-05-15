From: Tadeusz Struk <tadeusz.struk@intel.com>
Subject: [PATCH v6 4/6] crypto: algif_akcipher - enable compilation
Date: Sat, 14 May 2016 21:17:07 -0700
Message-ID: <20160515041707.15888.48987.stgit@tstruk-mobl1>
References: <20160515041645.15888.94903.stgit@tstruk-mobl1>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-crypto-owner@vger.kernel.org>
In-Reply-To: <20160515041645.15888.94903.stgit@tstruk-mobl1>
Sender: linux-crypto-owner@vger.kernel.org
To: dhowells@redhat.com
Cc: herbert@gondor.apana.org.au, tadeusz.struk@intel.com, smueller@chronox.de, linux-api@vger.kernel.org, marcel@holtmann.org, linux-kernel@vger.kernel.org, keyrings@vger.kernel.org, linux-crypto@vger.kernel.org, dwmw2@infradead.org, davem@davemloft.net
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
index 93a1fdc..b932319 100644
--- a/crypto/Kconfig
+++ b/crypto/Kconfig
@@ -1626,6 +1626,15 @@ config CRYPTO_USER_API_AEAD
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

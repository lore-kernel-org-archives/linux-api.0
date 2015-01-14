From: Stephan Mueller <smueller-T9tCv8IpfcWELgA04lAiVw@public.gmane.org>
Subject: [PATCH v10 2/2] crypto: AF_ALG: enable AEAD interface compilation
Date: Wed, 14 Jan 2015 04:53:43 +0100
Message-ID: <1957342.M3tYxT7ugI@tachyon.chronox.de>
References: <5489736.JvWhZNrmuD@tachyon.chronox.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <5489736.JvWhZNrmuD-PJstQz4BMNNP20K/wil9xYQuADTiUCJX@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: 'Herbert Xu' <herbert-lOAM2aK0SrRLBo1qDEOMRrpzq4S04n8Q@public.gmane.org>
Cc: Daniel Borkmann <dborkman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, 'Quentin Gouchet' <quentin.gouchet-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, 'LKML' <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, ABI/API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-crypto-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

Enable compilation of the AEAD AF_ALG support and provide a Kconfig
option to compile the AEAD AF_ALG support.

Signed-off-by: Stephan Mueller <smueller-T9tCv8IpfcWELgA04lAiVw@public.gmane.org>
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

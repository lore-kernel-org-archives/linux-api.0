From: Stephan Mueller <smueller@chronox.de>
Subject: [PATCH v3 1/4] crypto: AF_ALG -- add sign/verify API
Date: Fri, 18 Dec 2015 00:50:18 +0100
Message-ID: <3062724.SGMeAZnzym@myon.chronox.de>
References: <2602093.Yrp6nKrmX6@myon.chronox.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <2602093.Yrp6nKrmX6@myon.chronox.de>
Sender: linux-kernel-owner@vger.kernel.org
To: herbert@gondor.apana.org.au
Cc: tadeusz.struk@intel.com, marcel@holtmann.org, dwmw2@infradead.org, linux-api@vger.kernel.org, linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-api@vger.kernel.org

Add the flags for handling signature generation and signature
verification.

Also, the patch adds the interface for setting a public key.

Signed-off-by: Stephan Mueller <smueller@chronox.de>
---
 include/uapi/linux/if_alg.h | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/include/uapi/linux/if_alg.h b/include/uapi/linux/if_alg.h
index f2acd2f..02e6162 100644
--- a/include/uapi/linux/if_alg.h
+++ b/include/uapi/linux/if_alg.h
@@ -34,9 +34,12 @@ struct af_alg_iv {
 #define ALG_SET_OP			3
 #define ALG_SET_AEAD_ASSOCLEN		4
 #define ALG_SET_AEAD_AUTHSIZE		5
+#define ALG_SET_PUBKEY			6
 
 /* Operations */
 #define ALG_OP_DECRYPT			0
 #define ALG_OP_ENCRYPT			1
+#define ALG_OP_SIGN			2
+#define ALG_OP_VERIFY			3
 
 #endif	/* _LINUX_IF_ALG_H */
-- 
2.5.0

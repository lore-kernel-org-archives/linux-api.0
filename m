From: Stephan Mueller <smueller@chronox.de>
Subject: [PATCH v2 2/5] crypto: AF_ALG -- add sign/verify API
Date: Sun, 18 Oct 2015 12:46:45 +0200
Message-ID: <8604636.C7vCDu3JXH@myon.chronox.de>
References: <1831785.BBs8Hj3CxY@myon.chronox.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1831785.BBs8Hj3CxY@myon.chronox.de>
Sender: linux-kernel-owner@vger.kernel.org
To: herbert@gondor.apana.org.au
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org, linux-api@vger.kernel.org
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

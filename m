From: Tadeusz Struk <tadeusz.struk@intel.com>
Subject: [PATCH v6 1/6] crypto: AF_ALG -- add sign/verify API
Date: Sat, 14 May 2016 21:16:50 -0700
Message-ID: <20160515041650.15888.51083.stgit@tstruk-mobl1>
References: <20160515041645.15888.94903.stgit@tstruk-mobl1>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20160515041645.15888.94903.stgit@tstruk-mobl1>
Sender: linux-kernel-owner@vger.kernel.org
To: dhowells@redhat.com
Cc: herbert@gondor.apana.org.au, tadeusz.struk@intel.com, smueller@chronox.de, linux-api@vger.kernel.org, marcel@holtmann.org, linux-kernel@vger.kernel.org, keyrings@vger.kernel.org, linux-crypto@vger.kernel.org, dwmw2@infradead.org, davem@davemloft.net
List-Id: linux-api@vger.kernel.org

From: Stephan Mueller <smueller@chronox.de>

Add the flags for handling signature generation and signature
verification.

Also, the patch adds the interface for setting a public key.

Signed-off-by: Stephan Mueller <smueller@chronox.de>
Signed-off-by: Tadeusz Struk <tadeusz.struk@intel.com>
---
 include/uapi/linux/if_alg.h |    3 +++
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

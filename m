From: Tadeusz Struk <tadeusz.struk@intel.com>
Subject: [PATCH v4 1/7] crypto: AF_ALG -- add sign/verify API
Date: Thu, 31 Mar 2016 18:37:51 -0700
Message-ID: <20160401013751.16799.29796.stgit@tstruk-mobl1>
References: <20160401013745.16799.91093.stgit@tstruk-mobl1>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-crypto-owner@vger.kernel.org>
In-Reply-To: <20160401013745.16799.91093.stgit@tstruk-mobl1>
Sender: linux-crypto-owner@vger.kernel.org
To: herbert@gondor.apana.org.au
Cc: tadeusz.struk@intel.com, smueller@chronox.de, linux-api@vger.kernel.org, marcel@holtmann.org, linux-kernel@vger.kernel.org, dhowells@redhat.com, keyrings@vger.kernel.org, linux-crypto@vger.kernel.org, dwmw2@infradead.org, davem@davemloft.net
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

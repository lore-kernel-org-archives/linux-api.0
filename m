From: Stephan Mueller <smueller@chronox.de>
Subject: [PATCH v4 1/5] crypto: AF_ALG: add user space interface for AEAD
Date: Wed, 03 Dec 2014 20:55:42 +0100
Message-ID: <4746255.Vltg6sM4x3@tachyon.chronox.de>
References: <2105559.EmODblLYuY@tachyon.chronox.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Return-path: <linux-crypto-owner@vger.kernel.org>
In-Reply-To: <2105559.EmODblLYuY@tachyon.chronox.de>
Sender: linux-crypto-owner@vger.kernel.org
To: herbert@gondor.apana.org.au
Cc: Daniel Borkmann <dborkman@redhat.com>, 'Quentin Gouchet' <quentin.gouchet@gmail.com>, 'LKML' <linux-kernel@vger.kernel.org>, linux-crypto@vger.kernel.org, linux-api@vger.kernel.org
List-Id: linux-api@vger.kernel.org

AEAD requires the caller to specify the following information separate
from the data stream. This information allows the AEAD interface handler
to identify the AAD, ciphertext/plaintext and the authentication tag:

        * Associated authentication data of arbitrary length and
          length

        * Length of authentication tag for encryption

Signed-off-by: Stephan Mueller <smueller@chronox.de>
---
 crypto/af_alg.c             | 6 ++++++
 include/crypto/if_alg.h     | 1 +
 include/uapi/linux/if_alg.h | 2 ++
 3 files changed, 9 insertions(+)

diff --git a/crypto/af_alg.c b/crypto/af_alg.c
index 6a3ad80..68ff113 100644
--- a/crypto/af_alg.c
+++ b/crypto/af_alg.c
@@ -421,6 +421,12 @@ int af_alg_cmsg_send(struct msghdr *msg, struct af_alg_control *con)
 			con->op = *(u32 *)CMSG_DATA(cmsg);
 			break;
 
+		case ALG_SET_AEAD_ASSOCLEN:
+			if (cmsg->cmsg_len < CMSG_LEN(sizeof(u32)))
+				return -EINVAL;
+			con->aead_assoclen = *(u32 *)CMSG_DATA(cmsg);
+			break;
+
 		default:
 			return -EINVAL;
 		}
diff --git a/include/crypto/if_alg.h b/include/crypto/if_alg.h
index d61c111..cd62bf4 100644
--- a/include/crypto/if_alg.h
+++ b/include/crypto/if_alg.h
@@ -42,6 +42,7 @@ struct af_alg_completion {
 struct af_alg_control {
 	struct af_alg_iv *iv;
 	int op;
+	unsigned int aead_assoclen;
 };
 
 struct af_alg_type {
diff --git a/include/uapi/linux/if_alg.h b/include/uapi/linux/if_alg.h
index 0f9acce..f2acd2f 100644
--- a/include/uapi/linux/if_alg.h
+++ b/include/uapi/linux/if_alg.h
@@ -32,6 +32,8 @@ struct af_alg_iv {
 #define ALG_SET_KEY			1
 #define ALG_SET_IV			2
 #define ALG_SET_OP			3
+#define ALG_SET_AEAD_ASSOCLEN		4
+#define ALG_SET_AEAD_AUTHSIZE		5
 
 /* Operations */
 #define ALG_OP_DECRYPT			0
-- 
2.1.0

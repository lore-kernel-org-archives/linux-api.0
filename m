From: Stephan Mueller <smueller@chronox.de>
Subject: [PATCH v2 03/10] crypto: AF_ALG: extend data structuers for AEAD
Date: Sun, 16 Nov 2014 03:25:07 +0100
Message-ID: <3559156.AeU3gNGqyG@tachyon.chronox.de>
References: <5365136.g8vbXlhRyC@tachyon.chronox.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Return-path: <linux-crypto-owner@vger.kernel.org>
In-Reply-To: <5365136.g8vbXlhRyC@tachyon.chronox.de>
Sender: linux-crypto-owner@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Daniel Borkmann <dborkman@redhat.com>, quentin.gouchet@gmail.com, LKML <linux-kernel@vger.kernel.org>, linux-crypto@vger.kernel.org, ABI/API <linux-api@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

The data structure holding the state of an ongoing symmetric cipher
operation is extended by the data variables needed for AEAD.

The request data structures are encapsulated by a union as the symmetric
cipher implementation is either exclusively used for "normal" symmetric
ciphers or for AEAD ciphers.

The define MAX_AEAD_ASSOCLEN restricts the size of the associated
authentication data. The kernel must allocate memory for this data to be
stored for the cipher operation. To prevent an excessive use of memory,
it is limited to 128 bytes, which is considered to be a sensible size.

Signed-off-by: Stephan Mueller <smueller@chronox.de>
---
 crypto/algif_skcipher.c | 10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/crypto/algif_skcipher.c b/crypto/algif_skcipher.c
index 2f5d663..483ff97 100644
--- a/crypto/algif_skcipher.c
+++ b/crypto/algif_skcipher.c
@@ -46,7 +46,15 @@ struct skcipher_ctx {
 	bool merge;
 	bool enc;
 
-	struct ablkcipher_request req;
+	bool aead;
+	void *aead_assoc;
+	/* define arbitrary maximum length of associated data */
+	#define MAX_AEAD_ASSOCLEN 128
+	struct scatterlist sg_aead_assoc;
+	union {
+		struct ablkcipher_request ablkcipher_req;
+		struct aead_request aead_req;
+	} u;
 };
 
 #define MAX_SGL_ENTS ((4096 - sizeof(struct skcipher_sg_list)) / \
-- 
2.1.0

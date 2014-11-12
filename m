From: Stephan Mueller <smueller@chronox.de>
Subject: [PATCH 6/8] crypto: AF_ALG: make setkey optional
Date: Wed, 12 Nov 2014 08:05:11 +0100
Message-ID: <8532179.q3pCnHKv8n@tachyon.chronox.de>
References: <4738444.A2vZX1nNCo@tachyon.chronox.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Return-path: <linux-crypto-owner@vger.kernel.org>
In-Reply-To: <4738444.A2vZX1nNCo@tachyon.chronox.de>
Sender: linux-crypto-owner@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: ABI/API <linux-api@vger.kernel.org>, linux-crypto@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

The current AF_ALG implementation requires that a userspace interface
implementation must provide a callback for setkey. Such a call is not
appliable to random number generators.

To prepare AF_ALG for the addition of a random number generator user
space interface, this function callback invocation is made optional.

Signed-off-by: Stephan Mueller <smueller@chronox.de>
---
 crypto/af_alg.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/crypto/af_alg.c b/crypto/af_alg.c
index 635140b..47a199c 100644
--- a/crypto/af_alg.c
+++ b/crypto/af_alg.c
@@ -177,6 +177,9 @@ static int alg_setkey(struct sock *sk, char __user *ukey,
 	u8 *key;
 	int err;
 
+	if (!type->setkey)
+		return -EOPNOTSUPP;
+
 	key = sock_kmalloc(sk, keylen, GFP_KERNEL);
 	if (!key)
 		return -ENOMEM;
-- 
2.1.0

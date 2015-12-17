From: Stephan Mueller <smueller@chronox.de>
Subject: [PATCH v3 2/4] crypto: AF_ALG -- add setpubkey setsockopt call
Date: Fri, 18 Dec 2015 00:50:40 +0100
Message-ID: <2319743.4dGlRbI5FA@myon.chronox.de>
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

For supporting asymmetric ciphers, user space must be able to set the
public key. The patch adds a new setsockopt call for setting the public
key.

Signed-off-by: Stephan Mueller <smueller@chronox.de>
---
 crypto/af_alg.c         | 18 +++++++++++++-----
 include/crypto/if_alg.h |  1 +
 2 files changed, 14 insertions(+), 5 deletions(-)

diff --git a/crypto/af_alg.c b/crypto/af_alg.c
index a8e7aa3..767a134 100644
--- a/crypto/af_alg.c
+++ b/crypto/af_alg.c
@@ -173,13 +173,17 @@ static int alg_bind(struct socket *sock, struct sockaddr *uaddr, int addr_len)
 }
 
 static int alg_setkey(struct sock *sk, char __user *ukey,
-		      unsigned int keylen)
+		      unsigned int keylen,
+		      int (*setkey)(void *private, const u8 *key,
+				    unsigned int keylen))
 {
 	struct alg_sock *ask = alg_sk(sk);
-	const struct af_alg_type *type = ask->type;
 	u8 *key;
 	int err;
 
+	if (!setkey)
+		return -ENOPROTOOPT;
+
 	key = sock_kmalloc(sk, keylen, GFP_KERNEL);
 	if (!key)
 		return -ENOMEM;
@@ -188,7 +192,7 @@ static int alg_setkey(struct sock *sk, char __user *ukey,
 	if (copy_from_user(key, ukey, keylen))
 		goto out;
 
-	err = type->setkey(ask->private, key, keylen);
+	err = setkey(ask->private, key, keylen);
 
 out:
 	sock_kzfree_s(sk, key, keylen);
@@ -214,10 +218,14 @@ static int alg_setsockopt(struct socket *sock, int level, int optname,
 	case ALG_SET_KEY:
 		if (sock->state == SS_CONNECTED)
 			goto unlock;
-		if (!type->setkey)
+
+		err = alg_setkey(sk, optval, optlen, type->setkey);
+		break;
+	case ALG_SET_PUBKEY:
+		if (sock->state == SS_CONNECTED)
 			goto unlock;
 
-		err = alg_setkey(sk, optval, optlen);
+		err = alg_setkey(sk, optval, optlen, type->setpubkey);
 		break;
 	case ALG_SET_AEAD_AUTHSIZE:
 		if (sock->state == SS_CONNECTED)
diff --git a/include/crypto/if_alg.h b/include/crypto/if_alg.h
index 018afb2..ca4dc72 100644
--- a/include/crypto/if_alg.h
+++ b/include/crypto/if_alg.h
@@ -49,6 +49,7 @@ struct af_alg_type {
 	void *(*bind)(const char *name, u32 type, u32 mask);
 	void (*release)(void *private);
 	int (*setkey)(void *private, const u8 *key, unsigned int keylen);
+	int (*setpubkey)(void *private, const u8 *key, unsigned int keylen);
 	int (*accept)(void *private, struct sock *sk);
 	int (*setauthsize)(void *private, unsigned int authsize);
 
-- 
2.5.0

From: Tadeusz Struk <tadeusz.struk@intel.com>
Subject: [PATCH v3 2/7] crypto: AF_ALG -- add setpubkey setsockopt call
Date: Tue, 29 Mar 2016 17:57:03 -0700
Message-ID: <20160330005703.25410.79861.stgit@tstruk-mobl1>
References: <20160330005649.25410.70508.stgit@tstruk-mobl1>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-crypto-owner@vger.kernel.org>
In-Reply-To: <20160330005649.25410.70508.stgit@tstruk-mobl1>
Sender: linux-crypto-owner@vger.kernel.org
To: herbert@gondor.apana.org.au
Cc: tadeusz.struk@intel.com, smueller@chronox.de, linux-api@vger.kernel.org, marcel@holtmann.org, linux-kernel@vger.kernel.org, dhowells@redhat.com, keyrings@vger.kernel.org, linux-crypto@vger.kernel.org, dwmw2@infradead.org, davem@davemloft.net
List-Id: linux-api@vger.kernel.org

From: Stephan Mueller <smueller@chronox.de>

For supporting asymmetric ciphers, user space must be able to set the
public key. The patch adds a new setsockopt call for setting the public
key.

Signed-off-by: Stephan Mueller <smueller@chronox.de>
Signed-off-by: Tadeusz Struk <tadeusz.struk@intel.com>
---
 crypto/af_alg.c         |   18 +++++++++++++-----
 include/crypto/if_alg.h |    1 +
 2 files changed, 14 insertions(+), 5 deletions(-)

diff --git a/crypto/af_alg.c b/crypto/af_alg.c
index f5e18c2..24dc082 100644
--- a/crypto/af_alg.c
+++ b/crypto/af_alg.c
@@ -202,13 +202,17 @@ unlock:
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
@@ -217,7 +221,7 @@ static int alg_setkey(struct sock *sk, char __user *ukey,
 	if (copy_from_user(key, ukey, keylen))
 		goto out;
 
-	err = type->setkey(ask->private, key, keylen);
+	err = setkey(ask->private, key, keylen);
 
 out:
 	sock_kzfree_s(sk, key, keylen);
@@ -247,10 +251,14 @@ static int alg_setsockopt(struct socket *sock, int level, int optname,
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
index a2bfd78..6c3e6e7 100644
--- a/include/crypto/if_alg.h
+++ b/include/crypto/if_alg.h
@@ -52,6 +52,7 @@ struct af_alg_type {
 	void *(*bind)(const char *name, u32 type, u32 mask);
 	void (*release)(void *private);
 	int (*setkey)(void *private, const u8 *key, unsigned int keylen);
+	int (*setpubkey)(void *private, const u8 *key, unsigned int keylen);
 	int (*accept)(void *private, struct sock *sk);
 	int (*accept_nokey)(void *private, struct sock *sk);
 	int (*setauthsize)(void *private, unsigned int authsize);

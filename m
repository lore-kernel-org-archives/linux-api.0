From: Stephan Mueller <smueller@chronox.de>
Subject: [PATCH v5 2/8] crypto: AF_ALG: add setsockopt for auth tag size
Date: Sun, 07 Dec 2014 23:21:42 +0100
Message-ID: <5195949.2IIqD2tWoo@tachyon.chronox.de>
References: <56740432.V2v4gLHrzS@tachyon.chronox.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <56740432.V2v4gLHrzS@tachyon.chronox.de>
Sender: linux-kernel-owner@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Daniel Borkmann <dborkman@redhat.com>, 'Quentin Gouchet' <quentin.gouchet@gmail.com>, 'LKML' <linux-kernel@vger.kernel.org>, linux-crypto@vger.kernel.org, linux-api@vger.kernel.org
List-Id: linux-api@vger.kernel.org

Use setsockopt on the tfm FD to provide the authentication tag size for
an AEAD cipher. This is achieved by adding a callback function which is
intended to be used by the AEAD AF_ALG implementation.

The optlen argument of the setsockopt specifies the authentication tag
size to be used with the AEAD tfm.

Signed-off-by: Stephan Mueller <smueller@chronox.de>
---
 crypto/af_alg.c         | 7 +++++++
 include/crypto/if_alg.h | 1 +
 2 files changed, 8 insertions(+)

diff --git a/crypto/af_alg.c b/crypto/af_alg.c
index 68ff113..547c369 100644
--- a/crypto/af_alg.c
+++ b/crypto/af_alg.c
@@ -215,6 +215,13 @@ static int alg_setsockopt(struct socket *sock, int level, int optname,
 			goto unlock;
 
 		err = alg_setkey(sk, optval, optlen);
+		break;
+	case ALG_SET_AEAD_AUTHSIZE:
+		if (sock->state == SS_CONNECTED)
+			goto unlock;
+		if (!type->setauthsize)
+			goto unlock;
+		err = type->setauthsize(ask->private, optlen);
 	}
 
 unlock:
diff --git a/include/crypto/if_alg.h b/include/crypto/if_alg.h
index cd62bf4..5c7b6c5 100644
--- a/include/crypto/if_alg.h
+++ b/include/crypto/if_alg.h
@@ -50,6 +50,7 @@ struct af_alg_type {
 	void (*release)(void *private);
 	int (*setkey)(void *private, const u8 *key, unsigned int keylen);
 	int (*accept)(void *private, struct sock *sk);
+	int (*setauthsize)(void *private, unsigned int authsize);
 
 	struct proto_ops *ops;
 	struct module *owner;
-- 
2.1.0

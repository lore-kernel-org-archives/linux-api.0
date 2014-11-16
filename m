From: Stephan Mueller <smueller-T9tCv8IpfcWELgA04lAiVw@public.gmane.org>
Subject: [PATCH v2 06/10] crypto: AF_ALG: make setkey optional
Date: Sun, 16 Nov 2014 03:26:58 +0100
Message-ID: <2196615.OgfUNzPKdf@tachyon.chronox.de>
References: <5365136.g8vbXlhRyC@tachyon.chronox.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <5365136.g8vbXlhRyC-PJstQz4BMNNP20K/wil9xYQuADTiUCJX@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Herbert Xu <herbert-lOAM2aK0SrRLBo1qDEOMRrpzq4S04n8Q@public.gmane.org>
Cc: Daniel Borkmann <dborkman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, quentin.gouchet-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-crypto-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, ABI/API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

The current AF_ALG implementation requires that a userspace interface
implementation must provide a callback for setkey. Such a call is not
appliable to random number generators.

To prepare AF_ALG for the addition of a random number generator user
space interface, this function callback invocation is made optional.

Signed-off-by: Stephan Mueller <smueller-T9tCv8IpfcWELgA04lAiVw@public.gmane.org>
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

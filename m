From: Stephan Mueller <smueller-T9tCv8IpfcWELgA04lAiVw@public.gmane.org>
Subject: [PATCH v5 6/8] crypto: AF_ALG: zeroize key / seed data
Date: Sun, 07 Dec 2014 23:24:36 +0100
Message-ID: <2737258.UUWqeH5oOM@tachyon.chronox.de>
References: <56740432.V2v4gLHrzS@tachyon.chronox.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <56740432.V2v4gLHrzS-PJstQz4BMNNP20K/wil9xYQuADTiUCJX@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Herbert Xu <herbert-lOAM2aK0SrRLBo1qDEOMRrpzq4S04n8Q@public.gmane.org>
Cc: Daniel Borkmann <dborkman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, 'Quentin Gouchet' <quentin.gouchet-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, 'LKML' <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-crypto-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

alg_setop shall zeroize the sensitive data after use.

Signed-off-by: Stephan Mueller <smueller-T9tCv8IpfcWELgA04lAiVw@public.gmane.org>
---
 crypto/af_alg.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/crypto/af_alg.c b/crypto/af_alg.c
index d1eb1e9..836fa4a 100644
--- a/crypto/af_alg.c
+++ b/crypto/af_alg.c
@@ -189,7 +189,7 @@ static int alg_setop(struct sock *sk, char __user *udata,
 	err = handler(ask->private, data, datalen);
 
 out:
-	sock_kfree_s(sk, data, datalen);
+	sock_kzfree_s(sk, data, datalen);
 
 	return err;
 }
-- 
2.1.0

From: Marcel Holtmann <marcel-kz+m5ild9QBg9hUCZPvPmw@public.gmane.org>
Subject: Re: [PATCH v2 3/5] crypto: AF_ALG -- add setpubkey setsockopt call
Date: Fri, 30 Oct 2015 17:16:47 +0900
Message-ID: <DE14D478-A941-4F5B-A43F-7C6DB51E2CCE@holtmann.org>
References: <1831785.BBs8Hj3CxY@myon.chronox.de> <1500043.fUe7nt4IEH@myon.chronox.de>
Mime-Version: 1.0 (Mac OS X Mail 9.1 \(3096.5\))
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1500043.fUe7nt4IEH-Veo+UhszpQh6vwJ5+F2VIg@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Stephan Mueller <smueller-T9tCv8IpfcWELgA04lAiVw@public.gmane.org>
Cc: Herbert Xu <herbert-lOAM2aK0SrRLBo1qDEOMRrpzq4S04n8Q@public.gmane.org>, linux-crypto-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

Hi Stephan,

> For supporting asymmetric ciphers, user space must be able to set the
> public key. The patch adds a new setsockopt call for setting the public
> key.
> 
> Signed-off-by: Stephan Mueller <smueller-T9tCv8IpfcWELgA04lAiVw@public.gmane.org>
> ---
> crypto/af_alg.c         | 14 +++++++++++---
> include/crypto/if_alg.h |  1 +
> 2 files changed, 12 insertions(+), 3 deletions(-)
> 
> diff --git a/crypto/af_alg.c b/crypto/af_alg.c
> index a8e7aa3..bf6528e 100644
> --- a/crypto/af_alg.c
> +++ b/crypto/af_alg.c
> @@ -173,13 +173,16 @@ static int alg_bind(struct socket *sock, struct sockaddr *uaddr, int addr_len)
> }
> 
> static int alg_setkey(struct sock *sk, char __user *ukey,
> -		      unsigned int keylen)
> +		      unsigned int keylen, bool pubkey)
> {
> 	struct alg_sock *ask = alg_sk(sk);
> 	const struct af_alg_type *type = ask->type;
> 	u8 *key;
> 	int err;
> 
> +	if (pubkey && !type->setpubkey)
> +		return -EOPNOTSUPP;
> +
> 	key = sock_kmalloc(sk, keylen, GFP_KERNEL);
> 	if (!key)
> 		return -ENOMEM;
> @@ -188,7 +191,10 @@ static int alg_setkey(struct sock *sk, char __user *ukey,
> 	if (copy_from_user(key, ukey, keylen))
> 		goto out;
> 
> -	err = type->setkey(ask->private, key, keylen);
> +	if (pubkey)
> +		err = type->setpubkey(ask->private, key, keylen);
> +	else
> +		err = type->setkey(ask->private, key, keyless);

why is this kind of hackery needed? Why not just introduce alg_setpubkey to keep this a lot cleaner.

> 
> out:
> 	sock_kzfree_s(sk, key, keylen);
> @@ -212,12 +218,14 @@ static int alg_setsockopt(struct socket *sock, int level, int optname,
> 
> 	switch (optname) {
> 	case ALG_SET_KEY:
> +	case ALG_SET_PUBKEY:
> 		if (sock->state == SS_CONNECTED)
> 			goto unlock;
> 		if (!type->setkey)
> 			goto unlock;
> 
> -		err = alg_setkey(sk, optval, optlen);
> +		err = alg_setkey(sk, optval, optlen,
> +				 (optname == ALG_SET_PUBKEY) ? true : false);
> 		break;

Same here. Why not give ALG_SET_PUBKEY a separate case statement. Especially since you have to check type->setkey vs type->setpubkey.

> 	case ALG_SET_AEAD_AUTHSIZE:
> 		if (sock->state == SS_CONNECTED)
> diff --git a/include/crypto/if_alg.h b/include/crypto/if_alg.h
> index 018afb2..ca4dc72 100644
> --- a/include/crypto/if_alg.h
> +++ b/include/crypto/if_alg.h
> @@ -49,6 +49,7 @@ struct af_alg_type {
> 	void *(*bind)(const char *name, u32 type, u32 mask);
> 	void (*release)(void *private);
> 	int (*setkey)(void *private, const u8 *key, unsigned int keylen);
> +	int (*setpubkey)(void *private, const u8 *key, unsigned int keylen);
> 	int (*accept)(void *private, struct sock *sk);
> 	int (*setauthsize)(void *private, unsigned int authorize);

Regards

Marcel

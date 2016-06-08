From: Mat Martineau <mathew.j.martineau@linux.intel.com>
Subject: Re: [PATCH v6 3/6] crypto: AF_ALG -- add asymmetric cipher
 interface
Date: Tue, 7 Jun 2016 17:28:07 -0700 (PDT)
Message-ID: <alpine.OSX.2.20.1606071719170.9891@mjmartin-mac01.local>
References: <20160515041645.15888.94903.stgit@tstruk-mobl1> <20160515041701.15888.53830.stgit@tstruk-mobl1>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII; format=flowed
Return-path: <linux-crypto-owner@vger.kernel.org>
In-Reply-To: <20160515041701.15888.53830.stgit@tstruk-mobl1>
Sender: linux-crypto-owner@vger.kernel.org
To: smueller@chronox.de
Cc: Tadeusz Struk <tadeusz.struk@intel.com>, dhowells@redhat.com, herbert@gondor.apana.org.au, linux-api@vger.kernel.org, marcel@holtmann.org, linux-kernel@vger.kernel.org, keyrings@vger.kernel.org, linux-crypto@vger.kernel.org, dwmw2@infradead.org, davem@davemloft.net
List-Id: linux-api@vger.kernel.org


Stephan,

On Sat, 14 May 2016, Tadeusz Struk wrote:

> From: Stephan Mueller <smueller@chronox.de>
>
> This patch adds the user space interface for asymmetric ciphers. The
> interface allows the use of sendmsg as well as vmsplice to provide data.
>
> This version has been rebased on top of 4.6 and a few chackpatch issues
> have been fixed.
>
> Signed-off-by: Stephan Mueller <smueller@chronox.de>
> Signed-off-by: Tadeusz Struk <tadeusz.struk@intel.com>
> ---
> diff --git a/crypto/algif_akcipher.c b/crypto/algif_akcipher.c
> new file mode 100644
> index 0000000..6342b6e
> --- /dev/null
> +++ b/crypto/algif_akcipher.c
> +
> +static int akcipher_recvmsg(struct socket *sock, struct msghdr *msg,
> +			    size_t ignored, int flags)
> +{
> +	struct sock *sk = sock->sk;
> +	struct alg_sock *ask = alg_sk(sk);
> +	struct akcipher_ctx *ctx = ask->private;
> +	struct akcipher_sg_list *sgl = &ctx->tsgl;
> +	unsigned int i = 0;
> +	int err;
> +	unsigned long used = 0;
> +	size_t usedpages = 0;
> +	unsigned int cnt = 0;
> +
> +	/* Limit number of IOV blocks to be accessed below */
> +	if (msg->msg_iter.nr_segs > ALG_MAX_PAGES)
> +		return -ENOMSG;
> +
> +	lock_sock(sk);
> +
> +	if (ctx->more) {
> +		err = akcipher_wait_for_data(sk, flags);
> +		if (err)
> +			goto unlock;
> +	}
> +
> +	used = ctx->used;
> +
> +	/* convert iovecs of output buffers into scatterlists */
> +	while (iov_iter_count(&msg->msg_iter)) {
> +		/* make one iovec available as scatterlist */
> +		err = af_alg_make_sg(&ctx->rsgl[cnt], &msg->msg_iter,
> +				     iov_iter_count(&msg->msg_iter));
> +		if (err < 0)
> +			goto unlock;
> +		usedpages += err;
> +		/* chain the new scatterlist with previous one */
> +		if (cnt)
> +			af_alg_link_sg(&ctx->rsgl[cnt - 1], &ctx->rsgl[cnt]);
> +
> +		iov_iter_advance(&msg->msg_iter, err);
> +		cnt++;
> +	}
> +
> +	/* ensure output buffer is sufficiently large */
> +	if (usedpages < akcipher_calcsize(ctx)) {
> +		err = -EMSGSIZE;
> +		goto unlock;
> +	}

Why is the size of the output buffer enforced here instead of depending on 
the algorithm implementation?

Thanks,

Mat


> +	sg_mark_end(sgl->sg + sgl->cur - 1);
> +
> +	akcipher_request_set_crypt(&ctx->req, sgl->sg, ctx->rsgl[0].sg, used,
> +				   usedpages);
> +	switch (ctx->op) {
> +	case ALG_OP_VERIFY:
> +		err = crypto_akcipher_verify(&ctx->req);
> +		break;
> +	case ALG_OP_SIGN:
> +		err = crypto_akcipher_sign(&ctx->req);
> +		break;
> +	case ALG_OP_ENCRYPT:
> +		err = crypto_akcipher_encrypt(&ctx->req);
> +		break;
> +	case ALG_OP_DECRYPT:
> +		err = crypto_akcipher_decrypt(&ctx->req);
> +		break;
> +	default:
> +		err = -EFAULT;
> +		goto unlock;
> +	}
> +
> +	err = af_alg_wait_for_completion(err, &ctx->completion);
> +
> +	if (err) {
> +		/* EBADMSG implies a valid cipher operation took place */
> +		if (err == -EBADMSG)
> +			akcipher_put_sgl(sk);
> +		goto unlock;
> +	}
> +
> +	akcipher_put_sgl(sk);
> +
> +unlock:
> +	for (i = 0; i < cnt; i++)
> +		af_alg_free_sg(&ctx->rsgl[i]);
> +
> +	akcipher_wmem_wakeup(sk);
> +	release_sock(sk);
> +
> +	return err ? err : ctx->req.dst_len;
> +}

--
Mat Martineau
Intel OTC

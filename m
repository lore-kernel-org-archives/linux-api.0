From: Mat Martineau <mathew.j.martineau-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Subject: Re: [PATCH v6 3/6] crypto: AF_ALG -- add asymmetric cipher
 interface
Date: Tue, 14 Jun 2016 10:22:15 -0700 (PDT)
Message-ID: <alpine.OSX.2.20.1606140952080.13500@animeshb-mobl.amr.corp.intel.com>
References: <20160515041645.15888.94903.stgit@tstruk-mobl1> <20160515041701.15888.53830.stgit@tstruk-mobl1>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII; format=flowed
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160515041701.15888.53830.stgit@tstruk-mobl1>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: smueller-T9tCv8IpfcWELgA04lAiVw@public.gmane.org
Cc: Tadeusz Struk <tadeusz.struk-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, herbert-lOAM2aK0SrRLBo1qDEOMRrpzq4S04n8Q@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, marcel-kz+m5ild9QBg9hUCZPvPmw@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, keyrings-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-crypto-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, dwmw2-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org
List-Id: linux-api@vger.kernel.org


Stephan,

On Sat, 14 May 2016, Tadeusz Struk wrote:

> From: Stephan Mueller <smueller-T9tCv8IpfcWELgA04lAiVw@public.gmane.org>
>
> This patch adds the user space interface for asymmetric ciphers. The
> interface allows the use of sendmsg as well as vmsplice to provide data.
>
> This version has been rebased on top of 4.6 and a few chackpatch issues
> have been fixed.
>
> Signed-off-by: Stephan Mueller <smueller-T9tCv8IpfcWELgA04lAiVw@public.gmane.org>
> Signed-off-by: Tadeusz Struk <tadeusz.struk-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> ---
> crypto/algif_akcipher.c |  542 +++++++++++++++++++++++++++++++++++++++++++++++
> 1 file changed, 542 insertions(+)
> create mode 100644 crypto/algif_akcipher.c
>
> diff --git a/crypto/algif_akcipher.c b/crypto/algif_akcipher.c
> new file mode 100644
> index 0000000..6342b6e
> --- /dev/null
> +++ b/crypto/algif_akcipher.c
> +
> +static int akcipher_sendmsg(struct socket *sock, struct msghdr *msg,
> +			    size_t size)
> +{
> +	struct sock *sk = sock->sk;
> +	struct alg_sock *ask = alg_sk(sk);
> +	struct akcipher_ctx *ctx = ask->private;
> +	struct akcipher_sg_list *sgl = &ctx->tsgl;
> +	struct af_alg_control con = {};
> +	long copied = 0;
> +	int op = 0;
> +	bool init = 0;
> +	int err;
> +
> +	if (msg->msg_controllen) {
> +		err = af_alg_cmsg_send(msg, &con);
> +		if (err)
> +			return err;
> +
> +		init = 1;
> +		switch (con.op) {
> +		case ALG_OP_VERIFY:
> +		case ALG_OP_SIGN:
> +		case ALG_OP_ENCRYPT:
> +		case ALG_OP_DECRYPT:
> +			op = con.op;
> +			break;
> +		default:
> +			return -EINVAL;
> +		}
> +	}
> +
> +	lock_sock(sk);
> +	if (!ctx->more && ctx->used)
> +		goto unlock;

err might be uninitialised at this goto. Should it be set to something 
like -EALREADY to indicate that data is already queued for a different 
crypto op?

<snip>

> +unlock:
> +	akcipher_data_wakeup(sk);
> +	release_sock(sk);
> +
> +	return err ?: copied;
> +}

Regards,

--
Mat Martineau
Intel OTC

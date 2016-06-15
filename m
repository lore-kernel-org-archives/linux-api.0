From: Stephan Mueller <smueller@chronox.de>
Subject: Re: [PATCH v6 3/6] crypto: AF_ALG -- add asymmetric cipher interface
Date: Wed, 15 Jun 2016 09:04:31 +0200
Message-ID: <5938642.dT2rHVWrVO@positron.chronox.de>
References: <20160515041645.15888.94903.stgit@tstruk-mobl1> <20160515041701.15888.53830.stgit@tstruk-mobl1> <alpine.OSX.2.20.1606140952080.13500@animeshb-mobl.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Return-path: <linux-crypto-owner@vger.kernel.org>
In-Reply-To: <alpine.OSX.2.20.1606140952080.13500@animeshb-mobl.amr.corp.intel.com>
Sender: linux-crypto-owner@vger.kernel.org
To: Mat Martineau <mathew.j.martineau@linux.intel.com>
Cc: Tadeusz Struk <tadeusz.struk@intel.com>, dhowells@redhat.com, herbert@gondor.apana.org.au, linux-api@vger.kernel.org, marcel@holtmann.org, linux-kernel@vger.kernel.org, keyrings@vger.kernel.org, linux-crypto@vger.kernel.org, dwmw2@infradead.org, davem@davemloft.net
List-Id: linux-api@vger.kernel.org

Am Dienstag, 14. Juni 2016, 10:22:15 schrieb Mat Martineau:

Hi Mat,

> Stephan,
> 
> On Sat, 14 May 2016, Tadeusz Struk wrote:
> > From: Stephan Mueller <smueller@chronox.de>
> > 
> > This patch adds the user space interface for asymmetric ciphers. The
> > interface allows the use of sendmsg as well as vmsplice to provide data.
> > 
> > This version has been rebased on top of 4.6 and a few chackpatch issues
> > have been fixed.
> > 
> > Signed-off-by: Stephan Mueller <smueller@chronox.de>
> > Signed-off-by: Tadeusz Struk <tadeusz.struk@intel.com>
> > ---
> > crypto/algif_akcipher.c |  542
> > +++++++++++++++++++++++++++++++++++++++++++++++ 1 file changed, 542
> > insertions(+)
> > create mode 100644 crypto/algif_akcipher.c
> > 
> > diff --git a/crypto/algif_akcipher.c b/crypto/algif_akcipher.c
> > new file mode 100644
> > index 0000000..6342b6e
> > --- /dev/null
> > +++ b/crypto/algif_akcipher.c
> > +
> > +static int akcipher_sendmsg(struct socket *sock, struct msghdr *msg,
> > +			    size_t size)
> > +{
> > +	struct sock *sk = sock->sk;
> > +	struct alg_sock *ask = alg_sk(sk);
> > +	struct akcipher_ctx *ctx = ask->private;
> > +	struct akcipher_sg_list *sgl = &ctx->tsgl;
> > +	struct af_alg_control con = {};
> > +	long copied = 0;
> > +	int op = 0;
> > +	bool init = 0;
> > +	int err;
> > +
> > +	if (msg->msg_controllen) {
> > +		err = af_alg_cmsg_send(msg, &con);
> > +		if (err)
> > +			return err;
> > +
> > +		init = 1;
> > +		switch (con.op) {
> > +		case ALG_OP_VERIFY:
> > +		case ALG_OP_SIGN:
> > +		case ALG_OP_ENCRYPT:
> > +		case ALG_OP_DECRYPT:
> > +			op = con.op;
> > +			break;
> > +		default:
> > +			return -EINVAL;
> > +		}
> > +	}
> > +
> > +	lock_sock(sk);
> > +	if (!ctx->more && ctx->used)
> > +		goto unlock;
> 
> err might be uninitialised at this goto. Should it be set to something
> like -EALREADY to indicate that data is already queued for a different
> crypto op?

Thanks for the hint. Tadeusz, I will provide you with an updated 
algif_akcipher.c for your patchset.

I will also have a look at the comment from Andrew.

> 
> <snip>
> 
> > +unlock:
> > +	akcipher_data_wakeup(sk);
> > +	release_sock(sk);
> > +
> > +	return err ?: copied;
> > +}
> 
> Regards,
> 
> --
> Mat Martineau
> Intel OTC


Ciao
Stephan

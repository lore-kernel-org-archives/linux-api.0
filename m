From: Stephan Mueller <smueller@chronox.de>
Subject: Re: [PATCH v6 3/6] crypto: AF_ALG -- add asymmetric cipher interface
Date: Wed, 08 Jun 2016 07:31:14 +0200
Message-ID: <6401187.24v903AfyY@tauon.atsec.com>
References: <20160515041645.15888.94903.stgit@tstruk-mobl1> <20160515041701.15888.53830.stgit@tstruk-mobl1> <alpine.OSX.2.20.1606071719170.9891@mjmartin-mac01.local>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Return-path: <linux-crypto-owner@vger.kernel.org>
In-Reply-To: <alpine.OSX.2.20.1606071719170.9891@mjmartin-mac01.local>
Sender: linux-crypto-owner@vger.kernel.org
To: Mat Martineau <mathew.j.martineau@linux.intel.com>
Cc: Tadeusz Struk <tadeusz.struk@intel.com>, dhowells@redhat.com, herbert@gondor.apana.org.au, linux-api@vger.kernel.org, marcel@holtmann.org, linux-kernel@vger.kernel.org, keyrings@vger.kernel.org, linux-crypto@vger.kernel.org, dwmw2@infradead.org, davem@davemloft.net
List-Id: linux-api@vger.kernel.org

Am Dienstag, 7. Juni 2016, 17:28:07 schrieb Mat Martineau:

Hi Mat,

> > +	used = ctx->used;
> > +
> > +	/* convert iovecs of output buffers into scatterlists */
> > +	while (iov_iter_count(&msg->msg_iter)) {
> > +		/* make one iovec available as scatterlist */
> > +		err = af_alg_make_sg(&ctx->rsgl[cnt], &msg->msg_iter,
> > +				     iov_iter_count(&msg->msg_iter));
> > +		if (err < 0)
> > +			goto unlock;
> > +		usedpages += err;
> > +		/* chain the new scatterlist with previous one */
> > +		if (cnt)
> > +			af_alg_link_sg(&ctx->rsgl[cnt - 1], &ctx->rsgl[cnt]);
> > +
> > +		iov_iter_advance(&msg->msg_iter, err);
> > +		cnt++;
> > +	}
> > +
> > +	/* ensure output buffer is sufficiently large */
> > +	if (usedpages < akcipher_calcsize(ctx)) {
> > +		err = -EMSGSIZE;
> > +		goto unlock;
> > +	}
> 
> Why is the size of the output buffer enforced here instead of depending on
> the algorithm implementation?

akcipher_calcsize calls crypto_akcipher_maxsize to get the maximum size the 
algorithm generates as output during its operation.

The code ensures that the caller provided at least that amount of memory for 
the kernel to store its data in. This check therefore is present to ensure the 
kernel does not overstep memory boundaries in user space.

What is your concern?

Thanks

Ciao
Stephan

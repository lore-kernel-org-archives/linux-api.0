From: Stephan Mueller <smueller@chronox.de>
Subject: Re: [PATCH v6 3/6] crypto: AF_ALG -- add asymmetric cipher interface
Date: Thu, 09 Jun 2016 11:28:55 +0200
Message-ID: <8115473.hELPVzZyL0@tauon.atsec.com>
References: <20160515041645.15888.94903.stgit@tstruk-mobl1> <6401187.24v903AfyY@tauon.atsec.com> <alpine.OSX.2.20.1606081135160.16651@mjmartin-mac01.local>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Return-path: <linux-crypto-owner@vger.kernel.org>
In-Reply-To: <alpine.OSX.2.20.1606081135160.16651@mjmartin-mac01.local>
Sender: linux-crypto-owner@vger.kernel.org
To: Mat Martineau <mathew.j.martineau@linux.intel.com>
Cc: Tadeusz Struk <tadeusz.struk@intel.com>, dhowells@redhat.com, herbert@gondor.apana.org.au, linux-api@vger.kernel.org, marcel@holtmann.org, linux-kernel@vger.kernel.org, keyrings@vger.kernel.org, linux-crypto@vger.kernel.org, dwmw2@infradead.org, davem@davemloft.net
List-Id: linux-api@vger.kernel.org

Am Mittwoch, 8. Juni 2016, 12:14:49 schrieb Mat Martineau:

Hi Mat,

> On Wed, 8 Jun 2016, Stephan Mueller wrote:
> > Am Dienstag, 7. Juni 2016, 17:28:07 schrieb Mat Martineau:
> > 
> > Hi Mat,
> > 
> >>> +	used = ctx->used;
> >>> +
> >>> +	/* convert iovecs of output buffers into scatterlists */
> >>> +	while (iov_iter_count(&msg->msg_iter)) {
> >>> +		/* make one iovec available as scatterlist */
> >>> +		err = af_alg_make_sg(&ctx->rsgl[cnt], &msg->msg_iter,
> >>> +				     iov_iter_count(&msg->msg_iter));
> >>> +		if (err < 0)
> >>> +			goto unlock;
> >>> +		usedpages += err;
> >>> +		/* chain the new scatterlist with previous one */
> >>> +		if (cnt)
> >>> +			af_alg_link_sg(&ctx->rsgl[cnt - 1], &ctx->rsgl[cnt]);
> >>> +
> >>> +		iov_iter_advance(&msg->msg_iter, err);
> >>> +		cnt++;
> >>> +	}
> >>> +
> >>> +	/* ensure output buffer is sufficiently large */
> >>> +	if (usedpages < akcipher_calcsize(ctx)) {
> >>> +		err = -EMSGSIZE;
> >>> +		goto unlock;
> >>> +	}
> >> 
> >> Why is the size of the output buffer enforced here instead of depending
> >> on
> >> the algorithm implementation?
> > 
> > akcipher_calcsize calls crypto_akcipher_maxsize to get the maximum size
> > the
> > algorithm generates as output during its operation.
> > 
> > The code ensures that the caller provided at least that amount of memory
> > for the kernel to store its data in. This check therefore is present to
> > ensure the kernel does not overstep memory boundaries in user space.
> 
> Yes, it's understood that the userspace buffer length must not be
> exceeded. But dst_len is part of the akcipher_request struct, so why does
> it need to be checked *here* when it is also checked later?

I am always uneasy when the kernel has a user space interface and expects 
layers deep down inside the kernel to check for user space related boundaries. 
Note, we do not hand the __user flag down, so sparse and other tools cannot 
detect whether a particular cipher implementation has the right checks.

I therefore always would like to check parameters at the interface handling 
logic. Cryptographers rightly should worry about their code implementing the 
cipher correctly. But I do not think that the cipher implementations should 
worry about security implications since they may be called from user space.
> 
> > What is your concern?
> 
> Userspace must allocate larger buffers than it knows are necessary for
> expected results.
> 
> It looks like the software rsa implementation handles shorter output
> buffers ok (mpi_write_to_sgl will return EOVERFLOW if the the buffer is
> too small), however I see at least one hardware rsa driver that requires
> the output buffer to be the maximum size. But this inconsistency might be
> best addressed within the software cipher or drivers rather than in
> recvmsg.

Is your concern that we have a double check check for lengths here? If yes, I 
think we can live with an additional if() here.

Or is your concern that the user space interface restricts things too much and 
thus prevents a valid use case?

Ciao
Stephan

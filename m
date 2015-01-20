From: Herbert Xu <herbert-lOAM2aK0SrRLBo1qDEOMRrpzq4S04n8Q@public.gmane.org>
Subject: Re: [PATCH v8 1/2] crypto: AF_ALG: add AEAD support
Date: Tue, 20 Jan 2015 14:00:17 +1100
Message-ID: <20150120030017.GA10475@gondor.apana.org.au>
References: <33040723.pAXIT3fl8h@tachyon.chronox.de>
 <6260799.4x68Msg3Li@tachyon.chronox.de>
 <20150108110931.GA8568@gondor.apana.org.au>
 <1639027.yRSjDuRfFC@tachyon.chronox.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1639027.yRSjDuRfFC-PJstQz4BMNNP20K/wil9xYQuADTiUCJX@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Stephan Mueller <smueller-T9tCv8IpfcWELgA04lAiVw@public.gmane.org>
Cc: 'Quentin Gouchet' <quentin.gouchet-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Daniel Borkmann <dborkman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-crypto-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

On Fri, Jan 09, 2015 at 04:30:45AM +0100, Stephan Mueller wrote:
> Am Donnerstag, 8. Januar 2015, 22:09:31 schrieb Herbert Xu:
> 
> Hi Herbert,
> 
> > On Wed, Jan 07, 2015 at 04:51:38PM +0100, Stephan Mueller wrote:
> > > +		if (!aead_writable(sk)) {
> > > +			/*
> > > +			 * If there is more data to be expected, but we cannot
> > > +			 * write more data, forcefully define that we do not
> > > +			 * expect more data to invoke the AEAD operation. This
> > > +			 * prevents a deadlock in user space.
> > > +			 */
> > > +			ctx->more = 0;
> > 
> > We should return EMSGSIZE here.  Also we should clear out the
> > existing data so that the socket may be reused again.
> 
> Is this really wise considering that we want to support a threaded caller? For 
> example, one thread sends data and another reads data. For some reason, the 
> reading thread is throttled or slower than the sender. Now, with the current 
> solution, the sender is put on hold (i.e. throttled) until the reader can 
> catch up. I.e. we have an automated synchronization between sender/receiver.
> 
> Thus, when we remove the wait here and return an error, the sender will be 
> shut down and there is no synchronization of the reader/writer any more.
> 
> Note, the same applies to the very similar code in aead_sendpage too.

No, if we're in this case then something seriously wrong has
happened.  IOW the application writer has screwed up.  We're
not able to carry out the wish of user-space because of resource
limits on the socket.  Attempting to continue at this point will
only cause confusion.

So we should loudly declare that there was an error.

> > > +	ctx->more = msg->msg_flags & MSG_MORE;
> > > +	if (!ctx->more && !aead_sufficient_data(ctx))
> > > +		err = -EINVAL;
> > 
> > Ditto, we should discard the data that's queued up.  Also perhaps
> > use EBADMSG instead of EINVAL.
> 
> Agreed that we should clear out the buffer. I will provide that in the next 
> release for both, the sendmsg and sendpage implementations.
> 
> However, I am not sure whether using EBADMSG is a good idea. The error of 
> EBADMSG in the kernel crypto API is only used for integrity errors of AEAD 
> ciphers. But our error case here has nothing to do with the integrity error.
> 
> I would be fine with any other error number -- EMSGSIZE as you suggested 
> above?

Sure.

> Do you think whether such approach makes sense? If yes, which limit to the 
> number of rsgl should we apply -- is ALG_MAX_PAGES good?

Yes I think your solution in v10 is fine.  The current kernel
AEAD interface isn't the best but we're stuck with it for the
time being so this is the best we can do.

Cheers,
-- 
Email: Herbert Xu <herbert-lOAM2aK0SrRLBo1qDEOMRrpzq4S04n8Q@public.gmane.org>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt

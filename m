From: Stephan Mueller <smueller-T9tCv8IpfcWELgA04lAiVw@public.gmane.org>
Subject: Re: [PATCH v8 1/2] crypto: AF_ALG: add AEAD support
Date: Tue, 20 Jan 2015 04:08:48 +0100
Message-ID: <2322046.U2aPs8NjYq@tauon>
References: <33040723.pAXIT3fl8h@tachyon.chronox.de> <1639027.yRSjDuRfFC@tachyon.chronox.de> <20150120030017.GA10475@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20150120030017.GA10475-lOAM2aK0SrRLBo1qDEOMRrpzq4S04n8Q@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Herbert Xu <herbert-lOAM2aK0SrRLBo1qDEOMRrpzq4S04n8Q@public.gmane.org>
Cc: 'Quentin Gouchet' <quentin.gouchet-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Daniel Borkmann <dborkman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-crypto-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

Am Dienstag, 20. Januar 2015, 14:00:17 schrieb Herbert Xu:

Hi Herbert,

>On Fri, Jan 09, 2015 at 04:30:45AM +0100, Stephan Mueller wrote:
>> Am Donnerstag, 8. Januar 2015, 22:09:31 schrieb Herbert Xu:
>> 
>> Hi Herbert,
>> 
>> > On Wed, Jan 07, 2015 at 04:51:38PM +0100, Stephan Mueller wrote:
>> > > +		if (!aead_writable(sk)) {
>> > > +			/*
>> > > +			 * If there is more data to be expected, 
but we cannot
>> > > +			 * write more data, forcefully define 
that we do not
>> > > +			 * expect more data to invoke the AEAD 
operation. This
>> > > +			 * prevents a deadlock in user space.
>> > > +			 */
>> > > +			ctx->more = 0;
>> > 
>> > We should return EMSGSIZE here.  Also we should clear out the
>> > existing data so that the socket may be reused again.
>> 
>> Is this really wise considering that we want to support a threaded
>> caller? For example, one thread sends data and another reads data.
>> For some reason, the reading thread is throttled or slower than the
>> sender. Now, with the current solution, the sender is put on hold
>> (i.e. throttled) until the reader can catch up. I.e. we have an
>> automated synchronization between sender/receiver.
>> 
>> Thus, when we remove the wait here and return an error, the sender
>> will be shut down and there is no synchronization of the
>> reader/writer any more.
>> 
>> Note, the same applies to the very similar code in aead_sendpage too.
>
>No, if we're in this case then something seriously wrong has
>happened.  IOW the application writer has screwed up.  We're
>not able to carry out the wish of user-space because of resource
>limits on the socket.  Attempting to continue at this point will
>only cause confusion.
>
>So we should loudly declare that there was an error.

Ok. Your suggestion implies that it needs to be removed in aead_sendmsg 
and aead_sendpage. That in turn implies aead_wait_for_wmem can go as 
well.

Also, my previous suggestion with MSG_TRUNC can be removed as well.

I will do that with my next installment.

Ciao
Stephan

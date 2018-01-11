From: Jeff Moyer <jmoyer@redhat.com>
Subject: Re: [PATCH 30/32] aio: add delayed cancel support
Date: Thu, 11 Jan 2018 10:27:05 -0500
Message-ID: <x49373ce7qu.fsf@segfault.boston.devel.redhat.com>
References: <20180110155853.32348-1-hch@lst.de>
	<20180110155853.32348-31-hch@lst.de>
	<x49y3l52uda.fsf@segfault.boston.devel.redhat.com>
	<x49r2qx2t3k.fsf@segfault.boston.devel.redhat.com>
	<20180111134358.GA5926@lst.de>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <owner-linux-aio@kvack.org>
In-Reply-To: <20180111134358.GA5926@lst.de> (Christoph Hellwig's message of
	"Thu, 11 Jan 2018 14:43:58 +0100")
Sender: owner-linux-aio@kvack.org
To: Christoph Hellwig <hch@lst.de>
Cc: viro@zeniv.linux.org.uk, Avi Kivity <avi@scylladb.com>, linux-aio@kvack.org, linux-fsdevel@vger.kernel.org, netdev@vger.kernel.org, linux-api@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-api@vger.kernel.org

Christoph Hellwig <hch@lst.de> writes:

> On Wed, Jan 10, 2018 at 06:26:39PM -0500, Jeff Moyer wrote:
>> >> The upcoming aio poll support would like to be able to complete the
>> >> iocb inline from the cancellation context, but that would cause
>> >> a lock order reversal.  Add support for optionally moving the cancelation
>> >> outside the context lock to avoid this reversal.
>> >>
>> >> Signed-off-by: Christoph Hellwig <hch@lst.de>
>> >
>> > Acked-by: Jeff Moyer <jmoyer@redhat.com>
>> 
>> Actually, let's move these two defines:
>> 
>> #define AIO_IOCB_DELAYED_CANCEL (1 << 0)
>> #define AIO_IOCB_CANCELLED      (1 << 1)
>> 
>> to include/linux/aio.h so that drivers outside of fs/aio.c can make use
>> of them.
>
> struct aio_kiocb is private to aio.c, so just exposing them won't
> do anything useful.  If we really need these elsewhere we'll need
> to come up with a proper interface.

Duh, good point.  My main concern is that things like usb gadget will
have to deal with races between cancellation and completion on their
own.  It would be nice if we had infrastructure for them to use.  I'll
have a look through that code to see if there's something we could or
should be doing.

Cheers,
Jeff

--
To unsubscribe, send a message with 'unsubscribe linux-aio' in
the body to majordomo@kvack.org.  For more info on Linux AIO,
see: http://www.kvack.org/aio/
Don't email: <a href=mailto:"aart@kvack.org">aart@kvack.org</a>

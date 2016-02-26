From: Jeff Moyer <jmoyer-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: selective block polling and preadv2/pwritev2 revisited V2
Date: Fri, 26 Feb 2016 16:18:55 -0500
Message-ID: <x497fhrmaps.fsf@segfault.boston.devel.redhat.com>
References: <1456160876-14560-1-git-send-email-hch@lst.de>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1456160876-14560-1-git-send-email-hch-jcswGhMUV9g@public.gmane.org> (Christoph
	Hellwig's message of "Mon, 22 Feb 2016 18:07:49 +0100")
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
Cc: viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org, axboe-b10kYP2dOMg@public.gmane.org, milosz-B5zB6C1i6pkAvxtiuMwx3w@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org> writes:

> This series allows to selectively enable/disable polling for completions
> in the block layer on a per-I/O basis.  For this it resurrects the
> preadv2/pwritev2 syscalls that Milosz prepared a while ago (and which
> are much simpler now due to VFS changes that happened in the meantime).
> That approach also had a man page update prepared, which I will resubmit
> with the current flags once this series makes it in.

It would be helpful for reviewers if you submitted the man page at the
same time, in my opinion.

Do you have any plans on adding polling support to the buffered path?

> Polling for block I/O is important to reduce the latency on flash and
> post-flash storage technologies.  On the fastest NVMe controller I have
> access to it almost halves latencies from over 7 microseconds to about 4
> microseonds.  But it only is usesful if we actually care for the latency
> of this particular I/O, and generally is a waste if enabled for all I/O
> to a given device.  This series uses the per-I/O flags in preadv2/pwritev2
> to control this behavior.  The alternative would be a new O_* flag set
> at open time or using fcntl, but this is still to corse-grained for some
> applications and we're starting to run out out of open flags.

I agree that a per-I/O mechanism is better suited to this application.

> Note that there are plenty of other use cases for preadv2/pwritev2 as well,
> but I'd like to concentrate on this one for now.  Example are: non-blocking
> reads (the original purpose), per-I/O O_SYNC, user space support for T10
> DIF/DIX applications tags and probably some more.

And my favorite, RWF_ATOMIC.  :)  I agree, it's time we got this
interface in.

See responses to individual patches for my review.

Cheers,
Jeff

From: Dave Chinner <david-FqsqvQoI3Ljby3iVrkZq2A@public.gmane.org>
Subject: Re: [PATCH 07/13] aio: enabled thread based async fsync
Date: Thu, 21 Jan 2016 08:57:03 +1100
Message-ID: <20160120215703.GY6033@dastard>
References: <CA+55aFxtvMqHgHmHCcszV_QKQ2BY0wzenmrvc6BYN+tLFxesMA@mail.gmail.com>
 <20160112022548.GD6033@dastard>
 <CA+55aFzxSrLhOyV3VtO=Cv_J+npD8ubEP74CCF+rdt=CRipzxA@mail.gmail.com>
 <20160112033708.GE6033@dastard>
 <CA+55aFyLb8scNSYb19rK4iT_Vx5=hKxqPwRHVnETzAhEev0aHw@mail.gmail.com>
 <CA+55aFxCM-xWVR4jC=q2wSk+-WC1Xuf+nZLoud8JwKZopnR_dQ@mail.gmail.com>
 <20160115202131.GH6330@kvack.org>
 <CA+55aFzRo3yztEBBvJ4CMCvVHAo6qEDhTHTc_LGyqmxbcFyNYw@mail.gmail.com>
 <20160120195957.GV6033@dastard>
 <CA+55aFx4PzugV+wOKRqMEwo8XJ1QxP8r+s-mvn6H064FROnKdQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CA+55aFx4PzugV+wOKRqMEwo8XJ1QxP8r+s-mvn6H064FROnKdQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: Benjamin LaHaise <bcrl-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, linux-aio-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-fsdevel <linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux Kernel Mailing List <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-mm <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, Alexander Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Wed, Jan 20, 2016 at 12:29:32PM -0800, Linus Torvalds wrote:
> On Wed, Jan 20, 2016 at 11:59 AM, Dave Chinner <david-FqsqvQoI3Ljby3iVrkZq2A@public.gmane.org> wrote:
> >>
> >> Are there other users outside of Solace? It would be good to get comments..
> >
> > I know of quite a few storage/db products that use AIO. The most
> > recent high profile project that have been reporting issues with AIO
> > on XFS is http://www.scylladb.com/. That project is architected
> > around non-blocking AIO for scalability reasons...
> 
> I was more wondering about the new interfaces, making sure that the
> feature set actually matches what people want to do..

Well, they have mentioned that openat() can block, as will the first
operation after open that requires reading the file extent map from
disk. There are some ways of hacking around this (e.g. running
FIEMAP with a zero extent count or ext4's special extent prefetch
ioctl in a separate thread to prefetch the extent list into memory
before IO is required) so I suspect we may actually need some
interfaces that don't current exist at all....

> That said, I also agree that it would be interesting to hear what the
> performance impact is for existing performance-sensitive users. Could
> we make that "aio_may_use_threads()" case be unconditional, making
> things simpler?

That would make things a lot simpler in the kernel and AIO
submission a lot more predictable/deterministic for userspace. I'd
suggest that, at minimum, it should be the default behaviour...

Cheers,

Dave.
-- 
Dave Chinner
david-FqsqvQoI3Ljby3iVrkZq2A@public.gmane.org

From: Greg KH <gregkh@linuxfoundation.org>
Subject: Re: [PATCH 1/7] General notification queue with user mmap()'able
 ring buffer
Date: Wed, 29 May 2019 16:11:12 -0700
Message-ID: <20190529231112.GB3164@kroah.com>
References: <20190528231218.GA28384@kroah.com>
 <20190528162603.GA24097@kroah.com>
 <155905930702.7587.7100265859075976147.stgit@warthog.procyon.org.uk>
 <155905931502.7587.11705449537368497489.stgit@warthog.procyon.org.uk>
 <4031.1559064620@warthog.procyon.org.uk>
 <31936.1559146000@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <31936.1559146000@warthog.procyon.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
To: David Howells <dhowells@redhat.com>
Cc: viro@zeniv.linux.org.uk, raven@themaw.net, linux-fsdevel@vger.kernel.org, linux-api@vger.kernel.org, linux-block@vger.kernel.org, keyrings@vger.kernel.org, linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On Wed, May 29, 2019 at 05:06:40PM +0100, David Howells wrote:
> Greg KH <gregkh@linuxfoundation.org> wrote:
> > And how does the tracing and perf ring buffers do this without needing
> > volatile?  Why not use the same type of interface they provide, as it's
> > always good to share code that has already had all of the nasty corner
> > cases worked out.
> 
> I've no idea how trace does it - or even where - or even if.  As far as I can
> see, grepping for mmap in kernel/trace/*, there's no mmap support.
> 
> Reading Documentation/trace/ring-buffer-design.txt the trace subsystem has
> some sort of transient page fifo which is a lot more complicated than what I
> want and doesn't look like it'll be mmap'able.
> 
> Looking at the perf ring buffer, there appears to be a missing barrier in
> perf_aux_output_end():
> 
> 	rb->user_page->aux_head = rb->aux_head;
> 
> should be:
> 
> 	smp_store_release(&rb->user_page->aux_head, rb->aux_head);
> 
> It should also be using smp_load_acquire().  See
> Documentation/core-api/circular-buffers.rst
> 
> And a (partial) patch has been proposed: https://lkml.org/lkml/2018/5/10/249

So, if that's all that needs to be fixed, can you use the same
buffer/code if that patch is merged?

thanks,

greg k-h

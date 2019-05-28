From: David Howells <dhowells@redhat.com>
Subject: Re: [PATCH 1/7] General notification queue with user mmap()'able ring buffer
Date: Tue, 28 May 2019 18:30:20 +0100
Message-ID: <4031.1559064620@warthog.procyon.org.uk>
References: <20190528162603.GA24097@kroah.com> <155905930702.7587.7100265859075976147.stgit@warthog.procyon.org.uk> <155905931502.7587.11705449537368497489.stgit@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190528162603.GA24097@kroah.com>
Content-ID: <4030.1559064620.1@warthog.procyon.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
To: Greg KH <gregkh@linuxfoundation.org>
Cc: dhowells@redhat.com, viro@zeniv.linux.org.uk, raven@themaw.net, linux-fsdevel@vger.kernel.org, linux-api@vger.kernel.org, linux-block@vger.kernel.org, keyrings@vger.kernel.org, linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-api@vger.kernel.org

Greg KH <gregkh@linuxfoundation.org> wrote:

> > Implement a misc device that implements a general notification queue as a
> > ring buffer that can be mmap()'d from userspace.
> 
> "general" but just for filesystems, right?  :(

Whatever gave you that idea?  You can watch keyrings events, for example -
they're not exactly filesystems.  I've added the ability to watch for mount
topology changes and superblock events because those are something I've been
asked to do.  I've added something for block events because I've recently had
a problem with trying to recover data from a dodgy disk in that every time the
disk goes offline, the ddrecover goes "wheeeee!" as it just sees a lot of
EIO/ENODATA at a great rate of knots because it doesn't know the driver is now
ignoring the disk.

I don't know what else people might want to watch, but I've tried to make it
as generic as possible so as not to exclude it if possible.

> This doesn't match the structure definition in the documentation, so
> something is out of sync.

Ah, yes - I need to update that doc, thanks.

> I'm all for a "generic" event system for the kernel (heck, Solaris has
> had one for decades), but it keeps getting shot down every time it comes
> up.  What is different about this one?

Without studying all the other ones, I can't say - however, I need to add
something for keyrings and I would prefer to make something generic.

> > +#define DEBUG_WITH_WRITE /* Allow use of write() to record notifications */
> 
> debugging code left in?

I'll switch it to #undef.  I want to leave the code in there for testing
purposes.  Possibly I should make it a Kconfig option.

> > +	refcount_t		usage;
> 
> Usage of what, this structure?  Or something else?

This is the number of usages of this struct (references to if you prefer).  I
can add a comment to this effect.

> > +EXPORT_SYMBOL(__post_watch_notification);
> 
> _GPL for new apis?  (I have to ask...)

No.

> > +		return -EOPNOTSUPP;
> 
> -ENOTTY is the correct "not a valid ioctl" error value, right?

fs/ioctl.c does both, but I can switch it if it makes you happier.

> > +void put_watch_queue(struct watch_queue *wqueue)
> > +{
> > +	if (refcount_dec_and_test(&wqueue->usage))
> > +		kfree_rcu(wqueue, rcu);
> 
> Why not just use a kref?

Why use a kref?  It seems like an effort to be a C++ base class, but without
the C++ inheritance bit.  Using kref doesn't seem to gain anything.  It's just
a wrapper around refcount_t - so why not just use a refcount_t?

kref_put() could potentially add an unnecessary extra stack frame and would
seem to be best avoided, though an optimising compiler ought to be able to
inline if it can.

Are you now on the convert all refcounts to krefs path?

> > +EXPORT_SYMBOL(add_watch_to_object);
> 
> Naming nit, shouldn't the "prefix" all be the same for these new
> functions?
> 
> watch_queue_add_object()?  watch_queue_put()?  And so on?

Naming is fun.  watch_queue_add_object - that suggests something different to
what the function actually does.  I'll think about adjusting the names.

> > +module_exit(watch_queue_exit);
> 
> module_misc_device()?

	warthog>git grep module_misc_device -- Documentation/
	warthog1>

> > +/* SPDX-License-Identifier: GPL-2.0 WITH Linux-syscall-note */
> 
> Yeah!!!

Blech.

> > +		struct {
> > +			struct watch_notification watch; /* WATCH_TYPE_SKIP */
> > +			volatile __u32	head;		/* Ring head index */
> > +			volatile __u32	tail;		/* Ring tail index */
> 
> A uapi structure that has volatile in it?  Are you _SURE_ this is
> correct?
> 
> That feels wrong to me...  This is not a backing-hardware register, it's
> "just memory" and slapping volatile on it shouldn't be the correct
> solution for telling the compiler to not to optimize away reads/flushes,
> right?  You need a proper memory access type primitive for that to work
> correctly everywhere I thought.
> 
> We only have 2 users of volatile in include/uapi, one for WMI structures
> that are backed by firmware (seems correct), and one for DRM which I
> have no idea how it works as it claims to be a lock.  Why is this new
> addition the correct way to do this that no other ring-buffer that was
> mmapped has needed to?

Yeah, I understand your concern with this.

The reason I put the volatiles in is that the kernel may be modifying the head
pointer on one CPU simultaneously with userspace modifying the tail pointer on
another CPU.

Note that userspace does not need to enter the kernel to find out if there's
anything in the buffer or to read stuff out of the buffer.  Userspace only
needs to enter the kernel, using poll() or similar, to wait for something to
appear in the buffer.

David

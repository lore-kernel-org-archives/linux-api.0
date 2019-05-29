From: David Howells <dhowells@redhat.com>
Subject: Re: [PATCH 1/7] General notification queue with user mmap()'able ring buffer
Date: Wed, 29 May 2019 17:06:40 +0100
Message-ID: <31936.1559146000@warthog.procyon.org.uk>
References: <20190528231218.GA28384@kroah.com> <20190528162603.GA24097@kroah.com> <155905930702.7587.7100265859075976147.stgit@warthog.procyon.org.uk> <155905931502.7587.11705449537368497489.stgit@warthog.procyon.org.uk> <4031.1559064620@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190528231218.GA28384@kroah.com>
Content-ID: <31935.1559146000.1@warthog.procyon.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
To: Greg KH <gregkh@linuxfoundation.org>
Cc: dhowells@redhat.com, viro@zeniv.linux.org.uk, raven@themaw.net, linux-fsdevel@vger.kernel.org, linux-api@vger.kernel.org, linux-block@vger.kernel.org, keyrings@vger.kernel.org, linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-api@vger.kernel.org

Greg KH <gregkh@linuxfoundation.org> wrote:

> > kref_put() could potentially add an unnecessary extra stack frame and would
> > seem to be best avoided, though an optimising compiler ought to be able to
> > inline if it can.
> 
> If kref_put() is on your fast path, you have worse problems (kfree isn't
> fast, right?)
> 
> Anyway, it's an inline function, how can it add an extra stack frame?

The call to the function pointer.  Hopefully the compiler will optimise that
away for an inlineable function.

> > Are you now on the convert all refcounts to krefs path?
> 
> "now"?  Remember, I wrote kref all those years ago,

Yes - and I thought it wasn't a good idea at the time.  But this is the first
time you've mentioned it to me, let alone pushed to change to it, that I
recall.

> everyone should use
> it.  It saves us having to audit the same pattern over and over again.
> And, even nicer, it uses a refcount now, and as you are trying to
> reference count an object, it is exactly what this was written for.
> 
> So yes, I do think it should be used here, unless it is deemed to not
> fit the pattern/usage model.

kref_put() enforces a very specific destructor signature.  I know of places
where that doesn't work because the destructor takes more than one argument
(granted that this is not the case here).  So why does kref_put() exist at
all?  Why not kref_dec_and_test()?

Why doesn't refcount_t get merged into kref, or vice versa?  Having both would
seem redundant.

Mind you, I've been gradually reverting atomic_t-to-refcount_t conversions
because it seems I'm not allowed refcount_inc/dec_return() and I want to get
at the point refcount for tracing purposes.

> > > > +module_exit(watch_queue_exit);
> > > 
> > > module_misc_device()?
> > 
> > 	warthog>git grep module_misc_device -- Documentation/
> > 	warthog1>
> 
> Do I have to document all helper macros?

If you add an API, documenting it is your privilege ;-)  It's an important
test of the API - if you can't describe it, it's probably wrong.

Now I will grant that you didn't add that function...

> Anyway, it saves you boilerplate code, but if built in, it's at the module
> init level, not the fs init level, like you are asking for here.  So that
> might not work, it's your call.

Actually, I probably shouldn't have a module exit function.  It can't be a
module as it's called by core code.  I'll switch to builtin_misc_device().

> And how does the tracing and perf ring buffers do this without needing
> volatile?  Why not use the same type of interface they provide, as it's
> always good to share code that has already had all of the nasty corner
> cases worked out.

I've no idea how trace does it - or even where - or even if.  As far as I can
see, grepping for mmap in kernel/trace/*, there's no mmap support.

Reading Documentation/trace/ring-buffer-design.txt the trace subsystem has
some sort of transient page fifo which is a lot more complicated than what I
want and doesn't look like it'll be mmap'able.

Looking at the perf ring buffer, there appears to be a missing barrier in
perf_aux_output_end():

	rb->user_page->aux_head = rb->aux_head;

should be:

	smp_store_release(&rb->user_page->aux_head, rb->aux_head);

It should also be using smp_load_acquire().  See
Documentation/core-api/circular-buffers.rst

And a (partial) patch has been proposed: https://lkml.org/lkml/2018/5/10/249

David

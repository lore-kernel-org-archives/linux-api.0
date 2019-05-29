From: Jann Horn <jannh@google.com>
Subject: Re: [PATCH 1/7] General notification queue with user mmap()'able ring buffer
Date: Wed, 29 May 2019 19:46:54 +0200
Message-ID: <CAG48ez0R-R3Xs+3Xg9T9qcV3Xv6r4pnx1Z2y=Ltx7RGOayte_w@mail.gmail.com>
References: <20190528162603.GA24097@kroah.com> <155905930702.7587.7100265859075976147.stgit@warthog.procyon.org.uk>
 <155905931502.7587.11705449537368497489.stgit@warthog.procyon.org.uk>
 <4031.1559064620@warthog.procyon.org.uk> <20190528231218.GA28384@kroah.com> <31936.1559146000@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <31936.1559146000@warthog.procyon.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
To: David Howells <dhowells@redhat.com>
Cc: Greg KH <gregkh@linuxfoundation.org>, Al Viro <viro@zeniv.linux.org.uk>, raven@themaw.net, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Linux API <linux-api@vger.kernel.org>, linux-block@vger.kernel.org, keyrings@vger.kernel.org, linux-security-module <linux-security-module@vger.kernel.org>, kernel list <linux-kernel@vger.kernel.org>, Kees Cook <keescook@chromium.org>, Kernel Hardening <kernel-hardening@lists.openwall.com>
List-Id: linux-api@vger.kernel.org

On Wed, May 29, 2019 at 6:07 PM David Howells <dhowells@redhat.com> wrote:
> Greg KH <gregkh@linuxfoundation.org> wrote:
> > everyone should use
> > it.  It saves us having to audit the same pattern over and over again.
> > And, even nicer, it uses a refcount now, and as you are trying to
> > reference count an object, it is exactly what this was written for.
> >
> > So yes, I do think it should be used here, unless it is deemed to not
> > fit the pattern/usage model.
>
> kref_put() enforces a very specific destructor signature.  I know of places
> where that doesn't work because the destructor takes more than one argument
> (granted that this is not the case here).  So why does kref_put() exist at
> all?  Why not kref_dec_and_test()?
>
> Why doesn't refcount_t get merged into kref, or vice versa?  Having both would
> seem redundant.
>
> Mind you, I've been gradually reverting atomic_t-to-refcount_t conversions
> because it seems I'm not allowed refcount_inc/dec_return() and I want to get
> at the point refcount for tracing purposes.

Yeeech, that's horrible, please don't do that.

Does this mean that refcount_read() isn't sufficient for what you want
to do with tracing (because for some reason you actually need to know
the values atomically at the time of increment/decrement)?

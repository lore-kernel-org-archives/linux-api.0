From: Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH 1/7] General notification queue with user mmap()'able
 ring buffer
Date: Fri, 31 May 2019 18:44:44 +0200
Message-ID: <20190531164444.GD2606@hirez.programming.kicks-ass.net>
References: <CAG48ez0R-R3Xs+3Xg9T9qcV3Xv6r4pnx1Z2y=Ltx7RGOayte_w@mail.gmail.com>
 <20190528162603.GA24097@kroah.com>
 <155905930702.7587.7100265859075976147.stgit@warthog.procyon.org.uk>
 <155905931502.7587.11705449537368497489.stgit@warthog.procyon.org.uk>
 <4031.1559064620@warthog.procyon.org.uk>
 <20190528231218.GA28384@kroah.com>
 <31936.1559146000@warthog.procyon.org.uk>
 <16193.1559163763@warthog.procyon.org.uk>
 <21942.1559304135@warthog.procyon.org.uk>
 <606.1559312412@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <kernel-hardening-return-16023-glkh-kernel-hardening=m.gmane.org@lists.openwall.com>
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
Content-Disposition: inline
In-Reply-To: <606.1559312412@warthog.procyon.org.uk>
To: David Howells <dhowells@redhat.com>
Cc: Jann Horn <jannh@google.com>, Greg KH <gregkh@linuxfoundation.org>, Al Viro <viro@zeniv.linux.org.uk>, raven@themaw.net, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Linux API <linux-api@vger.kernel.org>, linux-block@vger.kernel.org, keyrings@vger.kernel.org, linux-security-module <linux-security-module@vger.kernel.org>, kernel list <linux-kernel@vger.kernel.org>, Kees Cook <keescook@chromium.org>, Kernel Hardening <kernel-hardening@lists.openwall.com>
List-Id: linux-api@vger.kernel.org

On Fri, May 31, 2019 at 03:20:12PM +0100, David Howells wrote:
> Peter Zijlstra <peterz@infradead.org> wrote:

> > (and it has already been established that refcount_t doesn't work for
> > usage count scenarios)
> 
> ?
> 
> Does that mean struct kref doesn't either?

Indeed, since kref is just a pointless wrapper around refcount_t it does
not either.

The main distinction between a reference count and a usage count is that
0 means different things. For a refcount 0 means dead. For a usage count
0 is merely unused but valid.

Incrementing a 0 refcount is a serious bug -- use-after-free (and hence
refcount_t will refuse this and splat), for a usage count this is no
problem.

Now, it is sort-of possible to merge the two, by basically stating
something like: usage = refcount - 1. But that can get tricky and people
have not really liked the result much for the few times I tried.

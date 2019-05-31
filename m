From: Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH 1/7] General notification queue with user mmap()'able
 ring buffer
Date: Fri, 31 May 2019 13:14:45 +0200
Message-ID: <20190531111445.GO2677@hirez.programming.kicks-ass.net>
References: <CAG48ez0R-R3Xs+3Xg9T9qcV3Xv6r4pnx1Z2y=Ltx7RGOayte_w@mail.gmail.com>
 <20190528162603.GA24097@kroah.com>
 <155905930702.7587.7100265859075976147.stgit@warthog.procyon.org.uk>
 <155905931502.7587.11705449537368497489.stgit@warthog.procyon.org.uk>
 <4031.1559064620@warthog.procyon.org.uk>
 <20190528231218.GA28384@kroah.com>
 <31936.1559146000@warthog.procyon.org.uk>
 <16193.1559163763@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <kernel-hardening-return-16018-glkh-kernel-hardening=m.gmane.org@lists.openwall.com>
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
Content-Disposition: inline
In-Reply-To: <16193.1559163763@warthog.procyon.org.uk>
To: David Howells <dhowells@redhat.com>
Cc: Jann Horn <jannh@google.com>, Greg KH <gregkh@linuxfoundation.org>, Al Viro <viro@zeniv.linux.org.uk>, raven@themaw.net, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Linux API <linux-api@vger.kernel.org>, linux-block@vger.kernel.org, keyrings@vger.kernel.org, linux-security-module <linux-security-module@vger.kernel.org>, kernel list <linux-kernel@vger.kernel.org>, Kees Cook <keescook@chromium.org>, Kernel Hardening <kernel-hardening@lists.openwall.com>
List-Id: linux-api@vger.kernel.org

On Wed, May 29, 2019 at 10:02:43PM +0100, David Howells wrote:
> Jann Horn <jannh@google.com> wrote:
> 
> > Does this mean that refcount_read() isn't sufficient for what you want
> > to do with tracing (because for some reason you actually need to know
> > the values atomically at the time of increment/decrement)?
> 
> Correct.  There's a gap and if an interrupt or something occurs, it's
> sufficiently big for the refcount trace to go weird.
> 
> I've seen it in afs/rxrpc where the incoming network packets that are part of
> the rxrpc call flow disrupt the refcounts noted in trace lines.

Can you re-iterate the exact problem? I konw we talked about this in the
past, but I seem to have misplaced those memories :/

FWIW I agree that kref is useless fluff, but I've long ago given up on
that fight.

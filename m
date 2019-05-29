From: David Howells <dhowells@redhat.com>
Subject: Re: [PATCH 1/7] General notification queue with user mmap()'able ring buffer
Date: Wed, 29 May 2019 22:02:43 +0100
Message-ID: <16193.1559163763@warthog.procyon.org.uk>
References: <CAG48ez0R-R3Xs+3Xg9T9qcV3Xv6r4pnx1Z2y=Ltx7RGOayte_w@mail.gmail.com> <20190528162603.GA24097@kroah.com> <155905930702.7587.7100265859075976147.stgit@warthog.procyon.org.uk> <155905931502.7587.11705449537368497489.stgit@warthog.procyon.org.uk> <4031.1559064620@warthog.procyon.org.uk> <20190528231218.GA28384@kroah.com> <31936.1559146000@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAG48ez0R-R3Xs+3Xg9T9qcV3Xv6r4pnx1Z2y=Ltx7RGOayte_w@mail.gmail.com>
Content-ID: <16192.1559163763.1@warthog.procyon.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
To: Jann Horn <jannh@google.com>
Cc: dhowells@redhat.com, Greg KH <gregkh@linuxfoundation.org>, Al Viro <viro@zeniv.linux.org.uk>, raven@themaw.net, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Linux API <linux-api@vger.kernel.org>, linux-block@vger.kernel.org, keyrings@vger.kernel.org, linux-security-module <linux-security-module@vger.kernel.org>, kernel list <linux-kernel@vger.kernel.org>, Kees Cook <keescook@chromium.org>, Kernel Hardening <kernel-hardening@lists.openwall.com>
List-Id: linux-api@vger.kernel.org

Jann Horn <jannh@google.com> wrote:

> Does this mean that refcount_read() isn't sufficient for what you want
> to do with tracing (because for some reason you actually need to know
> the values atomically at the time of increment/decrement)?

Correct.  There's a gap and if an interrupt or something occurs, it's
sufficiently big for the refcount trace to go weird.

I've seen it in afs/rxrpc where the incoming network packets that are part of
the rxrpc call flow disrupt the refcounts noted in trace lines.

David

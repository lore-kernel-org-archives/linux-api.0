From: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [RFC PATCH 00/11] pipe: Notification queue preparation [ver #3]
Date: Fri, 1 Nov 2019 12:24:54 -0700
Message-ID: <CAHk-=wjqx4j2vqg-tAwthNP1gcAcj1x4B7sq6Npbi8QJTUMd-A@mail.gmail.com>
References: <157262963995.13142.5568934007158044624.stgit@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <157262963995.13142.5568934007158044624.stgit@warthog.procyon.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
To: David Howells <dhowells@redhat.com>
Cc: Rasmus Villemoes <linux@rasmusvillemoes.dk>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Peter Zijlstra <peterz@infradead.org>, Nicolas Dichtel <nicolas.dichtel@6wind.com>, raven@themaw.net, Christian Brauner <christian@brauner.io>, keyrings@vger.kernel.org, linux-usb@vger.kernel.org, linux-block <linux-block@vger.kernel.org>, LSM List <linux-security-module@vger.kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Linux API <linux-api@vger.kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

On Fri, Nov 1, 2019 at 10:34 AM David Howells <dhowells@redhat.com> wrote:
>  (1) It removes the nr_exclusive argument from __wake_up_sync_key() as this
>      is always 1.  This prepares for step 2.
>
>  (2) Adds wake_up_interruptible_sync_poll_locked() so that poll can be
>      woken up from a function that's holding the poll waitqueue spinlock.

Side note: we have a couple of cases where I don't think we should use
the "sync" version at all.

Both pipe_read() and pipe_write() have that

        if (do_wakeup) {
                wake_up_interruptible_sync_poll(&pipe->wait, ...

code at the end, outside the loop. But those two wake-ups aren't
actually synchronous.

A sync wake is supposedly something where the waker is just about to
go to sleep, telling the scheduler that "don't bother trying to pick
another cpu, this process is going to sleep and you can stay here".

I'm not sure how much this matters, but it does strike me that it's
wrong. We're not going to sleep at all in that case - this is not the
"I filled the whole buffer, so I'm going to sleep" case (or the "I've
read all the data, I'm waiting for more".

It's entirely possible that we always wake pipe wakeups to be sync
just because it's a common pattern (and a common benchmark), but this
series made me look at it again. Particularly since David has
benchmarks that don't seem to show a lot of fluctuation with his
changes - I wonder how much the sync logic buys us (or hurts us)?

               Linus

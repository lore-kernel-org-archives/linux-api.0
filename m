From: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: Why add the general notification queue and its sources
Date: Thu, 5 Sep 2019 17:07:25 -0700
Message-ID: <CAHk-=wjt2Eb+yEDOcQwCa0SrZ4cWu967OtQG8Vz21c=n5ZP1Nw@mail.gmail.com>
References: <156763534546.18676.3530557439501101639.stgit@warthog.procyon.org.uk>
 <CAHk-=wh5ZNE9pBwrnr5MX3iqkUP4nspz17rtozrSxs5-OGygNw@mail.gmail.com>
 <17703.1567702907@warthog.procyon.org.uk> <CAHk-=wjQ5Fpv0D7rxX0W=obx9xoOAxJ_Cr+pGCYOAi2S9FiCNg@mail.gmail.com>
 <CAKCoTu7ms_Mr-q08d9XB3uascpzwBa5LF9JTT2aq8uUsoFE8aQ@mail.gmail.com>
 <CAHk-=wjcsxQ8QB_v=cwBQw4pkJg7pp-bBsdWyPivFO_OeF-y+g@mail.gmail.com>
 <5396.1567719164@warthog.procyon.org.uk> <CAHk-=wgbCXea1a9OTWgMMvcsCGGiNiPp+ty-edZrBWn63NCYdw@mail.gmail.com>
 <14883.1567725508@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <14883.1567725508@warthog.procyon.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
To: David Howells <dhowells@redhat.com>
Cc: Ray Strode <rstrode@redhat.com>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Steven Whitehouse <swhiteho@redhat.com>, Nicolas Dichtel <nicolas.dichtel@6wind.com>, raven@themaw.net, keyrings@vger.kernel.org, linux-usb@vger.kernel.org, linux-block <linux-block@vger.kernel.org>, Christian Brauner <christian@brauner.io>, LSM List <linux-security-module@vger.kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Linux API <linux-api@vger.kernel.org>, Linux List Kernel Mailing <linux-kernel@vger.kernel.org>, Al Viro <viro@zeniv.linux.org.uk>, "Ray, Debarshi" <debarshi.ray@gmail.com>, Robbie Harwood <rharwood@redhat.com>
List-Id: linux-api@vger.kernel.org

On Thu, Sep 5, 2019 at 4:18 PM David Howells <dhowells@redhat.com> wrote:
>
> Can you write into a pipe from softirq context and/or with spinlocks held
> and/or with the RCU read lock held?  That is a requirement.  Another is that
> messages get inserted whole or not at all (or if they are truncated, the size
> field gets updated).

Right now we use a mutex for the buffer locking, so no, pipe buffers
are not irq-safe or atomic. That's due to the whole "we may block on
data from user space" when doing a write.

HOWEVER.

Pipes actually have buffers on two different levels: there's the
actual data buffers themselves (each described by a "struct
pipe_buffer"), and there's the circular queue of them (the
"pipe->buf[]" array, with pipe->curbuf/nrbufs) that points to
individual data buffers.

And we could easily separate out that data buffer management. Right
now it's not really all that separated: people just do things like

        int newbuf = (pipe->curbuf + bufs) & (pipe->buffers-1);
        struct pipe_buffer *buf = pipe->bufs + newbuf;
...
        pipe->nrbufs++;

to add a buffer into that circular array of buffers, but _that_ part
could be made separate.  It's just all protected by the pipe mutex
right now, so it has never been an issue.

And yes, atomicity of writes has actually been an integral part of
pipes since forever. It's actually the only unambiguous atomicity that
POSIX guarantees. It only holds for writes to pipes() of less than
PIPE_BUF blocks, but that's 4096 on Linux.

> Since one end would certainly be attached to an fd, it looks on the face of it
> that writing into the pipe would require taking pipe->mutex.

That's how the normal synchronization is done, yes. And changing that
in general would be pretty painful. For example, two concurrent
user-space writers might take page faults and just generally be
painful, and the pipe locking needs to serialize that.

So the mutex couldn't go away from pipes in general - it would remain
for read/write/splice mutual exclusion (and it's not just the data it
protects, it's the reader/writer logic for EPIPE etc).

But the low-level pipe->bufs[] handling is another issue entirely.
Even when a user space writer copies things from user space, it does
so into a pre-allocated buffer that is then attached to the list of
buffers somewhat separately (there's a magical special case where you
can re-use a buffer that is marked as "I can be reused" and append
into an already allocated buffer).

And adding new buffers *could* be done with it's own separate locking.
If you have a blocking writer (ie a user space data source), that
would still take the pipe mutex, and it would delay the user space
readers (because the readers also need the mutex), but it should not
be all that hard to just make the whole "curbuf/nrbufs" handling use
its own locking (maybe even some lockless atomics and cmpxchg).

So a kernel writer could "insert" a "struct pipe_buffer" atomically,
and wake up the reader atomically. No need for the other complexity
that is protected by the mutex.

The buggest problem is perhaps that the number of pipe buffers per
pipe is fairly limited by default. PIPE_DEF_BUFFERS is 16, and if we'd
insert using the ->bufs[] array, that would be the limit of "number of
messages". But each message could be any size (we've historically
limited pipe buffers to one page each, but that limit isn't all that
hard. You could put more data in there).

The number of pipe buffers _is_ dynamic, so the above PIPE_DEF_BUFFERS
isn't a hard limit, but it would be the default.

Would it be entirely trivial to do all the above? No. But it's
*literally* just finding the places that work with pipe->curbuf/nrbufs
and making them use atomic updates. You'd find all the places by just
renaming them (and making them atomic or whatever) and the compiler
will tell you "this area needs fixing".

We've actually used pipes for messages before: autofs uses a magic
packetized pipe buffer thing. It didn't need any extra atomicity,
though, so it stil all worked with the regular pipe->mutex thing.

And there is a big advantage from using pipes. They really would work
with almost anything. You could even mix-and-match "data generated by
kernel" and "data done by 'write()' or 'splice()' by a user process".

NOTE! I'm not at all saying that pipes are perfect. You'll find people
who swear by sockets instead. They have their own advantages (and
disadvantages). Most people who do packet-based stuff tend to prefer
sockets, because those have standard packet-based models (Linux pipes
have that packet mode too, but it's certainly not standard, and I'm
not even sure we ever exposed it to user space - it could be that it's
only used by the autofs daemon).

I have a soft spot for pipes, just because I think they are simpler
than sockets. But that soft spot might be misplaced.

                   Linus

From: David Howells <dhowells@redhat.com>
Subject: Re: [PATCH 29/38] vfs: syscall: Add fsconfig() for configuring and managing a context [ver #10]
Date: Mon, 30 Jul 2018 13:32:35 +0100
Message-ID: <26455.1532953955@warthog.procyon.org.uk>
References: <CAG48ez3HY6UuOgo1gM9L=WwyOqifKSs6sFu7f2qqBZQg6hy96g@mail.gmail.com> <153271267980.9458.7640156373438016898.stgit@warthog.procyon.org.uk> <153271287586.9458.6001928723332685410.stgit@warthog.procyon.org.uk> <CAG48ez2f+J+UeFN0u1Hpfq3tFXJbi7ckts8sua3eY4jDwnh6-Q@mail.gmail.com> <19865.1532854200@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAG48ez3HY6UuOgo1gM9L=WwyOqifKSs6sFu7f2qqBZQg6hy96g@mail.gmail.com>
Content-ID: <26454.1532953955.1@warthog.procyon.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
To: Jann Horn <jannh@google.com>
Cc: dhowells@redhat.com, Al Viro <viro@zeniv.linux.org.uk>, Linux API <linux-api@vger.kernel.org>, Linus Torvalds <torvalds@linux-foundation.org>, linux-fsdevel@vger.kernel.org, kernel list <linux-kernel@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

Jann Horn <jannh@google.com> wrote:

> > > This means that a namespace admin (iow, an unprivileged user) can
> > > allocate 1MB of unswappable kmalloc memory per userspace task, right?
> > > Using userfaultfd or FUSE, you can then stall the task as long as you
> > > want while it has that allocation. Is that problematic, or is that
> > > normal?
> >
> > That's not exactly the case.  A userspace task can make a temporary
> > allocation, but unless the filesystem grabs it, it's released again on exit
> > from the system call.
> 
> That's what I said.

Sorry, I wasn't clear what you meant.  I assumed you were thinking it was then
automatically attached to the context, say:

	fd = fsopen("fuse", 0);
	fsconfig(fd, fsconfig_set_binary, "foo", buffer, size);

> Each userspace task can make a 1MB allocation by calling this syscall, and
> this temporary allocation stays allocated until the end of the syscall. But
> the runtime of the syscall is unbounded - even just the memdup_user_nul()
> can stall forever if the copy_from_user() call inside it faults on e.g. a
> userfault region or a memory-mapped file from a FUSE filesystem.

Okay, I see what you're getting at.  Note that this affects other syscalls
too, keyctl, module loading and read() with readahead for example.  Not sure
what the answer should be.

David

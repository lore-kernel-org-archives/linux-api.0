From: Jann Horn <jannh@google.com>
Subject: Re: [PATCH 29/38] vfs: syscall: Add fsconfig() for configuring and
 managing a context [ver #10]
Date: Sun, 29 Jul 2018 13:14:20 +0200
Message-ID: <CAG48ez3HY6UuOgo1gM9L=WwyOqifKSs6sFu7f2qqBZQg6hy96g@mail.gmail.com>
References: <153271267980.9458.7640156373438016898.stgit@warthog.procyon.org.uk>
 <153271287586.9458.6001928723332685410.stgit@warthog.procyon.org.uk>
 <CAG48ez2f+J+UeFN0u1Hpfq3tFXJbi7ckts8sua3eY4jDwnh6-Q@mail.gmail.com> <19865.1532854200@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <19865.1532854200@warthog.procyon.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
To: David Howells <dhowells@redhat.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>, Linux API <linux-api@vger.kernel.org>, Linus Torvalds <torvalds@linux-foundation.org>, linux-fsdevel@vger.kernel.org, kernel list <linux-kernel@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

On Sun, Jul 29, 2018 at 10:50 AM David Howells <dhowells@redhat.com> wrote:
>
> Jann Horn <jannh@google.com> wrote:
>
> > [...]
> > > +       case fsconfig_set_binary:
> > > +               param.type = fs_value_is_blob;
> > > +               param.size = aux;
> > > +               param.blob = memdup_user_nul(_value, aux);
> > > +               if (IS_ERR(param.blob)) {
> > > +                       ret = PTR_ERR(param.blob);
> > > +                       goto out_key;
> > > +               }
> > > +               break;
> >
> > This means that a namespace admin (iow, an unprivileged user) can
> > allocate 1MB of unswappable kmalloc memory per userspace task, right?
> > Using userfaultfd or FUSE, you can then stall the task as long as you
> > want while it has that allocation. Is that problematic, or is that
> > normal?
>
> That's not exactly the case.  A userspace task can make a temporary
> allocation, but unless the filesystem grabs it, it's released again on exit
> from the system call.

That's what I said. Each userspace task can make a 1MB allocation by
calling this syscall, and this temporary allocation stays allocated
until the end of the syscall. But the runtime of the syscall is
unbounded - even just the memdup_user_nul() can stall forever if the
copy_from_user() call inside it faults on e.g. a userfault region or a
memory-mapped file from a FUSE filesystem.

> Note that I should probably use vmalloc() rather than kmalloc(), but that
> doesn't really affect your point.  I could also pass the user pointer through
> to the filesystem instead - I wanted to avoid that for this interface, but it
> make sense in this instance.

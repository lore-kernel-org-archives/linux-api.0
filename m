From: John Stultz <john.stultz-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v3 3/7] shm: add memfd_create() syscall
Date: Fri, 13 Jun 2014 09:20:22 -0700
Message-ID: <CALAqxLUDDYhDbU-fa50ZHVe+yOmv0m3aOO3WmGpRrk-cPzsMAg@mail.gmail.com>
References: <1402655819-14325-1-git-send-email-dh.herrmann@gmail.com>
	<1402655819-14325-4-git-send-email-dh.herrmann@gmail.com>
	<CAKgNAkgnnWjrbE+2KAETsmiyrnrMQu0h7-MrYLvkiwj--_nxcQ@mail.gmail.com>
	<CANq1E4R2K+eq9AxtFewp4YUL2cujg+dg+sN19Anvf-zWuvgyWw@mail.gmail.com>
	<CAKgNAkgMA39AfoSoA5Pe1r9N+ZzfYQNvNPvcRN7tOvRb8+v06Q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAKgNAkgMA39AfoSoA5Pe1r9N+ZzfYQNvNPvcRN7tOvRb8+v06Q-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Michael Kerrisk <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: David Herrmann <dh.herrmann-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, lkml <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Ryan Lortie <desrt-0xnayjDhYQY@public.gmane.org>, Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, "linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org" <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, "linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Greg Kroah-Hartman <greg-U8xfFu+wG4EAvxtiuMwx3w@public.gmane.org>, Lennart Poettering <lennart-mdGvqq1h2p+GdvJs77BJ7Q@public.gmane.org>, Daniel Mack <zonque-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Kay Sievers <kay-tD+1rO4QERM@public.gmane.org>, Hugh Dickins <hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Tony Battersby <tonyb-vFAe+i1/wJI5UWNf+nJyDw@public.gmane.org>, Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Fri, Jun 13, 2014 at 7:20 AM, Michael Kerrisk (man-pages)
<mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
>
> The general notion these days is that a (comprehensive) manual page
> _should_ come *with* the system call, rather than after the fact. And
> there's a lot of value in that. I've found no end of bugs and design
> errors while writing (comprehensive) man pages after the fact (by
> which time it's too late to fix the design errors), and also found
> quite a few of those issues when I've managed to work with folk at the
> same time as they write the syscall. Bottom line: you really should
> write formal documentation now, as part of the process of code
> submission. It improves the chance of finding implementation and
> design bugs, and may well widen your circle of reviewers.

I very much agree here. One practical issue I've noticed is that
having separate targets for both the code changes and the manpages can
be an extra barrier for folks getting changes correctly documented as
the change is being submitted. Reviewers may say "be sure to send
updates to the man pages" but its not always easy to remember to
follow up and make sure the submitter got the changes (which match the
merged patches) to you as well.

I've been thinking it might be nice to have the kernel syscall man
pages included in the kernel source tree, then have them
copied/imported over to the man-pages project (similar to how glibc
imports uapi kernel headers).  They could even be kept in the
include/uapi directory, and checkpatch could ensure that changes that
touch include/uapi also have modifications to something in the
manpages directory. This way folks would be able to include the man
page change with the code change, making it easier for developers to
do the right thing, making it easier for reviewers to ensure its
correct, and making it easier for maintainers to ensure man page
documentation is properly in sync.

Or is this something that has been hashed over already? I do admit
this would disrupt your process a bit.

thanks
-john

From: Daniel Colascione <dancol-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v2 0/6] Harden userfaultfd
Date: Wed, 12 Feb 2020 09:12:00 -0800
Message-ID: <CAKOZuesS1_O0OuePwSN2Kc4b-vyokiV=MvBd4nDi=umBKM6v6w@mail.gmail.com>
References: <20200211225547.235083-1-dancol@google.com> <202002112332.BE71455@keescook>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <202002112332.BE71455@keescook>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>
Cc: Tim Murray <timmurray-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Nosh Minwalla <nosh-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Nick Kralevich <nnk-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Lokesh Gidra <lokeshgidra-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, linux-kernel <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, selinux-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Andrea Arcangeli <aarcange-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Mike Rapoport <rppt-tEXmvtCZX7AybS5Ee8rs3A@public.gmane.org>, Peter Xu <peterx-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Jann Horn <jannh-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, LSM List <linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

Thanks for taking a look and for the fast reply!

On Tue, Feb 11, 2020 at 11:51 PM Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org> wrote:
>
> Hi!
>
> Firstly, thanks for working on this! It's been on my TODO list for a
> while. :)
>
> Casey already recommended including the LSM list to CC (since this is a
> new LSM -- there are many LSMs). Additionally, the series should
> probably be sent _to_ the userfaultfd maintainers:
>         Andrea Arcangeli <aarcange-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
>         Mike Rapoport <rppt-tEXmvtCZX7AybS5Ee8rs3A@public.gmane.org>
> and I'd also CC a couple other people that have done recent work:
>         Peter Xu <peterx-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
>         Jann Horn <jannh-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
>
> More notes below...

In general, in the event that a patch series doesn't include all
needed parties on the to-line, what's the right way to fix the
situation without spamming everyone and forking the thread? In this
case, since I'm splitting the patch series anyway, I can just expand
the to-line in the reroll.

> On Tue, Feb 11, 2020 at 02:55:41PM -0800, Daniel Colascione wrote:
> > Userfaultfd in unprivileged contexts could be potentially very
> > useful. We'd like to harden userfaultfd to make such unprivileged use
> > less risky. This patch series allows SELinux to manage userfaultfd
> > file descriptors and allows administrators to limit userfaultfd to
> > servicing user-mode faults, increasing the difficulty of using
> > userfaultfd in exploit chains invoking delaying kernel faults.
>
> I actually think these are two very different goals and likely the
> series could be split into two for them. One is LSM hooking of
> userfaultfd and the SELinux attachment, and the other is the user-mode
> fault restrictions. And they would likely go via separate trees (LSM
> through James's LSM tree, and probably akpm's -mm tree for the sysctl).
>
> > A new anon_inodes interface allows callers to opt into SELinux
> > management of anonymous file objects. In this mode, anon_inodes
> > creates new ephemeral inodes for anonymous file objects instead of
> > reusing a singleton dummy inode. A new LSM hook gives security modules
> > an opportunity to configure and veto these ephemeral inodes.
> >
> > Existing anon_inodes users must opt into the new functionality.
> >
> > Daniel Colascione (6):
> >   Add a new flags-accepting interface for anonymous inodes
> >   Add a concept of a "secure" anonymous file
> >   Teach SELinux about a new userfaultfd class
> >   Wire UFFD up to SELinux
>
> The above is the first "series"... I don't have much opinion about it,
> though I do like the idea of making userfaultfd visible to the LSM.

Yeah. The interesting part there is the anon_inodes API change. I'll
split that half of the series out.

> >   Let userfaultfd opt out of handling kernel-mode faults
> >   Add a new sysctl for limiting userfaultfd to user mode faults
>
> Now this I'm very interested in. Can you go into more detail about two
> things:
>
> - What is the threat being solved? (I understand the threat, but detailing
>   it in the commit log is important for people who don't know it. Existing
>   commit cefdca0a86be517bc390fc4541e3674b8e7803b0 gets into some of the
>   details already, but I'd like to see reference to external sources like
>   https://duasynt.com/blog/linux-kernel-heap-spray)

Sure. I can add a reference to that and a more general discussion of
how delaying kernel fault handling can broaden race windows for other
exploits.

> - Why is this needed in addition to the existing vm.unprivileged_userfaultfd
>   sysctl? (And should this maybe just be another setting for that
>   sysctl, like "2"?)

We want to use UFFD for a new garbage collector in Android, and we
want unprivileged processes to be able to use this new garbage
collector. Giving them CAP_SYS_PTRACE is dangerous.

> As to the mechanics of the change, I'm not sure I like the idea of adding
> a UAPI flag for this. Why not just retain the permission check done at
> open() and if kernelmode faults aren't allowed, ignore them? This would
> require no changes to existing programs and gains the desired defense.

As Jann mentions below, it's a matter of the kernel's contractual
obligation to userspace. Right now, userfaultfd(2) either succeeds or
it fails with one of the enumerated error codes. You're proposing
having the userfaultfd(2) succeed but return a file descriptor that
doesn't do the job the kernel promised it would do. If we were to
adopt your proposal, an application would see UFFD succeed, then see
unexpeced EFAULTs from system calls, which would probably cause the
application to malfunctioning in exciting ways. An explicit "sorry, I
can't do that" error code is better: an application that gets an error
code from userfaultfd(2) can fall back to something else, but an
application that silently gets an underfeatured UFFD doesn't know
anything is wrong until it's too late. The additional flag preserves
the UFFD contract and gives applications a way to probe for feature
support.

> (And, I think, the sysctl value could be bumped to "2" as that's a
> better default state -- does qemu actually need kernelmode traps?)

I prefer a default of one for regular systems because I don't want to
make experimentation with novel ways to use UFFD more difficult, and a
default of two would require users go out of their way to handle user
faults, and few will. For a more constrained system like Android, two
is fine.

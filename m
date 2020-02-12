From: Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>
Subject: Re: [PATCH v2 0/6] Harden userfaultfd
Date: Tue, 11 Feb 2020 23:50:58 -0800
Message-ID: <202002112332.BE71455@keescook>
References: <20200211225547.235083-1-dancol@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20200211225547.235083-1-dancol-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Daniel Colascione <dancol-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: timmurray-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, nosh-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, nnk-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, lokeshgidra-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, selinux-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Andrea Arcangeli <aarcange-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Mike Rapoport <rppt-tEXmvtCZX7AybS5Ee8rs3A@public.gmane.org>, Peter Xu <peterx-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Jann Horn <jannh-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

Hi!

Firstly, thanks for working on this! It's been on my TODO list for a
while. :)

Casey already recommended including the LSM list to CC (since this is a
new LSM -- there are many LSMs). Additionally, the series should
probably be sent _to_ the userfaultfd maintainers:
	Andrea Arcangeli <aarcange-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
	Mike Rapoport <rppt-tEXmvtCZX7AybS5Ee8rs3A@public.gmane.org>
and I'd also CC a couple other people that have done recent work:
	Peter Xu <peterx-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
	Jann Horn <jannh-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>

More notes below...

On Tue, Feb 11, 2020 at 02:55:41PM -0800, Daniel Colascione wrote:
> Userfaultfd in unprivileged contexts could be potentially very
> useful. We'd like to harden userfaultfd to make such unprivileged use
> less risky. This patch series allows SELinux to manage userfaultfd
> file descriptors and allows administrators to limit userfaultfd to
> servicing user-mode faults, increasing the difficulty of using
> userfaultfd in exploit chains invoking delaying kernel faults.

I actually think these are two very different goals and likely the
series could be split into two for them. One is LSM hooking of
userfaultfd and the SELinux attachment, and the other is the user-mode
fault restrictions. And they would likely go via separate trees (LSM
through James's LSM tree, and probably akpm's -mm tree for the sysctl).

> A new anon_inodes interface allows callers to opt into SELinux
> management of anonymous file objects. In this mode, anon_inodes
> creates new ephemeral inodes for anonymous file objects instead of
> reusing a singleton dummy inode. A new LSM hook gives security modules
> an opportunity to configure and veto these ephemeral inodes.
> 
> Existing anon_inodes users must opt into the new functionality.
> 
> Daniel Colascione (6):
>   Add a new flags-accepting interface for anonymous inodes
>   Add a concept of a "secure" anonymous file
>   Teach SELinux about a new userfaultfd class
>   Wire UFFD up to SELinux

The above is the first "series"... I don't have much opinion about it,
though I do like the idea of making userfaultfd visible to the LSM.

>   Let userfaultfd opt out of handling kernel-mode faults
>   Add a new sysctl for limiting userfaultfd to user mode faults

Now this I'm very interested in. Can you go into more detail about two
things:

- What is the threat being solved? (I understand the threat, but detailing
  it in the commit log is important for people who don't know it. Existing
  commit cefdca0a86be517bc390fc4541e3674b8e7803b0 gets into some of the
  details already, but I'd like to see reference to external sources like
  https://duasynt.com/blog/linux-kernel-heap-spray)

- Why is this needed in addition to the existing vm.unprivileged_userfaultfd
  sysctl? (And should this maybe just be another setting for that
  sysctl, like "2"?)

As to the mechanics of the change, I'm not sure I like the idea of adding
a UAPI flag for this. Why not just retain the permission check done at
open() and if kernelmode faults aren't allowed, ignore them? This would
require no changes to existing programs and gains the desired defense.
(And, I think, the sysctl value could be bumped to "2" as that's a
better default state -- does qemu actually need kernelmode traps?)

Thanks again for the patches!

-Kees

> 
>  Documentation/admin-guide/sysctl/vm.rst | 13 ++++
>  fs/anon_inodes.c                        | 89 +++++++++++++++++--------
>  fs/userfaultfd.c                        | 29 ++++++--
>  include/linux/anon_inodes.h             | 27 ++++++--
>  include/linux/lsm_hooks.h               |  8 +++
>  include/linux/security.h                |  2 +
>  include/linux/userfaultfd_k.h           |  3 +
>  include/uapi/linux/userfaultfd.h        |  9 +++
>  kernel/sysctl.c                         |  9 +++
>  security/security.c                     |  8 +++
>  security/selinux/hooks.c                | 68 +++++++++++++++++++
>  security/selinux/include/classmap.h     |  2 +
>  12 files changed, 229 insertions(+), 38 deletions(-)
> 
> -- 
> 2.25.0.225.g125e21ebc7-goog
> 

-- 
Kees Cook

From: Andy Lutomirski <luto-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH 0/3] ABI CHANGE!!! Remove questionable remote SP reads
Date: Fri, 30 Sep 2016 10:58:55 -0700
Message-ID: <cover.1475257877.git.luto@kernel.org>
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Brian Gerst <brgerst-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Borislav Petkov <bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org>, Jann Horn <jann-XZ1E9jl8jIdeoWH0uzbU5w@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, Tycho Andersen <tycho.andersen-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>, Andy Lutomirski <luto-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
List-Id: linux-api@vger.kernel.org

Jann Horn noticed that KSTK_ESP + eager task stack freeing was a bad
combination and could crash.  I could very easily fix it to not
crash, but I think that using KSTK_ESP on a remote task is
questionable in general.  Therefore, I propose to get rid of the
major users for 4.9.

This series makes two ABI changes:

 - /proc/PID/stat will show 0 0 instead of esp eip.  I don't think
   that the esp and eip fields were ever reliable unless the target
   task was being ptraced by the reading task, and ptrace(2) gives a
   far better interface to the same thing in this case.  On the flip
   side, these fields could leak kernel addresses under some
   circumstances on some arches if the target task is running or was
   interrupted (on a remote CPU or preempted on the local CPU) in an
   inconvenient place.

   I suspect it made sense when everything was single-CPU and non-
   preemptible, which implied that the target task *had* to be
   sleeping in something resembling normal kernel code, but that
   hasn't been the case for a long time.

 - /proc/PID/task/TID/maps did some interesting things to guess which
   vma was the stack.  This behavior is recent and IMO dangerously
   racy.  I'd like to get rid of it.

This is a little late so, if there is significant objection, I'll
just do the easy fix for 4.9 and resubmit for 4.10.

Andy Lutomirski (3):
  proc: Stop reporting eip and esp in /proc/PID/stat
  proc: Stop trying to report thread stacks
  mm: Change vm_is_stack_for_task() to vm_is_stack_for_current()

 Documentation/filesystems/proc.txt | 26 --------------------------
 fs/proc/array.c                    |  9 +++++----
 fs/proc/task_mmu.c                 | 29 ++++++++++-------------------
 fs/proc/task_nommu.c               | 28 ++++++++++------------------
 include/linux/mm.h                 |  2 +-
 mm/util.c                          |  4 +++-
 security/selinux/hooks.c           |  2 +-
 7 files changed, 30 insertions(+), 70 deletions(-)

-- 
2.7.4

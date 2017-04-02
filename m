From: ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org (Eric W. Biederman)
Subject: [RFC][PATCH v2 0/5] exec: Fixing ptrace'd mulit-threaded hang
Date: Sun, 02 Apr 2017 17:50:02 -0500
Message-ID: <874ly6a0h1.fsf_-_@xmission.com>
References: <20170213141452.GA30203@redhat.com>
        <20170224160354.GA845@redhat.com> <87shmv6ufl.fsf@xmission.com>
        <20170303173326.GA17899@redhat.com> <87tw7axlr0.fsf@xmission.com>
        <87d1dyw5iw.fsf@xmission.com> <87tw7aunuh.fsf@xmission.com>
        <87lgsmunmj.fsf_-_@xmission.com> <20170304170312.GB13131@redhat.com>
        <8760ir192p.fsf@xmission.com> <878tnkpv8h.fsf_-_@xmission.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <878tnkpv8h.fsf_-_-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org> (Eric W. Biederman's message of
        "Sat, 01 Apr 2017 00:11:58 -0500")
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Oleg Nesterov <oleg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Aleksa Sarai <asarai-IBi9RG/b67k@public.gmane.org>, Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>, Attila Fazekas <afazekas-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Jann Horn <jann-XZ1E9jl8jIdeoWH0uzbU5w@public.gmane.org>, Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Ulrich Obergfell <uobergfe-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org


Oleg your comment about kill being able to send signal was an important
dimension I had missed thank you.

This patchset just denies the case of SIGHAND between different
multi-threaded processes as I don't think anyone cares.  I can
fix that if anyone cares but I am not certain we actally do.

I have reworked the ptrace notification code so that we always
send notifications if we can but don't wait if it is a coredump
or an exec.  Which simpilifies the code nicely.

A few more tweaks are needed before a final version but I think
things are compelling.

 fs/exec.c                    |  23 ++-------
 include/linux/sched/signal.h |   1 +
 kernel/exit.c                |  20 ++++----
 kernel/fork.c                |  14 +++++-
 kernel/ptrace.c              |   4 ++
 kernel/signal.c              | 112 +++++++++++++++++++------------------------
 6 files changed, 78 insertions(+), 96 deletions(-)

Eric W. Biederman (5):
      ptrace: Don't wait in PTRACE_O_TRACEEXIT for exec or coredump
      sighand: Count each thread group once in sighand_struct
      clone: Disallown CLONE_THREAD with a shared sighand_struct
      exec: If possible don't wait for ptraced threads to be reaped
      signal: Don't allow accessing signal_struct by old threads after exec

Eric

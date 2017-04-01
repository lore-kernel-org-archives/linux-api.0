From: ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org (Eric W. Biederman)
Subject: [RFC][PATCH 0/2] exec: Fixing ptrace'd mulit-threaded hang
Date: Sat, 01 Apr 2017 00:11:58 -0500
Message-ID: <878tnkpv8h.fsf_-_@xmission.com>
References: <20170213141452.GA30203@redhat.com>
        <20170224160354.GA845@redhat.com> <87shmv6ufl.fsf@xmission.com>
        <20170303173326.GA17899@redhat.com> <87tw7axlr0.fsf@xmission.com>
        <87d1dyw5iw.fsf@xmission.com> <87tw7aunuh.fsf@xmission.com>
        <87lgsmunmj.fsf_-_@xmission.com> <20170304170312.GB13131@redhat.com>
        <8760ir192p.fsf@xmission.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <8760ir192p.fsf-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org> (Eric W. Biederman's message of
        "Thu, 30 Mar 2017 03:07:42 -0500")
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Oleg Nesterov <oleg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Aleksa Sarai <asarai-IBi9RG/b67k@public.gmane.org>, Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>, Attila Fazekas <afazekas-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Jann Horn <jann-XZ1E9jl8jIdeoWH0uzbU5w@public.gmane.org>, Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Ulrich Obergfell <uobergfe-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org


I spent a little more time with this and only waiting until the killed
thread are zombies (and not reaped as we do today) really looks like
the right fix.

Oleg the following two patches work on top of your PTRACE_EVENT_EXIT
change and probably need a little more cleanup until they are ready
for serious posting.

That said I want to I want to post the code so I have a change at
some feedback before I prepare the final round of patches.

These patches only handle the case when sighand_struct is not
shared between different multi-threaded processes.  The general
case is solvable but that is a quite a bit more code.

Eric W. Biederman (2):
      sighand: Count each thread group once in sighand_struct
      exec: If possible don't wait for ptraced threads to be reaped

 fs/exec.c                    | 15 ++++++++++-----
 include/linux/sched/signal.h |  2 +-
 kernel/exit.c                | 15 ++++++++++-----
 kernel/fork.c                |  6 ++++--
 kernel/signal.c              |  8 ++++++--
 5 files changed, 31 insertions(+), 15 deletions(-)

Eric

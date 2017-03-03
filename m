From: ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org (Eric W. Biederman)
Subject: Re: [PATCH 0/2] fix the traced mt-exec deadlock
Date: Fri, 03 Mar 2017 14:06:30 -0600
Message-ID: <87tw7aunuh.fsf@xmission.com>
References: <20170213141452.GA30203@redhat.com>
        <20170224160354.GA845@redhat.com> <87shmv6ufl.fsf@xmission.com>
        <20170303173326.GA17899@redhat.com> <87tw7axlr0.fsf@xmission.com>
        <87d1dyw5iw.fsf@xmission.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <87d1dyw5iw.fsf-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org> (Eric W. Biederman's message of
        "Fri, 03 Mar 2017 12:59:19 -0600")
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Oleg Nesterov <oleg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Aleksa Sarai <asarai-IBi9RG/b67k@public.gmane.org>, Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>, Attila Fazekas <afazekas-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Jann Horn <jann-XZ1E9jl8jIdeoWH0uzbU5w@public.gmane.org>, Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Ulrich Obergfell <uobergfe-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org (Eric W. Biederman) writes:

> ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org (Eric W. Biederman) writes:
>
>> The big lesson for me, and what was not obvious from your change
>> description is that we are changing the user space visible semantics
>> of exec+ptrace and that cred_guard_mutex is not at all the problem (as
>> we always take cred_guard_mutex in a killable or interruptible way).
>
> Just to follow up.
>
> Because the cred_guard_mutex is fine as is we don't need to move
> de_thread out from under cred_guard_mutex.  We just need to change
> de_thread to wait until all of the other threads are zombies.
> Which should remove about half your proposed patch.
>
> The other key thing is that knowning it isn't cred_guard_mutex let's us
> know that this kind of deadlock goes all of the way back to when
> CLONE_THREAD was merged into the kernel.
>
> Insteresingly enough looking at zap_other_threads and notify_count I
> have found a second bug.  When a multi-threaded processes becomes a
> zombie we don't send the notification to the parent process until the
> non-leader threads have been reaped.  Which means ptrace can mess up
> sending SIGCHLD to the parent.

Bah. I was misreading the code.  Nothing but exec uses notify_count
and group_exit_task.

Eric

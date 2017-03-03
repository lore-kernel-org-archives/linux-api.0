From: ebiederm@xmission.com (Eric W. Biederman)
Subject: Re: [PATCH 0/2] fix the traced mt-exec deadlock
Date: Fri, 03 Mar 2017 12:59:19 -0600
Message-ID: <87d1dyw5iw.fsf@xmission.com>
References: <20170213141452.GA30203@redhat.com>
        <20170224160354.GA845@redhat.com> <87shmv6ufl.fsf@xmission.com>
        <20170303173326.GA17899@redhat.com> <87tw7axlr0.fsf@xmission.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <87tw7axlr0.fsf@xmission.com> (Eric W. Biederman's message of
        "Fri, 03 Mar 2017 12:23:31 -0600")
Sender: linux-kernel-owner@vger.kernel.org
To: Oleg Nesterov <oleg@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Aleksa Sarai <asarai@suse.com>, Andy Lutomirski <luto@amacapital.net>, Attila Fazekas <afazekas@redhat.com>, Jann Horn <jann@thejh.net>, Kees Cook <keescook@chromium.org>, Michal Hocko <mhocko@kernel.org>, Ulrich Obergfell <uobergfe@redhat.com>, linux-kernel@vger.kernel.org, linux-api@vger.kernel.org
List-Id: linux-api@vger.kernel.org

ebiederm@xmission.com (Eric W. Biederman) writes:

> The big lesson for me, and what was not obvious from your change
> description is that we are changing the user space visible semantics
> of exec+ptrace and that cred_guard_mutex is not at all the problem (as
> we always take cred_guard_mutex in a killable or interruptible way).

Just to follow up.

Because the cred_guard_mutex is fine as is we don't need to move
de_thread out from under cred_guard_mutex.  We just need to change
de_thread to wait until all of the other threads are zombies.
Which should remove about half your proposed patch.

The other key thing is that knowning it isn't cred_guard_mutex let's us
know that this kind of deadlock goes all of the way back to when
CLONE_THREAD was merged into the kernel.

Insteresingly enough looking at zap_other_threads and notify_count I
have found a second bug.  When a multi-threaded processes becomes a
zombie we don't send the notification to the parent process until the
non-leader threads have been reaped.  Which means ptrace can mess up
sending SIGCHLD to the parent.

Now arguably that might be what is desirable but I don't think so.  If
we aren't ptracing a thread then I don't think we want to delay sending
SIGCHLD to the parent.

So this whole area of the semantics of a ptrace'd multi-threaded process
exiting/exec'ing looks like it needs a thorough going over.

Eric

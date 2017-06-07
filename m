From: ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org (Eric W. Biederman)
Subject: Re: [PATCH 00/26] Fixing wait, exit, ptrace, exec, and CLONE_THREAD
Date: Wed, 07 Jun 2017 10:59:13 -0500
Message-ID: <87zidjokku.fsf@xmission.com>
References: <877f0pym71.fsf@xmission.com>
        <CA+55aFze5rR+rGcG6kt=8PtfgAcs02jqQ7Gm-1=1MzkbA7_nqA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CA+55aFze5rR+rGcG6kt=8PtfgAcs02jqQ7Gm-1=1MzkbA7_nqA-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
        (Linus Torvalds's message of "Tue, 6 Jun 2017 13:07:53 -0700")
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: Linux Kernel Mailing List <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux Containers <containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>, Oleg Nesterov <oleg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, Roland McGrath <roland-/Z5OmTQCD9xF6kxbq+BtvQ@public.gmane.org>, Al Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, David Howells <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "Michael Kerrisk (man-pages)" <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
List-Id: linux-api@vger.kernel.org

Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org> writes:

> On Tue, Jun 6, 2017 at 12:01 PM, Eric W. Biederman
> <ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org> wrote:
>>
>> I am posting this patches in the hope of some review of the strategy I
>> am taking and to let the individual patches be reviewed.
>
> I'm trying to look through these, and finding (as usual) that the
> signal handling and exit code is extremely scary from a correctness
> and security standpoint.
>
> I really want Oleg to review/ack these. Oleg?

Definitely.  The more review I can get the better. 

> I also would really really want to see the stuff that actually changes
> semantics split out.
>
> For example, I feel much less nervous about things like making the
> tasklist RCU-safe. So I'd like to see changes like that be separated
> out from the much scarier ones. Would that be possible? Hint hint..

The patches that I posted are the ones that I would really like to have
ready for the 4.13 merge window.  They are supposed to be the least
scary patches that don't really depend on anything else, and the semantic changes.

After a first brush with code review the non-scary patches wind up just
being these.

[PATCH 01/26] alpha: Remove unused TASK_GROUP_LEADER
[PATCH 02/26] cgroup: Don't open code tasklist_empty()
[PATCH 05/26] exit:  Remove the pointless clearing of SIGPENDING in __exit_signal
[PATCH 07/26] pidns: Improve the error handling in alloc_pid
[PATCH 08/26] exit: Make the runqueue rcu safe

This turns out to have a dependency I overlooked so I am dropping it for now.
[PATCH 06/26] rlimit: Remove unnecessary grab of tasklist_lock

There is a small pair of a semantic change and it's dependency:
[PATCH 03/26] signal: Do not perform permission checks when sending pdeath_signal
[PATCH 04/26] signal: Make group_send_sig_info static

There is a teeny tiny semantic change:
[PATCH 09/26] signal: Don't allow sending SIGKILL or SIGSTOP to init

The deeply related scarier changes (+ indicates it includes a semantic change):
 [PATCH 10/26] ptrace: Simplify ptrace_detach & exit_ptrace
+[PATCH 11/26] wait: Properly implement __WCLONE handling in the presence of exec and ptrace
 [PATCH 12/26] wait: Directly test for the two cases where wait_task_zombie is called
 [PATCH 13/26] wait: Remove unused delay_group_leader
+[PATCH 14/26] wait: Move changing of ptrace from wait_consider_task into wait_task_stopped
+[PATCH 15/26] wait: Don't delay !ptrace_reparented leaders
+[PATCH 16/26] exit: Fix reporting a ptraced !reparented leader has exited
 [PATCH 17/26] exit: Rework the exit states for ptracees
+[PATCH 18/26] wait: Fix WSTOPPED on a ptraced child
 [PATCH 19/26] wait: Simpler code for clearing notask_error in wait_consider_task
 [PATCH 20/26] wait: Don't pass the list to wait_consider_task
 [PATCH 21/26] wait: Optmize waitpid
+[PATCH 22/26] exit: Fix auto-wait of ptraced children
+[PATCH 23/26] signal: Fix SIGCONT before group stop completes.
+[PATCH 24/26] signal: In ptrace_stop improve identical signal detection
+[PATCH 25/26] signal: In ptrace_stop use CLD_TRAPPED in all ptrace signals
+[PATCH 26/26] pidns: Ensure zap_pid_ns_processes always terminates

Out of my 170 or so total changes those are the bulk of the semantic
changes and definitely the scariest.  Even those above are very
conservative and are really just about sorting out the weirdness in the
semantics when we are ptracing our own child which causes wait and the
siginfo of SIGCHLD to have two sets of meanings.

I am hoping we can just get 1,2,5,7, and 8 reviewed and I can just apply
them to my for-next branch.

If I need to repost I will respect the split-out I have described above.

At this point I am happy to see that people are not scared when I
suggest killing the concept of the thread group leader.

Eric

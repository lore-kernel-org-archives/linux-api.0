From: Alexey Dobriyan <adobriyan-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [RFC v16][PATCH 23/43] c/r: restart multiple processes
Date: Wed, 27 May 2009 23:37:58 +0400
Message-ID: <20090527193758.GC31930@x200.localdomain>
References: <1243445589-32388-1-git-send-email-orenl@cs.columbia.edu> <1243445589-32388-24-git-send-email-orenl@cs.columbia.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1243445589-32388-24-git-send-email-orenl-eQaUEPhvms7ENvBUuze7eA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Oren Laadan <orenl-eQaUEPhvms7ENvBUuze7eA@public.gmane.org>
Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Linus Torvalds <torvalds-3NddpPZAyC0@public.gmane.org>, containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Serge Hallyn <serue-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org>, Dave Hansen <dave-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, Ingo Molnar <mingo-X9Un+BFzKDI@public.gmane.org>, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, Alexander Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, Pavel Emelyanov <xemul-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Wed, May 27, 2009 at 01:32:49PM -0400, Oren Laadan wrote:
> Restarting of multiple processes expects all restarting tasks to call
> sys_restart(). Once inside the system call, each task will restart
> itself at the same order that they were saved. The internals of the
> syscall will take care of in-kernel synchronization bewteen tasks.
> 
> This patch does _not_ create the task tree in the kernel. Instead it
> assumes that all tasks are created in some way and then invoke the
> restart syscall. You can use the userspace mktree.c program to do
> that.
> 
> The init task (*) has a special role: it allocates the restart context
> (ctx), and coordinates the operation. In particular, it first waits
> until all participating tasks enter the kernel, and provides them the
> common restart context. Once everyone in ready, it begins to restart
> itself.
> 
> In contrast, the other tasks enter the kernel, locate the init task (*)
> and grab its restart context, and then wait for their turn to restore.
> 
> When a task (init or not) completes its restart, it hands the control
> over to the next in line, by waking that task.
> 
> An array of pids (the one saved during the checkpoint) is used to
> synchronize the operation. The first task in the array is the init
> task (*). The restart context (ctx) maintain a "current position" in
> the array, which indicates which task is currently active. Once the
> currently active task completes its own restart, it increments that
> position and wakes up the next task.
> 
> Restart assumes that userspace provides meaningful data, otherwise
> it's garbage-in-garbage-out. In this case, the syscall may block
> indefinitely, but in TASK_INTERRUPTIBLE, so the user can ctrl-c or
> otherwise kill the stray restarting tasks.
> 
> In terms of security, restart runs as the user the invokes it, so it
> will not allow a user to do more than is otherwise permitted by the
> usual system semantics and policy.
> 
> Currently we ignore threads and zombies

Let's discuss threads and zombies.

1. Will zombie end up in a image?
2. If yes, how it will be restored. Will it be forked, call restart(2)
   and then somehow zombified inside kernel?
3. How thread group will be restored, will every thread be CLONE_THREAD'ed?
   What to do with exited thread group leaders, will they be forked, then
   CLONE_THREAD thread group?
--
To unsubscribe from this list: send the line "unsubscribe linux-api" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

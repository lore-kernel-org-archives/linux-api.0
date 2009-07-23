From: "Serge E. Hallyn" <serue-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org>
Subject: Re: [RFC v17][PATCH 19/60] c/r: documentation
Date: Thu, 23 Jul 2009 09:24:54 -0500
Message-ID: <20090723142454.GA10769@us.ibm.com>
References: <1248256822-23416-1-git-send-email-orenl@librato.com> <1248256822-23416-20-git-send-email-orenl@librato.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1248256822-23416-20-git-send-email-orenl-RdfvBDnrOixBDgjK7y7TUQ@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Oren Laadan <orenl-RdfvBDnrOixBDgjK7y7TUQ@public.gmane.org>
Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Linus Torvalds <torvalds-3NddpPZAyC0@public.gmane.org>, containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Dave Hansen <dave-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, Ingo Molnar <mingo-X9Un+BFzKDI@public.gmane.org>, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, Alexander Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, Pavel Emelyanov <xemul-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>, Alexey Dobriyan <adobriyan-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Oren Laadan <orenl-eQaUEPhvms7ENvBUuze7eA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

Quoting Oren Laadan (orenl-RdfvBDnrOixBDgjK7y7TUQ@public.gmane.org):
> +Security
> +========
> +
> +The main question is whether sys_checkpoint() and sys_restart()
> +require privileged or unprivileged operation.
> +
> +Early versions checked capable(CAP_SYS_ADMIN) assuming that we would
> +attempt to remove the need for privilege, so that all users could
> +safely use it. Arnd Bergmann pointed out that it'd make more sense to
> +let unprivileged users use them now, so that we'll be more careful
> +about the security as patches roll in.
> +
> +Checkpoint: the main concern is whether a task that performs the
> +checkpoint of another task has sufficient privileges to access its
> +state. We address this by requiring that the checkpointer task will be
> +able to ptrace the target task, by means of ptrace_may_access() with
> +read mode.

with access mode now, actually.

> +Restart: the main concern is that we may allow an unprivileged user to
> +feed the kernel with random data. To this end, the restart works in a
> +way that does not skip the usual security checks. Task credentials,
> +i.e. euid, reuid, and LSM security contexts currently come from the
> +caller, not the checkpoint image.  When restoration of credentials
> +becomes supported, then definitely the ability of the task that calls
> +sys_restore() to setresuid/setresgid to those values must be checked.

That is now possible, and this is done.

> +Keeping the restart procedure to operate within the limits of the
> +caller's credentials means that there various scenarios that cannot
> +be supported. For instance, a setuid program that opened a protected
> +log file and then dropped privileges will fail the restart, because
> +the user won't have enough credentials to reopen the file. In these
> +cases, we should probably treat restarting like inserting a kernel
> +module: surely the user can cause havoc by providing incorrect data,
> +but then again we must trust the root account.
> +
> +So that's why we don't want CAP_SYS_ADMIN required up-front. That way
> +we will be forced to more carefully review each of those features.
> +However, this can be controlled with a sysctl-variable.
> +
> +
> diff --git a/Documentation/checkpoint/usage.txt b/Documentation/checkpoint/usage.txt
> new file mode 100644
> index 0000000..ed34765
> --- /dev/null
> +++ b/Documentation/checkpoint/usage.txt
> @@ -0,0 +1,193 @@
> +
> +	      How to use Checkpoint-Restart
> +	=========================================
> +
> +
> +API
> +===
> +
> +The API consists of two new system calls:
> +
> +* int checkpoint(pid_t pid, int fd, unsigned long flag);
> +
> + Checkpoint a (sub-)container whose root task is identified by @pid,
> + to the open file indicated by @fd. @flags may be on or more of:
> +   - CHECKPOINT_SUBTREE : allow checkpoint of sub-container
> + (other value are not allowed).
> +
> + Returns: a positive checkpoint identifier (ckptid) upon success, 0 if
> + it returns from a restart, and -1 if an error occurs. The ckptid will
> + uniquely identify a checkpoint image, for as long as the checkpoint
> + is kept in the kernel (e.g. if one wishes to keep a checkpoint, or a
> + partial checkpoint, residing in kernel memory).
> +
> +* int sys_restart(pid_t pid, int fd, unsigned long flags);
> +
> + Restart a process hierarchy from a checkpoint image that is read from
> + the blob stored in the file indicated by @fd. The @flags' will have
> + future meaning (must be 0 for now). @pid indicates the root of the
> + hierarchy as seen in the coordinator's pid-namespace, and is expected
> + to be a child of the coordinator. (Note that this argument may mean
> + 'ckptid' to identify an in-kernel checkpoint image, with some @flags
> + in the future).
> +
> + Returns: -1 if an error occurs, 0 on success when restarting from a
> + "self" checkpoint, and return value of system call at the time of the
> + checkpoint when restarting from an "external" checkpoint.

Return value of the checkpointed (init) task's syscall at the time of
external checkpoint?  If so, what's the use for this, as opposed to
returning 0 as in the case of self-checkpoint?

> + TODO: upon successful "external" restart, the container will end up
> + in a frozen state.

Should clone_with_pids() be mentioned here?

thanks,
-serge
--
To unsubscribe from this list: send the line "unsubscribe linux-api" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

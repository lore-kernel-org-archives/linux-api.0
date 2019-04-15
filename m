From: Christian Brauner <christian@brauner.io>
Subject: Re: [PATCH 2/4] clone: add CLONE_PIDFD
Date: Mon, 15 Apr 2019 15:52:48 +0200
Message-ID: <20190415135246.d6pvyf3pkt3sbh6t@brauner.io>
References: <20190414201436.19502-1-christian@brauner.io>
 <20190414201436.19502-3-christian@brauner.io>
 <20190415105209.GA22204@redhat.com>
 <20190415114204.ydczeuwmi74wfsuv@brauner.io>
 <20190415132416.GB22204@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20190415132416.GB22204@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Oleg Nesterov <oleg@redhat.com>
Cc: torvalds@linux-foundation.org, viro@zeniv.linux.org.uk, jannh@google.com, dhowells@redhat.com, linux-api@vger.kernel.org, linux-kernel@vger.kernel.org, serge@hallyn.com, luto@kernel.org, arnd@arndb.de, ebiederm@xmission.com, keescook@chromium.org, tglx@linutronix.de, mtk.manpages@gmail.com, akpm@linux-foundation.org, cyphar@cyphar.com, joel@joelfernandes.org, dancol@google.com
List-Id: linux-api@vger.kernel.org

On Mon, Apr 15, 2019 at 03:24:16PM +0200, Oleg Nesterov wrote:
> On 04/15, Christian Brauner wrote:
> >
> > > CLONE_PARENT_SETTID doesn't look very usefule, so what if we add
> > >
> > > 	if ((clone_flags & (CLONE_PIDFD|CLONE_PARENT_SETTID)) ==
> > > 	                   (CLONE_PIDFD|CLONE_PARENT_SETTID))
> > > 		return ERR_PTR(-EINVAL);
> > >
> > > at the start of copy_process() ?
> > >
> > > Then it can do
> > >
> > > 	if (clone_flags & CLONE_PIDFD) {
> > > 		retval = pidfd_create(pid, &pidfdf);
> > > 		if (retval < 0)
> > > 			goto bad_fork_free_pid;
> > > 		retval = put_user(retval, parent_tidptr)
> > > 		if (retval < 0)
> > > 			goto bad_fork_free_pid;
> > > 	}
> >
> > Uhhh Oleg, that is nifty. I have to say I like that a lot. This would
> > let us return the pid and the pidfd in one go and we can also start
> > pidfd numbering at 0.
> 
> Christian, sorry if it was already discussed, but I can't force myself to
> read all the previous discussions ;)
> 
> If we forget about CONFIG_PROC_FS, why do we really want to create a file?
> 
> 
> Suppose we add a global u64 counter incremented by copy_process and reported
> in /proc/$pid/status. Suppose that clone(CLONE_PIDFD) writes this counter to
> *parent_tidptr. Let's denote this counter as UNIQ_PID.
> 
> Now, if you want to (say) safely kill a task and you have its UNIQ_PID, you
> can do
> 
> 	kill_by_pid_uniq(int pid, u64 uniq_pid)
> 	{
> 		pidfd = open("/proc/$pid", O_DIRECTORY);
> 
> 		status = openat(pidfd, "status");
> 		u64 this_uniq_pid = ... read UNIQ_PID from status ...;
> 
> 		if (uniq_pid != this_uniq_pid)
> 			return;
> 
> 		pidfd_send_signal(pidfd);
> 	}
> 
> Why else do we want pidfd?

I think this was thrown around at one point but this is rather
inelegant imho. It basically makes a process unique by using a
combination of two identifiers. You end up with a similar concept but
you make it way less flexible and extensible imho. With pidfds you can
not care about pids at all if you don't want to. The UNIQ_PID thing
would require you to always juggle two identifiers.

Your example would also only work if CONFIG_PROC_FS is set (Not sure if
that's what you meant by "forget about CONFIG_PROC_FS")? Say, you get
a pid from clone() and your UNIQ_PID thing. Then you still can't
reliably kill a process because pidfd_send_signal() is not useable since
you can't get pidfds. And if you go the kill way you end up with the same
problem. Yes, you could solve this by probably extending syscalls to
take a UNIQ_PID argument but that seems very inelegant.

The UNIQ_PID implementation would also require being tracked in the
kernel either in task_struct or struct pid potentially and thus would
probably add more infrastructure in the kernel. We don't need any of
that if we simply rely on pidfds.

Most of all, the pidfd concept allows one way more flexibility in
extending it. For example, Joel is working on a patchset to make pidfds
pollable so you can get information about a process death by polling
them. We also want to be able to potentially wait on a process with
waitid(W_PIDFD) or similar as suggested by Linus in earlier threads. At
that point you end up in a similar situation as tgkill() where you pass
a tgid and a pid already to make sure that the pid you pass has the tgid
as thread-group leader. That is all way simpler with pidfds.

From: Joel Fernandes <joel@joelfernandes.org>
Subject: Re: [PATCH 2/4] pid: add pidctl()
Date: Tue, 26 Mar 2019 12:07:29 -0400
Message-ID: <20190326160729.GA76870@google.com>
References: <20190325162052.28987-1-christian@brauner.io>
 <20190325162052.28987-3-christian@brauner.io>
 <CAG48ez24xPM4f7ty=8k5p6_gVWd-bEUSxca5Ngy5svHgarhz+w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CAG48ez24xPM4f7ty=8k5p6_gVWd-bEUSxca5Ngy5svHgarhz+w@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Jann Horn <jannh@google.com>
Cc: Christian Brauner <christian@brauner.io>, Andy Lutomirski <luto@kernel.org>, Konstantin Khlebnikov <khlebnikov@yandex-team.ru>, David Howells <dhowells@redhat.com>, "Serge E. Hallyn" <serge@hallyn.com>, "Eric W. Biederman" <ebiederm@xmission.com>, Linux API <linux-api@vger.kernel.org>, kernel list <linux-kernel@vger.kernel.org>, Arnd Bergmann <arnd@arndb.de>, Kees Cook <keescook@chromium.org>, Alexey Dobriyan <adobriyan@gmail.com>, Thomas Gleixner <tglx@linutronix.de>, Michael Kerrisk-manpages <mtk.manpages@gmail.com>, bl0pbl33p@gmail.com, "Dmitry V. Levin" <ldv@altlinux.org>, Andrew Morton <akpm@linux-foundation.org>, Oleg Nesterov <oleg@redhat.com>, Nagarathnam Muthusamy <nagarathnam.muthusamy@oracle.com>, cyphar@cyphar.com, Al Viro <viro@zeniv.lin>
List-Id: linux-api@vger.kernel.org

On Mon, Mar 25, 2019 at 07:18:42PM +0100, Jann Horn wrote:
> On Mon, Mar 25, 2019 at 5:21 PM Christian Brauner <christian@brauner.io> wrote:
> > The pidctl() syscalls builds on, extends, and improves translate_pid() [4].
> > I quote Konstantins original patchset first that has already been acked and
> > picked up by Eric before and whose functionality is preserved in this
> > syscall:
> [...]
> > +
> > +static struct pid_namespace *get_pid_ns_by_fd(int fd)
> > +{
> > +       struct pid_namespace *pidns = ERR_PTR(-EINVAL);
> > +
> > +       if (fd >= 0) {
> > +#ifdef CONFIG_PID_NS
> > +               struct ns_common *ns;
> > +               struct file *file = proc_ns_fget(fd);
> > +               if (IS_ERR(file))
> > +                       return ERR_CAST(file);
> > +
> > +               ns = get_proc_ns(file_inode(file));
> > +               if (ns->ops->type == CLONE_NEWPID)
> > +                       pidns = get_pid_ns(
> > +                               container_of(ns, struct pid_namespace, ns));
> 
> This increments the refcount of the pidns...
> 
> > +
> > +               fput(file);
> > +#endif
> > +       } else {
> > +               pidns = task_active_pid_ns(current);
> 
> ... but this doesn't. That's pretty subtle; could you please put a
> comment on top of this function that points this out? Or even better,
> change the function to always take a reference, so that the caller
> doesn't have to worry about figuring this out.
> 
> > +       }
> > +
> > +       return pidns;
> > +}
> [...]
> > +SYSCALL_DEFINE5(pidctl, unsigned int, cmd, pid_t, pid, int, source, int, target,
> > +               unsigned int, flags)
> > +{
> > +       struct pid_namespace *source_ns = NULL, *target_ns = NULL;
> > +       struct pid *struct_pid;
> > +       pid_t result;
> > +
> > +       switch (cmd) {
> > +       case PIDCMD_QUERY_PIDNS:
> > +               if (pid != 0)
> > +                       return -EINVAL;
> > +               pid = 1;
> > +               /* fall through */
> > +       case PIDCMD_QUERY_PID:
> > +               if (flags != 0)
> > +                       return -EINVAL;
> > +               break;
> > +       case PIDCMD_GET_PIDFD:
> > +               if (flags & ~PIDCTL_CLOEXEC)
> > +                       return -EINVAL;
> > +               break;
> > +       default:
> > +               return -EOPNOTSUPP;
> > +       }
> > +
> > +       source_ns = get_pid_ns_by_fd(source);
> > +       result = PTR_ERR(source_ns);
> 
> I very much dislike using PTR_ERR() on pointers before checking
> whether they contain an error value or not. I understand that the
> result of this won't actually be used, but it still seems weird to
> have what is essentially a cast of a potentially valid pointer to a
> potentially smaller integer here.
> 
> Could you maybe move the PTR_ERR() into the error branch? Like so:
> 
> if (IS_ERR(source_ns)) {
>   result = PTR_ERR(source_ns);
>   goto err_source;
> }

FWIW, thought of mentioning that once the get_pid_ns_by_fd can be modified to
always take a reference on the ns, a further simplifcation here could be:

if (IS_ERR(source_ns)) {
	result = PTR_ERR(source_ns);
	source_ns = NULL;
	goto error;
}

if (IS_ERR(target_ns)) {
	result = PTR_ERR(target_ns);
	target_ns = NULL;
	goto error;
}

And the error patch can be simplified as well which also avoids the "if (target)"
issues Jan mentioned in the error path:

error:
	if (source_ns)
		put_pid_ns(source_ns);
	if (target_ns)
		put_pid_ns(target_ns);
	return result;

 
> > +       if (IS_ERR(source_ns))
> > +               goto err_source;
> > +
> > +       target_ns = get_pid_ns_by_fd(target);
> > +       result = PTR_ERR(target_ns);
> > +       if (IS_ERR(target_ns))
> > +               goto err_target;
> > +
> > +       if (cmd == PIDCMD_QUERY_PIDNS) {
> > +               result = pidns_related(source_ns, target_ns);
> > +       } else {
> > +               rcu_read_lock();
> > +               struct_pid = find_pid_ns(pid, source_ns);
> 
> find_pid_ns() doesn't take a reference on its return value, the return
> value is only pinned into memory by the RCU read-side critical
> section...
> 
> > +               result = struct_pid ? pid_nr_ns(struct_pid, target_ns) : -ESRCH;
> > +               rcu_read_unlock();
> 
> ... which ends here, making struct_pid a dangling pointer...
> 
> > +
> > +               if (cmd == PIDCMD_GET_PIDFD) {
> > +                       int cloexec = (flags & PIDCTL_CLOEXEC) ? O_CLOEXEC : 0;
> > +                       if (result > 0)
> > +                               result = pidfd_create_fd(struct_pid, cloexec);
> 
> ... and then here you continue to use struct_pid. That seems bogus.

Absolutely.

> > +                       else if (result == 0)
> > +                               result = -ENOENT;
> 
> You don't need to have flags for this for new syscalls, you can just
> make everything O_CLOEXEC; if someone wants to preserve an fd across
> execve(), they can just clear that bit with fcntl(). (I thiiink it was
> Andy Lutomirski who said that before regarding another syscall? But my
> memory of that is pretty foggy, might've been someone else.)

Agreed, I also was going to say the same, about the flags.

thanks,

 - Joel


> 
> > +               }
> > +       }
> > +
> > +       if (target)
> > +               put_pid_ns(target_ns);
> > +err_target:
> > +       if (source)
> > +               put_pid_ns(source_ns);
> 
> I think you probably intended to check for "if (target >= 0)" and "if
> (source >= 0)" instead of these conditions, matching the condition in
> get_pid_ns_by_fd()? The current code looks as if it will leave the
> refcount one too high when used with target==0 or source==0, and leave
> the refcount one too low when used with target==-1 or source==-1.
> Anyway, as stated above, I think it would be simpler to
> unconditionally take a reference instead.
> 
> > +err_source:
> > +       return result;
> > +}

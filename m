From: ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org (Eric W. Biederman)
Subject: Re: [PATCH 0/1] ns: introduce proc_get_ns_by_fd()
Date: Mon, 28 Sep 2015 11:37:08 -0500
Message-ID: <871tdi8pqj.fsf@x220.int.ebiederm.org>
References: <20150925135246.27620.97496.stgit@buzz>
	<20150925175654.GA12504@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20150925175654.GA12504-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> (Oleg Nesterov's message of
	"Fri, 25 Sep 2015 19:56:54 +0200")
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Oleg Nesterov <oleg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Konstantin Khlebnikov <khlebnikov-XoJtRXgx1JseBXzfvpsJ4g@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Roman Gushchin <klamm-XoJtRXgx1JseBXzfvpsJ4g@public.gmane.org>, Serge Hallyn <serge.hallyn-GeWIH/nMZzLQT0dZR+AlfA@public.gmane.org>, Chen Fan <chen.fan.fnst-BthXqXjhjHXQFUHtdCDX3A@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, =?utf-8?Q?St=C3=A9phane?= Graber <stgraber-GeWIH/nMZzLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

Oleg Nesterov <oleg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> writes:

> On 09/25, Konstantin Khlebnikov wrote:
>>
>> +struct ns_common *proc_ns_fdget(int fd, int nstype, struct fd *fd_ref)
>>  {
>> -	struct file *file;
>> +	struct ns_common *ns;
>> +	struct fd f;
>>  
>> -	file = fget(fd);
>> -	if (!file)
>> +	f = fdget(fd);
>> +	if (!f.file)
>>  		return ERR_PTR(-EBADF);
>>  
>> -	if (file->f_op != &ns_file_operations)
>> +	if (f.file->f_op != &ns_file_operations)
>> +		goto out_invalid;
>> +
>> +	ns = get_proc_ns(file_inode(f.file));
>> +	if (nstype && (ns->ops->type != nstype))
>>  		goto out_invalid;
>>  
>> -	return file;
>> +	*fd_ref = f;
>> +	return ns;
>>  
>>  out_invalid:
>> -	fput(file);
>> +	fdput(f);
>>  	return ERR_PTR(-EINVAL);
>>  }
>
> Well yes, fdget() makes sense but this is minor.
>
> Honestly, I do not really like the new helper... I understand this
> is subjective, so I won't insist. But how about 1/1? We do not need
> fd/file at all. With this patch your sys_getvpid() can just use
> proc_get_ns_by_fd(fd, CLONE_NEWPID) and put_pid_ns().
>
> Eric, what do you think?

At some level I don't care this is not exposed to userspace.

However since we are going several rounds with this.

Of the existing uses several of them sleep, which unfortunately means we
can not use rcu locking for everything.  The network namespace ones wind
up taking a reference to struct net because the have the legacy pid case
to deal with.  Which makes we can not use fdget for all callers either.

For this translate_pid rcu locking is sufficient, rcu locking is easy
and doing any more than rcu locking just seems silly.  So let me
respectfully suggest.

struct ns_common *ns_by_fd_rcu(int fd, int type)
{
	struct files_struct *files = current->files;
	struct file *file;
	struct ns_common *ns;
	void *ret;

	file = fcheck_files(files, fd);
        if (!file)
		return ERR_PTR(-EBADF);

	if (file->f_mode & FMODE_PATH)
		return ERR_PTR(-EINVAL);

	if (file->f_op != &ns_file_operations)
        	return ERR_PTR(-EINVAL);

	ns = get_proc_ns(file_inode(file));
	if (ns->ops->type != type)
		return ERR_PTR(-EINVAL);

	return ns;
}

struct pid_namespace *pidns_by_fd_rcu(int fd)
{
	struct ns_common *ns = ns_by_fd_rcu(fd, CLONE_NEWPID);
        if (IS_ERR(ns))
		return ERR_CAST(ns);
	return container_of(ns, struct pid_namespace, ns);
}

SYSCALL_DEFINE3(translate_pid, pid_t, pid_nr, int, sourcefd, int, targetfd)
{
	struct pid_namespace *source, *target;
	struct pid *pid;
	pid_t result;

	rcu_read_lock();

	if (sourcefd >= 0)
        	source = pidns_by_fd_rcu(sourcefd);
	else
		source = task_active_pid_ns(current);

	if (targetfd >= 0)
        	target = pidns_by_fd_rcu(targetfd);
	else
		target = task_active_pid_ns(current);

	pid = find_pid_ns(pid_nr, source);
        result = pid_nr_ns(pid, target);
        if (result == 0)
		result = -ESRCH;          

	rcu_read_unlock();

	return result;
}

Eric

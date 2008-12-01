From: Oren Laadan <orenl-eQaUEPhvms7ENvBUuze7eA@public.gmane.org>
Subject: Re: [RFC v10][PATCH 08/13] Dump open file descriptors
Date: Mon, 01 Dec 2008 15:23:57 -0500
Message-ID: <493447DD.7010102@cs.columbia.edu>
References: <1227747884-14150-1-git-send-email-orenl@cs.columbia.edu>	 <1227747884-14150-9-git-send-email-orenl@cs.columbia.edu>	 <20081128101919.GO28946@ZenIV.linux.org.uk> <1228153645.2971.36.camel@nimitz>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1228153645.2971.36.camel@nimitz>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Dave Hansen <dave-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
Cc: Al Viro <viro-3bDd1+5oDREiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Linus Torvalds <torvalds-3NddpPZAyC0@public.gmane.org>, containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Serge Hallyn <serue-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org>, Ingo Molnar <mingo-X9Un+BFzKDI@public.gmane.org>, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>
List-Id: linux-api@vger.kernel.org



Dave Hansen wrote:
> On Fri, 2008-11-28 at 10:19 +0000, Al Viro wrote:
>> On Wed, Nov 26, 2008 at 08:04:39PM -0500, Oren Laadan wrote:
>>> +int cr_scan_fds(struct files_struct *files, int **fdtable)
>>> +{
>>> +	struct fdtable *fdt;
>>> +	int *fds;
>>> +	int i, n = 0;
>>> +	int tot = CR_DEFAULT_FDTABLE;
>>> +
>>> +	fds = kmalloc(tot * sizeof(*fds), GFP_KERNEL);
>>> +	if (!fds)
>>> +		return -ENOMEM;
>>> +
>>> +	/*
>>> +	 * We assume that the target task is frozen (or that we checkpoint
>>> +	 * ourselves), so we can safely proceed after krealloc() from where
>>> +	 * we left off; in the worst cases restart will fail.
>>> +	 */
>> Task may be frozen, but it may share the table with any number of other
>> tasks...
> 
> First of all, thanks for looking at this, Al.  

That goes for me too.

> 
> I think Oren's assumption here is that all tasks possibly sharing the
> table would be frozen.  I don't think that's a good assumption,
> either. :)
> 
> This would be a lot safer and bulletproof if we size the allocation
> ahead of time, take all the locks, then retry if the size has changed.

Yes, I assume that all tasks possibly sharing the table are frozen for
this to work "right"; by "right" I mean that if checkpoint completes
then a matching restart would complete successfully.

Verifying that the size doesn't change does not ensure that the table's
contents remained the same, so we can still end up with obsolete data.
For that, you'll need to take the lock over a very long period of time,
while you capture and write data about the files.

So back to the assumption: the idea is that if the user does not adhere
to this assumption - ensuring that all tasks are frozen and that there
are no sharing otherwise - then the results are undefined (just as, e.g.
not calling execve() immediately after vfork() gives undefined results).

By "undefined" I mean that it may produce a checkpoint image that can't
be restarted, or fail. If the assumption doesn't hold, then the table may
change, and we will get a list of fd's which is "incorrect". The comment
before this function explicitly says that "The caller must validate the
file descriptors...", so the checkpoint may will fail subsequently, eg.
while trying to access a bad fd. Otherwise, the image file will reflect
a state that is inconsistent, and restart will fail.

Note that in both cases, the code will not crash the kernel (unless you
think I missed something...)

(BTW, the alternative would be to test for such sharing and abort with
an error. The only way I can think of is to loop through the all the
tasks, for each files_struct that we find. But we don't really need to,
given the argument above).

> 
> I think that will just plain work of we do this:
> 
>>> +	spin_lock(&files->file_lock);
>>> +	rcu_read_lock();
>>> +	fdt = files_fdtable(files);
>>> +	for (i = 0; i < fdt->max_fds; i++) {
>>> +		if (!fcheck_files(files, i))
>>> +			continue;
>>> +		if (n == tot) {
>>> +			/*
>>> +			 * fcheck_files() is safe with drop/re-acquire
>>> +			 * of the lock, because it tests:  fd < max_fds
>>> +			 */
>>> +			spin_unlock(&files->file_lock);
>>> +			rcu_read_unlock();
>>> +			tot *= 2;	/* won't overflow: kmalloc will fail */
> 
> 			  free(fds);
> 			  goto first_kmalloc_in_this_function;
> 
>>> +		}
>>> +		fds[n++] = i;
>>> +	}
>>> +	rcu_read_unlock();
>>> +	spin_unlock(&files->file_lock);
>>> +
>>> +	*fdtable = fds;
>>> +	return n;
>>> +}
> 
> Right?

Lol .. that was actually in my original post, and changed in response to
comments that explicitly asked to not count in advance :o

Actually, I think the current code is cleaner, and I don't see how counting
in advance with the lock give us any advantage here.

>>> +	switch (inode->i_mode & S_IFMT) {
>>> +	case S_IFREG:
>>> +		fd_type = CR_FD_FILE;
>>> +		break;
>>> +	case S_IFDIR:
>>> +		fd_type = CR_FD_DIR;
>>> +		break;
>>> +	case S_IFLNK:
>>> +		fd_type = CR_FD_LINK;
>> Opened symlinks?  May I have whatever you'd been smoking, please?
> 
> Ugh, that certainly doesn't have any place here.  I do wonder if Oren
> had some use for that in the fully put together code, but it can
> certainly go for now.

Not anymore. Indeed ugh...

Thanks,

Oren.

> 
> I'll send patches for these shortly.
> 
> -- Dave
> 
> 
--
To unsubscribe from this list: send the line "unsubscribe linux-api" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

From: ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org (Eric W. Biederman)
Subject: Re: [PATCH v8 07/11] proc: flush task dcache entries from all procfs instances
Date: Mon, 10 Feb 2020 22:01:06 -0600
Message-ID: <87d0allqm5.fsf@x220.int.ebiederm.org>
References: <20200210150519.538333-1-gladkov.alexey@gmail.com>
        <20200210150519.538333-8-gladkov.alexey@gmail.com>
        <87v9odlxbr.fsf@x220.int.ebiederm.org>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <87v9odlxbr.fsf-JOvCrm2gF+uungPnsOpG7nhyD016LWXt@public.gmane.org> (Eric W. Biederman's
        message of "Mon, 10 Feb 2020 19:36:08 -0600")
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Alexey Gladkov <gladkov.alexey-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Kernel Hardening <kernel-hardening-ZwoEplunGu1jrUoiu81ncdBPR1lH4CV8@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux FS Devel <linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux Security Module <linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Akinobu Mita <akinobu.mita-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Alexander Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, Alexey Dobriyan <adobriyan-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Andy Lutomirski <luto-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Daniel Micay <danielmicay-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Djalal Harouni <tixxdz-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "Dmitry V . Levin" <ldv-u2l5PoMzF/Vg9hUCZPvPmw@public.gmane.org>, Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "J . Bruce Fields" <bfields-uC3wQj2KruNg9hUCZPvPmw@public.gmane.org>, Jeff Layton <jlayton-vpEMnDpepFuMZCB2o+C8xQ@public.gmane.org>, Jonathan Corbet <corbet-T1hC0tSOHrs@public.gmane.org>Ke
List-Id: linux-api@vger.kernel.org

ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org (Eric W. Biederman) writes:

> Alexey Gladkov <gladkov.alexey-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> writes:
>
>> This allows to flush dcache entries of a task on multiple procfs mounts
>> per pid namespace.
>>
>> The RCU lock is used because the number of reads at the task exit time
>> is much larger than the number of procfs mounts.
>
> A couple of quick comments.
>
>> Cc: Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>
>> Cc: Andy Lutomirski <luto-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
>> Signed-off-by: Djalal Harouni <tixxdz-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
>> Suggested-by: Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
>> Signed-off-by: Alexey Gladkov <gladkov.alexey-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
>> ---
>>  fs/proc/base.c                | 20 +++++++++++++++-----
>>  fs/proc/root.c                | 27 ++++++++++++++++++++++++++-
>>  include/linux/pid_namespace.h |  2 ++
>>  include/linux/proc_fs.h       |  2 ++
>>  4 files changed, 45 insertions(+), 6 deletions(-)
>>
>> diff --git a/fs/proc/base.c b/fs/proc/base.c
>> index 4ccb280a3e79..24b7c620ded3 100644
>> --- a/fs/proc/base.c
>> +++ b/fs/proc/base.c
>> @@ -3133,7 +3133,7 @@ static const struct inode_operations proc_tgid_base_inode_operations = {
>>  	.permission	= proc_pid_permission,
>>  };
>>  
>> -static void proc_flush_task_mnt(struct vfsmount *mnt, pid_t pid, pid_t tgid)
>> +static void proc_flush_task_mnt_root(struct dentry *mnt_root, pid_t pid, pid_t tgid)
> Perhaps just rename things like:
>> +static void proc_flush_task_root(struct dentry *root, pid_t pid, pid_t tgid)
>>  {
>
> I don't think the mnt_ prefix conveys any information, and it certainly
> makes everything longer and more cumbersome.
>
>>  	struct dentry *dentry, *leader, *dir;
>>  	char buf[10 + 1];
>> @@ -3142,7 +3142,7 @@ static void proc_flush_task_mnt(struct vfsmount *mnt, pid_t pid, pid_t tgid)
>>  	name.name = buf;
>>  	name.len = snprintf(buf, sizeof(buf), "%u", pid);
>>  	/* no ->d_hash() rejects on procfs */
>> -	dentry = d_hash_and_lookup(mnt->mnt_root, &name);
>> +	dentry = d_hash_and_lookup(mnt_root, &name);
>>  	if (dentry) {
>>  		d_invalidate(dentry);
>>  		dput(dentry);
>> @@ -3153,7 +3153,7 @@ static void proc_flush_task_mnt(struct vfsmount *mnt, pid_t pid, pid_t tgid)
>>  
>>  	name.name = buf;
>>  	name.len = snprintf(buf, sizeof(buf), "%u", tgid);
>> -	leader = d_hash_and_lookup(mnt->mnt_root, &name);
>> +	leader = d_hash_and_lookup(mnt_root, &name);
>>  	if (!leader)
>>  		goto out;
>>  
>> @@ -3208,14 +3208,24 @@ void proc_flush_task(struct task_struct *task)
>>  	int i;
>>  	struct pid *pid, *tgid;
>>  	struct upid *upid;
>> +	struct dentry *mnt_root;
>> +	struct proc_fs_info *fs_info;
>>  
>>  	pid = task_pid(task);
>>  	tgid = task_tgid(task);
>>  
>>  	for (i = 0; i <= pid->level; i++) {
>>  		upid = &pid->numbers[i];
>> -		proc_flush_task_mnt(upid->ns->proc_mnt, upid->nr,
>> -					tgid->numbers[i].nr);
>> +
>> +		rcu_read_lock();
>> +		list_for_each_entry_rcu(fs_info, &upid->ns->proc_mounts, pidns_entry) {
>> +			mnt_root = fs_info->m_super->s_root;
>> +			proc_flush_task_mnt_root(mnt_root, upid->nr, tgid->numbers[i].nr);
>> +		}
>> +		rcu_read_unlock();
>> +
>> +		mnt_root = upid->ns->proc_mnt->mnt_root;
>> +		proc_flush_task_mnt_root(mnt_root, upid->nr, tgid->numbers[i].nr);
>
> I don't think this following of proc_mnt is needed.  It certainly
> shouldn't be.  The loop through all of the super blocks should be
> enough.
>
> Once this change goes through.  UML can be given it's own dedicated
> proc_mnt for the initial pid namespace, and proc_mnt can be removed
> entirely.
>
> Unless something has changed recently UML is the only other user of
> pid_ns->proc_mnt.  That proc_mnt really only exists to make the loop in
> proc_flush_task easy to write.
>
> It also probably makes sense to take the rcu_read_lock() over
> that entire for loop.
>
>
>>  	}
>>  }
>>  
>> diff --git a/fs/proc/root.c b/fs/proc/root.c
>> index 5d5cba4c899b..e2bb015da1a8 100644
>> --- a/fs/proc/root.c
>> +++ b/fs/proc/root.c
>> @@ -149,7 +149,22 @@ static int proc_fill_super(struct super_block *s, struct fs_context *fc)
>>  	if (ret) {
>>  		return ret;
>>  	}
>> -	return proc_setup_thread_self(s);
>> +
>> +	ret = proc_setup_thread_self(s);
>> +	if (ret) {
>> +		return ret;
>> +	}
>> +
>> +	/*
>> +	 * back reference to flush dcache entries at process exit time.
>> +	 */
>> +	ctx->fs_info->m_super = s;
>> +
>> +	spin_lock(&pid_ns->proc_mounts_lock);
>> +	list_add_tail_rcu(&ctx->fs_info->pidns_entry, &pid_ns->proc_mounts);
>> +	spin_unlock(&pid_ns->proc_mounts_lock);
>> +
>> +	return 0;
>>  }
>>  
>>  static int proc_reconfigure(struct fs_context *fc)
>> @@ -211,10 +226,17 @@ static void proc_kill_sb(struct super_block *sb)
>>  {
>>  	struct proc_fs_info *fs_info = proc_sb_info(sb);
>>  
>> +	spin_lock(&fs_info->pid_ns->proc_mounts_lock);
>> +	list_del_rcu(&fs_info->pidns_entry);
>> +	spin_unlock(&fs_info->pid_ns->proc_mounts_lock);
>> +
>> +	synchronize_rcu();
>> +
>
> Rather than a heavyweight synchronize_rcu here,
> it probably makes sense to instead to change
>
> 	kfree(fs_info)
> to
> 	kfree_rcu(fs_info, some_rcu_head_in_fs_info)
>
> Or possibly doing a full call_rcu.
>
> The problem is that synchronize_rcu takes about 10ms when HZ=100.
> Which makes synchronize_rcu incredibly expensive on any path where
> anything can wait for it.

I take it back.

The crucial thing to insert a rcu delay before is
shrink_dcache_for_umount.

With the call chain:
kill_anon_super
    generic_shutdown_super
        shrink_dcache_for_umount.

So we do need synchronize_rcu or to put everything below this point into
a call_rcu function.

The practical concern is mntput calls does task_work_add.
The task_work function is cleanup_mnt.
When called cleanup_mnt calls deactivate_locked_super
which in turn calls proc_kill_sb.

Which is a long way of saying that the code will delay the
exit of the process that calls mntput by 10ms (or
however syncrhonize_rcu runs).

We probably don't care.  But that is long enough in to be user
visible, and potentially cause problems.

But all it requires putting the code below in it's own
function and triggering it with call_rcu if that causes a regression
by bying so slow.

>>  	if (fs_info->proc_self)
>>  		dput(fs_info->proc_self);
>>  	if (fs_info->proc_thread_self)
>>  		dput(fs_info->proc_thread_self);
>> +
>>  	kill_anon_super(sb);
>>  	put_pid_ns(fs_info->pid_ns);
>>  	kfree(fs_info);
>> @@ -336,6 +358,9 @@ int pid_ns_prepare_proc(struct pid_namespace *ns)
>>  		ctx->fs_info->pid_ns = ns;
>>  	}
>>  
>> +	spin_lock_init(&ns->proc_mounts_lock);
>> +	INIT_LIST_HEAD_RCU(&ns->proc_mounts);
>> +
>>  	mnt = fc_mount(fc);
>>  	put_fs_context(fc);
>>  	if (IS_ERR(mnt))
>> diff --git a/include/linux/pid_namespace.h b/include/linux/pid_namespace.h
>> index 66f47f1afe0d..c36af1dfd862 100644
>> --- a/include/linux/pid_namespace.h
>> +++ b/include/linux/pid_namespace.h
>> @@ -26,6 +26,8 @@ struct pid_namespace {
>>  	struct pid_namespace *parent;
>>  #ifdef CONFIG_PROC_FS
>>  	struct vfsmount *proc_mnt; /* Internal proc mounted during each new pidns */
>> +	spinlock_t proc_mounts_lock;
>> +	struct list_head proc_mounts; /* list of separated procfs mounts */
>>  #endif
>>  #ifdef CONFIG_BSD_PROCESS_ACCT
>>  	struct fs_pin *bacct;
>> diff --git a/include/linux/proc_fs.h b/include/linux/proc_fs.h
>> index 5f0b1b7e4271..f307940f8311 100644
>> --- a/include/linux/proc_fs.h
>> +++ b/include/linux/proc_fs.h
>> @@ -20,6 +20,8 @@ enum {
>>  };
>>  
>>  struct proc_fs_info {
>> +	struct list_head pidns_entry;    /* Node in procfs_mounts of a pidns */
>> +	struct super_block *m_super;
>>  	struct pid_namespace *pid_ns;
>>  	struct dentry *proc_self;        /* For /proc/self */
>>  	struct dentry *proc_thread_self; /* For /proc/thread-self */
>
>
> Eric

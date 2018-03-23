From: NAGARATHNAM MUTHUSAMY <nagarathnam.muthusamy-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: Re: [REVIEW][PATCH 09/11] ipc/shm: Fix shmctl(..., IPC_STAT, ...)
	between pid namespaces.
Date: Fri, 23 Mar 2018 14:17:35 -0700
Message-ID: <7df62190-2407-bfd4-d144-7304a8ea8ae3@oracle.com>
References: <87vadmobdw.fsf_-_@xmission.com>
	<20180323191614.32489-9-ebiederm@xmission.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Content-Transfer-Encoding: 7bit
Return-path: <containers-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
In-Reply-To: <20180323191614.32489-9-ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org>
Content-Language: en-US
List-Unsubscribe: <https://lists.linuxfoundation.org/mailman/options/containers>,
	<mailto:containers-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.linuxfoundation.org/pipermail/containers/>
List-Post: <mailto:containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
List-Help: <mailto:containers-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=help>
List-Subscribe: <https://lists.linuxfoundation.org/mailman/listinfo/containers>,
	<mailto:containers-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=subscribe>
Sender: containers-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org
Errors-To: containers-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org
To: "Eric W. Biederman" <ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org>, Linux Containers <containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
Cc: esyr-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, jannh-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, khlebnikov-XoJtRXgx1JseBXzfvpsJ4g@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, serge.hallyn-GeWIH/nMZzLQT0dZR+AlfA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, prakash.sangappa-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org, linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, luto-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, oleg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, Pavel Emelyanov <xemul-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>
List-Id: linux-api@vger.kernel.org



On 3/23/2018 12:16 PM, Eric W. Biederman wrote:
> Today shm_cpid and shm_lpid are remembered in the pid namespace of the
> creator and the processes that last touched a sysvipc shared memory
> segment.   If you have processes in multiple pid namespaces that
> is just wrong, and I don't know how this has been over-looked for
> so long.
>
> As only creation and shared memory attach and shared memory detach
> update the pids I do not expect there to be a repeat of the issues
> when struct pid was attached to each af_unix skb, which in some
> notable cases cut the performance in half.  The problem was threads of
> the same process updating same struct pid from different cpus causing
> the cache line to be highly contended and bounce between cpus.
>
> As creation, attach, and detach are expected to be rare operations for
> sysvipc shared memory segments I do not expect that kind of cache line
> ping pong to cause probems.  In addition because the pid is at a fixed
> location in the structure instead of being dynamic on a skb, the
> reference count of the pid does not need to be updated on each
> operation if the pid is the same.  This ability to simply skip the pid
> reference count changes if the pid is unchanging further reduces the
> likelihood of the a cache line holding a pid reference count
> ping-ponging between cpus.
>
> Fixes: b488893a390e ("pid namespaces: changes to show virtual ids to user")
> Signed-off-by: "Eric W. Biederman" <ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org>
Thanks!

Reviewed-by: Nagarathnam Muthusamy <nagarathnam.muthusamy-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>

> ---
>   ipc/shm.c | 25 +++++++++++++++----------
>   1 file changed, 15 insertions(+), 10 deletions(-)
>
> diff --git a/ipc/shm.c b/ipc/shm.c
> index 0565669ebe5c..932b7e411c6c 100644
> --- a/ipc/shm.c
> +++ b/ipc/shm.c
> @@ -57,8 +57,8 @@ struct shmid_kernel /* private to the kernel */
>   	time64_t		shm_atim;
>   	time64_t		shm_dtim;
>   	time64_t		shm_ctim;
> -	pid_t			shm_cprid;
> -	pid_t			shm_lprid;
> +	struct pid		*shm_cprid;
> +	struct pid		*shm_lprid;
>   	struct user_struct	*mlock_user;
>   
>   	/* The task created the shm object.  NULL if the task is dead. */
> @@ -226,7 +226,7 @@ static int __shm_open(struct vm_area_struct *vma)
>   		return PTR_ERR(shp);
>   
>   	shp->shm_atim = ktime_get_real_seconds();
> -	shp->shm_lprid = task_tgid_vnr(current);
> +	ipc_update_pid(&shp->shm_lprid, task_tgid(current));
>   	shp->shm_nattch++;
>   	shm_unlock(shp);
>   	return 0;
> @@ -267,6 +267,8 @@ static void shm_destroy(struct ipc_namespace *ns, struct shmid_kernel *shp)
>   		user_shm_unlock(i_size_read(file_inode(shm_file)),
>   				shp->mlock_user);
>   	fput(shm_file);
> +	ipc_update_pid(&shp->shm_cprid, NULL);
> +	ipc_update_pid(&shp->shm_lprid, NULL);
>   	ipc_rcu_putref(&shp->shm_perm, shm_rcu_free);
>   }
>   
> @@ -311,7 +313,7 @@ static void shm_close(struct vm_area_struct *vma)
>   	if (WARN_ON_ONCE(IS_ERR(shp)))
>   		goto done; /* no-op */
>   
> -	shp->shm_lprid = task_tgid_vnr(current);
> +	ipc_update_pid(&shp->shm_lprid, task_tgid(current));
>   	shp->shm_dtim = ktime_get_real_seconds();
>   	shp->shm_nattch--;
>   	if (shm_may_destroy(ns, shp))
> @@ -614,8 +616,8 @@ static int newseg(struct ipc_namespace *ns, struct ipc_params *params)
>   	if (IS_ERR(file))
>   		goto no_file;
>   
> -	shp->shm_cprid = task_tgid_vnr(current);
> -	shp->shm_lprid = 0;
> +	shp->shm_cprid = get_pid(task_tgid(current));
> +	shp->shm_lprid = NULL;
>   	shp->shm_atim = shp->shm_dtim = 0;
>   	shp->shm_ctim = ktime_get_real_seconds();
>   	shp->shm_segsz = size;
> @@ -648,6 +650,8 @@ static int newseg(struct ipc_namespace *ns, struct ipc_params *params)
>   		user_shm_unlock(size, shp->mlock_user);
>   	fput(file);
>   no_file:
> +	ipc_update_pid(&shp->shm_cprid, NULL);
> +	ipc_update_pid(&shp->shm_lprid, NULL);
>   	call_rcu(&shp->shm_perm.rcu, shm_rcu_free);
>   	return error;
>   }
> @@ -970,8 +974,8 @@ static int shmctl_stat(struct ipc_namespace *ns, int shmid,
>   	tbuf->shm_atime	= shp->shm_atim;
>   	tbuf->shm_dtime	= shp->shm_dtim;
>   	tbuf->shm_ctime	= shp->shm_ctim;
> -	tbuf->shm_cpid	= shp->shm_cprid;
> -	tbuf->shm_lpid	= shp->shm_lprid;
> +	tbuf->shm_cpid	= pid_vnr(shp->shm_cprid);
> +	tbuf->shm_lpid	= pid_vnr(shp->shm_lprid);
>   	tbuf->shm_nattch = shp->shm_nattch;
>   
>   	ipc_unlock_object(&shp->shm_perm);
> @@ -1605,6 +1609,7 @@ SYSCALL_DEFINE1(shmdt, char __user *, shmaddr)
>   #ifdef CONFIG_PROC_FS
>   static int sysvipc_shm_proc_show(struct seq_file *s, void *it)
>   {
> +	struct pid_namespace *pid_ns = ipc_seq_pid_ns(s);
>   	struct user_namespace *user_ns = seq_user_ns(s);
>   	struct kern_ipc_perm *ipcp = it;
>   	struct shmid_kernel *shp;
> @@ -1627,8 +1632,8 @@ static int sysvipc_shm_proc_show(struct seq_file *s, void *it)
>   		   shp->shm_perm.id,
>   		   shp->shm_perm.mode,
>   		   shp->shm_segsz,
> -		   shp->shm_cprid,
> -		   shp->shm_lprid,
> +		   pid_nr_ns(shp->shm_cprid, pid_ns),
> +		   pid_nr_ns(shp->shm_lprid, pid_ns),
>   		   shp->shm_nattch,
>   		   from_kuid_munged(user_ns, shp->shm_perm.uid),
>   		   from_kgid_munged(user_ns, shp->shm_perm.gid),

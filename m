From: Casey Schaufler <casey-iSGtlc1asvQWG2LlvL+J4A@public.gmane.org>
Subject: Re: [PATCH RFC v2 1/3] LSM: Allow per LSM module per "struct
 task_struct" blob.
Date: Mon, 10 Apr 2017 08:50:53 -0700
Message-ID: <f25edeb6-35e1-2f8c-8fd6-fd051c4e79ce@schaufler-ca.com>
References: <1491734530-25002-1-git-send-email-tixxdz@gmail.com>
 <1491734530-25002-2-git-send-email-tixxdz@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1491734530-25002-2-git-send-email-tixxdz-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Djalal Harouni <tixxdz-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Linux Kernel Mailing List <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Andy Lutomirski <luto-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, kernel-hardening-ZwoEplunGu1jrUoiu81ncdBPR1lH4CV8@public.gmane.org, linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Dongsu Park <dpark-VwIFZPTo/vqsTnJN9+BGXg@public.gmane.org>, James Morris <james.l.morris-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, serge-A9i7LUbDfNHQT0dZR+AlfA@public.gmane.org, Paul Moore <paul-r2n+y4ga6xFZroRs9YW3xA@public.gmane.org>, Tetsuo Handa <penguin-kernel-JPay3/Yim36HaxMnTkn67Xf5DAMn2ifp@public.gmane.org>, Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On 4/9/2017 3:42 AM, Djalal Harouni wrote:
> From: Tetsuo Handa <penguin-kernel-JPay3/Yim36HaxMnTkn67Xf5DAMn2ifp@public.gmane.org>
>
> Since several modules are planning to use per "struct task_struct" blob,
> we need a layer for isolating it. Therefore, this patch introduces per LSM
> module per "struct task_struct" blob.
>
> It would be possible to remember location in security_hook_heads.task_alloc
> list and undo up to the corresponding security_hook_heads.task_free list
> when task_alloc hook failed. But this patch calls all task_free hooks
> without checking whether the corresponding task_alloc hook was called
> since most modules should be able to handle this correctly.
>
> How to calculate amount of needed bytes and allocate memory for initial
> task is a chicken-or-egg syndrome. We need to know how many bytes needs
> to be allocated for initial task's security blobs before security_init()
> is called. But security_reserve_task_blob_index() which calculates amount
> of needed bytes is called from security_init(). We will need to split
> module registration into three steps. The first step is call
> security_reserve_task_blob_index() on all modules which should be
> activated. The second step is allocate memory for the initial task's
> security blob. The third step is actually activate all modules which
> should be activated.
>
> Signed-off-by: Djalal Harouni <tixxdz-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> Signed-off-by: Tetsuo Handa <penguin-kernel-JPay3/Yim36HaxMnTkn67Xf5DAMn2ifp@public.gmane.org>

While I appreciate your enthusiasm, I would really like
to see a mechanism for managing all of the blobs as being
potentially shared rather than just the task blob. With
infrastructure blob management being the general case we
could stack any set of existing modules that does not
include both SELinux and Smack. (AppArmor is threatening
to join that set, but we're still waiting on that) I
think it's a bad idea to go ahead with one implementation
for task blobs without taking care of the others.

> ---
>  include/linux/lsm_hooks.h | 36 +++++++++++++++++++++++++++++++++++-
>  security/security.c       | 37 ++++++++++++++++++++++++++++++++++++-
>  2 files changed, 71 insertions(+), 2 deletions(-)
>
> diff --git a/include/linux/lsm_hooks.h b/include/linux/lsm_hooks.h
> index 080f34e..ca19cdb 100644
> --- a/include/linux/lsm_hooks.h
> +++ b/include/linux/lsm_hooks.h
> @@ -27,6 +27,7 @@
>  #include <linux/security.h>
>  #include <linux/init.h>
>  #include <linux/rculist.h>
> +#include <linux/sched.h> /* "struct task_struct" */
>  
>  /**
>   * Security hooks for program execution operations.
> @@ -536,7 +537,10 @@
>   * @task_alloc:
>   *	@task task being allocated.
>   *	@clone_flags contains the flags indicating what should be shared.
> - *	Handle allocation of task-related resources.
> + *	Handle allocation of task-related resources. Note that task_free is
> + *	called even if task_alloc failed. This means that all task_free users
> + *	have to be prepared for task_free being called without corresponding
> + *	task_alloc call.
>   *	Returns a zero on success, negative values on failure.
>   * @task_free:
>   *	@task task about to be freed.
> @@ -1947,4 +1951,34 @@ void __init loadpin_add_hooks(void);
>  static inline void loadpin_add_hooks(void) { };
>  #endif
>  
> +/*
> + * Per "struct task_struct" security blob is managed using index numbers.
> + *
> + * Any user who wants to use per "struct task_struct" security blob reserves an
> + * index number using security_reserve_task_blob_index() before calling
> + * security_add_hooks().
> + *
> + * security_reserve_task_blob_index() returns an index number which has to be
> + * passed to task_security() by that user when fetching security blob of given
> + * "struct task_struct" for that user.
> + *
> + * Security blob for newly allocated "struct task_struct" is allocated and
> + * initialized with 0 inside security_task_alloc(), before calling each user's
> + * task_alloc hook. Be careful with task_free hook, for security_task_free()
> + * can be called when calling each user's task_alloc hook failed.
> + *
> + * Note that security_reserve_task_blob_index() uses "u16". It is not a good
> + * idea to directly reserve large amount. Sum of reserved amount by all users
> + * should be less than PAGE_SIZE bytes, for per "struct task_struct" security
> + * blob is allocated for each "struct task_struct" using kcalloc().
> + */
> +extern u16 __init security_reserve_task_blob_index(const u16 size);
> +static inline void *task_security(const struct task_struct *task,
> +				  const u16 index)
> +{
> +	unsigned long *p = task->security;
> +
> +	return p + index;
> +}
> +
>  #endif /* ! __LINUX_LSM_HOOKS_H */
> diff --git a/security/security.c b/security/security.c
> index 549bddc..4dc6bca 100644
> --- a/security/security.c
> +++ b/security/security.c
> @@ -32,6 +32,7 @@
>  /* Maximum number of letters for an LSM name string */
>  #define SECURITY_NAME_MAX	10
>  
> +static u16 lsm_max_per_task_blob_index __ro_after_init;
>  struct security_hook_heads security_hook_heads __lsm_ro_after_init;
>  char *lsm_names;
>  /* Boot-time LSM user choice */
> @@ -75,6 +76,15 @@ int __init security_init(void)
>  	 */
>  	do_security_initcalls();
>  
> +	/*
> +	 * Allocate per "struct task_struct" blob for initial task.
> +	 * Initialization is done later by each module which needs it.
> +	 */
> +	if (lsm_max_per_task_blob_index)
> +		current->security = kcalloc(lsm_max_per_task_blob_index,
> +					    sizeof(unsigned long),
> +					    GFP_KERNEL | __GFP_NOFAIL);
> +
>  	return 0;
>  }
>  
> @@ -86,6 +96,15 @@ static int __init choose_lsm(char *str)
>  }
>  __setup("security=", choose_lsm);
>  
> +u16 __init security_reserve_task_blob_index(const u16 size)
> +{
> +	const u16 index = lsm_max_per_task_blob_index;
> +	u16 requested = DIV_ROUND_UP(size, sizeof(unsigned long));
> +
> +	lsm_max_per_task_blob_index += requested;
> +	return index;
> +}
> +
>  static int lsm_append(char *new, char **result)
>  {
>  	char *cp;
> @@ -939,12 +958,28 @@ int security_task_create(unsigned long clone_flags)
>  
>  int security_task_alloc(struct task_struct *task, unsigned long clone_flags)
>  {
> -	return call_int_hook(task_alloc, 0, task, clone_flags);
> +	int rc;
> +	const unsigned long index = lsm_max_per_task_blob_index;
> +
> +	if (index) {
> +		task->security = kcalloc(index, sizeof(unsigned long),
> +					 GFP_KERNEL);
> +		if (unlikely(!task->security))
> +			return -ENOMEM;
> +	}
> +	rc = call_int_hook(task_alloc, 0, task, clone_flags);
> +	if (unlikely(rc))
> +		security_task_free(task);
> +	return rc;
>  }
>  
>  void security_task_free(struct task_struct *task)
>  {
>  	call_void_hook(task_free, task);
> +	if (lsm_max_per_task_blob_index) {
> +		kfree(task->security);
> +		task->security = NULL;
> +	}
>  }
>  
>  int security_cred_alloc_blank(struct cred *cred, gfp_t gfp)

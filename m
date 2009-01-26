From: Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH 1/1] x86: syscalls: sys_setrlimit64/sys_getrlimit64 calls to provide FSIZE  limits > 2^32-1
Date: Mon, 26 Jan 2009 20:23:07 +0100
Message-ID: <200901262023.08522.arnd@arndb.de>
References: <200901231759.n0NHxKA3009104@eng-pool-55.spikesource.com>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1754499AbZAZTXa@vger.kernel.org>
In-Reply-To: <200901231759.n0NHxKA3009104@eng-pool-55.spikesource.com>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
To: Narendra Prasad Madanapalli <narendramind@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-api@vger.kernel.org, linux-arch@vger.kernel.org
List-Id: linux-api@vger.kernel.org

[hmm: "550 5.7.1 recipient <narendramind@spikesource.com> unknown #291",
trying your @gmail.com. I also need to learn that it's linux-api, not
linux-abi]

On Friday 23 January 2009, narendramind@spikesource.com wrote:
> 
>   The solution to this problem would require new setrlimit64() and 
>   getrlimit64() system calls on x86, and the existing 32-bit system calls 
>   would need to be retained so that existing binaries would still run.

When adding new syscalls, please Cc: linux-abi@vger.kernel.org and
linux-arch@vger.kernel.org to get attention from all parties that are
involved.

> diff -uNrp -X linux-2.6.29-rc2/Documentation/dontdiff linux-2.6.29-rc2/arch/x86/kernel/syscall_table_32.S linux-2.6.29-rc2-rlim64/arch/x86/kernel/syscall_table_32.S
> --- linux-2.6.29-rc2/arch/x86/kernel/syscall_table_32.S	2009-01-17 09:54:06.000000000 +0530
> +++ linux-2.6.29-rc2-rlim64/arch/x86/kernel/syscall_table_32.S	2009-01-17 19:15:52.000000000 +0530
> @@ -332,3 +332,5 @@ ENTRY(sys_call_table)
>  	.long sys_dup3			/* 330 */
>  	.long sys_pipe2
>  	.long sys_inotify_init1
> +	.long sys_setrlimit64
> +	.long sys_getrlimit64

This only adds the calls to the native 32 bit build, but not to
the 32-on-64 compat code in arch/x86/ia32/ia32entry.S (or any of the
other architectures.

> --- linux-2.6.29-rc2/kernel/ChangeLog	1970-01-01 05:30:00.000000000 +0530
> +++ linux-2.6.29-rc2-rlim64/kernel/ChangeLog	2009-01-17 19:15:50.000000000 +0530
> @@ -0,0 +1,10 @@
> +2008-01-17  Narendra Prasad <narendramind@gmail.com>
> +    Problem Description:
> +        The following issue affects the setrlimit() and getrlimit() system calls on Linux 2.6.13 (and earlier) on x86.
> +        The Problem is filed at kernel.org bug 5042 (http://bugzilla.kernel.org/show_bug.cgi?id=5042)
> +    Design Approach:
> +        Add two system calls sys_setrlimit64()/sys_getrlimit64().
> +        And a type 'struct rlimit64' to accomodate more no. of limits <= 2^64-1
> +    Implementation Details:
> +        Inclusions: struct rlimit64, struct rlimit64
> +        rlim64[RLIM64_NRLIMITS] to task_struct

The changelog is the git history, please don't add other files for this.

> +SYSCALL_DEFINE2(setrlimit64, unsigned int, resource,
> +				struct rlimit64 __user *, rlim)
> +{
> +	struct rlimit64  new_rlim;
> +	struct rlimit    *old_rlim, new_value;
> +	unsigned long    it_prof_secs;
> +	int              retval;
> +
> +	if (resource >= RLIM_NLIMITS)
> +		return -EINVAL;
> +	if (copy_from_user(&new_rlim, rlim, sizeof(*rlim)))
> +		return -EFAULT;
> +
> +	if (resource == RLIMIT_FSIZE) {
> +		struct rlimit64  *old_rlim;
> +		struct rlimit    *old_value;
> +
> +		old_rlim = current->signal->rlim64 + resource;
> +		if (((new_rlim.rlim64_cur > old_rlim->rlim64_max) ||
> +			(new_rlim.rlim64_max > old_rlim->rlim64_max)) &&
> +			!capable(CAP_SYS_RESOURCE))
> +			return -EPERM;
> +		*old_rlim = new_rlim;
> +		if (new_rlim.rlim64_cur > RLIM_INFINITY)
> +			new_rlim.rlim64_cur = RLIM_INFINITY;
> +		if (new_rlim.rlim64_max > RLIM_INFINITY)
> +			new_rlim.rlim64_max = RLIM_INFINITY;
> +
> +		task_lock(current->group_leader);
> +		old_value = (current->signal->rlim + resource);
> +		old_value->rlim_max = new_rlim.rlim64_max;
> +		old_value->rlim_cur = new_rlim.rlim64_cur;
> +		task_unlock(current->group_leader);
> +
> +		return 0;
> +	}
> +
> +	old_rlim = current->signal->rlim + resource;
> +	if (new_rlim.rlim64_cur > RLIM_INFINITY)
> +		new_rlim.rlim64_cur = RLIM_INFINITY;
> +	if (new_rlim.rlim64_max > RLIM_INFINITY)
> +		new_rlim.rlim64_max = RLIM_INFINITY;
> +	if (((new_rlim.rlim64_cur > old_rlim->rlim_max) ||
> +		(new_rlim.rlim64_max > old_rlim->rlim_max)) &&
> +		!capable(CAP_SYS_RESOURCE))
> +		return -EPERM;
> +	if (resource == RLIMIT_NOFILE) {
> +		if (new_rlim.rlim64_cur > INR_OPEN ||
> +			new_rlim.rlim64_max > INR_OPEN)
> +			return -EPERM;
> +	}
> +	new_value.rlim_max = new_rlim.rlim64_max;
> +	new_value.rlim_cur = new_rlim.rlim64_cur;
> +	retval = security_task_setrlimit(resource, &new_value);
> +	if (retval)
> +		return retval;
> +
> +	if (resource == RLIMIT_CPU && new_value.rlim_cur == 0) {
> +		/*
> +		 * The caller is asking for an immediate RLIMIT_CPU
> +		 * expiry.  But we use the zero value to mean "it was
> +		 * never set".  So let's cheat and make it one second
> +		 * instead
> +		 */
> +		new_value.rlim_cur = 1;
> +	}
> +
> +	task_lock(current->group_leader);
> +	*old_rlim = new_value;
> +	task_unlock(current->group_leader);
> +
> +	if (resource != RLIMIT_CPU)
> +		goto out;
> +
> +	/*
> +	 * RLIMIT_CPU handling.   Note that the kernel fails to return an error
> +	 * code if it rejected the user's attempt to set RLIMIT_CPU.  This is a
> +	 * very long-standing error, and fixing it now risks breakage of
> +	 * applications, so we live with it
> +	 */
> +	if (new_value.rlim_cur == RLIM_INFINITY)
> +		goto out;
> +
> +	it_prof_secs = cputime_to_secs(current->signal->it_prof_expires);
> +	if (it_prof_secs == 0 || new_value.rlim_cur <= it_prof_secs) {
> +		unsigned long  rlim_cur = new_value.rlim_cur;
> +		cputime_t      cputime;
> +
> +		cputime = secs_to_cputime(rlim_cur);
> +		read_lock(&tasklist_lock);
> +		spin_lock_irq(&current->sighand->siglock);
> +		set_process_cpu_timer(current, CPUCLOCK_PROF, &cputime, NULL);
> +		spin_unlock_irq(&current->sighand->siglock);
> +		read_unlock(&tasklist_lock);
> +	}
> +out:
> +	return 0;
> +}

This function is rather long, and duplicates most of the existing
set_rlimit syscall. You should consolidate the two so you get no
duplication. You can probably add a
static do_setrlimit(unsigned int resource, struct rlimit64 *rlim);
helper function that gets called by both setrlimit and setrlimit64
(also compat_sys_setrlimit) after the copy_from_user().

	Arnd <><

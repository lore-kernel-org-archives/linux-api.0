From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH v5] Added PR_SET_PROCTITLE_AREA option for prctl()
Date: Mon, 9 Nov 2009 14:47:17 -0800
Message-ID: <20091109144717.0cd17421.akpm@linux-foundation.org>
References: <20091103094703.GB11134@hack.redhat.com>
	<20091103230548.0B45.A69D9226@jp.fujitsu.com>
	<20091104002544.0B4A.A69D9226@jp.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1755268AbZKIWsE@vger.kernel.org>
In-Reply-To: <20091104002544.0B4A.A69D9226@jp.fujitsu.com>
Sender: linux-kernel-owner@vger.kernel.org
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Americo Wang <xiyou.wangcong@gmail.com>, Timo Sirainen <tss@iki.fi>, Bryan Donlan <bdonlan@gmail.com>, Ulrich Drepper <drepper@redhat.com>, LKML <linux-kernel@vger.kernel.org>, linux-api@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On Wed, 4 Nov 2009 00:26:44 +0900 (JST)
KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com> wrote:
> ========================================
> 
> Subject: [PATCH v5] Added PR_SET_PROCTITLE_AREA option for prctl()
> From: Timo Sirainen <tss@iki.fi>
> 
> Currently glibc2 doesn't have setproctitle(3), so several userland
> daemons attempt to emulate it by doing some brutal stack modifications.
> This works most of the time, but it has problems. For example:
> 
>  % ps -ef |grep avahi-daemon
>  avahi     1679     1  0 09:20 ?        00:00:00 avahi-daemon: running [kosadesk.local]
> 
>  # cat /proc/1679/cmdline
>  avahi-daemon: running [kosadesk.local]
> 
> This looks good, but the process has also overwritten its environment
> area and made the environ file useless:
> 
>  # cat /proc/1679/environ
>  adesk.local]
> 
> Another problem is that the process title length is limited by the size of
> the environment. Security conscious people try to avoid potential information
> leaks by clearing most of the environment before running a daemon:
> 
>  # env - MINIMUM_NEEDED_VAR=foo /path/to/daemon
> 
> The resulting environment size may be too small to fit the wanted process
> titles.
> 
> This patch makes it possible for userspace to implement setproctitle()
> cleanly. It adds a new PR_SET_PROCTITLE_AREA option for prctl(), which
> updates task's mm_struct->arg_start and arg_end to the given area.
> 
>  test_setproctitle.c
>  ================================================
>  #include <string.h>
>  #include <stdlib.h>
>  #include <unistd.h>
>  #include <stdio.h>
>  #include <sys/prctl.h>
> 
>  #define ERR(str) (perror(str), exit(1))
> 
>  void settitle(char* title){
>          int err;
> 
>          err = prctl(34, title, strlen(title)+1);
>          if (err < 0)
>                  ERR("prctl ");
>  }
> 
>  void main(void){
>          long i;
>          char buf[1024];
> 
>          for (i = 0; i < 10000000000LL; i++){
>                  sprintf(buf, "loooooooooooooooooooooooong string %d",i);
>                  settitle(buf);
>          }
>  }

What happens if userspace unmaps the memory after telling the kernel to
use it?

Will processes which try to read the command line get an error reading
/proc?  If so, do all the commandline-reading programs in the world
handle this in an appropriate fashion?


> diff --git a/fs/proc/base.c b/fs/proc/base.c
> index 837469a..ac800b4 100644
> --- a/fs/proc/base.c
> +++ b/fs/proc/base.c
> @@ -255,32 +255,45 @@ static int proc_pid_cmdline(struct task_struct *task, char * buffer)
>  	int res = 0;
>  	unsigned int len;
>  	struct mm_struct *mm = get_task_mm(task);
> +
>  	if (!mm)
>  		goto out;
> +
> +	/* The process was not constructed yet? */
>  	if (!mm->arg_end)
>  		goto out_mm;	/* Shh! No looking before we're done */
>  
> - 	len = mm->arg_end - mm->arg_start;
> - 
> +	mutex_lock(&mm->arg_lock);
> +	len = mm->arg_end - mm->arg_start;
>  	if (len > PAGE_SIZE)
>  		len = PAGE_SIZE;
> - 
> +
>  	res = access_process_vm(task, mm->arg_start, buffer, len, 0);
> +	if (mm->arg_end != mm->env_start)
> +		/* prctl(PR_SET_PROCTITLE_AREA) used */
> +		goto out_unlock;
>  
> -	// If the nul at the end of args has been overwritten, then
> -	// assume application is using setproctitle(3).
> +	/*
> +	 * If the nul at the end of args has been overwritten, then assume
> +	 * application is using sendmail's SPT_REUSEARGV style argv override.
> +	 */
>  	if (res > 0 && buffer[res-1] != '\0' && len < PAGE_SIZE) {
>  		len = strnlen(buffer, res);
> -		if (len < res) {
> -		    res = len;
> -		} else {
> +		if (len < res)
> +			res = len;
> +		else {
>  			len = mm->env_end - mm->env_start;
>  			if (len > PAGE_SIZE - res)
>  				len = PAGE_SIZE - res;
> -			res += access_process_vm(task, mm->env_start, buffer+res, len, 0);
> +			res += access_process_vm(task, mm->env_start,
> +						 buffer+res, len, 0);
>  			res = strnlen(buffer, res);
>  		}
>  	}
> +
> +out_unlock:
> +	mutex_unlock(&mm->arg_lock);
> +
>  out_mm:
>  	mmput(mm);
>  out:
> diff --git a/include/linux/mm_types.h b/include/linux/mm_types.h
> index 84a524a..3e2a346 100644
> --- a/include/linux/mm_types.h
> +++ b/include/linux/mm_types.h
> @@ -12,6 +12,7 @@
>  #include <linux/completion.h>
>  #include <linux/cpumask.h>
>  #include <linux/page-debug-flags.h>
> +#include <linux/mutex.h>
>  #include <asm/page.h>
>  #include <asm/mmu.h>
>  
> @@ -236,6 +237,7 @@ struct mm_struct {
>  	unsigned long stack_vm, reserved_vm, def_flags, nr_ptes;
>  	unsigned long start_code, end_code, start_data, end_data;
>  	unsigned long start_brk, brk, start_stack;
> +	struct mutex arg_lock;
>  	unsigned long arg_start, arg_end, env_start, env_end;
>  
>  	unsigned long saved_auxv[AT_VECTOR_SIZE]; /* for /proc/PID/auxv */

Please document the role of arg_lock with a code comment here.

> diff --git a/include/linux/prctl.h b/include/linux/prctl.h
> index 9311505..da47542 100644
> --- a/include/linux/prctl.h
> +++ b/include/linux/prctl.h
> @@ -90,4 +90,7 @@
>  
>  #define PR_MCE_KILL	33
>  
> +/* Set process title memory area for setproctitle() */
> +#define PR_SET_PROCTITLE_AREA 34
> +
>  #endif /* _LINUX_PRCTL_H */
> diff --git a/kernel/fork.c b/kernel/fork.c
> index 4c20fff..881a6b4 100644
> --- a/kernel/fork.c
> +++ b/kernel/fork.c
> @@ -459,6 +459,7 @@ static struct mm_struct * mm_init(struct mm_struct * mm, struct task_struct *p)
>  	mm->cached_hole_size = ~0UL;
>  	mm_init_aio(mm);
>  	mm_init_owner(mm, p);
> +	mutex_init(&mm->arg_lock);
>  
>  	if (likely(!mm_alloc_pgd(mm))) {
>  		mm->def_flags = 0;
> diff --git a/kernel/sys.c b/kernel/sys.c
> index 255475d..bde6957 100644
> --- a/kernel/sys.c
> +++ b/kernel/sys.c
> @@ -1564,6 +1564,28 @@ SYSCALL_DEFINE5(prctl, int, option, unsigned long, arg2, unsigned long, arg3,
>  			error = 0;
>  			break;
>  
> +		case PR_SET_PROCTITLE_AREA: {
> +			struct mm_struct *mm = current->mm;
> +			unsigned long addr = arg2;
> +			unsigned long len = arg3;
> +			unsigned long end = arg2 + arg3;
> +
> +			if (len > PAGE_SIZE)
> +				return -EINVAL;
> +
> +			if (addr >= end)
> +				return -EINVAL;
> +
> +			if (!access_ok(VERIFY_READ, addr, len))
> +				return -EFAULT;

It's unobvious (to me) why this access_ok() check is here.  If that
wasn't totally dumb of me, please add a comment so the next reader
won't be similarly mystified.


> +			mutex_lock(&mm->arg_lock);
> +			mm->arg_start = addr;
> +			mm->arg_end = end;
> +			mutex_unlock(&mm->arg_lock);
> +
> +			return 0;
> +		}
>  		default:
>  			error = -EINVAL;
>  			break;

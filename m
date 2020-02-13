From: Alexander Duyck <alexander.h.duyck-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Subject: Re: [PATCH v4 7/8] pid: export pidfd_get_pid
Date: Wed, 12 Feb 2020 16:25:31 -0800
Message-ID: <6bb20b3d4e3362337e1a4c8a4be13f6acda5b0ec.camel@linux.intel.com>
References: <20200212233946.246210-1-minchan@kernel.org>
         <20200212233946.246210-8-minchan@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20200212233946.246210-8-minchan-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Minchan Kim <minchan-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-mm <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, oleksandr-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, Suren Baghdasaryan <surenb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Tim Murray <timmurray-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Daniel Colascione <dancol-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Sandeep Patil <sspatil-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Sonny Rao <sonnyrao-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Brian Geffon <bgeffon-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, John Dias <joaodias-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Joel Fernandes <joel-QYYGw3jwrUn5owFQY34kdNi2O/JbrIOy@public.gmane.org>, Christian Brauner <christian-STijNZzMWpgWenYVfaLwtA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Wed, 2020-02-12 at 15:39 -0800, Minchan Kim wrote:
> process_madvise syscall needs pidfd_get_pid function to translate
> pidfd to pid so this patch exports the function.
> 
> Cc: Christian Brauner <christian-STijNZzMWpgWenYVfaLwtA@public.gmane.org>
> Signed-off-by: Minchan Kim <minchan-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>

I think you might have misunderstood my earlier comments. This should be
patch 2 in your set. What is patch 8 should be folded into you existing
patch 2 and become patch 3 with the rest of your patches shifted by 1
since you are reordering them.

Otherwise the code itself appears to not have changed anything so it looks
fine to me.

Reviewed-by: Alexander Duyck <alexander.h.duyck-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>

> ---
>  include/linux/pid.h |  1 +
>  kernel/exit.c       | 17 -----------------
>  kernel/pid.c        | 17 +++++++++++++++++
>  3 files changed, 18 insertions(+), 17 deletions(-)
> 
> diff --git a/include/linux/pid.h b/include/linux/pid.h
> index 998ae7d24450..023d9c3a8edc 100644
> --- a/include/linux/pid.h
> +++ b/include/linux/pid.h
> @@ -75,6 +75,7 @@ extern const struct file_operations pidfd_fops;
>  struct file;
>  
>  extern struct pid *pidfd_pid(const struct file *file);
> +extern struct pid *pidfd_get_pid(unsigned int fd);
>  
>  static inline struct pid *get_pid(struct pid *pid)
>  {
> diff --git a/kernel/exit.c b/kernel/exit.c
> index 0b81b26a872a..43375f9d8bbc 100644
> --- a/kernel/exit.c
> +++ b/kernel/exit.c
> @@ -1470,23 +1470,6 @@ static long do_wait(struct wait_opts *wo)
>  	return retval;
>  }
>  
> -static struct pid *pidfd_get_pid(unsigned int fd)
> -{
> -	struct fd f;
> -	struct pid *pid;
> -
> -	f = fdget(fd);
> -	if (!f.file)
> -		return ERR_PTR(-EBADF);
> -
> -	pid = pidfd_pid(f.file);
> -	if (!IS_ERR(pid))
> -		get_pid(pid);
> -
> -	fdput(f);
> -	return pid;
> -}
> -
>  static long kernel_waitid(int which, pid_t upid, struct waitid_info *infop,
>  			  int options, struct rusage *ru)
>  {
> diff --git a/kernel/pid.c b/kernel/pid.c
> index 0f4ecb57214c..360ba480a2a9 100644
> --- a/kernel/pid.c
> +++ b/kernel/pid.c
> @@ -496,6 +496,23 @@ struct pid *find_ge_pid(int nr, struct pid_namespace *ns)
>  	return idr_get_next(&ns->idr, &nr);
>  }
>  
> +struct pid *pidfd_get_pid(unsigned int fd)
> +{
> +	struct fd f;
> +	struct pid *pid;
> +
> +	f = fdget(fd);
> +	if (!f.file)
> +		return ERR_PTR(-EBADF);
> +
> +	pid = pidfd_pid(f.file);
> +	if (!IS_ERR(pid))
> +		get_pid(pid);
> +
> +	fdput(f);
> +	return pid;
> +}
> +
>  /**
>   * pidfd_create() - Create a new pid file descriptor.
>   *

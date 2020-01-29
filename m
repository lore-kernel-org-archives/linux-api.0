From: Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny-IBi9RG/b67k@public.gmane.org>
Subject: Re: [PATCH v5 3/6] cgroup: refactor fork helpers
Date: Wed, 29 Jan 2020 14:26:08 +0100
Message-ID: <20200129132608.GC11384@blackbody.suse.cz>
References: <20200121154844.411-1-christian.brauner@ubuntu.com>
 <20200121154844.411-4-christian.brauner@ubuntu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20200121154844.411-4-christian.brauner-GeWIH/nMZzLQT0dZR+AlfA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Christian Brauner <christian.brauner-GeWIH/nMZzLQT0dZR+AlfA@public.gmane.org>
Cc: linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Oleg Nesterov <oleg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

On Tue, Jan 21, 2020 at 04:48:41PM +0100, Christian Brauner <christian.brauner-GeWIH/nMZzLQT0dZR+AlfA@public.gmane.org> wrote:
> diff --git a/kernel/cgroup/cgroup.c b/kernel/cgroup/cgroup.c
> index 9b3241d67592..ce2d5b8aa19f 100644
> --- a/kernel/cgroup/cgroup.c
> +++ b/kernel/cgroup/cgroup.c
> @@ -5895,17 +5895,21 @@ static struct cgroup *cgroup_get_from_file(struct file *f)
>  
>  /**
>   * cgroup_can_fork - called on a new task before the process is exposed
> - * @child: the task in question.
> + * @child: the child process
> + * @kargs: the arguments passed to create the child process
This comment should only come with the later commmits.

> - * cgroup_cancel_fork - called if a fork failed after cgroup_can_fork()
> - * @child: the task in question
> - *
> - * This calls the cancel_fork() callbacks if a fork failed *after*
> - * cgroup_can_fork() succeded.
> - */
> +  * cgroup_cancel_fork - called if a fork failed after cgroup_can_fork()
> +  * @child: the child process
> +  * @kargs: the arguments passed to create the child process
Ditto

> - * cgroup_post_fork - called on a new task after adding it to the task list
> - * @child: the task in question
> - *
> - * Adds the task to the list running through its css_set if necessary and
> - * call the subsystem fork() callbacks.  Has to be after the task is
> - * visible on the task list in case we race with the first call to
> - * cgroup_task_iter_start() - to guarantee that the new task ends up on its
> - * list.
> + * cgroup_post_fork - finalize cgroup setup for the child process
> + * @child: the child process
> + * @kargs: the arguments passed to create the child process
One more.

Besides the misrebased comments
Acked-by: Michal Koutný <mkoutny-IBi9RG/b67k@public.gmane.org>

From: Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>
Subject: Re: [PATCHv2 5/7] cgroup: introduce cgroup namespaces
Date: Fri, 31 Oct 2014 17:02:41 -0700
Message-ID: <CALCETrWzYPngmWPMWnSFyiTPDwNJYPpXUj1C-294uQgjvp9wcA@mail.gmail.com>
References: <1414783141-6947-1-git-send-email-adityakali@google.com>
	<1414783141-6947-6-git-send-email-adityakali@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <containers-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
In-Reply-To: <1414783141-6947-6-git-send-email-adityakali-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
List-Unsubscribe: <https://lists.linuxfoundation.org/mailman/options/containers>,
	<mailto:containers-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.linuxfoundation.org/pipermail/containers/>
List-Post: <mailto:containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
List-Help: <mailto:containers-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=help>
List-Subscribe: <https://lists.linuxfoundation.org/mailman/listinfo/containers>,
	<mailto:containers-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=subscribe>
Sender: containers-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org
Errors-To: containers-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org
To: Aditya Kali <adityakali-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux Containers <containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>, Serge Hallyn <serge.hallyn-GeWIH/nMZzLQT0dZR+AlfA@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "Eric W. Biederman" <ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Fri, Oct 31, 2014 at 12:18 PM, Aditya Kali <adityakali-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org> wrote:
> Introduce the ability to create new cgroup namespace. The newly created
> cgroup namespace remembers the cgroup of the process at the point
> of creation of the cgroup namespace (referred as cgroupns-root).
> The main purpose of cgroup namespace is to virtualize the contents
> of /proc/self/cgroup file. Processes inside a cgroup namespace
> are only able to see paths relative to their namespace root
> (unless they are moved outside of their cgroupns-root, at which point
>  they will see a relative path from their cgroupns-root).
> For a correctly setup container this enables container-tools
> (like libcontainer, lxc, lmctfy, etc.) to create completely virtualized
> containers without leaking system level cgroup hierarchy to the task.
> This patch only implements the 'unshare' part of the cgroupns.
>

> +       /* Prevent cgroup changes for this task. */
> +       threadgroup_lock(current);

This could just be me being dense, but what is the lock for?

> +
> +       /* CGROUPNS only virtualizes the cgroup path on the unified hierarchy.
> +        */
> +       cgrp = get_task_cgroup(current);
> +
> +       err = -ENOMEM;
> +       new_ns = alloc_cgroup_ns();
> +       if (!new_ns)
> +               goto err_out_unlock;
> +
> +       err = proc_alloc_inum(&new_ns->proc_inum);
> +       if (err)
> +               goto err_out_unlock;
> +
> +       new_ns->user_ns = get_user_ns(user_ns);
> +       new_ns->root_cgrp = cgrp;
> +
> +       threadgroup_unlock(current);
> +
> +       return new_ns;
> +
> +err_out_unlock:
> +       threadgroup_unlock(current);
> +err_out:
> +       if (cgrp)
> +               cgroup_put(cgrp);
> +       kfree(new_ns);
> +       return ERR_PTR(err);
> +}
> +
> +static int cgroupns_install(struct nsproxy *nsproxy, void *ns)
> +{
> +       pr_info("setns not supported for cgroup namespace");
> +       return -EINVAL;
> +}
> +
> +static void *cgroupns_get(struct task_struct *task)
> +{
> +       struct cgroup_namespace *ns = NULL;
> +       struct nsproxy *nsproxy;
> +
> +       rcu_read_lock();
> +       nsproxy = task->nsproxy;
> +       if (nsproxy) {
> +               ns = nsproxy->cgroup_ns;
> +               get_cgroup_ns(ns);
> +       }
> +       rcu_read_unlock();

How is this correct?  Other namespaces do it too, so it Must Be
Correct (tm), but I don't understand.  What is RCU protecting?

--Andy

From: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Subject: Re: [PATCH RESEND 2/2] pidns: Expose task pid_ns_for_children to
 userspace
Date: Thu, 30 Mar 2017 15:05:20 -0700
Message-ID: <20170330150520.1bdf20e599ff464bda0776b9@linux-foundation.org>
References: <149086931397.4388.9604947335273204415.stgit@localhost.localdomain>
        <149086967937.4388.471494976517194744.stgit@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <149086967937.4388.471494976517194744.stgit-bi+AKbBUZKY6gyzm1THtWbp2dZbC/Bob@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Kirill Tkhai <ktkhai-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org>
Cc: agruenba-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org, oleg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, paul-r2n+y4ga6xFZroRs9YW3xA@public.gmane.org, ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org, avagin-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org, mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, serge-A9i7LUbDfNHQT0dZR+AlfA@public.gmane.org
List-Id: linux-api@vger.kernel.org

On Thu, 30 Mar 2017 13:27:59 +0300 Kirill Tkhai <ktkhai-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org> wrote:

> pid_ns_for_children set by a task is known only to the task itself,
> and it's impossible to identify it from outside.
> 
> It's a big problem for checkpoint/restore software like CRIU,
> because it can't correctly handle tasks, that do setns(CLONE_NEWPID)
> in proccess of their work.
> 
> This patch solves the problem, and it exposes pid_ns_for_children
> to ns directory in standard way with the name "pid_for_children":
> 
> ~# ls /proc/5531/ns -l | grep pid
> lrwxrwxrwx 1 root root 0 Jan 14 16:38 pid -> pid:[4026531836]
> lrwxrwxrwx 1 root root 0 Jan 14 16:38 pid_for_children -> pid:[4026532286]
> 
> --- a/fs/proc/namespaces.c
> +++ b/fs/proc/namespaces.c
> @@ -23,6 +23,7 @@ static const struct proc_ns_operations *ns_entries[] = {
>  #endif
>  #ifdef CONFIG_PID_NS
>  	&pidns_operations,
> +	&pidns_for_children_operations,
>  #endif

This interface should be documented somewhere under Documentation/. 
But I can't immediately find where the /proc/pid/ns/ pseudo-files are
documented...

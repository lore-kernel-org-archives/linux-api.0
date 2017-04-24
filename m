From: Cyrill Gorcunov <gorcunov-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 2/2] pid_ns: Introduce ioctl to set vector of
 ns_last_pid's on ns hierarhy
Date: Mon, 24 Apr 2017 22:03:18 +0300
Message-ID: <CAM5jBj4ik-deECPc-G+b6JHHszvQEFA5N9uYCUS-fex5xrT1gA@mail.gmail.com>
References: <149245014695.17600.12640895883798122726.stgit@localhost.localdomain>
 <149245057248.17600.1341652606136269734.stgit@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <149245057248.17600.1341652606136269734.stgit-bi+AKbBUZKY6gyzm1THtWbp2dZbC/Bob@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Kirill Tkhai <ktkhai-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org>
Cc: "Serge E. Hallyn" <serge-A9i7LUbDfNHQT0dZR+AlfA@public.gmane.org>, "Eric W. Biederman" <ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org>, agruenba-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Oleg Nesterov <oleg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Linux kernel mailing list <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, paul-r2n+y4ga6xFZroRs9YW3xA@public.gmane.org, Al Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, Andrew Vagin <avagin-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>, Linux FS Devel <linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Michael Kerrisk <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>, Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Mon, Apr 17, 2017 at 8:36 PM, Kirill Tkhai <ktkhai-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org> wrote:
> On implementing of nested pid namespaces support in CRIU
> (checkpoint-restore in userspace tool) we run into
> the situation, that it's impossible to create a task with
> specific NSpid effectively. After commit 49f4d8b93ccf
> "pidns: Capture the user namespace and filter ns_last_pid"
> it is impossible to set ns_last_pid on any pid namespace,
> except task's active pid_ns (before the commit it was possible
> to write to pid_ns_for_children). Thus, if a restored task
> in a container has more than one pid_ns levels, the restorer
> code must have a task helper for every pid namespace
> of the task's pid_ns hierarhy.
>
> This is a big problem, because of communication with
> a helper for every pid_ns in the hierarchy is not cheap
> and not performance-good as it implies many helpers wakeups
> to create a single task (independently, how you communicate
> with the helpers). This patch tries to decide the problem.
>
> It introduces a new pid_ns ns_ioctl(PIDNS_REQ_SET_LAST_PID_VEC),
> which allows to write a vector of last pids on pid_ns hierarchy.
> The vector is passed as a ":"-delimited string with pids,
> written in reverse order. The first number corresponds to
> the opened namespace ns_last_pid, the second is to its parent, etc.
> So, if you have the pid namespaces hierarchy like:
>
> pid_ns1 (grand father)
>   |
>   v
> pid_ns2 (father)
>   |
>   v
> pid_ns3 (child)
>
> and the ns of task's of pid_ns3 is open, then the corresponding
> vector will be "last_ns_pid3:last_ns_pid2:last_ns_pid1". This
> vector may be short and it may contain less levels, for example,
> "last_ns_pid3:last_ns_pid2" or even "last_ns_pid3", in dependence
> of which levels you want to populate.
>
> To write in a pid_ns's ns_last_pid we check that the writer task
> has CAP_SYS_ADMIN permittions in this pid_ns's user_ns.
>
> One note about struct pidns_ioc_req. It's made extensible and
> may expanded in the future. The always existing fields present
> at the moment, the future fields and they sizes may be determined
> by pidns_ioc_req::req by the future code.
>
> Signed-off-by: Kirill Tkhai <ktkhai-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org>
Reviewed-by: Cyrill Gorcunov <gorcunov-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>

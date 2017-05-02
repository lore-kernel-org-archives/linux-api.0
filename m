From: ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org (Eric W. Biederman)
Subject: Re: [PATCH 2/2] pid_ns: Introduce ioctl to set vector of ns_last_pid's on ns hierarhy
Date: Tue, 02 May 2017 12:22:39 -0500
Message-ID: <87inljjhr4.fsf@xmission.com>
References: <149245014695.17600.12640895883798122726.stgit@localhost.localdomain>
        <149245057248.17600.1341652606136269734.stgit@localhost.localdomain>
        <20170426155352.GA12131@redhat.com>
        <785e1986-da03-72aa-06c0-234ed2dbc0fd@virtuozzo.com>
        <20170427161255.GA19350@redhat.com>
        <fdd61d9c-6f88-1669-4d12-31748395fe99@virtuozzo.com>
        <20170427162254.GB19579@redhat.com>
        <43249645-f621-511e-dfa8-7bd78c547d2c@virtuozzo.com>
        <20170502163324.GA25036@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170502163324.GA25036-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> (Oleg Nesterov's message of
        "Tue, 2 May 2017 18:33:25 +0200")
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Oleg Nesterov <oleg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Kirill Tkhai <ktkhai-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org>, serge-A9i7LUbDfNHQT0dZR+AlfA@public.gmane.org, agruenba-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, paul-r2n+y4ga6xFZroRs9YW3xA@public.gmane.org, viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org, avagin-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org, gorcunov-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org, mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org
List-Id: linux-api@vger.kernel.org

Oleg Nesterov <oleg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> writes:

> sorry for delay, vacation...
>
> On 04/28, Kirill Tkhai wrote:
>>
>> On 27.04.2017 19:22, Oleg Nesterov wrote:
>> >
>> > Ah, OK, I didn't notice the ns->child_reaper check in pidns_for_children_get().
>> >
>> > But note that it doesn't need tasklist_lock too.
>>
>> Hm, are there possible strange situations with memory ordering, when we see
>> ns->child_reaper of already died ns, which was placed in the same memory?
>> Do we have to use some memory barriers here?
>
> Could you spell please? I don't understand your concerns...
>
> I don't see how, say,
>
> 	static struct ns_common *pidns_for_children_get(struct task_struct *task)
> 	{
> 		struct ns_common *ns = NULL;
> 		struct pid_namespace *pid_ns;
>
> 		task_lock(task);
> 		if (task->nsproxy) {
> 			pid_ns = task->nsproxy->pid_ns_for_children;
> 			if (pid_ns->child_reaper) {
> 				ns = &pid_ns->ns;
> 				get_pid_ns(ns);
> 			}
> 		}
> 		task_unlock(task);
>
> 		return ns;
> 	}
>
> can be wrong. It also looks more clean to me.
>
> ->child_reaper is not stable without tasklist, it can be dead/etc, but
> we do not care?

It breaks a number of assumptions if you can join a pid namespace before
an init process is created in that pid namespace.  Checking for
child_reaper is a bit heavy handed but appears to ensure all of the
assumptions of initial pid namespace creation have been met.

Which means your simplified pidns_for_children_get is a bit insufficient.

Eric

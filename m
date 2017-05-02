From: Oleg Nesterov <oleg@redhat.com>
Subject: Re: [PATCH 2/2] pid_ns: Introduce ioctl to set vector of
        ns_last_pid's on ns hierarhy
Date: Tue, 2 May 2017 18:33:25 +0200
Message-ID: <20170502163324.GA25036@redhat.com>
References: <149245014695.17600.12640895883798122726.stgit@localhost.localdomain> <149245057248.17600.1341652606136269734.stgit@localhost.localdomain> <20170426155352.GA12131@redhat.com> <785e1986-da03-72aa-06c0-234ed2dbc0fd@virtuozzo.com> <20170427161255.GA19350@redhat.com> <fdd61d9c-6f88-1669-4d12-31748395fe99@virtuozzo.com> <20170427162254.GB19579@redhat.com> <43249645-f621-511e-dfa8-7bd78c547d2c@virtuozzo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <43249645-f621-511e-dfa8-7bd78c547d2c@virtuozzo.com>
Sender: linux-fsdevel-owner@vger.kernel.org
To: Kirill Tkhai <ktkhai@virtuozzo.com>
Cc: serge@hallyn.com, ebiederm@xmission.com, agruenba@redhat.com, linux-api@vger.kernel.org, linux-kernel@vger.kernel.org, paul@paul-moore.com, viro@zeniv.linux.org.uk, avagin@openvz.org, linux-fsdevel@vger.kernel.org, mtk.manpages@gmail.com, akpm@linux-foundation.org, luto@amacapital.net, gorcunov@openvz.org, mingo@kernel.org, keescook@chromium.org
List-Id: linux-api@vger.kernel.org

sorry for delay, vacation...

On 04/28, Kirill Tkhai wrote:
>
> On 27.04.2017 19:22, Oleg Nesterov wrote:
> >
> > Ah, OK, I didn't notice the ns->child_reaper check in pidns_for_children_get().
> >
> > But note that it doesn't need tasklist_lock too.
>
> Hm, are there possible strange situations with memory ordering, when we see
> ns->child_reaper of already died ns, which was placed in the same memory?
> Do we have to use some memory barriers here?

Could you spell please? I don't understand your concerns...

I don't see how, say,

	static struct ns_common *pidns_for_children_get(struct task_struct *task)
	{
		struct ns_common *ns = NULL;
		struct pid_namespace *pid_ns;

		task_lock(task);
		if (task->nsproxy) {
			pid_ns = task->nsproxy->pid_ns_for_children;
			if (pid_ns->child_reaper) {
				ns = &pid_ns->ns;
				get_pid_ns(ns);
			}
		}
		task_unlock(task);

		return ns;
	}

can be wrong. It also looks more clean to me.

->child_reaper is not stable without tasklist, it can be dead/etc, but
we do not care?

Oleg.

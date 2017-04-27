From: Oleg Nesterov <oleg@redhat.com>
Subject: Re: [PATCH 2/2] pid_ns: Introduce ioctl to set vector of
 ns_last_pid's on ns hierarhy
Date: Thu, 27 Apr 2017 18:16:59 +0200
Message-ID: <20170427161659.GA19579@redhat.com>
References: <149245014695.17600.12640895883798122726.stgit@localhost.localdomain>
 <149245057248.17600.1341652606136269734.stgit@localhost.localdomain>
 <20170426155352.GA12131@redhat.com>
 <785e1986-da03-72aa-06c0-234ed2dbc0fd@virtuozzo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <785e1986-da03-72aa-06c0-234ed2dbc0fd@virtuozzo.com>
Sender: linux-fsdevel-owner@vger.kernel.org
To: Kirill Tkhai <ktkhai@virtuozzo.com>
Cc: serge@hallyn.com, ebiederm@xmission.com, agruenba@redhat.com, linux-api@vger.kernel.org, linux-kernel@vger.kernel.org, paul@paul-moore.com, viro@zeniv.linux.org.uk, avagin@openvz.org, linux-fsdevel@vger.kernel.org, mtk.manpages@gmail.com, akpm@linux-foundation.org, luto@amacapital.net, gorcunov@openvz.org, mingo@kernel.org, keescook@chromium.org
List-Id: linux-api@vger.kernel.org

On 04/26, Kirill Tkhai wrote:
>
> On 26.04.2017 18:53, Oleg Nesterov wrote:
> >>
> >> +static long set_last_pid_vec(struct pid_namespace *pid_ns,
> >> +			     struct pidns_ioc_req *req)
> >> +{
> >> +	char *str, *p;
> >> +	int ret = 0;
> >> +	pid_t pid;
> >> +
> >> +	read_lock(&tasklist_lock);
> >> +	if (!pid_ns->child_reaper)
> >> +		ret = -EINVAL;
> >> +	read_unlock(&tasklist_lock);
> >> +	if (ret)
> >> +		return ret;
> > 
> > why do you need to check ->child_reaper under tasklist_lock? this looks pointless.
> > 
> > In fact I do not understand how it is possible to hit pid_ns->child_reaper == NULL,
> > there must be at least one task in this namespace, otherwise you can't open a file
> > which has f_op == ns_file_operations, no?
> 
> Sure, it's impossible to pick a pid_ns, if there is no the pid_ns's tasks. I added
> it under impression of
> https://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.git/commit/?id=dfda351c729733a401981e8738ce497eaffcaa00
> but here it's completely wrong. It will be removed in v2.

Hmm. But if I read this commit correctly then we really need to check
pid_ns->child_reaper != NULL ?

Currently we can't pick an "empty" pid_ns. But after the commit above a task
can do sys_unshare(CLONE_NEWPID), another (or the same) task can open its
/proc/$pid/ns/pid_for_children and call ns_ioctl() before the 1st alloc_pid() ?

Or I am totally confused?

Oleg.

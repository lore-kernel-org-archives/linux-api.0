From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH] cgroup: Add new capability to allow a process to migrate
 other tasks between cgroups
Date: Mon, 19 Dec 2016 08:11:38 -0500
Message-ID: <20161219131138.GA14837@mtj.duckdns.org>
References: <1481949827-23613-1-git-send-email-john.stultz@linaro.org>
 <5855A8EB.8000005@digikod.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <5855A8EB.8000005-WFhQfpSGs3bR7s880joybQ@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: =?iso-8859-1?Q?Micka=EBl_Sala=FCn?= <mic-WFhQfpSGs3bR7s880joybQ@public.gmane.org>
Cc: John Stultz <john.stultz-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, lkml <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Jonathan Corbet <corbet-T1hC0tSOHrs@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Android Kernel Team <kernel-team-z5hGa2qSFaRBDgjK7y7TUQ@public.gmane.org>, Rom Lemarchand <romlem-z5hGa2qSFaRBDgjK7y7TUQ@public.gmane.org>, Colin Cross <ccross-z5hGa2qSFaRBDgjK7y7TUQ@public.gmane.org>, Dmitry Shmidt <dimitrysh-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Todd Kjos <tkjos-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Christian Poetzsch <christian.potzsch-1AXoQHu6uovQT0dZR+AlfA@public.gmane.org>, Amit Pundir <amit.pundir-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Dmitry Torokhov <dmitry.torokhov-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, "Serge E . Hallyn" <serge-A9i7LUbDfNHQT0dZR+AlfA@public.gmane.org>, Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Paul Moore <paul-r2n+y4ga6xFZroRs9YW3xA@public.gmane.org>, Stephen Smalley <sds-+05T5uksL2qpZYMLLGbcSA@public.gmane.org>, Eric Paris <eparis-FjpueFixGhCM4zKIHC2jIg@public.gmane.org>, James Morris <james.>
List-Id: linux-api@vger.kernel.org

Hello,

On Sat, Dec 17, 2016 at 10:06:51PM +0100, Mickaël Salaün wrote:
> If I understand correctly, this patch is intended to add a delegation
> feature to cgroup v1, which does not really make sense for the v2

It's more about upstreaming a workaround for android somewhat like
including binder into kernel.  It isn't adding actual cgroup
delegation to v1.  It's just splitting a small piece of CAP_SYS_ADMIN
to accomodate what android has been doing.

> because of the clean cgroup-v2 delegation design. However, this new
> capability impact both versions.

In the same way but it's not about cgroup delegation.  It's just
allowing splitting up CAP_SYS_ADMIN so that "no extra restrictions on
cgroup" can be given away in a safer way.

> However, even if a cgroup does not directly involve a limitation, it may
> be used to identify a group of processes for a security critical purpose
> (e.g. kill a group of process). It can then make sense to have a
> dedicated capability CAP_CGROUP to allow a process *without the right to
> write in cgroup.procs* to be allowed to move a process out of its
> current cgroup. This is similar to CAP_DAC_OVERRIDE but only for
> cgroup/controllers files (but not necessarily sufficient to modify all
> cgroups). This does not means that CAP_CGROUP should allow to move any
> process from any cgroup. The cgroup_procs_write_permission() should
> compose the checks for CAP_CGROUP and/or CAP_SYS_RESOURCE and/or
> CAP_SYS_ADMIN depending on the current use of the cgroup (i.e. cgroup
> controller, BPF program type, netfilter).

There's no reason to invent a whole new set of security policies for
cgroup.  It already got one which follows the filesystem permissions
with some extra restrictions.  The CAP split is purely to accomodate
android and that's it.  If that isn't good enough a reason, then
android should just keep carrying the patches it needs.  This doesn't
justify bolting on another permission model on cgroup in any way.

Thanks.

-- 
tejun

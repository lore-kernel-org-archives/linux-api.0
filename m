From: Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCHSET RFC cgroup/for-4.6] cgroup, sched: implement resource
 group and PRIO_RGRP
Date: Tue, 15 Mar 2016 18:21:36 +0100
Message-ID: <20160315172136.GA6114@dhcp22.suse.cz>
References: <1457710888-31182-1-git-send-email-tj@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1457710888-31182-1-git-send-email-tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, a.p.zijlstra-/NLkJaSkS4VmR6Xm/wNWPw@public.gmane.org, mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, pjt-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kernel-team-b10kYP2dOMg@public.gmane.org
List-Id: linux-api@vger.kernel.org

On Fri 11-03-16 10:41:18, Tejun Heo wrote:
> Hello,
> 
> This patchset extends cgroup v2 to support rgroup (resource group) for
> in-process hierarchical resource control and implements PRIO_RGRP for
> setpriority(2) on top to allow in-process hierarchical CPU cycle
> control in a seamless way.
> 
> cgroup v1 allowed putting threads of a process in different cgroups
> which enabled ad-hoc in-process resource control of some resources.
> Unfortunately, this approach was fraught with problems such as
> membership ambiguity with per-process resources

[Sorry if this has been already discussed, I haven't followed all the
 discussions regarding this topic]

While I agree that per-thread granularity is no fun for controllers
which operate on different than task_struct entities (like memory cgroup
controller) but I am afraid that all the complications will not go away
if we are strictly per-process anyway.

For example memcg controller is not strictly per-process either, it
operates on the mm_struct and that might be shared between different
_processes_. So we still might end up in the same schizophrenic
situation where two different processes are living in different
cgroups while one of them is silently operating in a different memcg
cgroup. I really hate this but this is what our clone(CLONE_VM) (without
CLONE_THREAD) allows to do.

I do not know about other controllers, maybe only memcg is so special,
but that would suggest that even process-only restriction might turn out
to be a problem in the future and controllers would have to face the
same problem later on.

Now I have to admit I do not have great ideas how to cover all the
possible cases but wouldn't it make more sense to allow for more
flexibility and allow thread migration while the migration can be vetoed
by any controller should it cross into a different/incompatible cgroup.

[...]

Thanks!
-- 
Michal Hocko
SUSE Labs

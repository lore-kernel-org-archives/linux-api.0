From: Christian Brauner <christian.brauner@ubuntu.com>
Subject: Re: [PATCH v4 5/6] clone3: allow spawning processes into cgroups
Date: Mon, 20 Jan 2020 22:38:56 +0100
Message-ID: <20200120213854.32mzzo6ifh76fs5q@wittgenstein>
References: <20200117181219.14542-1-christian.brauner@ubuntu.com>
 <20200117181219.14542-6-christian.brauner@ubuntu.com>
 <20200120153930.GE30403@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20200120153930.GE30403@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Oleg Nesterov <oleg@redhat.com>
Cc: linux-api@vger.kernel.org, linux-kernel@vger.kernel.org, Tejun Heo <tj@kernel.org>, Ingo Molnar <mingo@redhat.com>, Johannes Weiner <hannes@cmpxchg.org>, Li Zefan <lizefan@huawei.com>, Peter Zijlstra <peterz@infradead.org>, cgroups@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On Mon, Jan 20, 2020 at 04:39:30PM +0100, Oleg Nesterov wrote:
> On 01/17, Christian Brauner wrote:
> >
> > +static int cgroup_css_set_fork(struct task_struct *parent,
> > +			       struct kernel_clone_args *kargs)
> ...
> > +	kargs->cset = find_css_set(cset, dst_cgrp);
> > +	if (!kargs->cset) {
> > +		ret = -ENOMEM;
> > +		goto err;
> > +	}
> > +
> > +	if (cgroup_is_dead(dst_cgrp)) {
> > +		ret = -ENODEV;
> > +		goto err;
>                 ^^^^^^^^
> 
> this looks wrong... don't we need put_css_set(kargs->cset) before "goto err" ?

Yeah, but we should rather do:

diff --git a/kernel/cgroup/cgroup.c b/kernel/cgroup/cgroup.c
index 4d36255ef25f..482055d1e64a 100644
--- a/kernel/cgroup/cgroup.c
+++ b/kernel/cgroup/cgroup.c
@@ -5994,6 +5994,8 @@ static int cgroup_css_set_fork(struct kernel_clone_args *kargs)
        if (dst_cgrp)
                cgroup_put(dst_cgrp);
        put_css_set(cset);
+       if (kargs->cset)
+               put_css_set(kargs->cset);
        return ret;
 }

Christian

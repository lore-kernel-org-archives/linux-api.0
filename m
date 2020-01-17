From: Christian Brauner <christian.brauner-GeWIH/nMZzLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v2 2/3] clone3: allow spawning processes into cgroups
Date: Fri, 17 Jan 2020 18:12:28 +0100
Message-ID: <20200117171228.evtvrny3v7zjcocd@wittgenstein>
References: <20191223061504.28716-1-christian.brauner@ubuntu.com>
 <20191223061504.28716-3-christian.brauner@ubuntu.com>
 <20200107163204.GB2677547@devbig004.ftw2.facebook.com>
 <20200108180906.l4mvtdmh7nm2z7sc@wittgenstein>
 <20200116122944.nj3e66eusxu6sb44@wittgenstein>
 <20200117165311.GH2677547@devbig004.ftw2.facebook.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20200117165311.GH2677547-LpCCV3molIbIZ9tKgghJQw2O0Ztt9esIQQ4Iyu8u01E@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Oleg Nesterov <oleg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

On Fri, Jan 17, 2020 at 08:53:11AM -0800, Tejun Heo wrote:
> Hello, Christian.
> 
> Sorry about late reply.
> 
> On Thu, Jan 16, 2020 at 01:29:44PM +0100, Christian Brauner wrote:
> > Could it be that you misread cgroup_attach_permissions()? Because it
> > does check for write permissions on the destination cgroup.procs file.
> > That's why I've added the cgroup_get_from_file() helper. :) See:
> > 
> > static int cgroup_attach_permissions(struct cgroup *src_cgrp,
> > 				     struct cgroup *dst_cgrp,
> > 				     struct super_block *sb, bool thread)
> > {
> > 	int ret = 0;
> > 
> > 	ret = cgroup_procs_write_permission(src_cgrp, dst_cgrp, sb);
> > 	if (ret)
> > 		return ret;
> 
> So, if you look at cgroup_procs_write_permission(), it's only checking
> the write perm of the common ancestor, not the destination because it
> assumes that the destination is already checked by the vfs layer, and
> we need to check both.

Ok, gimme 20 min.

Thanks!
Christian

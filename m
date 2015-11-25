From: "Serge E. Hallyn" <serge.hallyn@ubuntu.com>
Subject: Re: [PATCH 7/8] cgroup: mount cgroupns-root when inside non-init
 cgroupns
Date: Wed, 25 Nov 2015 00:01:56 -0600
Message-ID: <20151125060156.GA678@mail.hallyn.com>
References: <1447703505-29672-1-git-send-email-serge@hallyn.com>
 <1447703505-29672-8-git-send-email-serge@hallyn.com>
 <20151124171610.GS17033@mtj.duckdns.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20151124171610.GS17033@mtj.duckdns.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Tejun Heo <tj@kernel.org>
Cc: serge@hallyn.com, linux-kernel@vger.kernel.org, adityakali@google.com, linux-api@vger.kernel.org, containers@lists.linux-foundation.org, cgroups@vger.kernel.org, lxc-devel@lists.linuxcontainers.org, akpm@linux-foundation.org, ebiederm@xmission.com
List-Id: linux-api@vger.kernel.org

On Tue, Nov 24, 2015 at 12:16:10PM -0500, Tejun Heo wrote:
...
> > +		if (ns != &init_cgroup_ns) {
> > +			struct dentry *nsdentry;
> > +			struct cgroup *cgrp;
> > +
> > +			cgrp = cset_cgroup_from_root(ns->root_cgrps, root);
> > +			nsdentry = kernfs_obtain_root(dentry->d_sb,
> > +				cgrp->kn);
> > +			dput(dentry);
> > +			dentry = nsdentry;
> > +		}
> > +	}
> 
> So, this would effectively allow namespace mounts to claim controllers
> which aren't configured otherwise which doesn't seem like a good idea.
> I think the right thing to do for namespace mounts is to always
> require an existing superblock.

that was my goal with https://git.kernel.org/cgit/linux/kernel/git/sergeh/linux-security.git/commit/?h=cgroupns.v4&id=8eb75d2bb24df59e262f050dce567d2332adc5f3
(which was sent inline earlier in this thread in response to Eric)  Does
that look sufficient?

thanks,
-serge

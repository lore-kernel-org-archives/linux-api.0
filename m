From: "Serge E. Hallyn" <serge.hallyn-GeWIH/nMZzLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 6/8] cgroup: mount cgroupns-root when inside non-init
	cgroupns
Date: Thu, 31 Dec 2015 18:58:43 -0600
Message-ID: <20160101005843.GA26243@mail.hallyn.com>
References: <1450844609-9194-1-git-send-email-serge.hallyn@ubuntu.com>
	<1450844609-9194-7-git-send-email-serge.hallyn@ubuntu.com>
	<20151231133822.GA463@swordfish>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <containers-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20151231133822.GA463@swordfish>
List-Unsubscribe: <https://lists.linuxfoundation.org/mailman/options/containers>,
	<mailto:containers-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.linuxfoundation.org/pipermail/containers/>
List-Post: <mailto:containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
List-Help: <mailto:containers-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=help>
List-Subscribe: <https://lists.linuxfoundation.org/mailman/listinfo/containers>,
	<mailto:containers-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=subscribe>
Sender: containers-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org
Errors-To: containers-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org
To: Sergey Senozhatsky <sergey.senozhatsky-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Stephen Rothwell <sfr-3FnU+UHB4dNDw9hX6IcOSA@public.gmane.org>, gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, serge.hallyn-GeWIH/nMZzLQT0dZR+AlfA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-next-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org, lxc-devel-cunTk1MwBs9qMoObBWhMNEqPaTDuhLve2LY78lusg7I@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org
List-Id: linux-api@vger.kernel.org

On Thu, Dec 31, 2015 at 10:38:22PM +0900, Sergey Senozhatsky wrote:
> On (12/22/15 22:23), serge.hallyn-GeWIH/nMZzLQT0dZR+AlfA@public.gmane.org wrote:
> [..]
> >  	root = kzalloc(sizeof(*root), GFP_KERNEL);
> >  	if (!root) {
> >  		ret = -ENOMEM;
> > @@ -2124,12 +2143,30 @@ out_free:
> >  	kfree(opts.release_agent);
> >  	kfree(opts.name);
> >  
> > -	if (ret)
> > +	if (ret) {
> > +		put_cgroup_ns(ns);
> >  		return ERR_PTR(ret);
> > +	}
> >  out_mount:
> >  	dentry = kernfs_mount(fs_type, flags, root->kf_root,
> >  			      is_v2 ? CGROUP2_SUPER_MAGIC : CGROUP_SUPER_MAGIC,
> >  			      &new_sb);
> > +
> > +	/*
> > +	 * In non-init cgroup namespace, instead of root cgroup's
> > +	 * dentry, we return the dentry corresponding to the
> > +	 * cgroupns->root_cgrp.
> > +	 */
> > +	if (!IS_ERR(dentry) && ns != &init_cgroup_ns) {
> > +		struct dentry *nsdentry;
> > +		struct cgroup *cgrp;
> > +
> > +		cgrp = cset_cgroup_from_root(ns->root_cset, root);
> > +		nsdentry = kernfs_node_dentry(cgrp->kn, dentry->d_sb);
> > +		dput(dentry);
> > +		dentry = nsdentry;
> > +	}
> > +
> >  	if (IS_ERR(dentry) || !new_sb)
> >  		cgroup_put(&root->cgrp);
> >  
> > @@ -2142,6 +2179,7 @@ out_mount:
> >  		deactivate_super(pinned_sb);
> >  	}
> >  
> > +	put_cgroup_ns(ns);
> >  	return dentry;
> >  }
> 
> Hello,
> 
> didn't investigate, just let you know that I'm seeing some warning on linux-next 20151231
> 
> 1159 is  lockdep_assert_held(&css_set_lock)
> 
> [    2.880978] WARNING: CPU: 1 PID: 198 at kernel/cgroup.c:1159 cset_cgroup_from_root+0xa8/0xaf()
> [    2.880981] Modules linked in: mousedev arc4 nls_iso8859_1 nls_cp437 vfat fat serio_raw iwlmvm psmouse i915 atkbd mac80211 libps2 mxm_wmi i2c_algo_bit drm_kms_helper coretemp cfbfillrect iwlwifi syscopyarea hwmon cfbimgblt crc32c_intel sysfillrect sysimgblt fb_sys_fops cfg80211 ie31200_edac cfbcopyarea evdev r8169 lpc_ich drm i2c_i801 mii intel_gtt edac_core i2c_core mfd_core thermal video i8042 wmi serio button acpi_cpufreq ext4 crc16 mbcache jbd2 sd_mod ehci_pci ehci_hcd ahci libahci libata xhci_pci scsi_mod xhci_hcd usbcore usb_common
> [    2.881040] CPU: 1 PID: 198 Comm: kworker/1:2 Tainted: G        W       4.4.0-rc7-next-20151231-dbg-00012-gc1e64b7-dirty #316
> [    2.881045] Workqueue: events cgroup_release_agent
> [    2.881048]  0000000000000000 ffff88041b7f3cb8 ffffffff811e8bc6 0000000000000000
> [    2.881053]  ffff88041b7f3cf0 ffffffff81040889 ffffffff810b2d27 ffffffff8163f3c0
> [    2.881057]  ffff88041cc84000 ffff88041b7c0000 ffff88042fa58a00 ffff88041b7f3d00
> [    2.881062] Call Trace:
> [    2.881068]  [<ffffffff811e8bc6>] dump_stack+0x4b/0x63
> [    2.881073]  [<ffffffff81040889>] warn_slowpath_common+0x99/0xb2
> [    2.881076]  [<ffffffff810b2d27>] ? cset_cgroup_from_root+0xa8/0xaf
> [    2.881080]  [<ffffffff81040955>] warn_slowpath_null+0x1a/0x1c
> [    2.881083]  [<ffffffff810b2d27>] cset_cgroup_from_root+0xa8/0xaf
> [    2.881086]  [<ffffffff810b58a4>] cgroup_path+0x51/0x83
> [    2.881090]  [<ffffffff810b59fa>] cgroup_release_agent+0x75/0xed
> [    2.881094]  [<ffffffff810566ea>] process_one_work+0x292/0x54b
> [    2.881098]  [<ffffffff81057826>] worker_thread+0x291/0x383
> [    2.881102]  [<ffffffff81057595>] ? rescuer_thread+0x2cf/0x2cf
> [    2.881105]  [<ffffffff8105c603>] kthread+0xf8/0x100
> [    2.881108]  [<ffffffff8105c50b>] ? kthread_create_on_node+0x1c7/0x1c7
> [    2.881114]  [<ffffffff813b71bf>] ret_from_fork+0x3f/0x70
> [    2.881117]  [<ffffffff8105c50b>] ? kthread_create_on_node+0x1c7/0x1c7
> [    2.881119] ---[ end trace aa407df654d6b05d ]---

Thanks!  Following trivial patch should fix this:

>From fc54592077533ff2ff90ed54b72bf03b4378ca9f Mon Sep 17 00:00:00 2001
From: Serge Hallyn <serge.hallyn-GeWIH/nMZzLQT0dZR+AlfA@public.gmane.org>
Date: Thu, 31 Dec 2015 16:55:19 -0800
Subject: [PATCH 1/1] cgroup_release_agent: grab css_set_lock around
 cgroup_path()

Reported-by: Sergey Senozhatsky <sergey.senozhatsky-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Signed-off-by: Serge Hallyn <serge.hallyn-GeWIH/nMZzLQT0dZR+AlfA@public.gmane.org>
---
 kernel/cgroup.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index 4812f59..d10f127 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -5769,7 +5769,9 @@ static void cgroup_release_agent(struct work_struct *work)
 	if (!pathbuf || !agentbuf)
 		goto out;
 
+	spin_lock_bh(&css_set_lock);
 	path = cgroup_path(cgrp, pathbuf, PATH_MAX);
+	spin_unlock_bh(&css_set_lock);
 	if (!path)
 		goto out;
 
-- 
2.5.0

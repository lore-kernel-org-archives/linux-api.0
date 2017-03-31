From: joeyli <jlee-IBi9RG/b67k@public.gmane.org>
Subject: Re: memory hotplug and force_remove
Date: Fri, 31 Mar 2017 19:55:30 +0800
Message-ID: <20170331115530.GB28365@linux-l9pv.suse>
References: <20170320192938.GA11363@dhcp22.suse.cz>
 <2735706.OR0SQDpVy6@aspire.rjw.lan>
 <20170328075808.GB18241@dhcp22.suse.cz>
 <2203902.lsAnRkUs2Y@aspire.rjw.lan>
 <20170331083017.GK27098@dhcp22.suse.cz>
 <20170331104905.GA28365@linux-l9pv.suse>
 <20170331105505.GM27098@dhcp22.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20170331105505.GM27098-2MMpYkNvuYDjFM9bn6wA6Q@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: "Rafael J. Wysocki" <rjw-LthD3rsA81gm4RdzfppkhA@public.gmane.org>, Kani Toshimitsu <toshi.kani-ZPxbGqLxI0U@public.gmane.org>, Jiri Kosina <jkosina-AlSwsSmVLrQ@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

On Fri, Mar 31, 2017 at 12:55:05PM +0200, Michal Hocko wrote:
> On Fri 31-03-17 18:49:05, Joey Lee wrote:
> > Hi Michal,
> > 
> > On Fri, Mar 31, 2017 at 10:30:17AM +0200, Michal Hocko wrote:
> [...]
> > > @@ -241,11 +232,10 @@ static int acpi_scan_try_to_offline(struct acpi_device *device)
> > >  		acpi_walk_namespace(ACPI_TYPE_ANY, handle, ACPI_UINT32_MAX,
> > >  				    NULL, acpi_bus_offline, (void *)true,
> > >  				    (void **)&errdev);
> > > -		if (!errdev || acpi_force_hot_remove)
> > > +		if (!errdev)
> > >  			acpi_bus_offline(handle, 0, (void *)true,
> > >  					 (void **)&errdev);
> > > -
> > > -		if (errdev && !acpi_force_hot_remove) {
> > > +		else {
> >               ^^^^^^^^^^^^^
> > Here should still checks the parent's errdev state then rollback
> > parent/children to online state:
> > 
> > -		if (errdev && !acpi_force_hot_remove) {
> > +		if (errdev) {
> 
> You are right, I have missed that acpi_bus_offline modifies errdev.
> Thanks for spotting that! Updated patch is below.
> ---
> >From 8df0abd29988ffb52b6df52407b96d6015861bb7 Mon Sep 17 00:00:00 2001
> From: Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>
> Date: Fri, 31 Mar 2017 10:08:41 +0200
> Subject: [PATCH] acpi: drop support for force_remove
> 
> /sys/firmware/acpi/hotplug/force_remove was presumably added to support
> auto offlining in the past. This is, however, inherently dangerous for
> some hotplugable resources like memory. The memory offlining fails when
> the memory is still in use and cannot be dropped or migrated. If we
> ignore the failure we are basically allowing for subtle memory
> corruption or a crash.
> 
> We have actually noticed the later while hitting BUG() during the memory
> hotremove (remove_memory):
> 	ret = walk_memory_range(PFN_DOWN(start), PFN_UP(start + size - 1), NULL,
> 			check_memblock_offlined_cb);
> 	if (ret)
> 		BUG();
> 
> it took us quite non-trivial time realize that the customer had
> force_remove enabled. Even if the BUG was removed here and we could
> propagate the error up the call chain it wouldn't help at all because
> then we would hit a crash or a memory corruption later and harder to
> debug. So force_remove is unfixable for the memory hotremove. We haven't
> checked other hotplugable resources to be prone to a similar problems.
> 
> Remove the force_remove functionality because it is not fixable currently.
> Keep the sysfs file and report an error if somebody tries to enable it.
> Encourage users to report about the missing functionality and work with
> them with an alternative solution.
> 
> Signed-off-by: Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>

This patch is good to me. Please feel free to add:

Reviewed-by: Lee, Chun-Yi <jlee-IBi9RG/b67k@public.gmane.org>

Regards
Joey Lee

From: "Rafael J. Wysocki" <rjw-LthD3rsA81gm4RdzfppkhA@public.gmane.org>
Subject: Re: memory hotplug and force_remove
Date: Thu, 30 Mar 2017 22:15:04 +0200
Message-ID: <8340752.8oM5M3L67Q@aspire.rjw.lan>
References: <20170320192938.GA11363@dhcp22.suse.cz> <20170330162031.GE4326@dhcp22.suse.cz> <20170330165729.GN28365@linux-l9pv.suse>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170330165729.GN28365-g7OFGfmEpDh8S/rGE13EwQ@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: joeyli <jlee-IBi9RG/b67k@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Jiri Kosina <jikos-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

On Friday, March 31, 2017 12:57:29 AM joeyli wrote:
> On Thu, Mar 30, 2017 at 06:20:34PM +0200, Michal Hocko wrote:
> > On Thu 30-03-17 10:47:52, Jiri Kosina wrote:
> > > On Tue, 28 Mar 2017, Rafael J. Wysocki wrote:
> > > 
> > > > > > > we have been chasing the following BUG() triggering during the memory
> > > > > > > hotremove (remove_memory):
> > > > > > > 	ret = walk_memory_range(PFN_DOWN(start), PFN_UP(start + size - 1), NULL,
> > > > > > > 				check_memblock_offlined_cb);
> > > > > > > 	if (ret)
> > > > > > > 		BUG();
> > > > > > > 
> > > > > > > and it took a while to learn that the issue is caused by
> > > > > > > /sys/firmware/acpi/hotplug/force_remove being enabled. I was really
> > > > > > > surprised to see such an option because at least for the memory hotplug
> > > > > > > it cannot work at all. Memory hotplug fails when the memory is still
> > > > > > > in use. Even if we do not BUG() here enforcing the hotplug operation
> > > > > > > will lead to problematic behavior later like crash or a silent memory
> > > > > > > corruption if the memory gets onlined back and reused by somebody else.
> > > > > > > 
> > > > > > > I am wondering what was the motivation for introducing this behavior and
> > > > > > > whether there is a way to disallow it for memory hotplug. Or maybe drop
> > > > > > > it completely. What would break in such a case?
> > > > > > 
> > > > > > Honestly, I don't remember from the top of my head and I haven't looked at
> > > > > > that code for several months.
> > > > > > 
> > > > > > I need some time to recall that.
> > > > > 
> > > > > Did you have any chance to look into this?
> > > > 
> > > > Well, yes.
> > > > 
> > > > It looks like that was added for some people who depended on the old behavior
> > > > at that time.
> > > > 
> > > > I guess we can try to drop it and see what happpens. :-)
> > > 
> > > I'd agree with that; at the same time, udev rule should be submitted to 
> > > systemd folks though. I don't think there is anything existing in this 
> > > area yet (neither do distros ship their own udev rules for this AFAIK).
> > 
> > Another option would keepint the force_remove knob but make the code be
> > error handling aware. In other words rather than ignoring offline error
> > simply propagate it up the chain and do not consider the offline. Would
> > that be acceptable?
> 
> Then the only difference between normal mode is that the force_remove mode
> doesn't send out uevent for not-offline-yet container.

Which would be rather confusing.

The whole point of the thing was the "remove no matter what" behavior and
there's not much point in keeping it around without that.

Thanks,
Rafael

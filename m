From: Michal Hocko <mhocko@kernel.org>
Subject: Re: [PATCH] acpi: drop support for force_remove
Date: Tue, 11 Apr 2017 14:20:16 +0200
Message-ID: <20170411122016.GK6729@dhcp22.suse.cz>
References: <20170403074023.29121-1-mhocko@kernel.org>
 <20170410171343.GO4618@dhcp22.suse.cz>
 <3644128.Y1GtXNQdkv@aspire.rjw.lan>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-acpi-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <3644128.Y1GtXNQdkv@aspire.rjw.lan>
Sender: linux-acpi-owner@vger.kernel.org
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>
Cc: Joey Lee <jlee@suse.com>, Jiri Kosina <jkosina@suse.cz>, Kani Toshimitsu <toshi.kani@hpe.com>, Len Brown <lenb@kernel.org>, LKML <linux-kernel@vger.kernel.org>, linux-acpi@vger.kernel.org, linux-api@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On Tue 11-04-17 00:15:42, Rafael J. Wysocki wrote:
> On Monday, April 10, 2017 07:13:44 PM Michal Hocko wrote:
> > On Mon 03-04-17 09:40:23, Michal Hocko wrote:
> > > From: Michal Hocko <mhocko@suse.com>
> > > 
> > > /sys/firmware/acpi/hotplug/force_remove was presumably added to support
> > > auto offlining in the past. This is, however, inherently dangerous for
> > > some hotplugable resources like memory. The memory offlining fails when
> > > the memory is still in use and cannot be dropped or migrated. If we
> > > ignore the failure we are basically allowing for subtle memory
> > > corruption or a crash.
> > > 
> > > We have actually noticed the later while hitting BUG() during the memory
> > > hotremove (remove_memory):
> > > 	ret = walk_memory_range(PFN_DOWN(start), PFN_UP(start + size - 1), NULL,
> > > 			check_memblock_offlined_cb);
> > > 	if (ret)
> > > 		BUG();
> > > 
> > > it took us quite non-trivial time realize that the customer had
> > > force_remove enabled. Even if the BUG was removed here and we could
> > > propagate the error up the call chain it wouldn't help at all because
> > > then we would hit a crash or a memory corruption later and harder to
> > > debug. So force_remove is unfixable for the memory hotremove. We haven't
> > > checked other hotplugable resources to be prone to a similar problems.
> > > 
> > > Remove the force_remove functionality because it is not fixable currently.
> > > Keep the sysfs file and report an error if somebody tries to enable it.
> > > Encourage users to report about the missing functionality and work with
> > > them with an alternative solution.
> > > 
> > > Reviewed-by: Lee, Chun-Yi <jlee@suse.com>
> > > Signed-off-by: Michal Hocko <mhocko@suse.com>
> > 
> > ping on this?
> 
> /shrug/
> 
> I'll apply it if nobody has any problems with it.

It is definitely your call but how long are we going to wait
(considering that the current behavior is obviously broken wrt memory
hotplug)?
-- 
Michal Hocko
SUSE Labs

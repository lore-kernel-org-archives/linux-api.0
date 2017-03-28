From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
Subject: Re: memory hotplug and force_remove
Date: Tue, 28 Mar 2017 17:22:58 +0200
Message-ID: <2203902.lsAnRkUs2Y@aspire.rjw.lan>
References: <20170320192938.GA11363@dhcp22.suse.cz> <2735706.OR0SQDpVy6@aspire.rjw.lan> <20170328075808.GB18241@dhcp22.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Return-path: <owner-linux-mm@kvack.org>
In-Reply-To: <20170328075808.GB18241@dhcp22.suse.cz>
Sender: owner-linux-mm@kvack.org
To: Michal Hocko <mhocko@kernel.org>
Cc: Toshi Kani <toshi.kani@hp.com>, Jiri Kosina <jkosina@suse.cz>, joeyli <jlee@suse.com>, linux-mm@kvack.org, LKML <linux-kernel@vger.kernel.org>, linux-api@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On Tuesday, March 28, 2017 09:58:08 AM Michal Hocko wrote:
> On Mon 20-03-17 22:24:42, Rafael J. Wysocki wrote:
> > On Monday, March 20, 2017 03:29:39 PM Michal Hocko wrote:
> > > Hi Rafael,
> > 
> > Hi,
> > 
> > > we have been chasing the following BUG() triggering during the memory
> > > hotremove (remove_memory):
> > > 	ret = walk_memory_range(PFN_DOWN(start), PFN_UP(start + size - 1), NULL,
> > > 				check_memblock_offlined_cb);
> > > 	if (ret)
> > > 		BUG();
> > > 
> > > and it took a while to learn that the issue is caused by
> > > /sys/firmware/acpi/hotplug/force_remove being enabled. I was really
> > > surprised to see such an option because at least for the memory hotplug
> > > it cannot work at all. Memory hotplug fails when the memory is still
> > > in use. Even if we do not BUG() here enforcing the hotplug operation
> > > will lead to problematic behavior later like crash or a silent memory
> > > corruption if the memory gets onlined back and reused by somebody else.
> > > 
> > > I am wondering what was the motivation for introducing this behavior and
> > > whether there is a way to disallow it for memory hotplug. Or maybe drop
> > > it completely. What would break in such a case?
> > 
> > Honestly, I don't remember from the top of my head and I haven't looked at
> > that code for several months.
> > 
> > I need some time to recall that.
> 
> Did you have any chance to look into this?

Well, yes.

It looks like that was added for some people who depended on the old behavior
at that time.

I guess we can try to drop it and see what happpens. :-)

Thanks,
Rafael

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>

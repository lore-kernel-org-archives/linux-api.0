From: Michal Hocko <mhocko@kernel.org>
Subject: memory hotplug and force_remove
Date: Mon, 20 Mar 2017 15:29:39 -0400
Message-ID: <20170320192938.GA11363@dhcp22.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <owner-linux-mm@kvack.org>
Content-Disposition: inline
Sender: owner-linux-mm@kvack.org
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>
Cc: Toshi Kani <toshi.kani@hp.com>, Jiri Kosina <jkosina@suse.cz>, joeyli <jlee@suse.com>, linux-mm@kvack.org, LKML <linux-kernel@vger.kernel.org>, linux-api@vger.kernel.org
List-Id: linux-api@vger.kernel.org

Hi Rafael,
we have been chasing the following BUG() triggering during the memory
hotremove (remove_memory):
	ret = walk_memory_range(PFN_DOWN(start), PFN_UP(start + size - 1), NULL,
				check_memblock_offlined_cb);
	if (ret)
		BUG();

and it took a while to learn that the issue is caused by
/sys/firmware/acpi/hotplug/force_remove being enabled. I was really
surprised to see such an option because at least for the memory hotplug
it cannot work at all. Memory hotplug fails when the memory is still
in use. Even if we do not BUG() here enforcing the hotplug operation
will lead to problematic behavior later like crash or a silent memory
corruption if the memory gets onlined back and reused by somebody else.

I am wondering what was the motivation for introducing this behavior and
whether there is a way to disallow it for memory hotplug. Or maybe drop
it completely. What would break in such a case?

Thanks!
-- 
Michal Hocko
SUSE Labs

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>

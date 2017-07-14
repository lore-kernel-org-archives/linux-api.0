From: Michal Hocko <mhocko@kernel.org>
Subject: [PATCH 0/2] mm, memory_hotplug: remove zone onlining restriction
Date: Fri, 14 Jul 2017 14:12:31 +0200
Message-ID: <20170714121233.16861-1-mhocko@kernel.org>
Return-path: <owner-linux-mm@kvack.org>
Sender: owner-linux-mm@kvack.org
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Mel Gorman <mgorman@suse.de>, Vlastimil Babka <vbabka@suse.cz>, Andrea Arcangeli <aarcange@redhat.com>, Reza Arbab <arbab@linux.vnet.ibm.com>, Yasuaki Ishimatsu <yasu.isimatu@gmail.com>, qiuxishi@huawei.com, Kani Toshimitsu <toshi.kani@hpe.com>, slaoub@gmail.com, Joonsoo Kim <js1304@gmail.com>, Daniel Kiper <daniel.kiper@oracle.com>, Igor Mammedov <imammedo@redhat.com>, Vitaly Kuznetsov <vkuznets@redhat.com>, Wei Yang <richard.weiyang@gmail.com>, linux-mm@kvack.org, LKML <linux-kernel@vger.kernel.org>, Joonsoo Kim <iamjoonsoo.kim@lge.com>, linux-api@vger.kernel.org, Michal Hocko <mhocko@suse.com>
List-Id: linux-api@vger.kernel.org

Hi,
I have sent this as an RFC previously [1] and there haven't been any
fundamental objections to the approach. The biggest concern was that
if anybody starts depending on the default online semantic introduced
in 4.13 merge window then this would break it [2]. I find it rather
unlikely but if we are worried we can try to push this later in the
release cycle. Unfortunatelly I didn't have much time to work on this
sooner.

This work should help Joonsoo with his CMA zone based approach when
reusing MOVABLE zone. I think it will also help to remove more code from
the memory hotplug (e.g. zone shrinking).

Patch 1 restores original memoryXY/valid_zones semantic wrt zone
ordering. This can be merged without patch 2 which removes the zone
overlap restriction and defines a semantic for the default onlining. See
more in the patch.

Questions, concerns, objections?

Shortlog
Michal Hocko (2):
      mm, memory_hotplug: display allowed zones in the preferred ordering
      mm, memory_hotplug: remove zone restrictions

Diffstat
 drivers/base/memory.c          | 30 ++++++++++-----
 include/linux/memory_hotplug.h |  2 +-
 mm/memory_hotplug.c            | 87 +++++++++++++++++-------------------------
 3 files changed, 55 insertions(+), 64 deletions(-)


[1] http://lkml.kernel.org/r/20170629073509.623-1-mhocko@kernel.org
[2] http://lkml.kernel.org/r/20170710064540.GA19185@dhcp22.suse.cz

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>

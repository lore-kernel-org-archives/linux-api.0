From: Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH 0/9] cleanup zonelists initialization
Date: Fri, 14 Jul 2017 09:59:57 +0200
Message-ID: <20170714080006.7250-1-mhocko@kernel.org>
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org
Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Mel Gorman <mgorman-l3A5Bk7waGM@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Vlastimil Babka <vbabka-AlSwsSmVLrQ@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, joonsoo kim <js1304-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>, Shaohua Li <shaohua.li-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Toshi Kani <toshi.kani-VXdhtT5mjnY@public.gmane.org>, Wen Congyang <wency-BthXqXjhjHXQFUHtdCDX3A@public.gmane.org>
List-Id: linux-api@vger.kernel.org

Hi,
this is aimed at cleaning up the zonelists initialization code we have
but the primary motivation was bug report [1] which got resolved but
the usage of stop_machine is just too ugly to live. Most patches are
straightforward but 3 of them need a special consideration.

Patch 1 removes zone ordered zonelists completely. I am CCing linux-api
because this is a user visible change. As I argue in the patch
description I do not think we have a strong usecase for it these days.
I have kept sysctl in place and warn into the log if somebody tries to
configure zone lists ordering. If somebody has a real usecase for it
we can revert this patch but I do not expect anybody will actually notice
runtime differences. This patch is not strictly needed for the rest but
it made patch 6 easier to implement.

Patch 7 removes stop_machine from build_all_zonelists without adding any
special synchronization between iterators and updater which I _believe_
is acceptable as explained in the changelog. I hope I am not missing
anything.

Patch 8 then removes zonelists_mutex which is kind of ugly as well and
not really needed AFAICS but a care should be taken when double checking
my thinking.

This has passed my light testing but I currently do not have a HW to
test hotadd_new_pgdat path (aka a completely new node added to the
system in runtime).

This is based on the current mmomt git tree (mmotm-2017-07-12-15-11).
Any feedback is highly appreciated.

The diffstat looks really promissing
 include/linux/mmzone.h |   3 +-
 init/main.c            |   2 +-
 kernel/sysctl.c        |   2 -
 mm/internal.h          |   1 +
 mm/memory_hotplug.c    |  27 +----
 mm/page_alloc.c        | 293 ++++++++++++-------------------------------------
 mm/page_ext.c          |   5 +-
 mm/sparse-vmemmap.c    |  11 +-
 mm/sparse.c            |  10 +-
 9 files changed, 89 insertions(+), 265 deletions(-)

Shortlog says
Michal Hocko (9):
      mm, page_alloc: rip out ZONELIST_ORDER_ZONE
      mm, page_alloc: remove boot pageset initialization from memory hotplug
      mm, page_alloc: do not set_cpu_numa_mem on empty nodes initialization
      mm, memory_hotplug: drop zone from build_all_zonelists
      mm, memory_hotplug: remove explicit build_all_zonelists from try_online_node
      mm, page_alloc: simplify zonelist initialization
      mm, page_alloc: remove stop_machine from build_all_zonelists
      mm, memory_hotplug: get rid of zonelists_mutex
      mm, sparse, page_ext: drop ugly N_HIGH_MEMORY branches for allocations

[1] http://lkml.kernel.org/r/alpine.DEB.2.20.1706291803380.1861@nanos

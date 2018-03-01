From: Matthew Wilcox <willy@infradead.org>
Subject: [PATCH v4 0/4] Record additional page allocation reasons
Date: Thu,  1 Mar 2018 13:15:19 -0800
Message-ID: <20180301211523.21104-1-willy@infradead.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-mm@kvack.org
Cc: Matthew Wilcox <mawilcox@microsoft.com>, Martin Schwidefsky <schwidefsky@de.ibm.com>, linux-kernel@vger.kernel.org, Fengguang Wu <fengguang.wu@intel.com>, linux-api@vger.kernel.org
List-Id: linux-api@vger.kernel.org

From: Matthew Wilcox <mawilcox@microsoft.com>

Rework how the _map_count field in struct page is used to record why
the page was allocated.  We now have about twenty bits available, and
I've taken two of them to mark pages allocated for page tables and
through vmalloc.  They are reported by the page-types tool as g and
V respectively.

Changes since v3:
 - Ack from Martin on s390 changes
 - Fix up some comments
 - Removed check for PageType from fs/proc/page.c; page_mapped() handles
   this just fine.
 - Added KPF_VMALLOC and KPF_PGTABLE (hence cc'ing linux-api)
 - Set KPF_VMALLOC and KPF_PGTABLE in fs/proc/page.c
 - Interpret KPF_VMALLOC and KPF_PGTABLE in tools/vm/page-flags.c
 - Set PageTable on tile's extra pages

Matthew Wilcox (4):
  s390: Use _refcount for pgtables
  mm: Split page_type out from _map_count
  mm: Mark pages allocated through vmalloc
  mm: Mark pages in use for page tables

 arch/s390/mm/pgalloc.c                 | 21 +++++++------
 arch/tile/mm/pgtable.c                 |  3 ++
 fs/proc/page.c                         |  4 +++
 include/linux/mm.h                     |  2 ++
 include/linux/mm_types.h               | 13 +++++---
 include/linux/page-flags.h             | 57 ++++++++++++++++++++++------------
 include/uapi/linux/kernel-page-flags.h |  3 +-
 kernel/crash_core.c                    |  1 +
 mm/page_alloc.c                        | 13 +++-----
 mm/vmalloc.c                           |  2 ++
 scripts/tags.sh                        |  6 ++--
 tools/vm/page-types.c                  |  2 ++
 12 files changed, 82 insertions(+), 45 deletions(-)

-- 
2.16.1

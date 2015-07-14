From: Konstantin Khlebnikov <khlebnikov@yandex-team.ru>
Subject: [PATCHSET v4 0/5] pagemap: make useable for non-privilege users
Date: Tue, 14 Jul 2015 18:37:34 +0300
Message-ID: <20150714152516.29844.69929.stgit@buzz>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <owner-linux-mm@kvack.org>
Sender: owner-linux-mm@kvack.org
To: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>, Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Cc: "Kirill A. Shutemov" <kirill@shutemov.name>, Mark Williamson <mwilliamson@undo-software.com>, linux-kernel@vger.kernel.org, linux-api@vger.kernel.org
List-Id: linux-api@vger.kernel.org

This patchset makes pagemap useable again in the safe way (after row hammer
bug it was made CAP_SYS_ADMIN-only). This patchset restores access for
non-privileged users but hides PFNs from them.

Also it adds bit 'map-exlusive' which is set if page is mapped only here:
it helps in estimation of working set without exposing pfns and allows to
distinguish CoWed and non-CoWed private anonymous pages.

Second patch removes page-shift bits and completes migration to the new
pagemap format: flags soft-dirty and mmap-exlusive are available only
in the new format.

Changes since v3:
* patches reordered: cleanup now in second patch
* update pagemap for hugetlb, add missing 'FILE' bit
* fix PM_PFRAME_BITS: its 55 not 54 as was in previous versions

---

Konstantin Khlebnikov (5):
      pagemap: check permissions and capabilities at open time
      pagemap: switch to the new format and do some cleanup
      pagemap: rework hugetlb and thp report
      pagemap: hide physical addresses from non-privileged users
      pagemap: add mmap-exclusive bit for marking pages mapped only here


 Documentation/vm/pagemap.txt |    3 
 fs/proc/task_mmu.c           |  267 ++++++++++++++++++------------------------
 tools/vm/page-types.c        |   35 +++---
 3 files changed, 137 insertions(+), 168 deletions(-)

--
Konstantin

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>

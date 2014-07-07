From: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Subject: [PATCH v3 0/3] mm: introduce fincore() v3
Date: Mon,  7 Jul 2014 14:00:03 -0400
Message-ID: <1404756006-23794-1-git-send-email-n-horiguchi@ah.jp.nec.com>
Return-path: <owner-linux-mm@kvack.org>
Sender: owner-linux-mm@kvack.org
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Konstantin Khlebnikov <koct9i@gmail.com>, Wu Fengguang <fengguang.wu@intel.com>, Arnaldo Carvalho de Melo <acme@redhat.com>, Borislav Petkov <bp@alien8.de>, "Kirill A. Shutemov" <kirill@shutemov.name>, Johannes Weiner <hannes@cmpxchg.org>, Rusty Russell <rusty@rustcorp.com.au>, David Miller <davem@davemloft.net>, Andres Freund <andres@2ndquadrant.com>, linux-kernel@vger.kernel.org, linux-mm@kvack.org, Dave Hansen <dave.hansen@intel.com>, Christoph Hellwig <hch@infradead.org>, Dave Chinner <david@fromorbit.com>, Michael Kerrisk <mtk.manpages@gmail.com>, Linux API <linux-api@vger.kernel.org>, Naoya Horiguchi <nao.horiguchi@gmail.com>
List-Id: linux-api@vger.kernel.org

This is the 3rd version of fincore patchset.
I stop exporting PAGECACHE_TAG_* information to userspace via fincore().
Rather than that, no major change since v2.

Any comments/reviews are welcomed.

v2: http://lwn.net/Articles/604380/
v1: http://lwn.net/Articles/601020/

Thanks,
Naoya Horiguchi
---
Tree: git@github.com:Naoya-Horiguchi/linux.git
Branch: v3.16-rc3/fincore.ver3
---
Summary:

Naoya Horiguchi (3):
      mm: introduce fincore()
      selftests/fincore: add test code for fincore()
      man2/fincore.2: document general description about fincore(2)

 arch/x86/syscalls/syscall_64.tbl                   |   1 +
 include/linux/syscalls.h                           |   4 +
 include/uapi/linux/fincore.h                       |  84 +++++
 man2/fincore.2                                     | 348 ++++++++++++++++++++
 mm/Makefile                                        |   2 +-
 mm/fincore.c                                       | 286 ++++++++++++++++
 tools/testing/selftests/Makefile                   |   1 +
 tools/testing/selftests/fincore/Makefile           |  31 ++
 .../selftests/fincore/create_hugetlbfs_file.c      |  49 +++
 tools/testing/selftests/fincore/fincore.c          | 153 +++++++++
 tools/testing/selftests/fincore/run_fincoretests   | 361 +++++++++++++++++++++
 11 files changed, 1319 insertions(+), 1 deletion(-)

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>

From: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Subject: [PATCH 0/4] mm: introduce fincore() v2
Date: Thu,  3 Jul 2014 17:52:11 -0400
Message-ID: <1404424335-30128-1-git-send-email-n-horiguchi@ah.jp.nec.com>
Return-path: <owner-linux-mm@kvack.org>
Sender: owner-linux-mm@kvack.org
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Konstantin Khlebnikov <koct9i@gmail.com>, Wu Fengguang <fengguang.wu@intel.com>, Arnaldo Carvalho de Melo <acme@redhat.com>, Borislav Petkov <bp@alien8.de>, "Kirill A. Shutemov" <kirill@shutemov.name>, Johannes Weiner <hannes@cmpxchg.org>, Rusty Russell <rusty@rustcorp.com.au>, David Miller <davem@davemloft.net>, Andres Freund <andres@2ndquadrant.com>, linux-kernel@vger.kernel.org, linux-mm@kvack.org, Dave Hansen <dave.hansen@intel.com>, Christoph Hellwig <hch@infradead.org>, Michael Kerrisk <mtk.manpages@gmail.com>, Linux API <linux-api@vger.kernel.org>, Naoya Horiguchi <nao.horiguchi@gmail.com>
List-Id: linux-api@vger.kernel.org

This is the 2nd version of fincore patchset.

In the previous discussion[1], I got many feedbacks about the following
points:
- robust ABI handling is needed (especially about PAGECACHE_TAG_*)
- man page is necessary
- the parameter/return value of sys_fincore() needs improvement
- the order of bits FINCORE_*  and the order of 8 bytes entry in buffer
  should be identical
so I covered these in this version.

Any comments/reviews are welcomed.

[1] http://lwn.net/Articles/601020/

Thanks,
Naoya Horiguchi
---
Tree: git@github.com:Naoya-Horiguchi/linux.git
Branch: v3.16-rc3/fincore.ver2
---
Summary:

Naoya Horiguchi (4):
      define PAGECACHE_TAG_* as enumeration under include/uapi
      mm: introduce fincore()
      selftests/fincore: add test code for fincore()
      man2/fincore.2: document general description about fincore(2)

 arch/x86/syscalls/syscall_64.tbl                   |   1 +
 include/linux/fs.h                                 |   9 +-
 include/linux/syscalls.h                           |   4 +
 include/uapi/linux/pagecache.h                     | 111 ++++++
 man2/fincore.2                                     | 383 ++++++++++++++++++++
 mm/Makefile                                        |   2 +-
 mm/fincore.c                                       | 322 +++++++++++++++++
 tools/testing/selftests/Makefile                   |   1 +
 tools/testing/selftests/fincore/Makefile           |  31 ++
 .../selftests/fincore/create_hugetlbfs_file.c      |  49 +++
 tools/testing/selftests/fincore/fincore.c          | 166 +++++++++
 tools/testing/selftests/fincore/run_fincoretests   | 401 +++++++++++++++++++++
 12 files changed, 1471 insertions(+), 9 deletions(-)

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>

From: Mike Rapoport <rppt@kernel.org>
Subject: [PATCH RFC] mm: add MAP_EXCLUSIVE to create exclusive user mappings
Date: Sun, 27 Oct 2019 12:17:31 +0200
Message-ID: <1572171452-7958-1-git-send-email-rppt@kernel.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: Alexey Dobriyan <adobriyan@gmail.com>, Andrew Morton <akpm@linux-foundation.org>, Andy Lutomirski <luto@kernel.org>, Arnd Bergmann <arnd@arndb.de>, Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>, James Bottomley <jejb@linux.ibm.com>, Mike Rapoport <rppt@kernel.org>, Peter Zijlstra <peterz@infradead.org>, Steven Rostedt <rostedt@goodmis.org>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>, linux-api@vger.kernel.org, linux-mm@kvack.org, x86@kernel.org, Mike Rapoport <rppt@linux.ibm.com>
List-Id: linux-api@vger.kernel.org

From: Mike Rapoport <rppt@linux.ibm.com>

Hi,

The patch below aims to allow applications to create mappins that have
pages visible only to the owning process. Such mappings could be used to
store secrets so that these secrets are not visible neither to other
processes nor to the kernel.

I've only tested the basic functionality, the changes should be verified
against THP/migration/compaction. Yet, I'd appreciate early feedback.

Mike Rapoport (1):
  mm: add MAP_EXCLUSIVE to create exclusive user mappings

 arch/x86/mm/fault.c                    | 14 ++++++++++
 fs/proc/task_mmu.c                     |  1 +
 include/linux/mm.h                     |  9 +++++++
 include/linux/page-flags.h             |  7 +++++
 include/linux/page_excl.h              | 49 ++++++++++++++++++++++++++++++++++
 include/trace/events/mmflags.h         |  9 ++++++-
 include/uapi/asm-generic/mman-common.h |  1 +
 kernel/fork.c                          |  3 ++-
 mm/Kconfig                             |  3 +++
 mm/gup.c                               |  8 ++++++
 mm/memory.c                            |  3 +++
 mm/mmap.c                              | 16 +++++++++++
 mm/page_alloc.c                        |  5 ++++
 13 files changed, 126 insertions(+), 2 deletions(-)
 create mode 100644 include/linux/page_excl.h

-- 
2.7.4

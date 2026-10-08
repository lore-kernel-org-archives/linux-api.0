Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F72C47605A;
	Thu,  8 Oct 2026 08:51:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791449484; cv=none; b=r7Vv7JVN7UDSH6HfkaIHqvxTBbGryE9etFxyeFdedodrxCtKbqGAREOOyRfjf8vZSzAWyWKOtAvBWxcAB/xzE+RR7An9lE4f4RG2xXUolTtPgxGFruhnM84BCb8RpvlKtdZxs1GoAsMQk9BtUBTpJFYcBwEI1eYGimFsEwSTHlc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791449484; c=relaxed/simple;
	bh=VRzKBeVBLvYBmi58DpwoyfnIMalrX3V/KtnoC4gOC6I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fXip3UyZgQrjzTfRcY9L4KB4aGB52JaBcwfthmSVMOzDhN9HF8ugJnZCFa5FQb9VZoY0Y57nISXeZEMfkpyNkqpQ8udByY+SE8+rOzfgh05eXXbeZXRNazYe9wM+31YrAR025RTuc2ByKUz0eU4jyZ7TPyJW8WU8czOIxePKhsk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=mSmrhk2W; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="mSmrhk2W"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 604101F000FF;
	Thu,  8 Oct 2026 08:51:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791449481;
	bh=RkyCbOC3YBa2fB7CaAz6SWtNUe1uEcQCgcfAVlsBQ9k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=mSmrhk2WnyDzuYt+RyCxLNZwmO2ocjR3NpFGOYsvap4hzvtjIUitQTKPTyDM1PCij
	 e3fgkB9KnHsOyEzc/21Jvgz0e4BRH7AifGDUnZTHUohtXkU6qjf4STLP8ALDyZ/svF
	 ZlNwz8WB2PsbqwftKrjDcobt8MmBIB6ksWOKYeL/IngJUu2VFEMgyyO+3XpL/MfxvO
	 t71mRvsq27i9wx2ffxZV6ubvGCuU2mxs3azTKJNyudzcZqcrwJlOlul2XSdMD5i7j6
	 5jnD2bEOYTCfCHvEDu/HSl4gtrxbH3hJGs4xIU+orMZ/MRE21OiMvieYDGaEYHrfce
	 Y6n6FWpdrHNKg==
From: Sasha Levin <sashal@kernel.org>
To: linux-api@vger.kernel.org,
	linux-kernel@vger.kernel.org
Cc: Sasha Levin <sashal@kernel.org>,
	linux-doc@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	linux-kbuild@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	workflows@vger.kernel.org,
	tools@kernel.org,
	x86@kernel.org,
	Thomas Gleixner <tglx@kernel.org>,
	"Paul E . McKenney" <paulmck@kernel.org>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Dmitry Vyukov <dvyukov@google.com>,
	Randy Dunlap <rdunlap@infradead.org>,
	Cyril Hrubis <chrubis@suse.cz>,
	Kees Cook <kees@kernel.org>,
	Jake Edge <jake@lwn.net>,
	David Laight <david.laight.linux@gmail.com>,
	Gabriele Paoloni <gpaoloni@redhat.com>,
	Mauro Carvalho Chehab <mchehab@kernel.org>,
	Christian Brauner <brauner@kernel.org>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Andrew Morton <akpm@linux-foundation.org>,
	Masahiro Yamada <masahiroy@kernel.org>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Arnd Bergmann <arnd@arndb.de>,
	Nathan Chancellor <nathan@kernel.org>,
	Steven Rostedt <rostedt@goodmis.org>,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Subject: [PATCH v5 10/11] kernel/api: add API specification for sys_madvise
Date: Thu,  8 Oct 2026 04:49:50 -0400
Message-ID: <20261008084956.2911790-11-sashal@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20261008084956.2911790-1-sashal@kernel.org>
References: <20261008084956.2911790-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: linux-api@vger.kernel.org
List-Id: <linux-api.vger.kernel.org>
List-Subscribe: <mailto:linux-api+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-api+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Add KAPI-annotated kerneldoc for the sys_madvise system call in
mm/madvise.c.

The specification documents the parameters (start, len_in, behavior),
per-behavior error conditions, lock acquisition (mmap_lock read and
write modes plus the per-VMA fast path, mmu_gather and mmu_notifier
brackets), signal handling, side effects, capability requirements
(CAP_SYS_ADMIN for MADV_HWPOISON and MADV_SOFT_OFFLINE), mseal
interaction, and how each behavior skips pages or reports errors.

Assisted-by: LLM
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 mm/madvise.c | 549 +++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 549 insertions(+)

diff --git a/mm/madvise.c b/mm/madvise.c
index eeee82cf2b3f4..4eb29922a2150 100644
--- a/mm/madvise.c
+++ b/mm/madvise.c
@@ -2018,6 +2018,555 @@ int do_madvise(struct mm_struct *mm, unsigned long start, size_t len_in, int beh
 	return error;
 }
 
+/**
+ * sys_madvise - Give advice about use of memory
+ * @start: Starting virtual address of the range to advise on
+ * @len_in: Length of the range in bytes
+ * @behavior: Advice (a MADV_* constant) the kernel should apply to the range
+ *
+ * long-desc: Provides the kernel with advice or directions about the address
+ *   range starting at start and extending for len_in bytes. The advice is
+ *   selected by behavior, which is one of the MADV_* constants defined in
+ *   <sys/mman.h>. The behaviors fall into three groups. The hint group
+ *   updates VMA flags (MADV_NORMAL, MADV_RANDOM, MADV_SEQUENTIAL,
+ *   MADV_DONTFORK, MADV_DOFORK, MADV_DONTDUMP, MADV_DODUMP, MADV_WIPEONFORK,
+ *   MADV_KEEPONFORK, MADV_MERGEABLE, MADV_UNMERGEABLE, MADV_HUGEPAGE,
+ *   MADV_NOHUGEPAGE). The immediate-action group performs work synchronously
+ *   while preserving page contents (MADV_WILLNEED, MADV_COLD, MADV_PAGEOUT,
+ *   MADV_POPULATE_READ, MADV_POPULATE_WRITE, MADV_COLLAPSE, MADV_GUARD_REMOVE,
+ *   MADV_SOFT_OFFLINE). The destructive group discards, replaces or
+ *   invalidates page contents (MADV_DONTNEED, MADV_DONTNEED_LOCKED, MADV_FREE,
+ *   MADV_REMOVE, MADV_GUARD_INSTALL, MADV_HWPOISON). MADV_GUARD_INSTALL
+ *   belongs to the destructive group because it zaps any existing pages in
+ *   the range before installing PTE guard markers.
+ *
+ *   start must be page-aligned; len_in is rounded up to the next page
+ *   boundary internally. Once those validation checks pass, a zero-length
+ *   range succeeds without performing work. The kernel rejects ranges that
+ *   wrap (start + PAGE_ALIGN(len_in) < start) and ranges where len_in is
+ *   non-zero but rounds up to zero. Address tagging bits are stripped
+ *   from start before VMA lookup for every behavior except MADV_HWPOISON
+ *   and MADV_SOFT_OFFLINE, which receive the raw start value because they
+ *   bypass the VMA walk entirely.
+ *
+ *   The kernel return value reports whether any error condition was
+ *   encountered, not whether the requested work was performed. The
+ *   relationship between the return code and the work done varies by
+ *   handler:
+ *
+ *     - Hint behaviors set or clear VMA flags; how the flag is used later
+ *       depends on the behavior. MADV_DONTFORK / MADV_DOFORK set or clear
+ *       VM_DONTCOPY, which dup_mmap() honors, so the child does not get the
+ *       mapping. MADV_MERGEABLE / MADV_UNMERGEABLE control whether KSM scans
+ *       the VMA. MADV_NOHUGEPAGE blocks the fault-time, MADV_COLLAPSE and
+ *       khugepaged THP paths for the VMA. MADV_HUGEPAGE makes the VMA
+ *       eligible for THP when the transparent_hugepage mode is "madvise" and
+ *       increases defrag effort; it does not force allocation, which still
+ *       depends on the global mode, VMA suitability, defrag GFP policy, and
+ *       allocation or memcg-charge success. MADV_WIPEONFORK does not wipe
+ *       pages at fork time; the child VMA's pages are not copied, and the
+ *       child sees zero-filled pages when it first touches them.
+ *       MADV_KEEPONFORK clears VM_WIPEONFORK. MADV_DONTDUMP / MADV_DODUMP set
+ *       or clear VM_DONTDUMP, although always_dump_vma() still includes gate,
+ *       vm_ops-named or arch-named VMAs in a core dump. MADV_NORMAL /
+ *       MADV_RANDOM / MADV_SEQUENTIAL set or clear VM_RAND_READ / VM_SEQ_READ,
+ *       which only steer read-ahead.
+ *
+ *     - Walk-and-skip handlers (MADV_COLD, MADV_PAGEOUT, MADV_FREE,
+ *       MADV_GUARD_REMOVE) traverse the range and silently skip pages or
+ *       PMDs that fail per-page preconditions (absent, special, device,
+ *       shared, non-LRU, unsplittable, locked, etc.), returning 0 even
+ *       when most or all pages were skipped.
+ *
+ *     - Bulk-backend handlers delegate the requested range to a single
+ *       backend call: MADV_DONTNEED and MADV_DONTNEED_LOCKED to
+ *       zap_vma_range_batched(), MADV_REMOVE to vfs_fallocate(),
+ *       MADV_WILLNEED on regular files to vfs_fadvise(). The backend's
+ *       return is propagated for MADV_REMOVE and discarded for
+ *       MADV_WILLNEED; DAX files short-circuit MADV_WILLNEED entirely.
+ *
+ *     - Stop-on-error handlers (MADV_POPULATE_READ, MADV_POPULATE_WRITE,
+ *       MADV_SOFT_OFFLINE) walk the range but surface the first per-page
+ *       failure as an errno (-EHWPOISON, -EFAULT, -ENOMEM, ...) rather
+ *       than skipping silently.
+ *
+ *     - Hybrid handlers combine modes: MADV_WILLNEED walks for anonymous
+ *       and shmem ranges but bulk-calls vfs_fadvise() for regular files;
+ *       MADV_COLLAPSE walks PMD-by-PMD and tracks the last scan failure
+ *       so transient skips coexist with terminal errors;
+ *       MADV_GUARD_INSTALL walks to install markers and re-walks after
+ *       zap_vma_range() to clear pre-existing pages, retrying up to
+ *       MAX_MADVISE_GUARD_RETRIES; MADV_HWPOISON walks pages but folds
+ *       memory_failure()'s -EOPNOTSUPP back to 0.
+ *
+ *   Applications that need to know whether a specific page was acted on
+ *   must verify the result through other means (e.g. /proc/[pid]/smaps,
+ *   page faults, read-after-write).
+ *
+ *   On success, madvise() returns 0; unlike read(2) and write(2) it has no
+ *   notion of partial completion at the syscall boundary. When the range
+ *   spans multiple VMAs, the kernel applies the advice to each in turn. For
+ *   the behaviors that walk VMAs (all except MADV_POPULATE_*, MADV_HWPOISON
+ *   and MADV_SOFT_OFFLINE), an unmapped gap inside the range causes the call
+ *   to return -ENOMEM after processing the mapped portions, rather than
+ *   aborting at the gap, although the walk stops at the first per-VMA error.
+ *   MADV_POPULATE_* stops at the first failure, and MADV_HWPOISON and
+ *   MADV_SOFT_OFFLINE bypass the walk, so an unmapped address gives -EFAULT.
+ *
+ *   POSIX defines posix_madvise(3) for a portable subset (POSIX_MADV_NORMAL,
+ *   _RANDOM, _SEQUENTIAL, _WILLNEED, _DONTNEED). Linux MADV_DONTNEED is
+ *   destructive: it discards the contents of the affected anonymous pages and
+ *   subsequent reads return zero. POSIX permits but does not require
+ *   destruction, so portable code that needs the POSIX semantics should use
+ *   posix_madvise(3) instead.
+ *
+ * contexts: process, sleepable
+ *
+ * param: start
+ *   type: uint, input
+ *   constraint-type: page_aligned
+ *   cdesc: Starting virtual address of the range. Must be aligned to
+ *     PAGE_SIZE. An unaligned start always returns -EINVAL, even when
+ *     len_in is zero. Address tag bits, where supported by the architecture,
+ *     are cleared via untagged_addr() before the range is interpreted, with
+ *     the exception of MADV_HWPOISON and MADV_SOFT_OFFLINE, which receive
+ *     the raw start value because they bypass the VMA walk.
+ *
+ * param: len_in
+ *   type: uint, input
+ *   cdesc: Length of the range in bytes. Internally rounded up to a multiple
+ *     of PAGE_SIZE. A len_in of 0 is accepted and the call is a no-op that
+ *     returns 0. A non-zero len_in that rounds up to 0 (i.e. wraps around)
+ *     returns -EINVAL, as does a range whose end (start + PAGE_ALIGN(len_in))
+ *     would wrap below start.
+ *
+ * param: behavior
+ *   type: int, input
+ *   cdesc: One of the MADV_* constants from <sys/mman.h>. See the long
+ *     description above for the full list and the three semantic groups
+ *     (hint, immediate-action, destructive). Behaviors gated by Kconfig
+ *     (KSM, transparent hugepage, memory failure) return -EINVAL when the
+ *     underlying support is disabled. A few architectures (notably alpha)
+ *     renumber values; portable code should always use the symbolic names.
+ *
+ * return:
+ *   type: int
+ *   check-type: exact
+ *   success: 0
+ *   desc: On success, returns 0. On error, returns a negative error code.
+ *     There is no partial-success indication; either the entire processed
+ *     range succeeded, or an error is returned and an unspecified prefix of
+ *     the range may have been advised.
+ *
+ * error: EINVAL, Invalid argument
+ *   desc: Invalid input (unknown or Kconfig-disabled MADV_*, unaligned start,
+ *     range wrap, non-zero len_in rounding up to zero) or a VMA filter.
+ *     DONTNEED/FREE reject VM_PFNMAP, VM_LOCKED (not DONTNEED_LOCKED) and
+ *     misaligned hugetlb; FREE non-anonymous; WIPEONFORK file or shared; REMOVE
+ *     VM_LOCKED or no file; COLD/PAGEOUT LOCKED/PFNMAP/HUGETLB; DOFORK
+ *     VM_SPECIAL; KEEPONFORK VM_DROPPABLE; DODUMP SPECIAL/DROPPABLE; GUARD_*
+ *     SPECIAL/HUGETLB (INSTALL also LOCKED); COLLAPSE if not possible;
+ *     POPULATE_* on bad permissions.
+ *
+ * error: ENOMEM, Cannot allocate memory
+ *   desc: For VMA-walking behaviors, a gap between mapped VMAs inside the range
+ *     gives -ENOMEM after the mapped subranges have been processed, unless a
+ *     per-VMA error ends the walk first. MADV_POPULATE_* stops at the first
+ *     failure and returns -ENOMEM when the region has no VMA or
+ *     faultin_page_range() exhausts memory. MADV_COLLAPSE returns -ENOMEM when
+ *     its struct collapse_control cannot be allocated, and when
+ *     madvise_collapse_errno() maps SCAN_ALLOC_HUGE_PAGE_FAIL (no hugepage
+ *     available) to it.
+ *
+ * error: EAGAIN, Resource temporarily unavailable
+ *   desc: For the VMA-flag-mutating behaviors, an internal -ENOMEM from VMA
+ *     splitting is translated to -EAGAIN before being returned to userspace,
+ *     advising the caller that a transient kernel resource shortage
+ *     prevented the update. Also returned by MADV_COLLAPSE via
+ *     madvise_collapse_errno() for transient scan failures (folio lock
+ *     contention, LRU isolation failure, dirty/writeback) where retrying
+ *     the call may succeed.
+ *
+ * error: EIO, Input/output error
+ *   desc: For MADV_REMOVE, an I/O error from the underlying filesystem's
+ *     FALLOC_FL_PUNCH_HOLE handler is propagated back as -EIO, and
+ *     MADV_SOFT_OFFLINE returns -EIO when soft_offline_page() cannot handle
+ *     the page. MADV_HWPOISON reports an unhandled page as -EBUSY; -EIO can
+ *     reach it only from a ZONE_DEVICE pagemap's ->memory_failure()
+ *     callback. MADV_WILLNEED and MADV_PAGEOUT do not surface filesystem or
+ *     device I/O errors: vfs_fadvise() returns are discarded by
+ *     madvise_willneed() and the pageout walk is invoked through a void
+ *     helper, so transient I/O failures during read-ahead or page-out are
+ *     silently dropped.
+ *
+ * error: EBADF, Bad file descriptor
+ *   desc: Returned by MADV_WILLNEED when applied to a non-file-backed VMA
+ *     and the kernel was built without CONFIG_SWAP, so there is neither a
+ *     file to read-ahead from nor a swap device to fault from.
+ *
+ * error: EACCES, Permission denied
+ *   desc: Returned by MADV_REMOVE when the target VMA fails
+ *     vma_is_shared_maywrite(), which needs both VM_SHARED and VM_MAYWRITE.
+ *     Private file mappings and shared mappings of files not opened for
+ *     writing are refused, while a PROT_READ MAP_SHARED mapping of a file
+ *     opened O_RDWR is accepted. Punching a hole through a refused mapping
+ *     would either be invisible to other mappers or bypass file write
+ *     permission.
+ *
+ * error: EPERM, Operation not permitted
+ *   desc: Returned in two situations. First, MADV_HWPOISON and
+ *     MADV_SOFT_OFFLINE require CAP_SYS_ADMIN; the inject-error handler
+ *     refuses non-privileged callers. Second, on 64-bit kernels, a discard
+ *     operation (MADV_FREE, MADV_DONTNEED, MADV_DONTNEED_LOCKED, MADV_REMOVE,
+ *     MADV_DONTFORK, MADV_WIPEONFORK, MADV_GUARD_INSTALL) is refused on a
+ *     read-only anonymous VMA that has been sealed with mseal(2), to prevent
+ *     bypassing the seal by discarding mapped data.
+ *
+ * error: EINTR, Interrupted system call
+ *   desc: Returned when a fatal signal is delivered while the call is
+ *     waiting to acquire the mmap write lock for a VMA-flag-mutating
+ *     behavior (mmap_write_lock_killable() returns -EINTR), or when
+ *     MADV_POPULATE_READ/MADV_POPULATE_WRITE is interrupted while faulting
+ *     in pages (faultin_page_range() returns -EINTR). Only a fatal signal
+ *     interrupts these waits, so the task is being killed and user space
+ *     does not normally see the error.
+ *
+ * error: EHWPOISON, Memory page has hardware error
+ *   desc: MADV_POPULATE_READ or MADV_POPULATE_WRITE encountered a page that
+ *     has been marked as containing a hardware-detected memory error and
+ *     could not be faulted in. MADV_HWPOISON also returns it when
+ *     memory_failure() finds the page already poisoned.
+ *
+ * error: EFAULT, Bad address
+ *   desc: MADV_POPULATE_READ or MADV_POPULATE_WRITE attempted to fault in a
+ *     page whose mapping raised VM_FAULT_SIGBUS or VM_FAULT_SIGSEGV (for
+ *     example, a file-backed page beyond the end of the file).
+ *     MADV_HWPOISON and MADV_SOFT_OFFLINE return a get_user_pages_fast()
+ *     failure, typically -EFAULT for an unmapped address.
+ *
+ * error: EBUSY, Device or resource busy
+ *   desc: Returned by MADV_COLLAPSE via madvise_collapse_errno() in two
+ *     specific scan-failure modes: SCAN_CGROUP_CHARGE_FAIL (the new
+ *     hugepage cannot be charged to the memory cgroup) and
+ *     SCAN_EXCEED_NONE_PTE (too many absent PTEs in the candidate range
+ *     for a synchronous collapse). Other transient collapse failures are
+ *     reported as -EAGAIN; non-transient ones as -EINVAL. MADV_HWPOISON and
+ *     MADV_SOFT_OFFLINE also return -EBUSY when the page cannot be handled.
+ *
+ * error: EOPNOTSUPP, Operation not supported
+ *   desc: MADV_REMOVE propagates vfs_fallocate() errors verbatim, so a
+ *     filesystem without FALLOC_FL_PUNCH_HOLE support fails with -EOPNOTSUPP
+ *     (other propagated errors include -EPERM, -ETXTBSY and -ENOSPC).
+ *     MADV_SOFT_OFFLINE also returns it when soft offlining is disabled via
+ *     /proc/sys/vm/enable_soft_offline or the event is filtered by
+ *     hwpoison_filter(); MADV_HWPOISON folds that case to 0.
+ *
+ * lock: mm->mmap_lock (read mode)
+ *   type: semaphore
+ *   acquired: yes
+ *   released: yes
+ *   desc: Taken for read for MADV_REMOVE, MADV_WILLNEED, MADV_COLD,
+ *     MADV_PAGEOUT, MADV_COLLAPSE, MADV_POPULATE_READ and
+ *     MADV_POPULATE_WRITE, and as the fallback when the per-VMA lock path
+ *     declines. It is dropped and retaken around vfs_fadvise() (WILLNEED on
+ *     regular files), vfs_fallocate() and userfaultfd_remove() (REMOVE, and
+ *     DONTNEED or FREE with UFFD_FEATURE_EVENT_REMOVE), the anon and file
+ *     collapse paths (COLLAPSE) and inside faultin_page_range()
+ *     (POPULATE_*), so the VMA must be looked up again afterwards.
+ *
+ * lock: mm->mmap_lock (write mode; killable)
+ *   type: semaphore
+ *   acquired: yes
+ *   released: yes
+ *   desc: Acquired in killable write mode for behaviors that modify
+ *     vma->vm_flags or split/merge VMAs (MADV_NORMAL, MADV_RANDOM,
+ *     MADV_SEQUENTIAL, MADV_DONTFORK, MADV_DOFORK, MADV_DONTDUMP, MADV_DODUMP,
+ *     MADV_WIPEONFORK, MADV_KEEPONFORK, MADV_MERGEABLE, MADV_UNMERGEABLE,
+ *     MADV_HUGEPAGE, MADV_NOHUGEPAGE). If the acquisition is killed by a
+ *     fatal signal, the syscall returns -EINTR before any VMA is touched.
+ *
+ * lock: per-VMA read lock (vma->vm_refcnt)
+ *   type: custom
+ *   acquired: yes
+ *   released: yes
+ *   desc: Tried first for MADV_DONTNEED, MADV_DONTNEED_LOCKED, MADV_FREE,
+ *     MADV_GUARD_INSTALL and MADV_GUARD_REMOVE via lock_vma_under_rcu(). The
+ *     lock is a reference on the VMA (vm_refcnt), not an rwsem. The per-VMA
+ *     path is taken only when the requested range fits within a single VMA,
+ *     the target mm is the caller's mm, the VMA is not armed with
+ *     userfaultfd, and, for MADV_GUARD_INSTALL on an anonymous VMA, an
+ *     anon_vma is already attached. Otherwise the code falls back to the
+ *     mmap read lock above.
+ *
+ * lock: mmu_gather TLB batch
+ *   type: custom
+ *   acquired: yes
+ *   released: yes
+ *   desc: For MADV_DONTNEED, MADV_DONTNEED_LOCKED and MADV_FREE a single
+ *     tlb_gather_mmu() / tlb_finish_mmu() pair (madvise_init_tlb() and
+ *     madvise_finish_tlb()) wraps the whole syscall, batching TLB invalidation
+ *     across all VMAs in the range. MADV_COLD and MADV_PAGEOUT build a
+ *     short-lived gather inside the handler. MADV_GUARD_INSTALL builds a
+ *     transient gather via zap_vma_range() each time the retry loop clears
+ *     pre-existing pages, and none if the range is already empty.
+ *     MADV_GUARD_REMOVE never gathers.
+ *
+ * lock: mmu_notifier invalidate range
+ *   type: custom
+ *   acquired: yes
+ *   released: yes
+ *   desc: All zap-based paths -- MADV_DONTNEED, MADV_DONTNEED_LOCKED, the
+ *     zap branch of MADV_GUARD_INSTALL via zap_vma_range(), and
+ *     MADV_FREE's own walk -- bracket their work with
+ *     mmu_notifier_invalidate_range_start()/_end() so secondary MMUs (KVM,
+ *     IOMMU SVA, etc.) observe the page clearing.
+ *
+ * signal: Any fatal signal
+ *   direction: receive
+ *   action: return
+ *   condition: Acquiring the mmap write lock or faulting in pages for
+ *     MADV_POPULATE_*
+ *   desc: A pending fatal signal aborts mmap_write_lock_killable() (used by
+ *     the VMA-flag-mutating behaviors) and faultin_page_range() (used by
+ *     MADV_POPULATE_READ and MADV_POPULATE_WRITE), in both cases surfacing as
+ *     -EINTR. Only a fatal signal interrupts these waits, so the task is
+ *     being killed and user space does not normally see the error.
+ *   errno: -EINTR
+ *   timing: during
+ *   restartable: no
+ *
+ * side-effect: modify_state
+ *   target: vma->vm_flags
+ *   condition: Hint-group behaviors (MADV_NORMAL, MADV_RANDOM, MADV_SEQUENTIAL,
+ *     MADV_DONTFORK, MADV_DOFORK, MADV_DONTDUMP, MADV_DODUMP, MADV_WIPEONFORK,
+ *     MADV_KEEPONFORK, MADV_MERGEABLE, MADV_UNMERGEABLE, MADV_HUGEPAGE,
+ *     MADV_NOHUGEPAGE)
+ *   desc: Sets or clears VM_RAND_READ, VM_SEQ_READ, VM_DONTCOPY,
+ *     VM_DONTDUMP, VM_WIPEONFORK, VM_MERGEABLE, VM_HUGEPAGE or VM_NOHUGEPAGE
+ *     on the affected VMAs, splitting or merging VMAs as needed. Reversible
+ *     with the inverse advice (MADV_DOFORK undoes MADV_DONTFORK), except
+ *     that the inverse call's VMA filter still applies (DOFORK rejects
+ *     VM_SPECIAL, DODUMP rejects non-hugetlb VM_SPECIAL or VM_DROPPABLE,
+ *     KEEPONFORK rejects VM_DROPPABLE).
+ *   reversible: yes
+ *
+ * side-effect: free_memory | modify_state | irreversible
+ *   target: page tables and resident pages within the range
+ *   condition: MADV_DONTNEED, MADV_DONTNEED_LOCKED, MADV_FREE
+ *   desc: MADV_DONTNEED zaps PTEs, releasing the pages or swap slots so the
+ *     next access faults in zero-filled anonymous pages or re-reads the
+ *     file. MADV_DONTNEED_LOCKED is identical but tolerates VM_LOCKED.
+ *     MADV_FREE marks anonymous pages lazy-freeable; clean pages may be
+ *     reclaimed under memory pressure and a write before reclaim cancels
+ *     the lazy free. Discarded data cannot be recovered.
+ *   reversible: no
+ *
+ * side-effect: filesystem | irreversible
+ *   target: backing file (FALLOC_FL_PUNCH_HOLE)
+ *   condition: MADV_REMOVE
+ *   desc: Calls vfs_fallocate(FALLOC_FL_PUNCH_HOLE | FALLOC_FL_KEEP_SIZE) on
+ *     the backing file, deallocating the corresponding file blocks. The hole
+ *     is visible to all mappers of the file and to read(2)/write(2)
+ *     callers; subsequent reads return zero. Filesystem freeze protection,
+ *     i_rwsem and any quota/space accounting are taken by the underlying
+ *     fallocate path.
+ *   reversible: no
+ *
+ * side-effect: modify_state | schedule
+ *   target: LRU lists and page reclaim
+ *   condition: MADV_COLD, MADV_PAGEOUT
+ *   desc: MADV_COLD deactivates the affected pages, moving them to the
+ *     inactive LRU and clearing PG_referenced/PG_young so they are reclaimed
+ *     sooner under pressure. MADV_PAGEOUT additionally calls reclaim_pages()
+ *     to write dirty pages out and drop clean ones synchronously. Page data
+ *     is preserved (rereads will fault in the same content), but the I/O and
+ *     LRU bookkeeping cannot be undone.
+ *   reversible: no
+ *
+ * side-effect: modify_state
+ *   target: page tables (faultin)
+ *   condition: MADV_POPULATE_READ, MADV_POPULATE_WRITE
+ *   desc: Walks the requested range with faultin_page_range(), populating
+ *     PTEs by triggering read or write faults so subsequent accesses do not
+ *     fault. Equivalent to touching every page in the range while suppressing
+ *     SIGBUS/SIGSEGV through the syscall return value. Allocations made by
+ *     faultin are not undone on partial failure.
+ *   reversible: no
+ *
+ * side-effect: modify_state | schedule
+ *   target: transparent hugepage layout
+ *   condition: MADV_COLLAPSE
+ *   desc: Synchronously coalesces base pages in the range into a PMD-sized
+ *     transparent hugepage when the mapping permits. Performs the same page
+ *     migration and zeroing that khugepaged would do asynchronously; the
+ *     range's data is preserved across the collapse.
+ *   reversible: no
+ *
+ * side-effect: free_memory | modify_state | irreversible
+ *   target: PTE marker (PTE_MARKER_GUARD)
+ *   condition: MADV_GUARD_INSTALL, MADV_GUARD_REMOVE
+ *   desc: MADV_GUARD_INSTALL installs PTE_MARKER_GUARD entries that cause
+ *     subsequent accesses to deliver SIGSEGV without consuming physical
+ *     memory; existing pages already mapped in the range are zapped via
+ *     zap_vma_range() before the markers are installed, so any
+ *     prior contents are lost. MADV_GUARD_REMOVE clears the markers but
+ *     does not (and cannot) restore zapped data.
+ *   reversible: no
+ *
+ * side-effect: hardware | irreversible
+ *   target: physical page (memory_failure)
+ *   condition: MADV_HWPOISON
+ *   desc: MADV_HWPOISON marks the affected pages as containing an
+ *     unrecoverable hardware error using the same machine-check path that
+ *     real ECC failures take. This affects physical memory bookkeeping
+ *     kernel-wide, and madvise() has no inverse. The poison can be cleared
+ *     through unpoison_memory() (the hwpoison-inject debugfs interface).
+ *     Intended for testing the memory-failure pipeline; restricted to
+ *     CAP_SYS_ADMIN.
+ *   reversible: no
+ *
+ * side-effect: hardware
+ *   target: physical page (soft_offline_page)
+ *   condition: MADV_SOFT_OFFLINE
+ *   desc: Migrates the contents off the affected pages and removes them from
+ *     the buddy allocator. Page contents are preserved. madvise() has no
+ *     inverse. The pages can be brought back through unpoison_memory() (the
+ *     hwpoison-inject debugfs interface). Intended for testing the
+ *     memory-failure pipeline; restricted to CAP_SYS_ADMIN.
+ *   reversible: no
+ *
+ * side-effect: modify_state
+ *   target: KSM merge state (vm_flags & VM_MERGEABLE)
+ *   condition: MADV_MERGEABLE, MADV_UNMERGEABLE
+ *   desc: Toggles VM_MERGEABLE, the VMA's eligibility for the kernel
+ *     same-page merger. MADV_MERGEABLE lets ksmd later replace identical
+ *     anonymous pages with shared, write-protected copies and is silently
+ *     ignored on KSM-incompatible VMAs. MADV_UNMERGEABLE synchronously
+ *     calls break_ksm(), which faults each KSM page in the range back to an
+ *     exclusive copy, before clearing VM_MERGEABLE. An -ENOMEM from either
+ *     advice is returned as -EAGAIN. The flag toggle is reversible by
+ *     issuing the inverse advice.
+ *   reversible: yes
+ *
+ * side-effect: modify_state
+ *   target: userfaultfd event queue
+ *   condition: MADV_DONTNEED, MADV_DONTNEED_LOCKED, MADV_FREE, MADV_REMOVE
+ *     on a VMA whose userfaultfd context negotiated UFFD_FEATURE_EVENT_REMOVE
+ *   desc: Generates a UFFD_EVENT_REMOVE notification covering the discarded
+ *     range so userfaultfd monitors observing the mapping see the
+ *     invalidation. The event is queued before the discard takes effect; the
+ *     monitor cannot veto it.
+ *   reversible: no
+ *
+ * capability: CAP_SYS_ADMIN
+ *   type: perform_operation
+ *   allows: Inject memory errors via MADV_HWPOISON or MADV_SOFT_OFFLINE
+ *   without: Both behaviors return -EPERM
+ *   condition: Checked at entry to madvise_inject_error() before any pages
+ *     are looked up
+ *
+ * constraint: Page-aligned start
+ *   desc: start must lie on a page boundary; otherwise the call returns
+ *     -EINVAL before any VMA is consulted.
+ *   expr: (start & (PAGE_SIZE - 1)) == 0
+ *
+ * constraint: Length rounded up to PAGE_SIZE
+ *   desc: The effective range length is PAGE_ALIGN(len_in). A non-zero len_in
+ *     that overflows during rounding, or a (start, end) range that wraps,
+ *     is rejected with -EINVAL.
+ *   expr: end = start + PAGE_ALIGN(len_in); end >= start
+ *
+ * constraint: Behavior must be supported
+ *   desc: behavior must be one of the MADV_* values listed under the
+ *     behavior parameter. Behaviors gated by Kconfig (KSM, THP, memory
+ *     failure) are rejected with -EINVAL when the corresponding option is
+ *     disabled in the running kernel.
+ *
+ * constraint: mseal-protected discards
+ *   desc: On 64-bit kernels, a discard operation (FREE, DONTNEED,
+ *     DONTNEED_LOCKED, REMOVE, DONTFORK, WIPEONFORK, GUARD_INSTALL) against
+ *     a sealed anonymous VMA is rejected unless the mapping is currently
+ *     writable -- both VM_WRITE in vm_flags and arch_vma_access_permitted()
+ *     allowing write -- so that mseal(2) cannot be bypassed by instructing
+ *     the kernel to throw the data away. File-backed sealed VMAs and
+ *     writable sealed VMAs are not subject to this restriction.
+ *   expr: !is_discard(behavior) || !vma_is_sealed(vma) ||
+ *     !vma_is_anonymous(vma) || ((vma->vm_flags & VM_WRITE) &&
+ *     arch_vma_access_permitted(vma, true, false, false))
+ *
+ * constraint: MADV_FREE requires anonymous mappings
+ *   desc: MADV_FREE is defined only over anonymous mappings; the handler
+ *     requires vma_is_anonymous() (no vm_ops) and rejects file-backed VMAs,
+ *     including shared anonymous (shmem) VMAs, with -EINVAL.
+ *   expr: vma_is_anonymous(vma)
+ *
+ * constraint: MADV_WIPEONFORK requires private anonymous mappings
+ *   desc: MADV_WIPEONFORK rejects file-backed mappings and shared anonymous
+ *     mappings; only MAP_PRIVATE anonymous VMAs accept it. Both rejections
+ *     surface as -EINVAL.
+ *   expr: !vma->vm_file && !(vma->vm_flags & VM_SHARED)
+ *
+ * constraint: MADV_REMOVE requires a shared file mapping that may be written
+ *   desc: MADV_REMOVE rejects VM_LOCKED VMAs and VMAs without an associated
+ *     file/mapping/host inode with -EINVAL. It rejects VMAs failing
+ *     vma_is_shared_maywrite() (VM_SHARED and VM_MAYWRITE) with -EACCES,
+ *     which covers private file mappings and shared mappings of files not
+ *     opened for writing, but not a PROT_READ MAP_SHARED mapping of a file
+ *     opened O_RDWR.
+ *   expr: !(vma->vm_flags & VM_LOCKED) && vma->vm_file &&
+ *     vma->vm_file->f_mapping && vma->vm_file->f_mapping->host &&
+ *     vma_is_shared_maywrite(vma)
+ *
+ * constraint: MADV_COLD / MADV_PAGEOUT VMA filter
+ *   desc: Both behaviors require LRU-managed pages; they reject VMAs that
+ *     are mlocked, raw-PFN or hugetlb.
+ *   expr: !(vma->vm_flags & (VM_LOCKED | VM_PFNMAP | VM_HUGETLB))
+ *
+ * examples: madvise(p, len, MADV_SEQUENTIAL);  // set VM_SEQ_READ on the VMA
+ *   madvise(p, len, MADV_POPULATE_WRITE);  // prefault writable PTEs
+ *   madvise(p, len, MADV_DONTNEED);        // discard anonymous pages
+ *   madvise(p, len, MADV_GUARD_INSTALL);   // install SIGSEGV guard pages
+ *
+ * notes: Behavior introduction history (mainline): MADV_FREE in 4.5,
+ *   MADV_WIPEONFORK / MADV_KEEPONFORK in 4.14, MADV_COLD / MADV_PAGEOUT in
+ *   5.4, MADV_POPULATE_READ / MADV_POPULATE_WRITE in 5.14,
+ *   MADV_DONTNEED_LOCKED in 5.18, MADV_COLLAPSE in 6.1, MADV_GUARD_INSTALL /
+ *   MADV_GUARD_REMOVE in 6.13. Code that wants to remain portable to older
+ *   kernels must handle -EINVAL gracefully and fall back.
+ *
+ *   process_madvise(2) applies the same advice values to another process
+ *   identified by a pidfd. When the target mm is the caller's own (the
+ *   pidfd refers to the caller), any locally-supported MADV_* value is
+ *   accepted. When the target is a different mm, the behavior must be in
+ *   the non-destructive remote subset (MADV_COLD, MADV_PAGEOUT,
+ *   MADV_WILLNEED, MADV_COLLAPSE) or the call returns -EINVAL, and the
+ *   caller must hold CAP_SYS_NICE.
+ *
+ *   MADV_PAGEOUT on a non-anonymous VM_MAYSHARE mapping is a silent no-op
+ *   returning 0 unless can_do_file_pageout() holds, meaning the caller owns
+ *   the file or is capable over it (file_owner_or_capable(), which honors
+ *   the mount idmap) or may write it (file_permission(MAY_WRITE)). On a
+ *   private file mapping that fails the same test, only anonymous pages are
+ *   paged out. MADV_COLD has no such filter.
+ *
+ *   MADV_GUARD_INSTALL retries up to MAX_MADVISE_GUARD_RETRIES (3) times
+ *   when it loses races with concurrent faulting or khugepaged. If those
+ *   retries are exhausted the handler returns -ERESTARTNOINTR via
+ *   restart_syscall(), which sets TIF_SIGPENDING so the return path runs
+ *   signal handling. madvise() is then transparently re-executed with the
+ *   same arguments, after any handler for a pending signal has run, unless
+ *   a fatal signal terminates the task first. The caller never observes an
+ *   errno from the restart itself and the call appears to make eventual
+ *   forward progress.
+ *
+ *   anon_vma_prepare() failures inside MADV_GUARD_INSTALL bypass the
+ *   ENOMEM-to-EAGAIN translation that applies to the VMA-flag-mutating
+ *   behaviors and surface as -ENOMEM directly.
+ *
+ *   Architecture note: alpha defines MADV_DONTNEED as 6 (not 4) and reserves
+ *   MADV_SPACEAVAIL=5; portable code must use the symbolic names from
+ *   <sys/mman.h>.
+ */
 SYSCALL_DEFINE3(madvise, unsigned long, start, size_t, len_in, int, behavior)
 {
 	return do_madvise(current->mm, start, len_in, behavior);
-- 
2.53.0


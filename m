Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.214.199
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794758470;
	b=UOF1e1U/a5QxQeyV7fY6dexEce6FgPRPs3t5qv/gXvF2rlTIlkZgLYpdu9QI2wOyx9aF
	 l2VoZWZ5GzNnpkQZQ1sUfwsUKtHEVmYEMPm/WtQRy9FsBVglVdCTVVZwPrCNz3NzKwLR2
	 URYOpqpNoKIVnqSEJzs3//xczhBBt/0e2IFrycicDJXwDVo8J2WbtMbN5RAmgp6IWdP2B
	 NbNAqqNLUcbfeJMTL8bjop3gEXod+DA/FgRCSYVFC5MHkLFewF2Evk+g6InKRBIt71B0c
	 3alF6BPV+qDqx9SsOOYmtcRc5mW9ZR0qm84JCVnQD05IS842t0nEIv9H3BA4vOYVo/Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794758470;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Received:Date:Mime-Version:
	 X-Mailer:Message-ID:Subject:From:To:Cc:Content-Type;
	bh=ibQv6e4ma9853gmSuuOGNJ4JeAgmIc7WO/anZOkJjs0=;
	b=iMC7nqdBQkeHybwl6EgLtwC6zJFsb2aDhg3xW43MWd4R6ePCPuWe7CZi+3RCYhB/gRcR
	 nALWwFBCs7Fnc+bvzpQZQuwUyH87d7VXK7ORJVkon9jWHnZd133Gzhwv3ZxIIqjt0pEmz
	 4LxKcCy2eviYlqpLFTsStGaPKD0KT/WwYpn74L6BhQ9YWH+fAuor7IcUEFTI4d4YnntwL
	 4h2PRuC3rooR1h5YGfaQk6dauhsZqZgFTSa3aDuD9c57EIQx4s90VodVrEwb5d2acQZR4
	 uGHnp9hB4Ty7+NenBT7BfSOpBTEsaK8pQfrCU26y4XQGwyUGcjIJf48ngZDgxvxrGxQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=google.com;
	spf=pass smtp.mailfrom=flex--jiaqiyan.bounces.google.com;
	dkim=pass header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b="JY/hNjv+";
	arc=none smtp.remote-ip=209.85.214.199
Received: from mail-pl1-f199.google.com (mail-pl1-f199.google.com [209.85.214.199])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 70D89606A31D
	for <linux-api@vger.kernel.org>; Sun, 15 Nov 2026 16:01:09 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 70D89606A31D
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--jiaqiyan.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=JY/hNjv+
Received: by mail-pl1-f199.google.com with SMTP id d9443c01a7336-2ee04c49451so37836545ad.2
        for <linux-api@vger.kernel.org>; Sun, 15 Nov 2026 08:01:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1794758469; x=1795363269; darn=vger.kernel.org;
        h=content-type:cc:to:from:subject:message-id:mime-version:date:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=ibQv6e4ma9853gmSuuOGNJ4JeAgmIc7WO/anZOkJjs0=;
        b=JY/hNjv+qVJeQ3su1ml/wlv9KEOYSg6JEju+WWPhOnIUah6TxBjn/EfzzyiHe9fwyJ
         mPlt0i4RCHI/oaLbAp7yBp0Z9aDnXNLbnUEAVyWBlN2AV2Ap9TqGbgxKXsLNqLqkjgnc
         4Zrr7IilNH2ok4aJnuI4zHHY3dz4CEJ92eB6dYOkGmxizTG7iAf5BzVgmGRF09SB1Jp+
         KCJu6qZm4GTrCdFIrAxAiJflBWhT/vK511ESFYW8MbO4C6DuH59QsFtUR1ZYK0CODwf+
         ZTc5mFFrUjmAq/yL6UZuscfDmRcuQJYMeSlVP8Yy5muYIxcluBFogttiHzd/brEGRn3y
         J75g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794758469; x=1795363269;
        h=content-type:cc:to:from:subject:message-id:mime-version:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=ibQv6e4ma9853gmSuuOGNJ4JeAgmIc7WO/anZOkJjs0=;
        b=QNRIZgVgw9jzey8qukDg5tavIogST4+ewgooTJTyHIPiIOhW/BBWYvU7G50dGgimfi
         5fp1Q+aJV+67VyqWcPD5s1lYG8OfAxaF949DvApUVnwhIP3Vmh18tfa/gp1WHtlkGC3h
         hr3NUd+rSBU77+8AFfEZwa0CqgifYV1UZC4Ym5sahm2o1Lzty5bsxXvxVoU5whwEfdj9
         zQbVwbcQjRJkBbZKx3TZiAO+atmy10CZsSEXDWWLKevLpBXygJjQsw10uzS7Dajis5Y9
         0suoyEvXVcQcpmuhgqH5dNnlF4FRzqERjtcqZEXMAkOmNJWMd2c2Jwx4V8UaKm64lGKW
         4Z6A==
X-Forwarded-Encrypted: i=1; AL+hErErxkV9unrU4OgM5fKUbNVbM3W+k4UxqPVPh3Mf+Gh4k8YUanqiMhdQDQgIwyASUTNvZa3PgKhx7xs=@vger.kernel.org
X-Gm-Message-State: APuU4Z8VCaGkTFXc2fURs/ECuaKnXt7Mtph7qbSiP2gDFDGVsWlZZgjc
	rjPigRWruEDQYF7bLmsnWo4zXjXxolBL0UHK27SL6qeOmFWYRkCO4zu4lnZ0dbMSArJ3hUAphFa
	8hty7noyyc6VGCw==
X-Received: from plhd18.prod.google.com ([2002:a17:903:2312:b0:2ed:aa39:f232])
 (user=jiaqiyan job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:903:22c3:b0:2e9:6788:9369 with SMTP id d9443c01a7336-2ee0dad1a75mr79804185ad.34.1794758468510;
 Sun, 15 Nov 2026 08:01:08 -0800 (PST)
Date: Sun, 15 Nov 2026 16:01:02 +0000
X-Mailing-List: linux-api@vger.kernel.org
List-Id: <linux-api.vger.kernel.org>
List-Post: <mailto:linux-api@vger.kernel.org>
List-Help: <mailto:linux-api+help@vger.kernel.org>
List-Subscribe: <mailto:linux-api+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-api+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-api+owner@vger.kernel.org>
Precedence: list
Mime-Version: 1.0
X-Mailer: git-send-email 2.56.0.611.g1030f0b940-goog
Message-ID: <20261115160105.2507650-1-jiaqiyan@google.com>
Subject: [PATCH v4 0/3] memfd-based Userspace MFR Policy for HugeTLB
From: Jiaqi Yan <jiaqiyan@google.com>
To: linmiaohe@huawei.com, muchun.song@linux.dev
Cc: nao.horiguchi@gmail.com, william.roche@oracle.com, ljs@kernel.org, 
	vbabka@kernel.org, tony.luck@intel.com, wangkefeng.wang@huawei.com, 
	willy@infradead.org, akpm@linux-foundation.org, osalvador@suse.de, 
	rientjes@google.com, duenwen@google.com, jthoughton@google.com, 
	jgg@nvidia.com, ankita@nvidia.com, peterx@redhat.com, 
	sidhartha.kumar@oracle.com, ziy@nvidia.com, skhan@linuxfoundation.org, 
	corbet@lwn.net, david@kernel.org, dave.hansen@linux.intel.com, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org, linux-api@vger.kernel.org, 
	linux-kselftest@vger.kernel.org, linux-doc@vger.kernel.org, 
	Jiaqi Yan <jiaqiyan@google.com>
Content-Type: text/plain; charset="UTF-8"

Note: I understand mm is in "firefighting mode" this cycle [6]
and prioritizes fixes over new features, so there is no rush on
this series. I'm happy to wait until things settle down, and can
rebase and resend if that's easier.

Problem
=======

This patchset is a follow-up for the userspace memory failure
recovery (MFR) policy proposed in [1] and [2], but focused on
a smaller scope: HugeTLB.

To recap the problem for HugeTLB discussed in [1] and [2]:
Cloud providers like Google and Oracle usually serve capacity-
and performance-critical guest memory with 1G HugeTLB
hugepages, as this significantly reduces the overhead
associated with managing page tables and TLB misses. However,
the kernel's current MFR behavior for HugeTLB is not ideal.
Once a byte of memory in a hugepage is hardware corrupted, the
kernel discards the whole hugepage, including the healthy
portion, from the HugeTLB system. Customer workload running in
the VM can hardly recover from such a great loss of memory.

[1] and [2] proposed the idea that the decision to keep or
discard a large chunk of contiguous memory exclusively owned
by a userspace process due to a recoverable uncorrected
memory error (UE) should be controlled by userspace. What this
means in the Cloud case is that, since a virtual machine
monitor (VMM) has taken host memory to exclusively back the
guest memory for a VM, the VMM can keep holding the memory
even after memory errors occur.

MFD_MF_KEEP_UE_MAPPED for HugeTLB
=================================

[2] proposed a solution centered around the memfd associated
with the memory exclusively owned by userspace.

A userspace process must opt into the MFD_MF_KEEP_UE_MAPPED
policy when it creates a new HugeTLB-backed memfd:

  #define MFD_MF_KEEP_UE_MAPPED	0x0020U
  int memfd_create(const char *name, unsigned int flags);

For any hugepage associated with the MFD_MF_KEEP_UE_MAPPED
enabled memfd, whenever it runs into a UE, MFR doesn't hard
offline the HWPoison huge folio. In other words, the
HWPoison memory remains accessible via the returned memfd
or the memory mapping created with that memfd. MFR still sends
SIGBUS to the userspace process as required, with si_addr_lsb
set to PAGE_SHIFT. MFR also still maintains HWPoison metadata
on the hugepage having the UE.

A HWPoison hugepage is dissolved once userspace truncates it
or punches a hole on it via the memfd, or the owning memfd is
finally released. Its healthy raw pages go back to the buddy
allocator, while its HWPoison raw pages are isolated.

MFD_MF_KEEP_UE_MAPPED works with MFD_ALLOW_SEALING, and file
seals work as usual. For example, the owner of a base image
can seal the memfd and then share it with MAP_PRIVATE. A
sealed memfd that blocks truncate and hole punch only
dissolves its HWPoison hugepage when it is finally released.

By default MFD_MF_KEEP_UE_MAPPED is not set, and MFR hard
offlines hugepages having UEs.

Implementation
==============

Part 1: When hugepages owned by an MFD_MF_KEEP_UE_MAPPED
enabled memfd run into a UE:

* MFR defers hard offline operations, i.e., unmapping and
  dissolving. MFR still sets the HWPoison flag, records the raw
  HWPoison page in the folio's raw_hwp_list, and sends SIGBUS
  to the consuming thread with si_addr_lsb reduced to
  PAGE_SHIFT. The result is reported as MF_DELAYED.

* MFR doesn't hold any refcount on the hugepage after
  memory_failure() returns; the page cache keeps the hugepage
  alive. Every memory_failure() on such a hugepage takes exactly
  one refcount, and me_huge_page() drops it. Since the 1st error
  clears the hugepage's migratable flag,
  get_huge_page_for_hwpoison() treats an already HWPoison
  hugepage of an MFD_MF_KEEP_UE_MAPPED memfd as in use, so that
  the 2nd and later errors are handled the same as the 1st.

* If the memory was not faulted in yet, the fault handler also
  allows faulting in the HWPoison folio.

Part 2: When an MFD_MF_KEEP_UE_MAPPED enabled memfd is being
released, or when a userspace process truncates or punches
holes in its hugepages:

* When the HugeTLB in-memory file system removes the filemap's
  folios one by one, it asks MFR to deal with HWPoison folios
  on the fly, implemented by filemap_offline_hwpoison_folio().

* MFR drops only the refcount taken by filemap_get_folios(), so
  that the HWPoison folio becomes free, then dissolves it.
  dissolve_free_hugetlb_folio() moves the HWPoison flags to the
  raw pages after restoring vmemmap, and with [4], only the
  healthy raw pages are freed to the buddy allocator. If the
  dissolve fails (e.g. someone else holds a refcount), the folio
  stays HWPoison and is never allocated from the HugeTLB pool
  again.

Limitation
==========

For a MAP_PRIVATE mapping of the memfd, the first write fault
anywhere in a HWPoison hugepage copies the whole hugepage, and
the copy consumes the UEs. With CONFIG_ARCH_HAS_COPY_MC, the
writer gets SIGBUS with si_addr_lsb of the hugepage size.

Dependency
==========

This patchset is based on mm-unstable commit 0ea6dc8c4a21
("fs/proc/task_mmu: fix lost maps entries above 2^63") with
v7 of [4] applied, which frees only the healthy pages of a
high-order folio having HWPoison pages.

Testing
=======

Tested with the new selftest hugetlb-mfr in patch 2/3, with

* HVO (hugetlb_optimize_vmemmap) on and off.
* 2M and 1G hugepages.
* errors injected with MADV_HWPOISON and hwpoison_inject's
  corrupt-pfn. corrupt-pfn covers the code paths in
  get_huge_page_for_hwpoison() that MADV_HWPOISON skips with
  MF_COUNT_INCREASED.
* hugepages released by truncation, and by closing a memfd
  sealed before and after injecting errors.

AI Disclosure
=============

I used an AI assistant (Antigravity with Claude) to review the
code and help debug, to reword the commit messages and this
cover letter, and to rewrite the selftest. Each patch has an
Assisted-by tag. I wrote the kernel code, and have reviewed and
tested everything in this patchset.

Changelog
=========

v4 -> v3 [5]

- Rebase onto mm-unstable commit 0ea6dc8c4a21
  ("fs/proc/task_mmu: fix lost maps entries above 2^63")
  with v7 of [4].

- Rework the refcount handling to address the issues pointed out
  by Miaohe Lin <linmiaohe@huawei.com> [7]. In v3, MFR held one
  refcount per raw HWPoison page, and dropped one refcount per
  raw_hwp_list entry when releasing the folio. This drops too
  many, since get_huge_page_for_hwpoison() takes at most one
  refcount per folio, and it may drop the refcount held by
  someone else. In v4:
  - MFR holds no refcount after memory_failure() returns.
    me_huge_page() drops the refcount taken by
    get_huge_page_for_hwpoison() or passed in with
    MF_COUNT_INCREASED. A folio under isolation is not HWPoison
    yet and has its migratable flag cleared, so memory_failure()
    neither takes a refcount on it nor reaches me_huge_page().
  - filemap_offline_hwpoison_folio() drops only the refcount
    taken by filemap_get_folios(). It returns whether it has
    consumed that refcount, so that remove_inode_hugepages()
    doesn't release it again.
  - get_huge_page_for_hwpoison() treats a HWPoison folio of an
    MFD_MF_KEEP_UE_MAPPED memfd as in use. Without this, the 2nd
    and later errors of a folio went to MF_HUGETLB_RETRY and
    ended up MF_IGNORED.

- Merge with hugetlb_update_hwpoison() from commit a148a2040191
  ("mm/memory-failure: fix missing ->mf_stats count in hugetlb poison").
  If hugetlb_update_hwpoison() sees a new raw HWPoison page in a
  kept-mapped folio, it returns MF_HUGETLB_IN_USED, so that
  try_memory_failure_hugetlb() handles the new error the same
  as the 1st one.

- Don't touch raw_hwp_list in filemap_offline_hwpoison_folio().

- hugetlbfs_error_remove_folio() returns MF_DELAYED for an
  MFD_MF_KEEP_UE_MAPPED memfd, so the result is reported as
  "Delayed" instead of "Recovered".

- Use folio_mapping() instead of folio->mapping.

- Remove the comment saying MFD_MF_KEEP_UE_MAPPED is not
  seal-able. Since MFR no longer holds refcounts, F_SEAL_WRITE
  can be added after a hugepage has UEs.

- Rewrite selftest hugetlb-mfr:
  - Set up and restore HugeTLB pages with hugepage_settings.h,
    and unpoison raw pages at the end, as suggested by William
    Roche <william.roche@oracle.com>.
  - Keep the nr_hwp_pages argument for debugging, but default to
    poisoning all 8 raw pages.
  - Add corrupt-pfn injection (the default) besides MADV_HWPOISON.
  - Add a seal mode that seals the memfd before and after injecting
    errors, and releases it by close.
  - Check HardwareCorrupted and KPF_HWPOISON of the raw pages.
  - Add it to run_vmtests.sh under the memory-failure category.
  - Keep it a separate test instead of folding into
    memory-failure.c as suggested by Miaohe Lin
    <linmiaohe@huawei.com>, because it needs its own HugeTLB
    setup and a multi-step memfd lifecycle.

- Document the MAP_PRIVATE copy-on-write limitation, hole punch,
  and how MFD_MF_KEEP_UE_MAPPED works with seals.

- Drop Tested-by and Reviewed-by from William and Jane Chu, since
  patches changed a lot.

v3 -> v2 [3]

- Rebase onto [4] to simplify filemap_offline_hwpoison_folio_hugetlb().
  With free_has_hwpoisoned() rejecting HWPoison subpages in a HugeTLB
  folio, there is no need to take_page_off_buddy() after
  dissolve_free_hugetlb_folio().

- Address comments from William Roche <william.roche@oracle.com> and
  Jane Chu <jane.chu@oracle.com>.

- Update size_shift in kill_accessing_process() if MFD_MF_KEEP_UE_MAPPED
  is enabled. Thanks William Roche <william.roche@oracle.com> for providing
  his patch on this.

- Add a new tunable to hugetlb-mfr to control the number of pages within
  the 1st hugepage to MADV_HWPOISON.

v2 -> v1 [2]

- Rebase onto commit 6da43bbeb6918 ("Merge tag 'vfio-v6.18-rc6' of
  https://github.com/awilliam/linux-vfio").

- Remove populate_memfd_hwp_folios() and offline_memfd_hwp_folios() so
  that no memory allocation is needed during releasing HWPoison memfd.

- Insert filemap_offline_hwpoison_folio() into remove_inode_single_folio().
  Now dissolving and offlining HWPoison huge folios is done on the fly.

- Fix the bug pointed out by William Roche <william.roche@oracle.com>:
  call take_page_off_buddy() no matter HWPoison page is buddy page or not.

- Remove update_per_node_mf_stats() when dissolve failed.

- Make hugetlb-mfr allocate 4 1G hugepages to cover new code introduced
  in remove_inode_hugepages().

- Make hugetlb-mfr support testing both 1GB and 2MB HugeTLB hugepages.

- Fix some typos in documentation.

[1] https://lwn.net/Articles/991513
[2] https://lore.kernel.org/lkml/20250118231549.1652825-1-jiaqiyan@google.com
[3] https://lore.kernel.org/linux-mm/20251116013223.1557158-3-jiaqiyan@google.com
[4] https://lore.kernel.org/linux-mm/20261110053331.2708996-1-jiaqiyan@google.com
[5] https://lore.kernel.org/linux-mm/20260203192352.2674184-1-jiaqiyan@google.com
[6] https://lore.kernel.org/linux-mm/a2f584f6-e382-4876-aa6d-d5a34de6ee59@kernel.org
[7] https://lore.kernel.org/linux-mm/5e0fc743-eb44-b69f-01a2-da7b6f2eca8d@huawei.com

Jiaqi Yan (3):
  mm: memfd/hugetlb: memfd-based userspace HugeTLB MFR policy
  selftests/mm: test userspace MFR for HugeTLB hugepage
  Documentation: add documentation for MFD_MF_KEEP_UE_MAPPED

 Documentation/userspace-api/index.rst         |   1 +
 .../userspace-api/mfd_mfr_policy.rst          |  81 ++
 fs/hugetlbfs/inode.c                          |  42 +-
 include/linux/pagemap.h                       |  24 +
 include/uapi/linux/memfd.h                    |   6 +
 mm/hugetlb.c                                  |   8 +-
 mm/memfd.c                                    |   9 +-
 mm/memory-failure.c                           | 119 ++-
 tools/testing/selftests/mm/Makefile           |   1 +
 tools/testing/selftests/mm/hugetlb-mfr.c      | 704 ++++++++++++++++++
 tools/testing/selftests/mm/run_vmtests.sh     |   1 +
 11 files changed, 977 insertions(+), 19 deletions(-)
 create mode 100644 Documentation/userspace-api/mfd_mfr_policy.rst
 create mode 100644 tools/testing/selftests/mm/hugetlb-mfr.c

-- 
2.56.0.611.g1030f0b940-goog


Received: from mail-pz2-f43.google.com (mail-pz2-f43.google.com [74.125.228.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C79E143E492
	for <linux-api@vger.kernel.org>; Mon, 14 Sep 2026 10:45:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.228.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789382720; cv=none; b=N763uLDZeHFGPrMXyFwIHp2uuRa5b9iTkOtg+bDNfJ9DjG2j45h5Dqo2R+a4wZFTptJZty2p4oAl62Ol7oRI1Fe7f7FLWQniQxyZMMLowuP2CDriZHmZJ9iV/CMGBNeDilh3CYO7+3iXbl8bG2S1pMrYExVMidTpYeCQE1if8iw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789382720; c=relaxed/simple;
	bh=e7vNYM+WHo2QHJFS+H0w5tDbhh5kApZbGem+B9fbWps=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=cvyoitmHRWb1lhdf7HKs2qtI5aeX4rK9zZpGedmbCALIrS78wOhO9JqE0L6OgWJ54APe6kLfYVuOUwZuTImcD33pGw01OqIANrH0pcc7265WoFkjiHjURaGOfzyE6bU2ITQOj7jddbC+HS52bMkuZOUR5+0ppzdtvMPxx9rUojA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Q/b4F+y1; arc=none smtp.client-ip=74.125.228.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Q/b4F+y1"
Received: by mail-pz2-f43.google.com with SMTP id d2e1a72fcca58-86b90133ae8so1442136b3a.1
        for <linux-api@vger.kernel.org>; Mon, 14 Sep 2026 03:45:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1789382712; x=1789987512; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=3m3SP6e9NrbIRaMkWtj1uZEt6uHgAf5jXfUplg45r+k=;
        b=Q/b4F+y1zaus5GPjXUMwdXQy5YzJ1u4dB/R/4Y7DzoUWAdypnZJ8DjopjVzVU+5/12
         L7xLQNnUjhvdsG0R5ZuaPoTVfz7nQ/+k/UeC7vo2OexscvKCKtW8UJRa4lFUo2uh2TNk
         zA/GEOuGWuq+wYpq6gEtqsei0TD9dn3RdyJhNLkfc4LSZADcShzrZiXqi16dG8tPeE5S
         /nz94xSXpug3PLyGfuovLmbIrD6cCNS/tCWy9PGjf4krVy83632LKQHstvslt5/Wpr6X
         rD/0H+HDpPvOI3Z8qSsI45b1P/85TdIq0YeHhvsVkGs8SDwn7XdPrV1EtctFTFwclo+N
         O7Bg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1789382712; x=1789987512;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=3m3SP6e9NrbIRaMkWtj1uZEt6uHgAf5jXfUplg45r+k=;
        b=ZgDpVGgJt2nGHr+iMjJmlbO46sWhwIkekQADNNzGWJ+CaloTfeGwW5EGL4ZUUmxlBQ
         XTdm5FG0debNdGeJZtA5jpxI+cXLUVIpdPYVsS5kLOYHGdisaKnc5oPuXP2IsxuNu6D8
         bMY9se3bL1L1JlEehgO8TIg7DszzKjfye3AQO8LDvSgH8N5EJyvxNFgAX6UJ9XnNfdih
         IiSusCMRiR+bGjqtM/gNrq/hQPIdhqghJuMYWTJuP5DOnmlY4d3GQWhyetbIdhjBeDYT
         TqJSiwxQtDgmkK1uY4K7JY1zJKAPoKzC2EDm0PD0230o6jjgOyHlp+1exICeemx8KPHr
         GUbA==
X-Forwarded-Encrypted: i=1; AKwUvBxZDVlxgflr206m/wexlR8T8wZuUJsncPs8J4Gg2Q/+jLMcoME/EZUoBJzE4zwRHipjGid5HG4+cOY=@vger.kernel.org
X-Gm-Message-State: AFuF++nXHq9V5Xtcrgf53trAxu6meIb4rn51W6hzw7dOwLKXnaG1/pX2
	fodkdoejEPGr/dhmfv93NXgDaTwDgygt1WFUeYlABhM+tK5Z0y6sO0gZ
X-Gm-Gg: AYBFou2E/Sd1reMoTAT5mFBK/+1eIBPPk8X0IpPrM+LSgLVzLq3YudXMof7MmIb8KCB
	kaLrHy/0hvVpovLmdw6SersHjCtmBcySqwPocAaBgsvFUv16Ad8GaAz3vfXonVgcb/8HBqa3fxq
	l7LhVFV16Q8WqHfB72ke3Ge0QhG1T8LEOqP9xyQKV72vXV3orNv/1ds7SF1cv/uSTZWrWQcNb/o
	ytwyGYxgcB+GiPCkvLdghF18quWhn7YWedO0nBT2+7Pv8FUbepkO+Bx0jFrfS/F72AgelE5i710
	bk2gaIXiWttQijugUlDuQNvlIptgIBURFz05CLCiFOca9ySKRVjdRZlffpZmxdhnNPb17CblVWz
	UG9nf0/1lVafqQoXIw6JyRFvyhJGQCOtM2Fh2orc14i1WFqrtT4TD9KKXIgx/rXXaCHXnDHvhc+
	LS0nHXhuk3HpbXVrAgWl+QidnUHth9YKU1fDhuBkcva/Qy69j4KS/YcWNOzj7EloZdvgFdY2feH
	JVWLt1+RSnorqSsYHLqu5oB/8Y8kvSLeCComrTdYnPjshWoUVZ5CMBHQeE8nrcO0aCoPn+3PjPC
	2f9kisMZYYtqiZ4Re/+OdYhzDgPcY93mWzt3R/fiz8JGiPlxuVqsWT4SDWhWh/A=
X-Received: by 2002:a05:6a00:21c2:b0:857:7384:b5fd with SMTP id d2e1a72fcca58-86f8737ced2mr3809414b3a.25.1789382712304;
        Mon, 14 Sep 2026 03:45:12 -0700 (PDT)
Received: from spider.bream-herring.ts.net ([103.252.203.158])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-86b28fd0e0dsm4234386b3a.26.2026.09.14.03.45.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 14 Sep 2026 03:45:11 -0700 (PDT)
From: Matthias Goergens <matthias.goergens@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Matthias Goergens <matthias.goergens@gmail.com>,
	Chris Li <chrisl@kernel.org>,
	Kairui Song <kasong@tencent.com>,
	Johannes Weiner <hannes@cmpxchg.org>,
	David Hildenbrand <david@kernel.org>,
	Michal Hocko <mhocko@kernel.org>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Kemeng Shi <shikemeng@huaweicloud.com>,
	Nhat Pham <nphamcs@gmail.com>,
	Yosry Ahmed <yosry@kernel.org>,
	Youngjun Park <youngjun.park@lge.com>,
	Baoquan He <baoquan.he@linux.dev>,
	Barry Song <baohua@kernel.org>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	cgroups@vger.kernel.org,
	linux-api@vger.kernel.org,
	Alejandro Colomar <alx@kernel.org>,
	linux-man@vger.kernel.org,
	Karel Zak <kzak@redhat.com>,
	util-linux@vger.kernel.org,
	Jani Nikula <jani.nikula@linux.intel.com>,
	Joonas Lahtinen <joonas.lahtinen@linux.intel.com>,
	Rodrigo Vivi <rodrigo.vivi@intel.com>,
	Tvrtko Ursulin <tursulin@ursulin.net>,
	David Airlie <airlied@gmail.com>,
	Simona Vetter <simona@ffwll.ch>,
	intel-gfx@lists.freedesktop.org,
	dri-devel@lists.freedesktop.org,
	"Rafael J . Wysocki" <rafael@kernel.org>,
	Pavel Machek <pavel@kernel.org>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	linux-pm@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	Shuah Khan <shuah@kernel.org>,
	linux-kselftest@vger.kernel.org
Subject: [RFC PATCH 0/3] mm/swap: reserve swap areas for deliberate offload
Date: Mon, 14 Sep 2026 18:44:58 +0800
Message-ID: <20260914104501.3960616-1-matthias.goergens@gmail.com>
X-Mailer: git-send-email 2.55.0
Precedence: bulk
X-Mailing-List: linux-api@vger.kernel.org
List-Id: <linux-api.vger.kernel.org>
List-Subscribe: <mailto:linux-api+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-api+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Some swap backends are useful for deliberate cold-page offload but are poor
dependencies for ordinary reclaim under acute memory pressure. Swap on ZFS
zvols is an existing example, with documented deadlocks under memory
pressure [3]. Compressed swap is another attractive target: accepting a
write may require memory for compression or storage even when logical swap
slots remain free.

This series adds an offload-only swap-area policy for such deployments,
alongside a conventional swap reserve for pressure reclaim.

Proactive offloading is already established by TMO/Senpai [4], which uses
pressure feedback to offload cold pages to compressed memory or SSDs.
DAMON_RECLAIM [5] also uses free-memory watermarks to suspend proactive
reclaim under severe pressure. These control when reclaim runs; this RFC
restricts which swap areas ordinary reclaim may write, including through
retained swap entries. The existing memory.zswap.writeback control [6]
restricts backing-swap writes per cgroup, rather than reserving individual
swap areas for explicitly admitted offload.

The minimum contract is that ordinary reclaim must not initiate a new,
non-zero backend write to an offload-only area. Reads, swapoff, zero-page
metadata, architecture preparation, and I/O that was already admitted remain
valid. If no eligible swap remains, existing reclaim and OOM behaviour applies.
This RFC does not promise a performance result or define a new workload policy.

Cgroup v2 memory.reclaim and per-node reclaim establish admission. Manual
MGLRU eviction currently does too, but its debugfs interface is not stable
ABI. Ordinary direct reclaim, kswapd, MADV_PAGEOUT and DAMON reclaim do not
gain access. This is an explicit operator policy; the kernel does not measure
physical headroom or automatically classify backends.

The three patches are based on mm-new as refreshed on 11 September, at
995829088503:

1. The complete swap-area policy, including eligible-capacity accounting and
   recovery of eligible cache entries.
2. zram03/zram04 coverage for reclaim routing, zswap bypass, discard policy
   and file workingset activation.
3. zram05 coverage for retained swap entries, including ordinary-write
   refusal, proactive recovery, data integrity and checked teardown.

The implementation is intended to make these questions reviewable:

1. Should pressure eligibility be a durable property activated with the
   physical swap area, or should it be selected late during backend migration?
2. Do provenance, allocation filtering, eligible capacity, and retained-entry
   refusal provide a useful minimum contract for userspace and controllers?
3. Is redirtying or activating a retained dirty folio, with possible churn or
   OOM, acceptable, or is backend migration a prerequisite?
4. How should persistent activation fail closed and remain auditable when
   /proc/swaps and swapon --show do not expose the policy?
5. Should an ineligible fast-path cluster be invalidated immediately, and
   should an offload-only area recover its own cache entries based on eligible
   fullness rather than global swap fullness?
6. Should the workingset activation heuristic continue to count offload-only
   capacity when pressure reclaim cannot allocate from it?

Build checks passed on x86 with i915 built-in or modular, and with swap or
memory cgroups disabled. The affected arm64 MTE objects also compiled.

The routing and workingset tests passed in x86 QEMU guests. In the
retained-entry test, ordinary reclaim wrote nothing to offload-only swap;
proactive reclaim then wrote the dirty folio, and all data verified
correctly. With the write guard removed, the same test failed because
ordinary reclaim wrote to the offload-only area.

Persistent fstab encoding remains unsettled. When hibernation is about to
save an image, an active offload-only area named by resume= is rejected as
the image target with -ENODEV. Virtual Swap Space v4 [1] separates swap
entries from their physical backing, while swap tiers v10 [2] proposes
per-cgroup backend selection. These raise the question of whether offload
eligibility belongs to physical swap areas or a later placement decision;
this RFC does not assume those interfaces are settled.

An explicit-only util-linux companion implementing swapon --offload-only
is prepared for separate submission.

Feedback on the eligibility contract, its placement in the swap stack,
and the unresolved ABI and reclaim-policy questions would be welcome.

[1] https://patchew.org/linux/20260825153238.2695446-1-nphamcs@gmail.com/
[2] https://patchew.org/linux/20260713025644.170839-1-youngjun.park@lge.com/
[3] https://openzfs.github.io/openzfs-docs/Project%20and%20Community/FAQ.html#using-a-zvol-for-a-swap-device-on-linux
[4] https://engineering.fb.com/2022/06/20/data-infrastructure/transparent-memory-offloading-more-memory-at-a-fraction-of-the-cost-and-power/
[5] https://www.kernel.org/doc/html/latest/admin-guide/mm/damon/reclaim.html
[6] https://www.kernel.org/doc/html/latest/admin-guide/mm/zswap.html

Matthias Goergens (3):
  mm: restrict offload-only swap to proactive reclaim
  selftests: zram: cover offload-only swap policy
  selftests: zram: cover retained offload-only entries

 Documentation/mm/swap.rst                     |  87 ++++
 drivers/gpu/drm/i915/gem/i915_gem_shrinker.c  |   2 +-
 .../gpu/drm/i915/gem/selftests/huge_pages.c   |   6 +-
 drivers/gpu/drm/msm/msm_gem_shrinker.c        |   2 +-
 drivers/gpu/drm/panthor/panthor_gem.c         |   2 +-
 drivers/gpu/drm/ttm/ttm_backup.c              |   2 +-
 drivers/gpu/drm/xe/tests/xe_bo.c              |   2 +-
 include/linux/swap.h                          |  29 +-
 include/linux/vm_event_item.h                 |   1 +
 mm/memcontrol.c                               |  20 +-
 mm/page_io.c                                  |  24 +-
 mm/swapfile.c                                 | 126 +++++-
 mm/vmscan.c                                   |  31 +-
 mm/vmstat.c                                   |   1 +
 tools/testing/selftests/zram/.gitignore       |   2 +
 tools/testing/selftests/zram/Makefile         |   4 +-
 tools/testing/selftests/zram/config           |  10 +-
 tools/testing/selftests/zram/swap_offload.c   | 402 ++++++++++++++++++
 .../selftests/zram/workingset_offload.c       | 206 +++++++++
 tools/testing/selftests/zram/zram03.sh        | 166 ++++++++
 tools/testing/selftests/zram/zram04.sh        | 149 +++++++
 tools/testing/selftests/zram/zram05.sh        | 360 ++++++++++++++++
 tools/testing/selftests/zram/zram_lib.sh      |  28 ++
 23 files changed, 1620 insertions(+), 42 deletions(-)
 create mode 100644 tools/testing/selftests/zram/swap_offload.c
 create mode 100644 tools/testing/selftests/zram/workingset_offload.c
 create mode 100755 tools/testing/selftests/zram/zram03.sh
 create mode 100755 tools/testing/selftests/zram/zram04.sh
 create mode 100755 tools/testing/selftests/zram/zram05.sh


base-commit: 9958290885035431e2494159f555e332c3c14906
-- 
2.55.0


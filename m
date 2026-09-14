Received: from mail-pz2-f12.google.com (mail-pz2-f12.google.com [74.125.228.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2BA6C43F4B1
	for <linux-api@vger.kernel.org>; Mon, 14 Sep 2026 10:45:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.228.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789382747; cv=none; b=WaLL/2I42s7DRLZ90BhiDupKKRjGoqXNOvrLP36xw8hC62DJ9sWIB52MDgHP7uUVTlCixS3ySMlwZh+GuBSKNegiB+0nytjBBgPH2SzOGm48396DoptzwJHnrIzCVuFRvP++1zdqMwoD+S93WNrIUQH+dH7BhEgqv9OKxe6JfdQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789382747; c=relaxed/simple;
	bh=Irxx7peQ928WhvoWSB0sFKds108WeJyWG0FxPLGjWuM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Srtldnp8LA4z7d4SWb4pBWM/kAnO6oICUNXLmvhcWEIIIjgv+/XCOdxsZ8PTplYHEuxts/lb3OdkYwT+klS9yDdGL6qcgXO52D0Aqbt+33uUD0lsA7Ty+kJYX2ut6vOBWcFNw8YauEZOkCjmPO3g5zey8aHqN4fu4dRMCS7Kd9U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=mz+Xfnpf; arc=none smtp.client-ip=74.125.228.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="mz+Xfnpf"
Received: by mail-pz2-f12.google.com with SMTP id d2e1a72fcca58-8693af0d7c4so2435089b3a.3
        for <linux-api@vger.kernel.org>; Mon, 14 Sep 2026 03:45:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1789382728; x=1789987528; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=D8VW5W+UzT0ktmX9k+Qun+Nqem9Z8cI3ixM8qiW4isQ=;
        b=mz+Xfnpfe8W/ttvoiNt8QefPoBGiACo+bXFxVhsG+/I36gEBnxnjtcQctw+lAynQT7
         9WzNqnPXLdHsN9xr/LTkmL3qxj+gDI+fyDDeeEafFvflL4/BbNs2SAWyGPgw1wAmuiEm
         +uOcDseyo0clDYMAmHjeGEQChZm0l+eqYrsW/8xQky1vrERCcr5AcyDmplp2E94lti88
         n12VVg+4Lo9nQHAVBiog9K+aM1E/pcCe8gbiyF8mP0CTzTdSw8HVnxblDKNRYfpAPQ0S
         O4YU8J4VA47vs44PTNqWDZsHD2qJIzuwFpIkv6y7TZfHNcC+3EenbW8fQQ+lz9RfKHcN
         pBsw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1789382728; x=1789987528;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=D8VW5W+UzT0ktmX9k+Qun+Nqem9Z8cI3ixM8qiW4isQ=;
        b=fNfa7wd05nC5kv4wz7dm1PvYaqpM7YVydLrdC2ozhUwOTDoIvtC122kGJMxRqEC7gN
         INzw1Z8AnUdrC0XUhOCYfSDhPWRk1gsNbGY1gr603FUP3eLhub5Kt+pAt+RQJGfX5olQ
         wUS/ZeSP1JAbduJsB3Au0uTH+q6fiR3jZ9pZGcnpNHtQiLixox5NRx4WUDpGGcaHEZrf
         6LesJ9WDTJAClNFcPnoQA7SgSfnXx6Djim6YNhbdVdbbxr9wsbnGo3o2IiAwkJvvoYof
         qByPGUV+w3z5RtwMx981ZV5dW0iQypavQz9GW9t+dd7leR/A8h2RYUhC97e6orlwHXYL
         zeJA==
X-Forwarded-Encrypted: i=1; AKwUvBybHFqEi5M/Pbbz768r2lwKNkAMDkWTSpsSxCuGmS2wNYBm/r8CnXfMYRiKRafYqzfISS7dbleCVfI=@vger.kernel.org
X-Gm-Message-State: AFuF++nCXNME/aESLjAH3r1WGOB5JeEpA2DxtJ+aX7dnQSvdAK9VFFeE
	Mh5iaF41tOiO5QBlndytsdCrWEw/TYtvIn9vBLpD9ZehTXOz9UWfuiBm
X-Gm-Gg: AYBFou3tgIidyj1+0hRSVQcPAANLkY5Q8YpjlY6q888W0BU59pOeMKbGbmJP868JvC2
	D81KTTUqpbfeVNfT0ye4qB6n0YLcQQ4Z7IiqbnBMGKWRpeVMeEMGmbAelN2nfz87vucly5aQrof
	jtNSwR/MlCiEOEKqcXgBKdMcbCFYRqykGbBUzqEIKuaDs2chSp7dFLJQQFtRy403SI/O6OhdOCE
	pRznAMzljekJYceOHeRE4gMpFJECjhXIzNrPRo6uXiKVDFNH7ySDZAHu+gwIuQioKQtLhn+nK6C
	7LhtzjXt+3YUOkp80b7dex425M8jHES9iYEAP/pkhQ4cNNMvjo67/ft+1GwF8Tmo4QHv6gwr1q+
	6/UoMFCLSNYwmIxrGXioweGznp1F7vmG6CP0XVpT6yCkWGyUm6dqMyT4P3Purr1g8HG60DseVSO
	P5QW5tSlJYF2sgTbf0q/o7y6tBwZ2GRzQYt7EQq4nDfkiN77wU70L3krf8acSbIESdEi8Y480Qv
	S48+qghDa/fgeaLDara3xs+u0oWrLMdXfyAAkeCcHXODe8PAAwZ8CixK0tKmz9b475JYztcL/GG
	hp9nb5A/UlupcL8tf0BGGu178sWaT/I/E/h3iUtzHaARY1KoJwPtQmwxdCVPkhLBNkFx36yD7Q=
	=
X-Received: by 2002:a05:6a00:35c8:b0:857:72ba:ff0d with SMTP id d2e1a72fcca58-86f85ce3d75mr5244316b3a.21.1789382727833;
        Mon, 14 Sep 2026 03:45:27 -0700 (PDT)
Received: from spider.bream-herring.ts.net ([103.252.203.158])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-86b28fd0e0dsm4234386b3a.26.2026.09.14.03.45.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 14 Sep 2026 03:45:27 -0700 (PDT)
From: Matthias Goergens <matthias.goergens@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Matthias Goergens <matthias.goergens@gmail.com>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@kernel.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Shuah Khan <shuah@kernel.org>,
	Randy Dunlap <rdunlap@infradead.org>,
	Jani Nikula <jani.nikula@linux.intel.com>,
	Joonas Lahtinen <joonas.lahtinen@linux.intel.com>,
	Rodrigo Vivi <rodrigo.vivi@intel.com>,
	Tvrtko Ursulin <tursulin@ursulin.net>,
	David Airlie <airlied@gmail.com>,
	Simona Vetter <simona@ffwll.ch>,
	Rob Clark <robin.clark@oss.qualcomm.com>,
	Dmitry Baryshkov <lumag@kernel.org>,
	Abhinav Kumar <abhinav.kumar@linux.dev>,
	Jessica Zhang <jesszhan0024@gmail.com>,
	Sean Paul <sean@poorly.run>,
	Marijn Suijten <marijn.suijten@somainline.org>,
	Boris Brezillon <boris.brezillon@collabora.com>,
	Steven Price <steven.price@arm.com>,
	Liviu Dudau <liviu.dudau@arm.com>,
	Maarten Lankhorst <maarten.lankhorst@linux.intel.com>,
	Maxime Ripard <mripard@kernel.org>,
	Thomas Zimmermann <tzimmermann@suse.de>,
	Christian Koenig <christian.koenig@amd.com>,
	Huang Rui <ray.huang@amd.com>,
	Matthew Auld <matthew.auld@intel.com>,
	Matthew Brost <matthew.brost@intel.com>,
	=?UTF-8?q?Thomas=20Hellstr=C3=B6m?= <thomas.hellstrom@linux.intel.com>,
	Chris Li <chrisl@kernel.org>,
	Kairui Song <kasong@tencent.com>,
	Kemeng Shi <shikemeng@huaweicloud.com>,
	Nhat Pham <nphamcs@gmail.com>,
	Baoquan He <baoquan.he@linux.dev>,
	Barry Song <baohua@kernel.org>,
	Youngjun Park <youngjun.park@lge.com>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Muchun Song <muchun.song@linux.dev>,
	Qi Zheng <qi.zheng@linux.dev>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Yuanchu Xie <yuanchu@google.com>,
	Wei Xu <weixugc@google.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	linux-mm@kvack.org,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	intel-gfx@lists.freedesktop.org,
	dri-devel@lists.freedesktop.org,
	linux-arm-msm@vger.kernel.org,
	freedreno@lists.freedesktop.org,
	intel-xe@lists.freedesktop.org,
	cgroups@vger.kernel.org,
	linux-api@vger.kernel.org,
	linux-man@vger.kernel.org,
	"Rafael J . Wysocki" <rafael@kernel.org>,
	Pavel Machek <pavel@kernel.org>,
	linux-pm@vger.kernel.org,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	linux-arm-kernel@lists.infradead.org,
	Yosry Ahmed <yosry@kernel.org>,
	Chengming Zhou <chengming.zhou@linux.dev>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Alejandro Colomar <alx@kernel.org>,
	Karel Zak <kzak@redhat.com>,
	util-linux@vger.kernel.org
Subject: [RFC PATCH 1/3] mm: restrict offload-only swap to proactive reclaim
Date: Mon, 14 Sep 2026 18:44:59 +0800
Message-ID: <20260914104501.3960616-2-matthias.goergens@gmail.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260914104501.3960616-1-matthias.goergens@gmail.com>
References: <20260914104501.3960616-1-matthias.goergens@gmail.com>
Precedence: bulk
X-Mailing-List: linux-api@vger.kernel.org
List-Id: <linux-api.vger.kernel.org>
List-Subscribe: <mailto:linux-api+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-api+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Some swap backends need memory to accept writes, making them useful for
deliberate cold-page offload but unsuitable dependencies for reclaim under
acute memory pressure.

Add SWAP_FLAG_OFFLOAD_ONLY to reserve a swap area for explicitly admitted
reclaim. Cgroup v2 memory.reclaim, per-node reclaim and manual MGLRU
eviction establish admission; ordinary reclaim cannot initiate new,
non-zero backend writes to the area.

Keep admission separate from scan_control.proactive so future proactive
callers do not inherit it accidentally. The MGLRU debugfs interface is
not stable ABI.

Filter swap allocation and reclaim capacity by eligibility, including
cached clusters and recovery of unused conventional swap-cache entries.
Preserve physical free-space reporting and workingset accounting.

Allocation filtering alone is insufficient: a partially swapped-in large
folio can retain its swap entry and reach writeout without allocating a
new slot. Refuse such ordinary-reclaim writes by redirtying and activating
the folio. Preserve architecture metadata before refusal, since sibling
faults can restore swap-indexed tags into the resident folio.

Bypass zswap and reject asynchronous page-cluster discard so later writes
cannot escape the admitting context. Exclude marked areas from hibernation
selection. Reads, swapoff and queued or in-flight I/O remain unaffected.

Refusing retained-entry writes can cause repeated reclaim or OOM; moving
these entries to conventional swap would require swap-entry migration.

Signed-off-by: Matthias Goergens <matthias.goergens@gmail.com>
---
 Documentation/mm/swap.rst                     |  87 ++++++++++++
 drivers/gpu/drm/i915/gem/i915_gem_shrinker.c  |   2 +-
 .../gpu/drm/i915/gem/selftests/huge_pages.c   |   6 +-
 drivers/gpu/drm/msm/msm_gem_shrinker.c        |   2 +-
 drivers/gpu/drm/panthor/panthor_gem.c         |   2 +-
 drivers/gpu/drm/ttm/ttm_backup.c              |   2 +-
 drivers/gpu/drm/xe/tests/xe_bo.c              |   2 +-
 include/linux/swap.h                          |  29 +++-
 include/linux/vm_event_item.h                 |   1 +
 mm/memcontrol.c                               |  20 ++-
 mm/page_io.c                                  |  24 +++-
 mm/swapfile.c                                 | 126 ++++++++++++++++--
 mm/vmscan.c                                   |  31 +++--
 mm/vmstat.c                                   |   1 +
 14 files changed, 296 insertions(+), 39 deletions(-)

diff --git a/Documentation/mm/swap.rst b/Documentation/mm/swap.rst
index 78819bd4d745..7d5bbd65e616 100644
--- a/Documentation/mm/swap.rst
+++ b/Documentation/mm/swap.rst
@@ -3,3 +3,90 @@
 ====
 Swap
 ====
+
+Offload-only swap areas
+-----------------------
+
+``SWAP_FLAG_OFFLOAD_ONLY`` marks a swap area as a destination for explicit
+userspace proactive reclaim.  The stable qualifying interfaces are cgroup v2
+``memory.reclaim`` and ``/sys/devices/system/node/nodeX/reclaim``.  The swap
+allocator excludes such an area from kswapd, direct reclaim, and other
+pressure-driven swap allocation.  Normal swap priority ordering still applies
+among the areas eligible for the current reclaim context.
+
+The MGLRU debugfs eviction interface currently establishes the same internal
+proactive-reclaim provenance and can therefore use an offload-only area.
+Debugfs is not a stable userspace ABI, however, so that behaviour is not part
+of this interface's permanent contract.
+
+This permits a system to combine a small conventional swap area, which is
+engineered for forward progress in emergency reclaim, with a larger or more
+complex area used for ordinary cold-page offload.  For example, the latter may
+be RAM-compressed or may use a filesystem with compression, checksums, or
+redundancy.  Making every such write path safe in direct reclaim can require
+backend-specific reserves, preallocation, non-blocking allocation, and
+recursion rules.  Excluding new pressure-reclaim writes can reduce that
+requirement and its complexity.
+
+For a RAM-compressed area such as zram, unused logical slots also do not imply
+that enough physical memory remains to store their future contents.  Static
+swap priority cannot express that distinction or provide late fallback after a
+selected area's write fails.
+
+The policy is attached to an activated swap area, not to its underlying
+physical storage.  A raw swap partition and a filesystem swapfile on the same
+device are separate areas and may use different policies.  The kernel does not
+infer this policy from the block driver, filesystem, or swap priority.
+
+This is a reclaim-provenance policy, not a measurement of current memory
+headroom.  Userspace should only request proactive offload while its own
+watermark or PSI policy considers memory pressure low.
+
+DAMON reclaim and ``MADV_PAGEOUT`` do not currently establish the proactive
+reclaim context, so they cannot allocate slots from an offload-only area.
+Offload-only areas are also ineligible for hibernation image allocation.
+
+Offload-only areas bypass zswap stores.  Zswap writeback may run after the
+proactive context which selected the slot has ended, so admitting the folio to
+zswap would otherwise defer the backend write beyond that context.  The
+hierarchical cgroup v2 ``memory.zswap.writeback=0`` policy remains
+authoritative: when zswap is enabled, it also refuses direct proactive writes
+to an offload-only area.  Marking an area offload-only does not override a
+cgroup policy which disables all swapping attempts to devices.
+
+The flag controls both allocation of new swap slots and newly initiated
+non-zero backend writes.  A folio can retain its swap entry after swapin.  If
+ordinary reclaim later tries to rewrite such an offload-only entry, the VM
+redirties and activates the folio instead; proactive reclaim may retry the
+write.  Zero-filled folios may still update the in-memory swap zeromap without
+backend I/O.
+
+The flag does not prevent reads, swapoff, or writes which are already queued or
+in flight.  It therefore does not by itself provide a forward progress
+guarantee for an I/O path which allocates memory: earlier writes must still be
+able to complete, and reads must remain reclaim-safe.  Repeatedly refusing
+retained-entry writes can also reduce reclaim efficiency and lead to OOM while
+the dirty folios remain resident.
+
+Page-cluster discard is incompatible with an offload-only area because its
+work item can run after the context which freed the entries has ended.  Swapon
+therefore rejects a resolved page-cluster discard policy combined with
+``SWAP_FLAG_OFFLOAD_ONLY``.  Swapon-time discard is permitted because it
+completes synchronously during activation.  The existing discard precedence
+still applies: requesting both discard-once and discard-pages selects
+discard-once.  Discard requests which the swap area does not support remain
+ignored.
+
+Architecture-specific swap metadata preparation still runs before a retained
+write is refused, so that metadata remains coherent with the dirty resident
+folio.  This policy controls swap-backend I/O; it does not promise that core VM
+or architecture preparation performs no allocation.
+
+``/proc/vmstat`` reports ``swpout_offload_refused`` in base pages.  The counter
+advances when ordinary reclaim refuses a newly initiated write through a
+retained offload-only entry.  It can reveal repeated activation of such folios,
+but it is not a count of skipped areas during new-slot allocation.
+
+An offload-only area should therefore be configured with a reclaim-safe swap
+area as fallback.  If no eligible swap space remains, swap allocation fails
+and the existing reclaim and OOM policy applies.
diff --git a/drivers/gpu/drm/i915/gem/i915_gem_shrinker.c b/drivers/gpu/drm/i915/gem/i915_gem_shrinker.c
index e0d1f369a163..b58e61f15ab1 100644
--- a/drivers/gpu/drm/i915/gem/i915_gem_shrinker.c
+++ b/drivers/gpu/drm/i915/gem/i915_gem_shrinker.c
@@ -21,7 +21,7 @@
 
 static bool swap_available(void)
 {
-	return get_nr_swap_pages() > 0;
+	return get_nr_swap_pages_eligible() > 0;
 }
 
 static bool can_release_pages(struct drm_i915_gem_object *obj)
diff --git a/drivers/gpu/drm/i915/gem/selftests/huge_pages.c b/drivers/gpu/drm/i915/gem/selftests/huge_pages.c
index 44718e728291..73b62b065510 100644
--- a/drivers/gpu/drm/i915/gem/selftests/huge_pages.c
+++ b/drivers/gpu/drm/i915/gem/selftests/huge_pages.c
@@ -1895,8 +1895,8 @@ static int igt_shrink_thp(void *arg)
 	i915_gem_context_unlock_engines(ctx);
 	/*
 	 * Nuke everything *before* we unpin the pages so we can be reasonably
-	 * sure that when later checking get_nr_swap_pages() that some random
-	 * leftover object doesn't steal the remaining swap space.
+	 * sure that when later checking get_nr_swap_pages_eligible() that some
+	 * random leftover object doesn't steal the remaining swap space.
 	 */
 	i915_gem_shrink(NULL, i915, -1UL, NULL,
 			I915_SHRINK_BOUND |
@@ -1910,7 +1910,7 @@ static int igt_shrink_thp(void *arg)
 	 * Now that the pages are *unpinned* shrinking should invoke
 	 * shmem to truncate our pages, if we have available swap.
 	 */
-	should_swap = get_nr_swap_pages() > 0;
+	should_swap = get_nr_swap_pages_eligible() > 0;
 	i915_gem_shrink(NULL, i915, -1UL, NULL,
 			I915_SHRINK_BOUND |
 			I915_SHRINK_UNBOUND |
diff --git a/drivers/gpu/drm/msm/msm_gem_shrinker.c b/drivers/gpu/drm/msm/msm_gem_shrinker.c
index 9d2788f79ace..da6a66b747b0 100644
--- a/drivers/gpu/drm/msm/msm_gem_shrinker.c
+++ b/drivers/gpu/drm/msm/msm_gem_shrinker.c
@@ -21,7 +21,7 @@ module_param(enable_eviction, bool, 0600);
 
 static bool can_swap(void)
 {
-	return enable_eviction && get_nr_swap_pages() > 0;
+	return enable_eviction && get_nr_swap_pages_eligible() > 0;
 }
 
 static bool can_block(struct shrink_control *sc)
diff --git a/drivers/gpu/drm/panthor/panthor_gem.c b/drivers/gpu/drm/panthor/panthor_gem.c
index 72908be5e144..23488f417cf7 100644
--- a/drivers/gpu/drm/panthor/panthor_gem.c
+++ b/drivers/gpu/drm/panthor/panthor_gem.c
@@ -1371,7 +1371,7 @@ panthor_dummy_bo_create(struct panthor_device *ptdev)
 
 static bool can_swap(void)
 {
-	return get_nr_swap_pages() > 0;
+	return get_nr_swap_pages_eligible() > 0;
 }
 
 static bool can_block(struct shrink_control *sc)
diff --git a/drivers/gpu/drm/ttm/ttm_backup.c b/drivers/gpu/drm/ttm/ttm_backup.c
index 0c2d53a13b2a..bf9d41bdf652 100644
--- a/drivers/gpu/drm/ttm/ttm_backup.c
+++ b/drivers/gpu/drm/ttm/ttm_backup.c
@@ -206,7 +206,7 @@ u64 ttm_backup_bytes_avail(void)
 	 * number also depends on shmem actually swapping out backed-up
 	 * shmem objects without too much buffering.
 	 */
-	return (u64)get_nr_swap_pages() << PAGE_SHIFT;
+	return (u64)get_nr_swap_pages_eligible() << PAGE_SHIFT;
 }
 EXPORT_SYMBOL_GPL(ttm_backup_bytes_avail);
 
diff --git a/drivers/gpu/drm/xe/tests/xe_bo.c b/drivers/gpu/drm/xe/tests/xe_bo.c
index 6a17e13d58cf..14d6bb8e41c9 100644
--- a/drivers/gpu/drm/xe/tests/xe_bo.c
+++ b/drivers/gpu/drm/xe/tests/xe_bo.c
@@ -695,7 +695,7 @@ static int shrink_test_run_device(struct xe_device *xe)
 	}
 	to_alloc = ram * 2;
 
-	ram_and_swap = ram + get_nr_swap_pages() * PAGE_SIZE;
+	ram_and_swap = ram + get_nr_swap_pages_eligible() * PAGE_SIZE;
 	if (to_alloc > ram_and_swap)
 		purgeable = to_alloc - ram_and_swap;
 	purgeable += div64_u64(purgeable, 5);
diff --git a/include/linux/swap.h b/include/linux/swap.h
index 78974da6810e..75350c450c47 100644
--- a/include/linux/swap.h
+++ b/include/linux/swap.h
@@ -21,10 +21,11 @@
 #define SWAP_FLAG_DISCARD	0x10000 /* enable discard for swap */
 #define SWAP_FLAG_DISCARD_ONCE	0x20000 /* discard swap area at swapon-time */
 #define SWAP_FLAG_DISCARD_PAGES 0x40000 /* discard page-clusters after use */
+#define SWAP_FLAG_OFFLOAD_ONLY  0x80000 /* only use for proactive reclaim */
 
 #define SWAP_FLAGS_VALID	(SWAP_FLAG_PRIO_MASK | SWAP_FLAG_PREFER | \
 				 SWAP_FLAG_DISCARD | SWAP_FLAG_DISCARD_ONCE | \
-				 SWAP_FLAG_DISCARD_PAGES)
+				 SWAP_FLAG_DISCARD_PAGES | SWAP_FLAG_OFFLOAD_ONLY)
 /*
  * MAX_SWAPFILES defines the maximum number of swaptypes: things which can
  * be swapped to.  The swap type and the offset into that swap type are
@@ -140,12 +141,20 @@ union swap_header {
 struct reclaim_state {
 	/* pages reclaimed outside of LRU-based reclaim */
 	unsigned long reclaimed;
+	/* this reclaim context may use offload-only swap */
+	bool allow_offload_swap;
 #ifdef CONFIG_LRU_GEN
 	/* per-thread mm walk data */
 	struct lru_gen_mm_walk *mm_walk;
 #endif
 };
 
+static inline bool current_reclaim_allows_offload_swap(void)
+{
+	return current->reclaim_state &&
+	       current->reclaim_state->allow_offload_swap;
+}
+
 /*
  * mm_account_reclaimed_pages(): account reclaimed pages outside of LRU-based
  * reclaim
@@ -201,6 +210,7 @@ enum {
 	SWP_STABLE_WRITES = (1 << 11),	/* no overwrite PG_writeback pages */
 	SWP_SYNCHRONOUS_IO = (1 << 12),	/* synchronous IO is efficient */
 	SWP_HIBERNATION = (1 << 13),	/* pinned for hibernation */
+	SWP_OFFLOAD_ONLY = (1 << 14),	/* proactive-reclaim swap only */
 					/* add others here before... */
 };
 
@@ -389,6 +399,9 @@ static inline long get_nr_swap_pages(void)
 	return atomic_long_read(&nr_swap_pages);
 }
 
+long get_nr_swap_pages_eligible(void);
+bool folio_swap_full(struct folio *folio);
+
 extern void si_swapinfo(struct sysinfo *);
 extern int pin_hibernation_swap_type(dev_t device, sector_t offset);
 extern void unpin_hibernation_swap_type(int type);
@@ -443,10 +456,16 @@ static inline void put_swap_device(struct swap_info_struct *si)
 }
 
 #define get_nr_swap_pages()			0L
+#define get_nr_swap_pages_eligible()		0L
 #define total_swap_pages			0L
 #define total_swapcache_pages()			0UL
 #define vm_swap_full()				0
 
+static inline bool folio_swap_full(struct folio *folio)
+{
+	return false;
+}
+
 #define si_swapinfo(val) \
 	do { (val)->freeswap = (val)->totalswap = 0; } while (0)
 #define free_folio_and_swap_cache(folio) \
@@ -531,6 +550,7 @@ static inline void mem_cgroup_uncharge_swap(unsigned short id, unsigned int nr_p
 
 long mem_cgroup_get_folio_swap_margin(struct folio *folio);
 extern long mem_cgroup_get_nr_swap_pages(struct mem_cgroup *memcg);
+long mem_cgroup_get_nr_swap_pages_eligible(struct mem_cgroup *memcg);
 extern bool mem_cgroup_swap_full(struct folio *folio);
 #else
 static inline int mem_cgroup_try_charge_swap(struct folio *folio)
@@ -553,9 +573,14 @@ static inline long mem_cgroup_get_nr_swap_pages(struct mem_cgroup *memcg)
 	return get_nr_swap_pages();
 }
 
+static inline long mem_cgroup_get_nr_swap_pages_eligible(struct mem_cgroup *memcg)
+{
+	return get_nr_swap_pages_eligible();
+}
+
 static inline bool mem_cgroup_swap_full(struct folio *folio)
 {
-	return vm_swap_full();
+	return folio_swap_full(folio);
 }
 #endif
 
diff --git a/include/linux/vm_event_item.h b/include/linux/vm_event_item.h
index 2628ccda076a..fc8458b314a5 100644
--- a/include/linux/vm_event_item.h
+++ b/include/linux/vm_event_item.h
@@ -32,6 +32,7 @@
 	HIGHMEM_ZONE(xx) xx##_MOVABLE, DEVICE_ZONE(xx)
 
 enum vm_event_item { PGPGIN, PGPGOUT, PSWPIN, PSWPOUT,
+		SWPOUT_OFFLOAD_REFUSED,
 		FOR_ALL_ZONES(PGALLOC)
 		FOR_ALL_ZONES(ALLOCSTALL)
 		FOR_ALL_ZONES(PGSCAN_SKIP)
diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 1460cba53588..1412084d2f43 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -6002,16 +6002,28 @@ void __mem_cgroup_uncharge_swap(unsigned short id, unsigned int nr_pages)
 	rcu_read_unlock();
 }
 
-long mem_cgroup_get_nr_swap_pages(struct mem_cgroup *memcg)
+static long
+mem_cgroup_get_nr_swap_pages_with_limit(struct mem_cgroup *memcg,
+					long nr_swap_pages)
 {
-	long nr_swap_pages = get_nr_swap_pages();
-
 	if (!mem_cgroup_disabled() && !do_memsw_account())
 		nr_swap_pages = min(nr_swap_pages, page_counter_margin(&memcg->swap));
 
 	return nr_swap_pages;
 }
 
+long mem_cgroup_get_nr_swap_pages(struct mem_cgroup *memcg)
+{
+	return mem_cgroup_get_nr_swap_pages_with_limit(memcg,
+			get_nr_swap_pages());
+}
+
+long mem_cgroup_get_nr_swap_pages_eligible(struct mem_cgroup *memcg)
+{
+	return mem_cgroup_get_nr_swap_pages_with_limit(memcg,
+			get_nr_swap_pages_eligible());
+}
+
 /**
  * mem_cgroup_get_folio_swap_margin - get a folio's memcg swap margin
  * @folio: folio whose memcg margin is queried
@@ -6042,7 +6054,7 @@ bool mem_cgroup_swap_full(struct folio *folio)
 
 	VM_BUG_ON_FOLIO(!folio_test_locked(folio), folio);
 
-	if (vm_swap_full())
+	if (folio_swap_full(folio))
 		return true;
 	if (do_memsw_account() || !folio_memcg_charged(folio))
 		return ret;
diff --git a/mm/page_io.c b/mm/page_io.c
index 1da4ff484f09..1b281a1d6df0 100644
--- a/mm/page_io.c
+++ b/mm/page_io.c
@@ -203,6 +203,7 @@ static void swap_zeromap_folio_clear(struct folio *folio)
  */
 int swap_writeout(struct swap_io_ctx *ctx, struct folio *folio)
 {
+	struct swap_info_struct *sis = __swap_entry_to_info(folio->swap);
 	int ret = 0;
 
 	if (folio_free_swap(folio))
@@ -210,7 +211,9 @@ int swap_writeout(struct swap_io_ctx *ctx, struct folio *folio)
 
 	/*
 	 * Arch code may have to preserve more data than just the folio
-	 * contents, e.g. memory tags.
+	 * contents, e.g. memory tags.  Do this before refusing a retained
+	 * offload-only entry below: a later sibling swap-PTE fault can restore
+	 * swap-indexed metadata into this resident folio.
 	 */
 	ret = arch_prepare_to_swap(folio);
 	if (ret) {
@@ -228,6 +231,18 @@ int swap_writeout(struct swap_io_ctx *ctx, struct folio *folio)
 		goto out_unlock;
 	}
 
+	/*
+	 * A folio can retain an existing swap entry after swapin.  Do not let
+	 * ordinary reclaim use an offload-only entry through that path.
+	 */
+	if ((READ_ONCE(sis->flags) & SWP_OFFLOAD_ONLY) &&
+	    !current_reclaim_allows_offload_swap()) {
+		count_vm_events(SWPOUT_OFFLOAD_REFUSED,
+				folio_nr_pages(folio));
+		folio_mark_dirty(folio);
+		return AOP_WRITEPAGE_ACTIVATE;
+	}
+
 	/*
 	 * Clear bits this folio occupies in the zeromap to prevent zero data
 	 * being read in from any previous zero writes that occupied the same
@@ -235,7 +250,12 @@ int swap_writeout(struct swap_io_ctx *ctx, struct folio *folio)
 	 */
 	swap_zeromap_folio_clear(folio);
 
-	if (zswap_store(folio)) {
+	/*
+	 * Zswap writeback can happen much later from pressure reclaim or its
+	 * shrinker workqueue.  Do not let it defer an offload-only backend write
+	 * beyond the proactive reclaim context which admitted the swap slot.
+	 */
+	if (!(READ_ONCE(sis->flags) & SWP_OFFLOAD_ONLY) && zswap_store(folio)) {
 		count_mthp_stat(folio_order(folio), MTHP_STAT_ZSWPOUT);
 		goto out_unlock;
 	}
diff --git a/mm/swapfile.c b/mm/swapfile.c
index 280dd906eb18..256617059f30 100644
--- a/mm/swapfile.c
+++ b/mm/swapfile.c
@@ -65,13 +65,17 @@ static void move_cluster(struct swap_info_struct *si,
  */
 static DEFINE_SPINLOCK(swap_lock);
 static unsigned int nr_swapfiles;
-atomic_long_t nr_swap_pages;
 /*
  * Some modules use swappable objects and may try to swap them out under
  * memory pressure (via the shrinker). Before doing so, they may wish to
  * check to see if any swap space is available.
+ *
+ * This remains the raw free-space counter for accounting users. Reclaim
+ * decisions subtract nr_swap_pages_offload_only below when necessary.
  */
+atomic_long_t nr_swap_pages;
 EXPORT_SYMBOL_GPL(nr_swap_pages);
+static atomic_long_t nr_swap_pages_offload_only;
 /* protected with swap_lock. reading in vm_swap_full() doesn't need lock */
 long total_swap_pages;
 #define DEF_SWAP_PRIO  -1
@@ -120,6 +124,7 @@ atomic_t nr_rotate_swap = ATOMIC_INIT(0);
 struct percpu_swap_cluster {
 	struct swap_info_struct *si[SWAP_NR_ORDERS];
 	unsigned long offset[SWAP_NR_ORDERS];
+	bool allow_offload_swap[SWAP_NR_ORDERS];
 	local_lock_t lock;
 };
 
@@ -163,6 +168,31 @@ static long swap_usage_in_pages(struct swap_info_struct *si)
 	return atomic_long_read(&si->inuse_pages) & SWAP_USAGE_COUNTER_MASK;
 }
 
+static bool swap_area_needs_reclaim(struct swap_info_struct *si)
+{
+	if (vm_swap_full())
+		return true;
+
+	/*
+	 * Free offload-only slots must not keep a full conventional area
+	 * pinned in swapcache.  Recover that area's unused cache entries
+	 * even when the raw pool is not full.  This is independent of the
+	 * current task: proactive reclaim can fill the conventional area too.
+	 */
+	return !(READ_ONCE(si->flags) & SWP_OFFLOAD_ONLY) &&
+		atomic_long_read(&nr_swap_pages_offload_only) > 0 &&
+		swap_usage_in_pages(si) == si->pages;
+}
+
+/* The caller must hold the lock on a folio in swapcache. */
+bool folio_swap_full(struct folio *folio)
+{
+	VM_WARN_ON_FOLIO(!folio_test_locked(folio), folio);
+	VM_WARN_ON_FOLIO(!folio_test_swapcache(folio), folio);
+
+	return swap_area_needs_reclaim(__swap_entry_to_info(folio->swap));
+}
+
 /* Reclaim the swap entry anyway if possible */
 #define TTRS_ANYWAY		0x1
 /*
@@ -903,7 +933,7 @@ static bool cluster_scan_range(struct swap_info_struct *si,
 		if (swp_tb_is_null(swp_tb))
 			continue;
 		if (swp_tb_is_folio(swp_tb) && !__swp_tb_get_count(swp_tb)) {
-			if (!vm_swap_full())
+			if (!swap_area_needs_reclaim(si))
 				return false;
 			*need_reclaim = true;
 			continue;
@@ -1014,6 +1044,8 @@ static unsigned int alloc_swap_scan_cluster(struct swap_info_struct *si,
 	if (si->flags & SWP_SOLIDSTATE) {
 		this_cpu_write(percpu_swap_cluster.offset[order], next);
 		this_cpu_write(percpu_swap_cluster.si[order], si);
+		this_cpu_write(percpu_swap_cluster.allow_offload_swap[order],
+			       current_reclaim_allows_offload_swap());
 	} else {
 		si->global_cluster->next[order] = next;
 	}
@@ -1161,7 +1193,7 @@ static unsigned long cluster_alloc_swap_entry(struct swap_info_struct *si,
 	}
 
 	/* Try reclaim full clusters if free and nonfull lists are drained */
-	if (vm_swap_full())
+	if (swap_area_needs_reclaim(si))
 		swap_reclaim_full_clusters(si, false);
 
 	if (order < PMD_ORDER) {
@@ -1315,9 +1347,11 @@ static void swap_range_alloc(struct swap_info_struct *si,
 			     unsigned int nr_entries)
 {
 	if (swap_usage_add(si, nr_entries)) {
-		if (vm_swap_full())
+		if (swap_area_needs_reclaim(si))
 			schedule_work(&si->reclaim_work);
 	}
+	if (si->flags & SWP_OFFLOAD_ONLY)
+		atomic_long_sub(nr_entries, &nr_swap_pages_offload_only);
 	atomic_long_sub(nr_entries, &nr_swap_pages);
 }
 
@@ -1346,6 +1380,8 @@ static void swap_range_free(struct swap_info_struct *si, unsigned long offset,
 	 * only after the above cleanups are done.
 	 */
 	smp_wmb();
+	if (si->flags & SWP_OFFLOAD_ONLY)
+		atomic_long_add(nr_entries, &nr_swap_pages_offload_only);
 	atomic_long_add(nr_entries, &nr_swap_pages);
 	swap_usage_sub(si, nr_entries);
 }
@@ -1366,6 +1402,31 @@ static bool get_swap_device_info(struct swap_info_struct *si)
 	return true;
 }
 
+static bool swap_area_eligible(struct swap_info_struct *si)
+{
+	if (!(READ_ONCE(si->flags) & SWP_OFFLOAD_ONLY))
+		return true;
+
+	return current_reclaim_allows_offload_swap();
+}
+
+long get_nr_swap_pages_eligible(void)
+{
+	long nr_pages;
+
+	if (current_reclaim_allows_offload_swap())
+		return get_nr_swap_pages();
+
+	/*
+	 * The reads are intentionally unpaired.  This is a capacity hint; the
+	 * allocator enforces eligibility.  Clamp a transient negative result.
+	 */
+	nr_pages = get_nr_swap_pages() -
+		   atomic_long_read(&nr_swap_pages_offload_only);
+	return max(nr_pages, 0L);
+}
+EXPORT_SYMBOL_GPL(get_nr_swap_pages_eligible);
+
 /*
  * Fast path try to get swap entries with specified order from current
  * CPU's swap entry pool (a cluster).
@@ -1385,6 +1446,20 @@ static bool swap_alloc_fast(struct folio *folio)
 	offset = this_cpu_read(percpu_swap_cluster.offset[order]);
 	if (!si || !offset || !get_swap_device_info(si))
 		return false;
+	if (!swap_area_eligible(si)) {
+		put_swap_device(si);
+		return false;
+	}
+	/*
+	 * Pressure reclaim may cache a lower-priority conventional area while
+	 * an offload-only area is ineligible.  Drop that cache on a context
+	 * change so proactive reclaim returns to the normal priority search.
+	 */
+	if (this_cpu_read(percpu_swap_cluster.allow_offload_swap[order]) !=
+	    current_reclaim_allows_offload_swap()) {
+		put_swap_device(si);
+		return false;
+	}
 
 	ci = swap_cluster_lock(si, offset);
 	if (cluster_is_usable(ci, order)) {
@@ -1407,6 +1482,9 @@ static void swap_alloc_slow(struct folio *folio)
 	spin_lock(&swap_avail_lock);
 start_over:
 	plist_for_each_entry_safe(si, next, &swap_avail_head, avail_list) {
+		if (!swap_area_eligible(si))
+			continue;
+
 		/* Rotate the device and switch to a new cluster */
 		plist_requeue(&si->avail_list, &swap_avail_head);
 		spin_unlock(&swap_avail_lock);
@@ -1450,7 +1528,8 @@ static bool swap_sync_discard(void)
 	plist_for_each_entry_safe(si, next, &swap_active_head, list) {
 		spin_unlock(&swap_lock);
 		if (get_swap_device_info(si)) {
-			if (si->flags & SWP_PAGE_DISCARD)
+			if (swap_area_eligible(si) &&
+			    (si->flags & SWP_PAGE_DISCARD))
 				ret = swap_do_scheduled_discard(si);
 			put_swap_device(si);
 		}
@@ -1738,8 +1817,8 @@ static int swap_dup_entries_cluster(struct swap_info_struct *si,
  *
  * Context: Caller needs to hold the folio lock.
  * Return: %0 on success, %-E2BIG if splitting the folio might allow swapout,
- * %-ENOSPC if no global swap space is available, or %-ENOMEM if splitting
- * would not help.
+ * %-ENOSPC if no global swap space is eligible for the caller, or %-ENOMEM
+ * if splitting would not help.
  */
 int folio_alloc_swap(struct folio *folio)
 {
@@ -1790,7 +1869,7 @@ int folio_alloc_swap(struct folio *folio)
 	return 0;
 
 failed:
-	if (get_nr_swap_pages() <= 0)
+	if (get_nr_swap_pages_eligible() <= 0)
 		return -ENOSPC;
 	if (mem_cgroup_get_folio_swap_margin(folio) <= 0)
 		return -ENOMEM;
@@ -2180,7 +2259,7 @@ swp_entry_t swap_alloc_hibernation_slot(int type)
 	struct swap_cluster_info *ci;
 	swp_entry_t entry = {0};
 
-	if (!si)
+	if (!si || (si->flags & SWP_OFFLOAD_ONLY))
 		goto fail;
 
 	/*
@@ -2247,7 +2326,8 @@ static int __find_hibernation_swap_type(dev_t device, sector_t offset)
 	for (type = 0; type < nr_swapfiles; type++) {
 		struct swap_info_struct *sis = swap_info[type];
 
-		if (!(sis->flags & SWP_WRITEOK))
+		if (!(sis->flags & SWP_WRITEOK) ||
+		    (sis->flags & SWP_OFFLOAD_ONLY))
 			continue;
 
 		if (device == sis->bdev->bd_dev) {
@@ -2434,7 +2514,8 @@ int find_first_swap(dev_t *device)
 	for (type = 0; type < nr_swapfiles; type++) {
 		struct swap_info_struct *sis = swap_info[type];
 
-		if (!(sis->flags & SWP_WRITEOK))
+		if (!(sis->flags & SWP_WRITEOK) ||
+		    (sis->flags & SWP_OFFLOAD_ONLY))
 			continue;
 		*device = sis->bdev->bd_dev;
 		spin_unlock(&swap_lock);
@@ -2474,7 +2555,8 @@ unsigned int count_swap_pages(int type, int free)
 		struct swap_info_struct *sis = swap_info[type];
 
 		spin_lock(&sis->lock);
-		if (sis->flags & SWP_WRITEOK) {
+		if ((sis->flags & SWP_WRITEOK) &&
+		    !(sis->flags & SWP_OFFLOAD_ONLY)) {
 			n = sis->pages;
 			if (free)
 				n -= swap_usage_in_pages(sis);
@@ -3083,6 +3165,8 @@ static int setup_swap_extents(struct swap_info_struct *sis,
 
 static void _enable_swap_info(struct swap_info_struct *si)
 {
+	if (si->flags & SWP_OFFLOAD_ONLY)
+		atomic_long_add(si->pages, &nr_swap_pages_offload_only);
 	atomic_long_add(si->pages, &nr_swap_pages);
 	total_swap_pages += si->pages;
 
@@ -3231,6 +3315,8 @@ SYSCALL_DEFINE1(swapoff, const char __user *, specialfile)
 	spin_lock(&p->lock);
 	del_from_avail_list(p, true);
 	plist_del(&p->list, &swap_active_head);
+	if (p->flags & SWP_OFFLOAD_ONLY)
+		atomic_long_sub(p->pages, &nr_swap_pages_offload_only);
 	atomic_long_sub(p->pages, &nr_swap_pages);
 	total_swap_pages -= p->pages;
 	spin_unlock(&p->lock);
@@ -3727,7 +3813,6 @@ SYSCALL_DEFINE2(swapon, const char __user *, specialfile, int, swap_flags)
 
 	if (swap_flags & ~SWAP_FLAGS_VALID)
 		return -EINVAL;
-
 	if (!capable(CAP_SYS_ADMIN))
 		return -EPERM;
 
@@ -3841,6 +3926,9 @@ SYSCALL_DEFINE2(swapon, const char __user *, specialfile, int, swap_flags)
 	if (error)
 		goto bad_swap_unlock_inode;
 
+	if (swap_flags & SWAP_FLAG_OFFLOAD_ONLY)
+		si->flags |= SWP_OFFLOAD_ONLY;
+
 	if ((swap_flags & SWAP_FLAG_DISCARD) &&
 	    si->bdev && bdev_max_discard_sectors(si->bdev)) {
 		/*
@@ -3863,6 +3951,18 @@ SYSCALL_DEFINE2(swapon, const char __user *, specialfile, int, swap_flags)
 		else if (swap_flags & SWAP_FLAG_DISCARD_PAGES)
 			si->flags &= ~SWP_AREA_DISCARD;
 
+		/*
+		 * Cluster discard can run later from discard_work, after the
+		 * context which freed the entries has ended.  Swapon-time discard
+		 * is explicit and synchronous, but page discard cannot honour
+		 * offload provenance.
+		 */
+		if ((si->flags & SWP_OFFLOAD_ONLY) &&
+		    (si->flags & SWP_PAGE_DISCARD)) {
+			error = -EINVAL;
+			goto bad_swap_unlock_inode;
+		}
+
 		/* issue a swapon-time discard if it's still required */
 		if (si->flags & SWP_AREA_DISCARD) {
 			int err = discard_swap(si);
diff --git a/mm/vmscan.c b/mm/vmscan.c
index aaceed4759ee..0633feb5d88b 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -123,6 +123,9 @@ struct scan_control {
 	/* Proactive reclaim invoked by userspace */
 	unsigned int proactive:1;
 
+	/* This reclaim context may use offload-only swap */
+	unsigned int allow_offload_swap:1;
+
 	/*
 	 * Cgroup memory below memory.low is protected as long as we
 	 * don't threaten to OOM. If any cgroup is reclaimed at
@@ -291,14 +294,18 @@ static inline bool is_exec_file_folio(const struct folio *folio,
 }
 
 static void set_task_reclaim_state(struct task_struct *task,
-				   struct reclaim_state *rs)
+				   struct scan_control *sc)
 {
+	struct reclaim_state *rs = sc ? &sc->reclaim_state : NULL;
+
 	/* Check for an overwrite */
 	WARN_ON_ONCE(rs && task->reclaim_state);
 
 	/* Check for the nulling of an already-nulled member */
 	WARN_ON_ONCE(!rs && !task->reclaim_state);
 
+	if (rs)
+		rs->allow_offload_swap = sc->allow_offload_swap;
 	task->reclaim_state = rs;
 }
 
@@ -418,7 +425,7 @@ static inline bool can_reclaim_anon_pages(struct mem_cgroup *memcg,
 		 * And under GFP_NOIO, is there enough swapcached anon to make
 		 * scanning anon worthwhile?
 		 */
-		if (get_nr_swap_pages() > 0 &&
+		if (get_nr_swap_pages_eligible() > 0 &&
 		    !reclaimable_anon_is_low(memcg, nid, sc))
 			return true;
 	} else {
@@ -426,7 +433,7 @@ static inline bool can_reclaim_anon_pages(struct mem_cgroup *memcg,
 		 * Is the memcg below its swap limit, and under GFP_NOIO does
 		 * it have enough swapcached anon to make scanning worthwhile?
 		 */
-		if (mem_cgroup_get_nr_swap_pages(memcg) > 0 &&
+		if (mem_cgroup_get_nr_swap_pages_eligible(memcg) > 0 &&
 		    !reclaimable_anon_is_low(memcg, nid, sc))
 			return true;
 	}
@@ -2853,7 +2860,7 @@ static int get_swappiness(struct lruvec *lruvec, struct scan_control *sc)
 		return 0;
 
 	if (!can_demote(pgdat->node_id, sc, memcg) &&
-	    mem_cgroup_get_nr_swap_pages(memcg) < MIN_LRU_BATCH)
+	    mem_cgroup_get_nr_swap_pages_eligible(memcg) < MIN_LRU_BATCH)
 		return 0;
 
 	return swappiness;
@@ -5926,6 +5933,7 @@ static ssize_t lru_gen_seq_write(struct file *file, const char __user *src,
 		.reclaim_idx = MAX_NR_ZONES - 1,
 		.gfp_mask = GFP_KERNEL,
 		.proactive = true,
+		.allow_offload_swap = true,
 	};
 
 	buf = kvmalloc(len + 1, GFP_KERNEL);
@@ -5937,7 +5945,7 @@ static ssize_t lru_gen_seq_write(struct file *file, const char __user *src,
 		return -EFAULT;
 	}
 
-	set_task_reclaim_state(current, &sc.reclaim_state);
+	set_task_reclaim_state(current, &sc);
 	flags = memalloc_noreclaim_save();
 	blk_start_plug(&plug);
 	if (!set_mm_walk(NULL, true)) {
@@ -6941,7 +6949,7 @@ unsigned long try_to_free_pages(struct zonelist *zonelist, int order,
 	if (throttle_direct_reclaim(sc.gfp_mask, zonelist, nodemask))
 		return 1;
 
-	set_task_reclaim_state(current, &sc.reclaim_state);
+	set_task_reclaim_state(current, &sc);
 	trace_mm_vmscan_direct_reclaim_begin(sc.gfp_mask, order, NULL);
 
 	nr_reclaimed = do_try_to_free_pages(zonelist, &sc);
@@ -6974,6 +6982,8 @@ unsigned long try_to_free_mem_cgroup_pages(struct mem_cgroup *memcg,
 		.may_unmap = 1,
 		.may_swap = !!(reclaim_options & MEMCG_RECLAIM_MAY_SWAP),
 		.proactive = !!(reclaim_options & MEMCG_RECLAIM_PROACTIVE),
+		.allow_offload_swap =
+			!!(reclaim_options & MEMCG_RECLAIM_PROACTIVE),
 	};
 	/*
 	 * Traverse the ZONELIST_FALLBACK zonelist of the current node to put
@@ -6982,7 +6992,7 @@ unsigned long try_to_free_mem_cgroup_pages(struct mem_cgroup *memcg,
 	 */
 	struct zonelist *zonelist = node_zonelist(numa_node_id(), sc.gfp_mask);
 
-	set_task_reclaim_state(current, &sc.reclaim_state);
+	set_task_reclaim_state(current, &sc);
 	trace_mm_vmscan_memcg_reclaim_begin(sc.gfp_mask, 0, memcg);
 	noreclaim_flag = memalloc_noreclaim_save();
 
@@ -7272,7 +7282,7 @@ static int balance_pgdat(pg_data_t *pgdat, int order, int highest_zoneidx)
 
 	trace_mm_vmscan_balance_pgdat_begin(pgdat->node_id, order,
 					    highest_zoneidx);
-	set_task_reclaim_state(current, &sc.reclaim_state);
+	set_task_reclaim_state(current, &sc);
 	psi_memstall_enter(&pflags);
 	__fs_reclaim_acquire(_THIS_IP_);
 
@@ -7769,7 +7779,7 @@ unsigned long shrink_all_memory(unsigned long nr_to_reclaim)
 
 	fs_reclaim_acquire(sc.gfp_mask);
 	noreclaim_flag = memalloc_noreclaim_save();
-	set_task_reclaim_state(current, &sc.reclaim_state);
+	set_task_reclaim_state(current, &sc);
 
 	nr_reclaimed = do_try_to_free_pages(zonelist, &sc);
 
@@ -7950,7 +7960,7 @@ static unsigned long __node_reclaim(struct pglist_data *pgdat,
 	 * We need to be able to allocate from the reserves for RECLAIM_UNMAP
 	 */
 	noreclaim_flag = memalloc_noreclaim_save();
-	set_task_reclaim_state(p, &sc->reclaim_state);
+	set_task_reclaim_state(p, sc);
 
 	do {
 		shrink_node(pgdat, sc);
@@ -8136,6 +8146,7 @@ int user_proactive_reclaim(char *buf,
 				.may_unmap = 1,
 				.may_swap = 1,
 				.proactive = 1,
+				.allow_offload_swap = 1,
 			};
 
 			if (test_and_set_bit_lock(PGDAT_RECLAIM_LOCKED,
diff --git a/mm/vmstat.c b/mm/vmstat.c
index a3e809c57f29..b924c715886e 100644
--- a/mm/vmstat.c
+++ b/mm/vmstat.c
@@ -1331,6 +1331,7 @@ const char * const vmstat_text[] = {
 	[I(PGPGOUT)]				= "pgpgout",
 	[I(PSWPIN)]				= "pswpin",
 	[I(PSWPOUT)]				= "pswpout",
+	[I(SWPOUT_OFFLOAD_REFUSED)]		= "swpout_offload_refused",
 
 #define OFF (NR_VM_ZONE_STAT_ITEMS + NR_VM_NUMA_EVENT_ITEMS + \
 	     NR_VM_NODE_STAT_ITEMS + NR_VM_STAT_ITEMS)
-- 
2.55.0


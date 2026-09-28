Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 14872315D58
	for <linux-api@vger.kernel.org>; Mon, 28 Sep 2026 00:19:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790554777; cv=none; b=lB3PPauDO7jWofEk3ABDDDuCioGgb7d294IOxlsw+u3jK5drTAcnQURJmrme3Vxk/IcLhNLu5SakT2whI+fGExeSXXPCIXxSwvzmO5JPvG9HTQIgO7sceyrML6XCYTnO1x9INhg4XmlEE7huUXjRampH525h2mvG/y5gtRvDf5U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790554777; c=relaxed/simple;
	bh=HEgF2P+1+y5g+ATlOPzavhWaPRyRERUoCblxXCR8tVk=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=HKmFSqFuaKI9sqgrgRCbpb3YlFbkj3zcpDHDyFDZLIMeqnoYqOmRH+VfpHee4s5vIaHRxBuO9AreRIXdJ8JwrAzjQAcA/dYdyhtJvnuf+cjRx9nbPeFuAfdGuoEme+yeykudyEPC/QDKH3rA3gqKzckz3QM5uIuOLeg8wsE5HVw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Q8TZD+Kc; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Q8TZD+Kc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BDB9E1F00899
	for <linux-api@vger.kernel.org>; Mon, 28 Sep 2026 00:19:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790554771;
	bh=QP6xyVeWK0fjKYOX13CdCHacAmA58q94pWWFU7WezpA=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=Q8TZD+KcqH7MAX6dUpS/JSAVMhLxLCz/zKjss7NWuWteWhn4UPDXrNDTw4/3wJkzu
	 s0A7Sjr9iUneoZmNMS6n41xk58hMloD6szVNGTpPcNlvLwtWtHe1zI1SpzYUY71fs0
	 euQ8yCgYZj0M5Pn++1NUZ+XhF4WZhkFhpQxcN3QLWTc78ucAx0zfGa9u1CwhoSql9K
	 MMJlEK18oXfl81axHE7227Mf2OPzIvDCuz0iKyckAoqhel+s+dk+sHdJIY8Yzng8LM
	 4ct4VucEoZlYQzCkk6Ywu0aMBNgxbDnfAC8Wi+uM/UaM0qE8+qPddtXDjHc6Y7OXR+
	 CnAKxfVBpSEAw==
Received: by mail-ej2-f43.google.com with SMTP id a640c23a62f3a-c2af876539fso233439866b.2
        for <linux-api@vger.kernel.org>; Sun, 27 Sep 2026 17:19:31 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AKwUvBxfTqUk4I0w1pU8vcgL3bH/6Ylomw8+Fv/OIZbLsQQSIbGy5QKVaTKK+Awm+oezi67r3VC8ia+Dt6M=@vger.kernel.org
X-Gm-Message-State: AFuF++kWbNh3h8/FJ+ekK3Iewa5+69L8ztB9p8fq//9D7f8UdV8gUYd3
	xsB6AnNmTcwaodMEqBbhjbxOgypjnUMle7t9du/XQLq0ql/VeNBgpwoD+HNAirMHyQbMxTOel3i
	XSeEZ6RLTMGYR6gD6Oc6FTujbEjq0zekcDDKHuMC98w==
X-Received: by 2002:a17:907:3f91:b0:c21:450d:cd88 with SMTP id
 a640c23a62f3a-c2ae979e5eamr638636266b.6.1790554770310; Sun, 27 Sep 2026
 17:19:30 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-api@vger.kernel.org
List-Id: <linux-api.vger.kernel.org>
List-Subscribe: <mailto:linux-api+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-api+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260926045517.3458413-1-matthias.goergens@gmail.com>
In-Reply-To: <20260926045517.3458413-1-matthias.goergens@gmail.com>
From: Chris Li <chrisl@kernel.org>
Date: Sun, 27 Sep 2026 14:19:18 -1000
X-Gmail-Original-Message-ID: <CACePvbWM8kMjtJbH4vc6Qt=TBZQ-0d-Yj9NOtkepZmtNN3wd9w@mail.gmail.com>
X-Gm-Features: AclHuK_Emqiw5PPDnEui2wzXu2lByLHdjYDOsTY-4bLEBoChvn9DrfIUdVmpewI
Message-ID: <CACePvbWM8kMjtJbH4vc6Qt=TBZQ-0d-Yj9NOtkepZmtNN3wd9w@mail.gmail.com>
Subject: Re: [RFC PATCH v2 0/4] mm/swap: reserve swap areas for deliberate offload
To: Matthias Goergens <matthias.goergens@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Kairui Song <kasong@tencent.com>, 
	Johannes Weiner <hannes@cmpxchg.org>, David Hildenbrand <david@kernel.org>, Michal Hocko <mhocko@kernel.org>, 
	Shakeel Butt <shakeel.butt@linux.dev>, Kemeng Shi <shikemeng@huaweicloud.com>, 
	Nhat Pham <nphamcs@gmail.com>, Yosry Ahmed <yosry@kernel.org>, 
	Youngjun Park <youngjun.park@lge.com>, Baoquan He <baoquan.he@linux.dev>, 
	Barry Song <baohua@kernel.org>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	cgroups@vger.kernel.org, linux-api@vger.kernel.org, 
	Alejandro Colomar <alx@kernel.org>, linux-man@vger.kernel.org, Karel Zak <kzak@redhat.com>, 
	util-linux@vger.kernel.org, Jani Nikula <jani.nikula@linux.intel.com>, 
	Joonas Lahtinen <joonas.lahtinen@linux.intel.com>, Rodrigo Vivi <rodrigo.vivi@intel.com>, 
	Tvrtko Ursulin <tursulin@ursulin.net>, David Airlie <airlied@gmail.com>, 
	Simona Vetter <simona@ffwll.ch>, intel-gfx@lists.freedesktop.org, 
	dri-devel@lists.freedesktop.org, "Rafael J . Wysocki" <rafael@kernel.org>, 
	Pavel Machek <pavel@kernel.org>, Catalin Marinas <catalin.marinas@arm.com>, 
	Will Deacon <will@kernel.org>, linux-pm@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, Shuah Khan <shuah@kernel.org>, 
	linux-kselftest@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Sep 25, 2026 at 6:55=E2=80=AFPM Matthias Goergens
<matthias.goergens@gmail.com> wrote:
>
> This RFC adds offload-only swap areas for deliberate cold-page offload to
> backends unsuitable for pressure reclaim. ZFS zvol swap has documented
> deadlocks under memory pressure [3]; compressed swap is another target
> because writes may need memory despite free logical slots.

What is the high-level user-visible impact of this series?

I am curious: if we never run out of swap file space on the
non-offload swap area, does that mean we don't need this patch series?

The series discusses proactive reclaim and direct reclaim. The
offload-only swap area is for proactive reclaim. However, direct
reclaim can use both types of swap areas. Wouldn't using the
non-offload case cause memory allocation which you want to avoid?

I was wondering if we should actually flip things around. Mark the
type of swap device that avoids memory allocation during swap out.
Then direct reclaim prioritizes using those.That would make the happy
path allocate less memory during direct reclaim. Right now this series
does not seem to guarantee that direct reclaim stays away from the
area that allocates memory.

Chris

>
> Explicit proactive reclaim can use these areas alongside conventional
> swap, ordered by priority. Ordinary reclaim cannot initiate non-zero
> writes to them, including through retained swap entries. Conventional
> capacity is not reserved for emergencies. Operators choose the policy;
> the kernel does not measure headroom or make an allocating backend safe.
>
> TMO/Senpai [4] and DAMON_RECLAIM [5] are related cold-page reclaim
> approaches. This RFC admits offload-only swap through memory.reclaim and
> per-node reclaim, but not DAMON. Other related work includes per-cgroup
> zswap writeback control [6], Virtual Swap Space v4 [1] and swap tiers v10
> [2].
>
> The util-linux companion [8] proposes swapon --offload-only and an fstab
> option. Older swapon silently ignores the fstab token, so persistent
> activation needs discussion. Apply the separate i915 fix [9] first to avo=
id
> a pre-existing folio-lock leak when shmem writeback is skipped.
>
> The series fixes zram selftest device tracking and error reporting, adds
> the swap policy with DRM eligibility checks, and tests routing, workingse=
t
> activation and retained-entry write refusal. It is based on mm-new at
> 995829088503.
>
> Feedback is particularly welcome on:
>
> - Activation-time eligibility versus backend placement or migration:
>   is retained-entry refusal, with possible reclaim churn or OOM,
>   acceptable without migration?
> - Eligible-capacity accounting, including overcommit limits and OOM
>   scoring; cache recovery, cluster invalidation and workingset activation=
.
> - Persistent activation and visibility: current swap listings do not
>   expose the policy.
>
> Validation includes x86 builds, affected arm64 MTE objects and builds
> without swap or memory cgroups. QEMU tests covered routing, retained-entr=
y
> recovery, data integrity and cleanup, with negative controls for write
> refusal and teardown failure.
>
> I have also been using this policy on my own machine with experimental
> bcachefs swap support, with no problems observed so far. Deliberate stres=
s
> testing is confined to VMs; I do not deliberately stress-test this machin=
e.
>
> Changes since v1, incorporating Sashiko's public review [7]:
>
> - Improve selftest isolation, retained-swap measurement and memlock skips=
.
> - Track allocated zram devices, wait for udev probes and report cleanup
>   errors without deleting data through a mount that could not be released=
.
> - Clarify activation, capacity reporting and conventional fallback limits=
.
>
> [1] https://patchew.org/linux/20260825153238.2695446-1-nphamcs@gmail.com/
> [2] https://patchew.org/linux/20260713025644.170839-1-youngjun.park@lge.c=
om/
> [3] https://openzfs.github.io/openzfs-docs/Project%20and%20Community/FAQ.=
html#using-a-zvol-for-a-swap-device-on-linux
> [4] https://engineering.fb.com/2022/06/20/data-infrastructure/transparent=
-memory-offloading-more-memory-at-a-fraction-of-the-cost-and-power/
> [5] https://www.kernel.org/doc/html/latest/admin-guide/mm/damon/reclaim.h=
tml
> [6] https://www.kernel.org/doc/html/latest/admin-guide/mm/zswap.html
> [7] https://sashiko.dev/#/patchset/20260914104501.3960616-1-matthias.goer=
gens@gmail.com
> [8] https://github.com/util-linux/util-linux/pull/4633
> [9] https://lore.kernel.org/all/20260914105606.3997649-1-matthias.goergen=
s@gmail.com/
>
> v1: https://lore.kernel.org/all/20260914104501.3960616-1-matthias.goergen=
s@gmail.com/
>
> Matthias Goergens (4):
>   selftests: zram: track owned devices and report cleanup failures
>   mm: restrict offload-only swap to proactive reclaim
>   selftests: zram: cover offload-only swap policy
>   selftests: zram: cover retained offload-only entries
>
>  Documentation/mm/swap.rst                     | 105 ++++
>  drivers/gpu/drm/i915/gem/i915_gem_shrinker.c  |   2 +-
>  .../gpu/drm/i915/gem/selftests/huge_pages.c   |   6 +-
>  drivers/gpu/drm/msm/msm_gem_shrinker.c        |   2 +-
>  drivers/gpu/drm/panthor/panthor_gem.c         |   2 +-
>  drivers/gpu/drm/ttm/ttm_backup.c              |   2 +-
>  drivers/gpu/drm/xe/tests/xe_bo.c              |   2 +-
>  include/linux/swap.h                          |  29 +-
>  include/linux/vm_event_item.h                 |   1 +
>  mm/memcontrol.c                               |  20 +-
>  mm/page_io.c                                  |  24 +-
>  mm/swapfile.c                                 | 123 ++++-
>  mm/vmscan.c                                   |  31 +-
>  mm/vmstat.c                                   |   1 +
>  tools/testing/selftests/zram/.gitignore       |   2 +
>  tools/testing/selftests/zram/Makefile         |   4 +-
>  tools/testing/selftests/zram/README           |  20 +-
>  tools/testing/selftests/zram/config           |  10 +-
>  tools/testing/selftests/zram/settings         |   1 +
>  tools/testing/selftests/zram/swap_offload.c   | 425 +++++++++++++++++
>  .../selftests/zram/workingset_offload.c       | 207 ++++++++
>  tools/testing/selftests/zram/zram.sh          |   9 +
>  tools/testing/selftests/zram/zram01.sh        |   9 +-
>  tools/testing/selftests/zram/zram02.sh        |   9 +-
>  tools/testing/selftests/zram/zram03.sh        | 174 +++++++
>  tools/testing/selftests/zram/zram04.sh        | 164 +++++++
>  tools/testing/selftests/zram/zram05.sh        | 447 ++++++++++++++++++
>  tools/testing/selftests/zram/zram_lib.sh      | 189 ++++++--
>  28 files changed, 1926 insertions(+), 94 deletions(-)
>  create mode 100644 tools/testing/selftests/zram/settings
>  create mode 100644 tools/testing/selftests/zram/swap_offload.c
>  create mode 100644 tools/testing/selftests/zram/workingset_offload.c
>  create mode 100755 tools/testing/selftests/zram/zram03.sh
>  create mode 100755 tools/testing/selftests/zram/zram04.sh
>  create mode 100755 tools/testing/selftests/zram/zram05.sh
>
> --
> 2.55.0
>

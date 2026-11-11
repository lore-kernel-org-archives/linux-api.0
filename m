Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794390976;
	b=gNzPd7iS+i0R0Dfw3R1iG2LlGf9qv+T8VERSfY+aEO02lsmrQUQ+e3WhdS/xgdmKDHSO
	 K7goqyCSCy+/JsK9Q86tBghLzOu/g2RdAo+mejhnhWS/qdGVOuvjCml4oT9+cY++0xQjF
	 KsFwcPTd0dZbsYo+MKotZ9xZispktWfD6aYqEK+zzCJ3mIzmLzxHnLyYDxGxXIDo6AJ0o
	 r5wMSscfbWJBodKdnDlzLEzq7WRgAZQDc/SfCc5+dNkmiE+Y5hNUwpI4nUmCFOOK9+E+O
	 yovWbvkwYB7oxriKu+jPhDN2JJxNsmliz1AAxatrprd4XFgpkrLCj7EmZLac2mEkiiQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794390976;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=diWWembtglhqYOPIvis4i129yRh0famPUXEo2wrIz2U=;
	b=it6bdmt5jISEb2kAOXbim/vhSOkJRUvwUhWPYn5VJpVJOXKmOBL1hTQe4Fjpre0kTIdV
	 UlDR4QYg0aWWDz0zt06lzNrdFSzmB4Ilt8xszqE8zf6qogcCFyaPNnXs0Nrpe14vnYm7I
	 as2nfvzfm8F+JWx+Ku5zfIJ9zp/wgLf0qlsmi8yUS43cVknhsjVFnlq+wRQEbdEhpj3Ln
	 5MjXH8pqNWbNkWENjqPVv6gn/JfLP0qMk3g073lHzxSqaw5jqOAs4+It8yVwx0xzuzhsR
	 +WiOYcrcvkD11gV7rKXYPBoYlAsBgwtjSKtgcxr8FHP4NsOyhixTXxMAYKn1gyTsDCw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=jfdjwyV7;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6DD54606A321;
	Wed, 11 Nov 2026 09:56:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=jfdjwyV7
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8389C1F00A07;
	Wed, 11 Nov 2026 09:56:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794390975;
	bh=diWWembtglhqYOPIvis4i129yRh0famPUXEo2wrIz2U=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=jfdjwyV7bUSfgDZ02cMgBlkUPVzLsUIHBZpEZ9gjxJLEB7RQQotgrvJDisFBP2mGe
	 1NHuCT0JkZNr+UP/Ybs26Lu+/9fKSssvhnCOKdmX7d9DcmfLg+SIOFKhUvkSfwW7ab
	 HRtGRji2oHVakaCzi+qGkCEI7raAQ2t7BsCKCAhnGnHmFNCbzBewT2P0phoWMuaozQ
	 cXI5F+lpiu9h/tgByfAOB+GrgTYhtXSaWyZXt4tt9baW75C+zFBV+IUEbq6Q60eMQw
	 Co897B6NUq24lQqOADAhxfrdpeoY1uvOzL8cYDQ8MRlCFdEiVtHcAStNfURIKZ3Ovz
	 pfm7uj1uJMbyA==
Date: Wed, 11 Nov 2026 11:56:07 +0200
From: Mike Rapoport <rppt@kernel.org>
To: Pasha Tatashin <pasha.tatashin@soleen.com>
Cc: linux-api@vger.kernel.org, linux-kselftest@vger.kernel.org,
	shuah@kernel.org, linux-mm@kvack.org, skhan@linuxfoundation.org,
	linux-doc@vger.kernel.org, vipinsh@google.com,
	linux-kernel@vger.kernel.org, corbet@lwn.net, dmatlack@google.com,
	kexec@lists.infradead.org, pratyush@kernel.org,
	rdunlap@infradead.org, graf@amazon.com
Subject: Re: [PATCH v5 0/6] liveupdate: Add LIVEUPDATE_SESSION_FREEZE ioctl
Message-ID: <avQ7t_ijdR4nm-RO@kernel.org>
References: <20261105050053.3063001-1-pasha.tatashin@soleen.com>
X-Mailing-List: linux-api@vger.kernel.org
List-Id: <linux-api.vger.kernel.org>
List-Post: <mailto:linux-api@vger.kernel.org>
List-Help: <mailto:linux-api+help@vger.kernel.org>
List-Subscribe: <mailto:linux-api+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-api+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-api+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261105050053.3063001-1-pasha.tatashin@soleen.com>

(adding linux-api@)

On Thu, Nov 05, 2026 at 12:00:46AM -0500, Pasha Tatashin wrote:
> Currently, LUO freezes outgoing sessions only inside the
> reboot(LINUX_REBOOT_CMD_KEXEC) syscall path, serially under global write
> locks, and binds every outgoing session's lifetime strictly to an open
> session FD until reboot.
> 
> On hosts running many workloads (such as VMs or stateful daemons),
> workloads do not all pause simultaneously inside reboot(): they quiesce
> one by one ahead of the host kexec. Userspace needs an explicit
> per-session freeze point to snapshot final file state (.freeze()) as
> each workload pauses -- concurrently across sessions under per-session
> locks -- along with a way to commit a frozen session into KHO so it
> survives closing the session FD.
> 
> This series introduces LIVEUPDATE_SESSION_FREEZE on session FDs:
> 
> 1. Freeze (flags == 0):
>    Freezes all preserved files in the session under the per-session
>    mutex while keeping session lifetime tied to the session FD. The
>    session stays frozen as long as the FD remains open; closing the
>    session FD before reboot (for example, to abort the session or on
>    process exit/crash) runs .unfreeze() and .unpreserve() and reclaims
>    all resources. At kexec time, already-frozen sessions skip the late
>    auto-freeze step and are published into the outgoing KHO subtree.
> 
> 2. Freeze and commit (LIVEUPDATE_SESSION_FREEZE_COMMIT):
>    Freezes preserved files, immediately inserts the session and its FLB
>    dependencies into the outgoing KHO subtree in O(1), and commits the
>    session so it survives close() with full ownership retained by LUO
>    until reboot. Once committed, closing the session FD (or another
>    session failing to freeze during reboot) never unfreezes or
>    unpreserves it. This allows processes to hand off preserved state to
>    LUO and exit prior to kexec, and makes committed sessions immediately
>    visible in the outgoing KHO subtree before the host reboots.
> 
> Overview of the series:
> - Patch 1 decouples luo_file_freeze()/unfreeze() from
>   struct luo_file_set_ser.
> - Patches 2-4 add incremental KHO publication helpers for kho_block
>   (kho_block_set_it_append()), LUO sessions (luo_session_publish_one()),
>   and outgoing FLBs (luo_flb_ser_publish_one(), replacing the late
>   luo_flb_serialize() reboot pass).
> - Patch 5 introduces LIVEUPDATE_SESSION_FREEZE and
>   LIVEUPDATE_SESSION_FREEZE_COMMIT and updates the LUO core and uAPI
>   documentation.
> - Patch 6 adds selftests covering both uncommitted and committed session
>   freezes across unit and multi-session kexec tests.
> 
> This series is based on liveupdate/next commit d80a5528df4c ("Merge
> branch 'lu-pci-preservation' into next").
> 
> Changelog:
> v5:
> - Rebase onto latest liveupdate/next.
> - Replace reserved field in struct liveupdate_session_freeze with flags
>   and add LIVEUPDATE_SESSION_FREEZE_COMMIT so userspace can either
>   freeze a session while keeping it bound to its FD (rolled back on
>   close()) or commit the frozen session (inserted immediately into KHO
>   and retained by LUO across close() until reboot).
> - Add incremental KHO publication helpers in kho_block, luo_session, and
>   luo_flb so committed sessions and their FLB dependencies are inserted
>   into the outgoing KHO subtree immediately on freeze, dropping the
>   separate luo_flb_serialize() pass at reboot.
> - Keep luo_session_freeze_one() / luo_session_unfreeze_one() in Patch 1
>   rather than renaming them to luo_session_serialize_one() /
>   luo_session_unserialize_one() and back once luo_session_publish_one()
>   is introduced.
> - Update Documentation/userspace-api/liveupdate.rst and kernel-doc
>   across kho_block, luo_flb, luo_file, and luo_session.
> - Drop v4 Reviewed-by tag on the modified freeze and selftest patches,
>   and expand selftests to cover both uncommitted and committed freezes.
> v4:
> - Split out a preparatory patch that drops struct luo_file_set_ser *
>   from luo_file_freeze() / luo_file_unfreeze() and moves file_set_ser
>   handling into luo_session_serialize_one() /
>   luo_session_unserialize_one() (Suggested by Mike Rapoport).
> - Few more nits from Mike.
> v3:
> - Renamed session->frozen to session->user_frozen, - Pratyush
> - Added Reviewed-by's
> v2:
> - Rebased onto liveupdate/next (commit 27be83a12b24 ("Merge branch
>   'lu-pci-preservation' into next")) and split out early session freeze
>   into a standalone series (tmpfs preservation and its per-file user
>   argument plumbing were spun out into a separate series).
> - Patch 1:
>   - Drop struct luo_file_set_ser * from luo_file_freeze() and
>     luo_file_unfreeze(), and rename the session helpers to
>     luo_session_serialize_one() / luo_session_unserialize_one() so all
>     of struct luo_session_ser is populated and cleared in one place
>     (Suggested by Pratyush Yadav).
>   - Unfreeze the session's files if luo_ucmd_respond() fails in
>     luo_session_freeze().
>   - Update remaining reboot-only wording in luo_file.c kernel-doc
>     comments.
> - Patch 2:
>   - Add checks verifying that non-zero reserved bits and freezing an
>     incoming post-kexec session fail with -EINVAL.
> Link: https://lore.kernel.org/all/20261015093816.2438942-1-pasha.tatashin@soleen.com/ # v1
> 
> Pasha Tatashin (6):
>   liveupdate: Move file_set_ser handling to luo_session_serialize()
>   kho: support incremental entry publication in kho_block
>   liveupdate: luo: serialize sessions via per-session publish helper
>   liveupdate: luo_flb: support incremental outgoing FLB publication
>   liveupdate: Add LIVEUPDATE_SESSION_FREEZE ioctl to freeze sessions
>     early
>   selftests: liveupdate: Add tests for LIVEUPDATE_SESSION_FREEZE
> 
>  Documentation/userspace-api/liveupdate.rst    |  30 +++
>  include/linux/kho_block.h                     |   1 +
>  include/linux/liveupdate.h                    |   3 +-
>  include/uapi/linux/liveupdate.h               |  46 +++++
>  kernel/liveupdate/kho_block.c                 |  86 ++++++++-
>  kernel/liveupdate/luo_core.c                  |  10 +-
>  kernel/liveupdate/luo_file.c                  |  94 ++++-----
>  kernel/liveupdate/luo_flb.c                   | 111 +++++++----
>  kernel/liveupdate/luo_internal.h              |  16 +-
>  kernel/liveupdate/luo_session.c               | 178 ++++++++++++++----
>  .../liveupdate/lib/include/libliveupdate.h    |   5 +-
>  .../selftests/liveupdate/lib/lu_utils.c       |  21 ++-
>  .../testing/selftests/liveupdate/liveupdate.c | 107 +++++++++++
>  .../selftests/liveupdate/luo_kexec_simple.c   |  22 ++-
>  .../selftests/liveupdate/luo_multi_session.c  |  33 +++-
>  15 files changed, 612 insertions(+), 151 deletions(-)
> 
> 
> base-commit: d80a5528df4cdee5871243e392da08c2d5c92e43
> -- 
> 2.56.0.398.g882cbad275-goog
> 

-- 
Sincerely yours,
Mike.

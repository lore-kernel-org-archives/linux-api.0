Received: from fanzine2.igalia.com (fanzine2.igalia.com [213.97.179.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 29C0D346E58;
	Fri, 25 Sep 2026 17:53:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.97.179.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790358827; cv=none; b=RfhHtaoKsiikJqnyrf6/aWbHvVxtpAoC8ykN2PEz4qxwlqXzX/nRJBxnL6et+jUEC7IBf9wfyjXbgGBFtoFifQSOWttLqulBOKi4D93+FT1c29/shjdohoOfNsfWkHlVNu2K61M+NjZLos6tVJVxb69T5RX6KdiAeMI5yFZhIVI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790358827; c=relaxed/simple;
	bh=f8J+bZF34JOcztQ6nRdQrs1x6p/+jJNS7+5lZYFOgF0=;
	h=From:Subject:Date:Message-Id:MIME-Version:Content-Type:To:Cc; b=d6B+yVfve2RVYA6YQnzOVmd9TC0YnedQPHzniesY/EpUshjCSx8suoyEYGJfCsO2sQcuMhAx9gyDIkAoyhGbgAhLfZuiGjLpQTDiWGPU/DeMOUZ5Ry+5JJpmWoIi7QLyst4TQbT2VczPQa9aZX9LGHvgqKJgPVrAwUFtdsrFeDY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=igalia.com; spf=pass smtp.mailfrom=igalia.com; dkim=pass (2048-bit key) header.d=igalia.com header.i=@igalia.com header.b=IWX7RUZx; arc=none smtp.client-ip=213.97.179.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=igalia.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=igalia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=igalia.com header.i=@igalia.com header.b="IWX7RUZx"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=igalia.com;
	s=20170329; h=Cc:To:Content-Transfer-Encoding:Content-Type:MIME-Version:
	Message-Id:Date:Subject:From:From:Reply-To;
	bh=N4qMsy6jqzJdMh8PAsMxCmwrbsaWDYUgWh+zjS70TVI=; b=IWX7RUZxkDmTUEzGVrsYLYa4Zl
	5BJOvbnX5p8O0iFtc9NiQWs+ENDox2fWZHECaNJaqipgAMBMObSdzeeSvf0566lOBn/l3TJNTVCFV
	0KqvGPsCDtevAp3q3ndtsMV1zmZx/VCXfOqoXyk6kM8EH+7TGI3b1W2//JneV/wdErhEPQnAEn0nj
	8nUiIsP8JvE/yqQXUA4oRBYS3t/YLCor8nl1EKvYhm+IbpbL9z60OeLtsg16RAXCz3p8/a2zmgnj0
	SAUsrfkkm+EnT4+bkWD1xY2qCql+JMMNawc/nVz6w6bjnGt7B8iaJwEFv78UcejFrRWNVpmY4l6zW
	3H/Rc4qQ==;
Received: from [177.172.123.214] (helo=[192.168.15.100])
	by fanzine2.igalia.com with esmtpsa 
	(Cipher TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256) (Exim)
	id 1xAA73-007GQg-Vc; Fri, 25 Sep 2026 19:53:33 +0200
From: =?utf-8?q?Andr=C3=A9_Almeida?= <andrealmeid@igalia.com>
Subject: [PATCH v7 00/10] futex: Create {set,get}_robust_list2() syscalls
Date: Fri, 25 Sep 2026 14:53:23 -0300
Message-Id: <20260925-tonyk-robust_futex-v7-0-d1095991152c@igalia.com>
Precedence: bulk
X-Mailing-List: linux-api@vger.kernel.org
List-Id: <linux-api.vger.kernel.org>
List-Subscribe: <mailto:linux-api+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-api+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-B4-Tracking: v=1; b=H4sIAAAAAAAC/23NQQrCMBCF4auUrI1MYycaV95DRNJmYoPaSNIWR
 Xp30wqK2OU/MN97skjBUWTb7MkC9S4636RYLzJW1bo5EXcmNRMgEIRA3vrmcebBl11sj7Zr6c4
 laENkdCUVsvR4C2TdfUL3h9S1i60Pj2mjL8brm0MBc1xfcOB5LlagVoTK0M6d9MXpZeWvbPR6/
 BpSyFkDR2OtclWY0tDG/hnyY6QpMWvIZABa0gCowZofYxiGF/4oEPM9AQAA
X-Change-ID: 20250225-tonyk-robust_futex-60adeedac695
To: Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>, 
 Darren Hart <dvhart@infradead.org>, Davidlohr Bueso <dave@stgolabs.net>, 
 Arnd Bergmann <arnd@arndb.de>, 
 Sebastian Andrzej Siewior <bigeasy@linutronix.de>, 
 Waiman Long <longman@redhat.com>, Ryan Houdek <Sonicadvance1@gmail.com>, 
 Thomas Gleixner <tglx@kernel.org>
Cc: linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org, 
 linux-api@vger.kernel.org, kernel-dev@igalia.com, 
 =?utf-8?q?Andr=C3=A9_Almeida?= <andrealmeid@igalia.com>
X-Mailer: b4 0.15.2

Hello,

Now that we mostly fixed the op_pending race condition, I believe it's time to
continue the new syscall work. This patchset is adapted to the robust_try_unlock
mechanics.

 * Use case

The use-case for the new syscalls is detailed in the last patch version:

  https://lore.kernel.org/lkml/20250626-tonyk-robust_futex-v5-0-179194dbde8f@igalia.com

 * The syscall interface

Documented at patches 3/9 "futex: Create set_robust_list2() syscall" and
4/9 "futex: Create get_robust_list2() syscall".

 * Testing

I expanded the current robust list selftest to use the new interface,
and also ported the original syscall to use the new syscall internals,
and everything survived the tests. Tested on both x86 and arm64.

This patchset depends on https://lore.kernel.org/lkml/20260922005407.522060-1-andrealmeid@igalia.com/

 * Changelog

Changes from v6:
 - Interface now uses CREATE/MODIFY semantics instead of SET. This allows to
 both libc and app to use the lists without conflicts.
 - Rebased on top of mainline, including the new VDSO changes
 - v6: https://lore.kernel.org/r/20251122-tonyk-robust_futex-v6-0-05fea005a0fd@igalia.com

Changes from v5:
 - Complete interface rewrite, there are so many changes but the main
   ones are the following points
 - Array of robust lists now has a static size, allocated once during the
   first usage of the list
 - Now that the list of robust lists have a fixed size, I removed the
   logic of having a command for creating a new index on the list. To
   simplify things for everyone, userspace just need to call
   set_robust_list2(head, 32-bit/64-bit type, index).
 - Created get_robust_list2()
 - The new code can be better integrated with the original interface
 - v5: https://lore.kernel.org/r/20250626-tonyk-robust_futex-v5-0-179194dbde8f@igalia.com

Feedback is very welcomed!

---
André Almeida (10):
      futex: Skip test_futex_robust_unlock() if not supported
      futex: Use explicit sizes for compat_robust_list structs
      futex: Make exit_robust_list32() unconditionally available for 64-bit kernels
      futex: Create set_robust_list2() syscall
      futex: Create get_robust_list2() syscall
      futex: Wire up set_robust_list2 syscall
      futex: Wire up get_robust_list2 syscall
      selftests/futex: Expand for set_robust_list2()
      selftests/futex: Expand for get_robust_list2()
      futex: Use new robust list API internally

 arch/alpha/kernel/syscalls/syscall.tbl             |   2 +
 arch/arm/tools/syscall.tbl                         |   2 +
 arch/m68k/kernel/syscalls/syscall.tbl              |   2 +
 arch/microblaze/kernel/syscalls/syscall.tbl        |   2 +
 arch/mips/kernel/syscalls/syscall_n32.tbl          |   2 +
 arch/mips/kernel/syscalls/syscall_n64.tbl          |   2 +
 arch/mips/kernel/syscalls/syscall_o32.tbl          |   2 +
 arch/parisc/kernel/syscalls/syscall.tbl            |   2 +
 arch/powerpc/kernel/syscalls/syscall.tbl           |   2 +
 arch/s390/kernel/syscalls/syscall.tbl              |   2 +
 arch/sh/kernel/syscalls/syscall.tbl                |   2 +
 arch/sparc/kernel/syscalls/syscall.tbl             |   2 +
 arch/x86/entry/syscalls/syscall_32.tbl             |   2 +
 arch/x86/entry/syscalls/syscall_64.tbl             |   2 +
 arch/xtensa/kernel/syscalls/syscall.tbl            |   2 +
 include/linux/compat.h                             |  13 +-
 include/linux/futex.h                              |  24 +
 include/linux/futex_types.h                        |   8 +-
 include/linux/sched.h                              |   2 -
 include/uapi/asm-generic/unistd.h                  |   7 +-
 include/uapi/linux/futex.h                         |  28 +
 kernel/futex/core.c                                | 194 +++++--
 kernel/futex/futex.h                               |   5 +
 kernel/futex/syscalls.c                            | 147 +++++-
 kernel/sys_ni.c                                    |   2 +
 scripts/syscall.tbl                                |   2 +
 .../selftests/futex/functional/robust_list.c       | 567 +++++++++++++++++++--
 27 files changed, 907 insertions(+), 122 deletions(-)
---
base-commit: fe2ec83746e501645709761605c2464a44fd2929
change-id: 20250225-tonyk-robust_futex-60adeedac695

Best regards,
--  
André Almeida <andrealmeid@igalia.com>


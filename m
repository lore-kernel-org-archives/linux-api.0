Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=213.97.179.56
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794763896;
	b=vUOGu7EXDrNVNgALZ69dEE7/Cluyo6SabAGRVQjnUEviNz4ltE1LA6Wj2sL5tJeNJFFn
	 FyopPlYLYr4i6VgAhELOlCvExN1oDWRSKBOmzLbewi8/4sIlgSGHGgQ14tfDY0DpgM83+
	 aaOGb6VIdOka2sKAF9tLZ0zWMRrq9juzSohPg10+S+axcN4F+4xGH3WovZwRF6n3UtMJn
	 3PqSaagUXrYkEsY1OeNzfo+TFC8j+XN+cSBFyGhAG02Z6AezJMylOSGhU88ypE0HjO1YA
	 FmARYr3FyBdzyrE4aok2OJ+7eRtHd2Z+bYfb6hhZnLIad/Myu0clal1fDw74CvecVSw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794763896;
	h=DMARC-Filter:DKIM-Signature:Received:From:Subject:Date:Message-Id:
	 MIME-Version:Content-Type:Content-Transfer-Encoding:X-B4-Tracking:
	 X-Change-ID:To:Cc:X-Mailer;
	bh=3Bm6G36KGuTuY3HD+kSHCQq5JPKPGEZxFL6fjfFggn4=;
	b=pT/PWh2HNEUIwnllaGnzFqImLJ4QODmVG80nfCz5Pfj0qwiOPUm3r4ZybKvc/o7DsGwi
	 toXB4RHBauRx4gqbLBo+IgYaL7DU24yY8Jo+xokiApHBhUa/169MY0HhOz4pkJXhUgPVN
	 DYt7bR+cYuM6gQPgNjkLbjS3yehbq3J+eh1IXD/idPUT6bRhRwxdBRofFB4JR6zQHS8An
	 BmzISvez0g3KKaYR7V21i5/OJW2H6yDkF/nod/HkG38ap95LNS50R0jwF9I6uWmKT7f7i
	 NsufUfKoBEmEthM7zJocJbHknI4j/PViWHhnptLvqFpA1a1Ubt6Xd5LHibNWD5fNccg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=igalia.com;
	spf=pass smtp.mailfrom=igalia.com;
	dkim=pass header.d=igalia.com header.i=@igalia.com header.a=rsa-sha256 header.s=20170329 header.b=A+XeH0pI;
	arc=none smtp.remote-ip=213.97.179.56
Received: from fanzine2.igalia.com (fanzine2.igalia.com [213.97.179.56])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (prime256v1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3212B606A31F;
	Sun, 15 Nov 2026 17:31:34 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 3212B606A31F
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=igalia.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=igalia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=igalia.com header.i=@igalia.com header.a=rsa-sha256 header.s=20170329 header.b=A+XeH0pI
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=igalia.com;
	s=20170329; h=Cc:To:Content-Transfer-Encoding:Content-Type:MIME-Version:
	Message-Id:Date:Subject:From:From:Reply-To;
	bh=3Bm6G36KGuTuY3HD+kSHCQq5JPKPGEZxFL6fjfFggn4=; t=1794763894; x=2110123894; 
	b=A+XeH0pIdP/FetZ0bSQRDUsm8kG1+V89u9vbmGovptEEqyhgALez/FqxzmAGxjW/Dojla7aNasg
	XBckuDK80ZveDEK2heO21mGNUkJomRpAOvdpRdumljZdC0XO8egTahr8LV+y9l/Hpx3iR97X/dj9w
	JgcojQ3bLKPviqC3GE71kBqg3YH0e/iDHkHX93qfNvkeDjCN5lW4JBRlKdPqjFINu3mnH7/usQ2ri
	SDuoWTS6oEm5awoMJ7rLGikSrxjWsiwDkEmb8PTwdqYuwOaLdsr5976ziTEIGNZq7xckEJt/XgC/M
	lQFktEaO9uldJhgRGmnVGi4PW0Hid/XzNB/A==;
Received: from [177.172.124.218] (helo=[192.168.15.100])
	by fanzine2.igalia.com with esmtpsa 
	(Cipher TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256) (Exim)
	id 1xSe4Q-00B0BK-Fi; Sun, 15 Nov 2026 18:31:14 +0100
From: =?utf-8?q?Andr=C3=A9_Almeida?= <andrealmeid@igalia.com>
Subject: [PATCH v8 00/10] futex: Create {set,get}_robust_list2() syscalls
Date: Sun, 15 Nov 2026 14:31:09 -0300
Message-Id: <20261115-tonyk-robust_futex-v8-0-a4fe47333a28@igalia.com>
X-Mailing-List: linux-api@vger.kernel.org
List-Id: <linux-api.vger.kernel.org>
List-Post: <mailto:linux-api@vger.kernel.org>
List-Help: <mailto:linux-api+help@vger.kernel.org>
List-Subscribe: <mailto:linux-api+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-api+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-api+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-B4-Tracking: v=1; b=H4sIAAAAAAAC/23Q0WoCMRAF0F+RPDdlEneyjk/9jyISNxMNrRtJ1
 qDI/nuzii3FfbwX5lyYm8icAmexXtxE4hJyiH0Nq7eF6A6237MMrmahQSNojXKI/fVLprg752H
 rzwNfpAHrmJ3tDKGoh6fEPlzu6Oem5kPIQ0zX+0ZppvbBoYY5rjQSpFJ6CbRkJMcfYW+/g33v4
 lFMXsE/w2gza+BktKSocTvHK/9imF+jTulZw1QD0LMFQAvevRjt0zBA868pbTWcAkIipVB3/4x
 xHH8A9/GJx4EBAAA=
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

 * Changelog

Changes from v7:
- Expanded the selftest for more corner cases and error handling
- Fix a lot of Sashiko findings, including:
- Refactor handling of 32-bit lists in get_robust_list2 
- Fix legacy 32-bit list creation overwritting 64-bit list
- Fix 32-bit list never getting cleared
- Fix corrupting error code
- Fix logic for modifying list elements
- Link to v7: https://patch.msgid.link/20260925-tonyk-robust_futex-v7-0-d1095991152c@igalia.com

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
 include/linux/futex_types.h                        |   9 +-
 include/uapi/asm-generic/unistd.h                  |   7 +-
 include/uapi/linux/futex.h                         |  28 +
 kernel/futex/core.c                                | 196 +++++--
 kernel/futex/futex.h                               |   5 +
 kernel/futex/syscalls.c                            | 158 +++++-
 kernel/sys_ni.c                                    |   2 +
 scripts/syscall.tbl                                |   2 +
 .../selftests/futex/functional/robust_list.c       | 626 +++++++++++++++++++--
 26 files changed, 976 insertions(+), 124 deletions(-)
---
base-commit: 9f74092fda91ef93c2b07585785c1dc83cd7971f
change-id: 20250225-tonyk-robust_futex-60adeedac695

Best regards,
--  
André Almeida <andrealmeid@igalia.com>


Return-Path: <linux-api-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6271FC43461
	for <linux-api@archiver.kernel.org>; Fri, 14 May 2021 04:55:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 44D98613C5
	for <linux-api@archiver.kernel.org>; Fri, 14 May 2021 04:55:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232322AbhENE4U (ORCPT <rfc822;linux-api@archiver.kernel.org>);
        Fri, 14 May 2021 00:56:20 -0400
Received: from out03.mta.xmission.com ([166.70.13.233]:37838 "EHLO
        out03.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232287AbhENE4T (ORCPT
        <rfc822;linux-api@vger.kernel.org>); Fri, 14 May 2021 00:56:19 -0400
Received: from in02.mta.xmission.com ([166.70.13.52])
        by out03.mta.xmission.com with esmtps  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.93)
        (envelope-from <ebiederm@xmission.com>)
        id 1lhPqq-00BoLN-Ng; Thu, 13 May 2021 22:55:04 -0600
Received: from ip68-227-160-95.om.om.cox.net ([68.227.160.95] helo=fess.xmission.com)
        by in02.mta.xmission.com with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.93)
        (envelope-from <ebiederm@xmission.com>)
        id 1lhPqo-001pPq-NE; Thu, 13 May 2021 22:55:03 -0600
From:   ebiederm@xmission.com (Eric W. Biederman)
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     Arnd Bergmann <arnd@arndb.de>, Florian Weimer <fweimer@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Collingbourne <pcc@google.com>,
        Dmitry Vyukov <dvyukov@google.com>,
        Alexander Potapenko <glider@google.com>,
        sparclinux <sparclinux@vger.kernel.org>,
        linux-arch <linux-arch@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux API <linux-api@vger.kernel.org>,
        kasan-dev <kasan-dev@googlegroups.com>,
        Marco Elver <elver@google.com>
References: <YIpkvGrBFGlB5vNj@elver.google.com>
        <m11rat9f85.fsf@fess.ebiederm.org>
        <CAK8P3a0+uKYwL1NhY6Hvtieghba2hKYGD6hcKx5n8=4Gtt+pHA@mail.gmail.com>
        <m15z031z0a.fsf@fess.ebiederm.org> <YIxVWkT03TqcJLY3@elver.google.com>
        <m1zgxfs7zq.fsf_-_@fess.ebiederm.org>
        <m1r1irpc5v.fsf@fess.ebiederm.org>
        <CANpmjNNfiSgntiOzgMc5Y41KVAV_3VexdXCMADekbQEqSP3vqQ@mail.gmail.com>
        <m1czuapjpx.fsf@fess.ebiederm.org>
        <CANpmjNNyifBNdpejc6ofT6+n6FtUw-Cap_z9Z9YCevd7Wf3JYQ@mail.gmail.com>
        <m14kfjh8et.fsf_-_@fess.ebiederm.org>
        <m1tuni8ano.fsf_-_@fess.ebiederm.org>
Date:   Thu, 13 May 2021 23:54:57 -0500
In-Reply-To: <m1tuni8ano.fsf_-_@fess.ebiederm.org> (Eric W. Biederman's
        message of "Tue, 04 May 2021 16:13:47 -0500")
Message-ID: <m1a6oxewym.fsf_-_@fess.ebiederm.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-SPF: eid=1lhPqo-001pPq-NE;;;mid=<m1a6oxewym.fsf_-_@fess.ebiederm.org>;;;hst=in02.mta.xmission.com;;;ip=68.227.160.95;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX18LwkDtE9Oj161KN5+izzXCHEVxEw+wP90=
X-SA-Exim-Connect-IP: 68.227.160.95
X-SA-Exim-Mail-From: ebiederm@xmission.com
Subject: [GIT PULL] siginfo: ABI fixes for v5.13-rc2
X-SA-Exim-Version: 4.2.1 (built Sat, 08 Feb 2020 21:53:50 +0000)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Precedence: bulk
List-ID: <linux-api.vger.kernel.org>
X-Mailing-List: linux-api@vger.kernel.org


Linus,

Please pull the for-v5.13-rc2 branch from the git tree:

  git://git.kernel.org/pub/scm/linux/kernel/git/ebiederm/user-namespace.git for-v5.13-rc2

  HEAD: addd6821190ebf1e9fece0b7848db667fd280e2e signalfd: Remove SIL_FAULT_PERF_EVENT fields from signalfd_siginfo

During the merge window an issue with si_perf and the siginfo ABI came
up.  The alpha and sparc siginfo structure layout had changed with the
addition of SIGTRAP TRAP_PERF and the new field si_perf.

The reason only alpha and sparc were affected is that they are the
only architectures that use si_trapno.

Looking deeper it was discovered that si_trapno is used for only
a few select signals on alpha and sparc, and that none of the
other _sigfault fields past si_addr are used at all.  Which means
technically no regression on alpha and sparc.

While the alignment concerns might be dismissed the abuse of
si_errno by SIGTRAP TRAP_PERF does have the potential to cause
regressions in existing userspace.

While we still have time before userspace starts using and depending on
the new definition siginfo for SIGTRAP TRAP_PERF this set of changes
cleans up siginfo_t.

- The si_trapno field is demoted from magic alpha and sparc status and
  made an ordinary union member of the _sigfault member of siginfo_t.
  Without moving it of course.

- si_perf is replaced with si_perf_data and si_perf_type ending the
  abuse of si_errno.

- BUILD_BUG_ONs are added and various helpers are modified to
  accommodate this change.

- Unnecessary additions to signalfd_siginfo are removed.

v3: https://lkml.kernel.org/r/m1tuni8ano.fsf_-_@fess.ebiederm.org
v2: https://lkml.kernel.org/r/m14kfjh8et.fsf_-_@fess.ebiederm.org
v1: https://lkml.kernel.org/r/m1zgxfs7zq.fsf_-_@fess.ebiederm.org

You might notice a recent rebase.  This code has been sitting in
linux-next as  ef566ba2d7d9 ("signal: Remove the last few si_perf
references").  Which results in the exact same code as the branch
I am sending you but the commits differ to keep git bisect working.

The difference is that I squashed a fix for a mips BUILD_BUG_ON about
si_perf into the commit that replaces si_perf with si_perf_data and
si_perf_type.  This keeps the kernel building on all architectures for
all commits keeping git-bisect working for everyone.

Eric W. Biederman (9):
      signal: Verify the alignment and size of siginfo_t
      siginfo: Move si_trapno inside the union inside _si_fault
      signal: Implement SIL_FAULT_TRAPNO
      signal: Use dedicated helpers to send signals with si_trapno set
      signal: Remove __ARCH_SI_TRAPNO
      signal: Rename SIL_PERF_EVENT SIL_FAULT_PERF_EVENT for consistency
      signal: Factor force_sig_perf out of perf_sigtrap
      signal: Deliver all of the siginfo perf data in _perf
      signalfd: Remove SIL_FAULT_PERF_EVENT fields from signalfd_siginfo

Marco Elver (3):
      sparc64: Add compile-time asserts for siginfo_t offsets
      arm: Add compile-time asserts for siginfo_t offsets
      arm64: Add compile-time asserts for siginfo_t offsets

 arch/alpha/include/uapi/asm/siginfo.h              |   2 -
 arch/alpha/kernel/osf_sys.c                        |   2 +-
 arch/alpha/kernel/signal.c                         |   4 +-
 arch/alpha/kernel/traps.c                          |  24 ++---
 arch/alpha/mm/fault.c                              |   4 +-
 arch/arm/kernel/signal.c                           |  39 +++++++
 arch/arm64/kernel/signal.c                         |  39 +++++++
 arch/arm64/kernel/signal32.c                       |  39 +++++++
 arch/m68k/kernel/signal.c                          |   3 +-
 arch/mips/include/uapi/asm/siginfo.h               |   2 -
 arch/sparc/include/uapi/asm/siginfo.h              |   3 -
 arch/sparc/kernel/process_64.c                     |   2 +-
 arch/sparc/kernel/signal32.c                       |  37 +++++++
 arch/sparc/kernel/signal_64.c                      |  36 +++++++
 arch/sparc/kernel/sys_sparc_32.c                   |   2 +-
 arch/sparc/kernel/sys_sparc_64.c                   |   2 +-
 arch/sparc/kernel/traps_32.c                       |  22 ++--
 arch/sparc/kernel/traps_64.c                       |  44 ++++----
 arch/sparc/kernel/unaligned_32.c                   |   2 +-
 arch/sparc/mm/fault_32.c                           |   2 +-
 arch/sparc/mm/fault_64.c                           |   2 +-
 arch/x86/kernel/signal_compat.c                    |  15 ++-
 fs/signalfd.c                                      |  23 ++---
 include/linux/compat.h                             |  10 +-
 include/linux/sched/signal.h                       |  13 +--
 include/linux/signal.h                             |   3 +-
 include/uapi/asm-generic/siginfo.h                 |  20 ++--
 include/uapi/linux/perf_event.h                    |   2 +-
 include/uapi/linux/signalfd.h                      |   4 +-
 kernel/events/core.c                               |  11 +-
 kernel/signal.c                                    | 113 +++++++++++++--------
 .../selftests/perf_events/sigtrap_threads.c        |  14 +--
 32 files changed, 377 insertions(+), 163 deletions(-)

Eric

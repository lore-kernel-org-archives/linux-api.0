Return-Path: <linux-api-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0F443C43460
	for <linux-api@archiver.kernel.org>; Mon, 17 May 2021 19:58:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DC7ED60FF3
	for <linux-api@archiver.kernel.org>; Mon, 17 May 2021 19:58:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236936AbhEQT7T (ORCPT <rfc822;linux-api@archiver.kernel.org>);
        Mon, 17 May 2021 15:59:19 -0400
Received: from out01.mta.xmission.com ([166.70.13.231]:55158 "EHLO
        out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236924AbhEQT7S (ORCPT
        <rfc822;linux-api@vger.kernel.org>); Mon, 17 May 2021 15:59:18 -0400
Received: from in01.mta.xmission.com ([166.70.13.51])
        by out01.mta.xmission.com with esmtps  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
        (Exim 4.93)
        (envelope-from <ebiederm@xmission.com>)
        id 1lijNH-009gqy-Gb; Mon, 17 May 2021 13:57:59 -0600
Received: from ip68-227-160-95.om.om.cox.net ([68.227.160.95] helo=fess.xmission.com)
        by in01.mta.xmission.com with esmtpsa (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.87)
        (envelope-from <ebiederm@xmission.com>)
        id 1lijMX-0001ch-UG; Mon, 17 May 2021 13:57:16 -0600
From:   ebiederm@xmission.com (Eric W. Biederman)
To:     Marco Elver <elver@google.com>
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
        kasan-dev <kasan-dev@googlegroups.com>
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
Date:   Mon, 17 May 2021 14:56:54 -0500
In-Reply-To: <m1tuni8ano.fsf_-_@fess.ebiederm.org> (Eric W. Biederman's
        message of "Tue, 04 May 2021 16:13:47 -0500")
Message-ID: <m1a6ot5e2h.fsf_-_@fess.ebiederm.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-SPF: eid=1lijMX-0001ch-UG;;;mid=<m1a6ot5e2h.fsf_-_@fess.ebiederm.org>;;;hst=in01.mta.xmission.com;;;ip=68.227.160.95;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX19wgF5urIEeuZov1TyNkbEl+ZRf8d7DJfI=
X-SA-Exim-Connect-IP: 68.227.160.95
X-SA-Exim-Mail-From: ebiederm@xmission.com
Subject: [PATCH v4 0/5] siginfo: ABI fixes for TRAP_PERF
X-SA-Exim-Version: 4.2.1 (built Thu, 05 May 2016 13:38:54 -0600)
X-SA-Exim-Scanned: Yes (on in01.mta.xmission.com)
Precedence: bulk
List-ID: <linux-api.vger.kernel.org>
X-Mailing-List: linux-api@vger.kernel.org


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

- Unnecessary additions to signalfd_siginfo are removed.

v3: https://lkml.kernel.org/r/m1tuni8ano.fsf_-_@fess.ebiederm.org
v2: https://lkml.kernel.org/r/m14kfjh8et.fsf_-_@fess.ebiederm.org
v1: https://lkml.kernel.org/r/m1zgxfs7zq.fsf_-_@fess.ebiederm.org

This version drops the tests and fine grained handling of si_trapno
on alpha and sparc (replaced assuming si_trapno is valid for
all but the faults that defined different data).

Eric W. Biederman (5):
      siginfo: Move si_trapno inside the union inside _si_fault
      signal: Implement SIL_FAULT_TRAPNO
      signal: Factor force_sig_perf out of perf_sigtrap
      signal: Deliver all of the siginfo perf data in _perf
      signalfd: Remove SIL_PERF_EVENT fields from signalfd_siginfo


 arch/m68k/kernel/signal.c                          |  3 +-
 arch/x86/kernel/signal_compat.c                    |  9 +++-
 fs/signalfd.c                                      | 23 ++++-----
 include/linux/compat.h                             | 10 ++--
 include/linux/sched/signal.h                       |  1 +
 include/linux/signal.h                             |  1 +
 include/uapi/asm-generic/siginfo.h                 | 15 +++---
 include/uapi/linux/perf_event.h                    |  2 +-
 include/uapi/linux/signalfd.h                      |  4 +-
 kernel/events/core.c                               | 11 +---
 kernel/signal.c                                    | 59 +++++++++++++---------
 .../selftests/perf_events/sigtrap_threads.c        | 14 ++---
 12 files changed, 79 insertions(+), 73 deletions(-)

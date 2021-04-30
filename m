Return-Path: <linux-api-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7896FC433B4
	for <linux-api@archiver.kernel.org>; Fri, 30 Apr 2021 22:49:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 532FB613B0
	for <linux-api@archiver.kernel.org>; Fri, 30 Apr 2021 22:49:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232158AbhD3Wul (ORCPT <rfc822;linux-api@archiver.kernel.org>);
        Fri, 30 Apr 2021 18:50:41 -0400
Received: from out03.mta.xmission.com ([166.70.13.233]:56124 "EHLO
        out03.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230378AbhD3Wul (ORCPT
        <rfc822;linux-api@vger.kernel.org>); Fri, 30 Apr 2021 18:50:41 -0400
Received: from in01.mta.xmission.com ([166.70.13.51])
        by out03.mta.xmission.com with esmtps  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
        (Exim 4.93)
        (envelope-from <ebiederm@xmission.com>)
        id 1lcbxF-004Atp-LD; Fri, 30 Apr 2021 16:49:49 -0600
Received: from ip68-227-160-95.om.om.cox.net ([68.227.160.95] helo=fess.xmission.com)
        by in01.mta.xmission.com with esmtpsa (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.87)
        (envelope-from <ebiederm@xmission.com>)
        id 1lcbxF-00038q-0D; Fri, 30 Apr 2021 16:49:49 -0600
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
Date:   Fri, 30 Apr 2021 17:49:45 -0500
In-Reply-To: <YIxVWkT03TqcJLY3@elver.google.com> (Marco Elver's message of
        "Fri, 30 Apr 2021 21:07:06 +0200")
Message-ID: <m1zgxfs7zq.fsf_-_@fess.ebiederm.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-SPF: eid=1lcbxF-00038q-0D;;;mid=<m1zgxfs7zq.fsf_-_@fess.ebiederm.org>;;;hst=in01.mta.xmission.com;;;ip=68.227.160.95;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX194HKcbJ3hzROboO3aXmacGQftTa4VgQr0=
X-SA-Exim-Connect-IP: 68.227.160.95
X-SA-Exim-Mail-From: ebiederm@xmission.com
Subject: [RFC][PATCH 0/3] signal: Move si_trapno into the _si_fault union
X-SA-Exim-Version: 4.2.1 (built Thu, 05 May 2016 13:38:54 -0600)
X-SA-Exim-Scanned: Yes (on in01.mta.xmission.com)
Precedence: bulk
List-ID: <linux-api.vger.kernel.org>
X-Mailing-List: linux-api@vger.kernel.org


Eric W. Biederman (3):
      siginfo: Move si_trapno inside the union inside _si_fault
      signal: Implement SIL_FAULT_TRAPNO
      signal: Use dedicated helpers to send signals with si_trapno set

 arch/alpha/kernel/osf_sys.c        |  2 +-
 arch/alpha/kernel/signal.c         |  4 +-
 arch/alpha/kernel/traps.c          | 24 ++++++------
 arch/alpha/mm/fault.c              |  4 +-
 arch/sparc/kernel/process_64.c     |  2 +-
 arch/sparc/kernel/sys_sparc_32.c   |  2 +-
 arch/sparc/kernel/sys_sparc_64.c   |  2 +-
 arch/sparc/kernel/traps_32.c       | 22 +++++------
 arch/sparc/kernel/traps_64.c       | 44 ++++++++++------------
 arch/sparc/kernel/unaligned_32.c   |  2 +-
 arch/sparc/mm/fault_32.c           |  2 +-
 arch/sparc/mm/fault_64.c           |  2 +-
 fs/signalfd.c                      |  7 +---
 include/linux/compat.h             |  4 +-
 include/linux/sched/signal.h       | 12 ++----
 include/linux/signal.h             |  1 +
 include/uapi/asm-generic/siginfo.h |  6 +--
 kernel/signal.c                    | 77 ++++++++++++++++++++++----------------
 18 files changed, 107 insertions(+), 112 deletions(-)


Return-Path: <linux-api-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7FD53C433EF
	for <linux-api@archiver.kernel.org>; Fri, 24 Sep 2021 00:09:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5ABDA61241
	for <linux-api@archiver.kernel.org>; Fri, 24 Sep 2021 00:09:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236458AbhIXAKl (ORCPT <rfc822;linux-api@archiver.kernel.org>);
        Thu, 23 Sep 2021 20:10:41 -0400
Received: from out02.mta.xmission.com ([166.70.13.232]:33528 "EHLO
        out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232143AbhIXAKl (ORCPT
        <rfc822;linux-api@vger.kernel.org>); Thu, 23 Sep 2021 20:10:41 -0400
Received: from in01.mta.xmission.com ([166.70.13.51]:52332)
        by out02.mta.xmission.com with esmtps  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.93)
        (envelope-from <ebiederm@xmission.com>)
        id 1mTYm3-007ju0-D3; Thu, 23 Sep 2021 18:09:07 -0600
Received: from ip68-227-160-95.om.om.cox.net ([68.227.160.95]:57218 helo=email.xmission.com)
        by in01.mta.xmission.com with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.93)
        (envelope-from <ebiederm@xmission.com>)
        id 1mTYm2-00EloX-6M; Thu, 23 Sep 2021 18:09:06 -0600
From:   ebiederm@xmission.com (Eric W. Biederman)
To:     <linux-kernel@vger.kernel.org>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        Oleg Nesterov <oleg@redhat.com>,
        Al Viro <viro@ZenIV.linux.org.uk>, <linux-api@vger.kernel.org>,
        Kees Cook <keescook@chromium.org>
Date:   Thu, 23 Sep 2021 19:08:09 -0500
Message-ID: <87v92qx2c6.fsf@disp2133>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-SPF: eid=1mTYm2-00EloX-6M;;;mid=<87v92qx2c6.fsf@disp2133>;;;hst=in01.mta.xmission.com;;;ip=68.227.160.95;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX1/MWEGFo8SfpHSHDGwehupHY+XVRmEIGZo=
X-SA-Exim-Connect-IP: 68.227.160.95
X-SA-Exim-Mail-From: ebiederm@xmission.com
Subject: [PATCH 0/6] per signal_struct coredumps
X-SA-Exim-Version: 4.2.1 (built Sat, 08 Feb 2020 21:53:50 +0000)
X-SA-Exim-Scanned: Yes (on in01.mta.xmission.com)
Precedence: bulk
List-ID: <linux-api.vger.kernel.org>
X-Mailing-List: linux-api@vger.kernel.org


Current coredumps are mixed up with the exit code, the signal handling
code and with the ptrace code in was they are much more complicated than
necessary and difficult to follow.

This series of changes starts with ptrace_stop and cleans it up,
making it easier to follow what is happening in ptrace_stop.
Then cleans up the exec interactions with coredumps.
Then cleans up the coredump interactions with exit.
Then the coredump interactions with the signal handling code is clean
up.

The first and last changes are bug fixes for minor bugs.

I believe the fact that vfork followed by execve can kill the process
the called vfork if exec fails is sufficient justification to change
the userspace visible behavior.

In previous conversations it was suggested that some of these cleanups
did not stand on their own.  I think I have managed to organize things
so all of their patches stand on their own.

Which means that if for some reason the last change needs to be reverted
we can still keep the gains from the other changes.


Eric W. Biederman (6):
      signal: Remove the bogus sigkill_pending in ptrace_stop
      ptrace: Remove the unnecessary arguments from arch_ptrace_stop
      exec: Check for a pending fatal signal instead of core_state
      exit: Factor coredump_exit_mm out of exit_mm
      coredump:  Don't perform any cleanups before dumping core
      coredump: Limit coredumps to a single thread group

 arch/ia64/include/asm/ptrace.h  |  4 +-
 arch/sparc/include/asm/ptrace.h |  8 ++--
 fs/binfmt_elf.c                 |  4 +-
 fs/binfmt_elf_fdpic.c           |  2 +-
 fs/coredump.c                   | 88 ++++++-----------------------------------
 fs/exec.c                       | 14 +++----
 fs/proc/array.c                 |  6 +--
 include/linux/mm_types.h        | 13 ------
 include/linux/ptrace.h          | 22 +++++------
 include/linux/sched.h           |  1 +
 include/linux/sched/signal.h    | 13 ++++++
 kernel/exit.c                   | 76 +++++++++++++++++++----------------
 kernel/fork.c                   |  4 +-
 kernel/signal.c                 | 49 ++++-------------------
 mm/oom_kill.c                   |  6 +--
 15 files changed, 104 insertions(+), 206 deletions(-)

Eric

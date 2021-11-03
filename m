Return-Path: <linux-api-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 97515C433F5
	for <linux-api@archiver.kernel.org>; Wed,  3 Nov 2021 19:07:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 768CE6112E
	for <linux-api@archiver.kernel.org>; Wed,  3 Nov 2021 19:07:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230036AbhKCTKW (ORCPT <rfc822;linux-api@archiver.kernel.org>);
        Wed, 3 Nov 2021 15:10:22 -0400
Received: from out03.mta.xmission.com ([166.70.13.233]:60278 "EHLO
        out03.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229697AbhKCTKV (ORCPT
        <rfc822;linux-api@vger.kernel.org>); Wed, 3 Nov 2021 15:10:21 -0400
Received: from in02.mta.xmission.com ([166.70.13.52]:47506)
        by out03.mta.xmission.com with esmtps  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.93)
        (envelope-from <ebiederm@xmission.com>)
        id 1miLbs-000ch0-4k; Wed, 03 Nov 2021 13:07:44 -0600
Received: from ip68-227-160-95.om.om.cox.net ([68.227.160.95]:53986 helo=email.xmission.com)
        by in02.mta.xmission.com with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.93)
        (envelope-from <ebiederm@xmission.com>)
        id 1miLbq-002G6s-PB; Wed, 03 Nov 2021 13:07:43 -0600
From:   ebiederm@xmission.com (Eric W. Biederman)
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     <linux-kernel@vger.kernel.org>, Oleg Nesterov <oleg@redhat.com>,
        Al Viro <viro@ZenIV.linux.org.uk>,
        Kees Cook <keescook@chromium.org>, <linux-api@vger.kernel.org>
Date:   Wed, 03 Nov 2021 14:07:36 -0500
Message-ID: <878ry512iv.fsf@disp2133>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-SPF: eid=1miLbq-002G6s-PB;;;mid=<878ry512iv.fsf@disp2133>;;;hst=in02.mta.xmission.com;;;ip=68.227.160.95;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX1/L36RxVZc3PY5oCLUJ61fTl/cpMvTH2qc=
X-SA-Exim-Connect-IP: 68.227.160.95
X-SA-Exim-Mail-From: ebiederm@xmission.com
Subject: [GIT PULL] per signal_struct coredumps
X-SA-Exim-Version: 4.2.1 (built Sat, 08 Feb 2020 21:53:50 +0000)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Precedence: bulk
List-ID: <linux-api.vger.kernel.org>
X-Mailing-List: linux-api@vger.kernel.org


Linus,

Please pull the per_signal_struct_coredumps-for-v5.16 branch from the git tree:

  git://git.kernel.org/pub/scm/linux/kernel/git/ebiederm/user-namespace.git per_signal_struct_coredumps-for-v5.16

  HEAD: 3f66f86bfed33dee2e9c1d0e14486915bb0750b0 per signal_struct coredumps


Current coredumps are mixed up with the exit code, the signal handling
code, and the ptrace code making coredumps much more complicated than
necessary and difficult to follow.

This series of changes starts with ptrace_stop and cleans it up,
making it easier to follow what is happening in ptrace_stop.
Then cleans up the exec interactions with coredumps.
Then cleans up the coredump interactions with exit.
Then the coredump interactions with the signal handling code is cleaned
up.

The first and last changes are bug fixes for minor bugs.

I believe the fact that vfork followed by execve can kill the process
the called vfork if exec fails is sufficient justification to change
the userspace visible behavior.

In previous discussions some of these changes were organized differently
and individually appeared to make the code base worse.  As currently
written I believe they all stand on their own as cleanups and bug fixes.

Which means that even if the worst should happen and the last change
needs to be reverted for some unimaginable reason, the code base will
still be improved.

If the worst does not happen there are a more cleanups that can be made.
Signals that generate coredumps can easily become eligible for short
circuit delivery in complete_signal.  The entire rendezvous for
generating a coredump can move into get_signal.  The function
force_sig_info_to_task be written in a way that does not modify the
signal handling state of the target task (because coredumps are eligible
for short circuit delivery).  Many of these future cleanups can be done
another way but nothing so cleanly as if coredumps become per
signal_struct.

Eric W. Biederman (7):
      signal: Remove the bogus sigkill_pending in ptrace_stop
      ptrace: Remove the unnecessary arguments from arch_ptrace_stop
      exec: Check for a pending fatal signal instead of core_state
      exit: Factor coredump_exit_mm out of exit_mm
      coredump:  Don't perform any cleanups before dumping core
      coredump: Limit coredumps to a single thread group
      per signal_struct coredumps

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
 mm/debug.c                      |  4 +-
 mm/oom_kill.c                   |  6 +--
 16 files changed, 106 insertions(+), 208 deletions(-)

Link: https://lkml.kernel.org/r/87v92qx2c6.fsf@disp2133
Signed-off-by: "Eric W. Biederman" <ebiederm@xmission.com>

Eric

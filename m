Return-Path: <linux-api-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BF1F9C433F5
	for <linux-api@archiver.kernel.org>; Mon, 13 Dec 2021 22:51:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243946AbhLMWvG (ORCPT <rfc822;linux-api@archiver.kernel.org>);
        Mon, 13 Dec 2021 17:51:06 -0500
Received: from out01.mta.xmission.com ([166.70.13.231]:41038 "EHLO
        out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243945AbhLMWvF (ORCPT
        <rfc822;linux-api@vger.kernel.org>); Mon, 13 Dec 2021 17:51:05 -0500
Received: from in01.mta.xmission.com ([166.70.13.51]:45234)
        by out01.mta.xmission.com with esmtps  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.93)
        (envelope-from <ebiederm@xmission.com>)
        id 1mwu9w-0081F3-BK; Mon, 13 Dec 2021 15:51:04 -0700
Received: from ip68-227-160-95.om.om.cox.net ([68.227.160.95]:60372 helo=email.froward.int.ebiederm.org.xmission.com)
        by in01.mta.xmission.com with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.93)
        (envelope-from <ebiederm@xmission.com>)
        id 1mwu9v-007pJx-7N; Mon, 13 Dec 2021 15:51:03 -0700
From:   ebiederm@xmission.com (Eric W. Biederman)
To:     <linux-kernel@vger.kernel.org>
Cc:     <linux-arch@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Alexey Gladkov <legion@kernel.org>,
        Kyle Huey <me@kylehuey.com>, Oleg Nesterov <oleg@redhat.com>,
        Kees Cook <keescook@chromium.org>,
        Al Viro <viro@ZenIV.linux.org.uk>, <linux-api@vger.kernel.org>
References: <87a6ha4zsd.fsf@email.froward.int.ebiederm.org>
Date:   Mon, 13 Dec 2021 16:50:56 -0600
In-Reply-To: <87a6ha4zsd.fsf@email.froward.int.ebiederm.org> (Eric
        W. Biederman's message of "Wed, 08 Dec 2021 14:17:22 -0600")
Message-ID: <87bl1kunjj.fsf@email.froward.int.ebiederm.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-SPF: eid=1mwu9v-007pJx-7N;;;mid=<87bl1kunjj.fsf@email.froward.int.ebiederm.org>;;;hst=in01.mta.xmission.com;;;ip=68.227.160.95;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX1/ldPosCXFTTNb6Bl3CGqPIXoijxcUBdx4=
X-SA-Exim-Connect-IP: 68.227.160.95
X-SA-Exim-Mail-From: ebiederm@xmission.com
Subject: [PATCH 0/8] signal: Cleanup of the signal->flags
X-SA-Exim-Version: 4.2.1 (built Sat, 08 Feb 2020 21:53:50 +0000)
X-SA-Exim-Scanned: Yes (on in01.mta.xmission.com)
Precedence: bulk
List-ID: <linux-api.vger.kernel.org>
X-Mailing-List: linux-api@vger.kernel.org


The special case of SIGKILL during coredumps is very fragile today and
while reading through the code I realized I have almost broken it twice.
So this simplifies that special case, removes SIGNAL_GROUP_COREDUMP
which has become unnecessary with the addition of signal->core_state,
and this removes the helper signal_group_exit which is misnamed and
is not used properly.

If you squint very hard there might be a user space visible difference
in behavior somewhere but I don't think there is one in practice.

These patches are on top of:
https://git.kernel.org/pub/scm/linux/kernel/git/ebiederm/user-namespace.git/ signal-for-v5.17

After these patches have been reviewed it is my plan to apply them to my
signal-for-v5.17 branch.

Eric W. Biederman (8):
      signal: Make SIGKILL during coredumps an explicit special case
      signal: Drop signals received after a fatal signal has been processed
      signal: Have the oom killer detect coredumps using signal->core_state
      signal: During coredumps set SIGNAL_GROUP_EXIT in zap_process
      signal: Remove SIGNAL_GROUP_COREDUMP
      coredump: Stop setting signal->group_exit_task
      signal: Rename group_exit_task group_exec_task
      signal: Remove the helper signal_group_exit

 fs/coredump.c                | 20 +++++++++-----------
 fs/exec.c                    | 10 +++++-----
 include/linux/sched/signal.h | 18 +++---------------
 kernel/exit.c                | 12 ++++++++----
 kernel/signal.c              | 24 ++++++++++++++++--------
 mm/oom_kill.c                |  2 +-
 6 files changed, 42 insertions(+), 44 deletions(-)

Eric

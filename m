Return-Path: <linux-api-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 48F29C433F5
	for <linux-api@archiver.kernel.org>; Tue, 15 Mar 2022 23:19:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236985AbiCOXUW (ORCPT <rfc822;linux-api@archiver.kernel.org>);
        Tue, 15 Mar 2022 19:20:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33942 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352542AbiCOXUV (ORCPT
        <rfc822;linux-api@vger.kernel.org>); Tue, 15 Mar 2022 19:20:21 -0400
Received: from out03.mta.xmission.com (out03.mta.xmission.com [166.70.13.233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B80902B1AD;
        Tue, 15 Mar 2022 16:19:08 -0700 (PDT)
Received: from in02.mta.xmission.com ([166.70.13.52]:49304)
        by out03.mta.xmission.com with esmtps  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.93)
        (envelope-from <ebiederm@xmission.com>)
        id 1nUGRX-000gSW-46; Tue, 15 Mar 2022 17:19:07 -0600
Received: from ip68-227-174-4.om.om.cox.net ([68.227.174.4]:37848 helo=email.froward.int.ebiederm.org.xmission.com)
        by in02.mta.xmission.com with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.93)
        (envelope-from <ebiederm@xmission.com>)
        id 1nUGRW-00EYhW-AA; Tue, 15 Mar 2022 17:19:06 -0600
From:   "Eric W. Biederman" <ebiederm@xmission.com>
To:     <linux-kernel@vger.kernel.org>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        Alexey Gladkov <legion@kernel.org>,
        Kyle Huey <me@kylehuey.com>, Oleg Nesterov <oleg@redhat.com>,
        Kees Cook <keescook@chromium.org>,
        Al Viro <viro@ZenIV.linux.org.uk>, <linux-api@vger.kernel.org>,
        Jens Axboe <axboe@kernel.dk>
References: <87a6ha4zsd.fsf@email.froward.int.ebiederm.org>
        <87bl1kunjj.fsf@email.froward.int.ebiederm.org>
        <87r19opkx1.fsf_-_@email.froward.int.ebiederm.org>
        <87o82gdlu9.fsf_-_@email.froward.int.ebiederm.org>
Date:   Tue, 15 Mar 2022 18:18:59 -0500
In-Reply-To: <87o82gdlu9.fsf_-_@email.froward.int.ebiederm.org> (Eric
        W. Biederman's message of "Tue, 08 Mar 2022 18:13:34 -0600")
Message-ID: <87tubyx0rg.fsf_-_@email.froward.int.ebiederm.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/27.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-SPF: eid=1nUGRW-00EYhW-AA;;;mid=<87tubyx0rg.fsf_-_@email.froward.int.ebiederm.org>;;;hst=in02.mta.xmission.com;;;ip=68.227.174.4;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX18q0QTOMQzEBUR9felhWzseChKcq8/iNIs=
X-SA-Exim-Connect-IP: 68.227.174.4
X-SA-Exim-Mail-From: ebiederm@xmission.com
Subject: [PATCH 0/2] ptrace: Making the ptrace changes atomic
X-SA-Exim-Version: 4.2.1 (built Sat, 08 Feb 2020 21:53:50 +0000)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Precedence: bulk
List-ID: <linux-api.vger.kernel.org>
X-Mailing-List: linux-api@vger.kernel.org


While working on cleaning up the exit path it have had occasion to look
at what guarantees are provided for setting and reading the fields that
are provided in task_struct for ptraces.  Namely exit_code,
ptrace_message, and last_siginfo. It turns out as the ptrace interface
in the kernel was extended in the kernel the old existing interfaces
in the kernel were just wrapped and not properly updated to handle
the new functionality.  This lead to races and inconsistencies.

This fixes the reason for the races and inconsistencies by moving the
work of maintaining the ptrace fields into ptrace_stop.

The inconsistency that results in some ptrace_stop points continuing
with a signal while others will not I have left alone as it appears to
be part of our userspace ABI, and changing that risks breaking
userspace.

Eric W. Biederman (2):
      ptrace: Move setting/clearing ptrace_message into ptrace_stop
      ptrace: Return the signal to continue with from ptrace_stop

 include/linux/ptrace.h      | 17 +++++++----------
 include/uapi/linux/ptrace.h |  2 +-
 kernel/signal.c             | 40 ++++++++++++++++++++++++----------------
 3 files changed, 32 insertions(+), 27 deletions(-)

Eric

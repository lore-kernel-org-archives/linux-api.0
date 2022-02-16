Return-Path: <linux-api-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 53F0DC433EF
	for <linux-api@archiver.kernel.org>; Wed, 16 Feb 2022 16:04:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233725AbiBPQEn convert rfc822-to-8bit (ORCPT
        <rfc822;linux-api@archiver.kernel.org>);
        Wed, 16 Feb 2022 11:04:43 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:53702 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233585AbiBPQEm (ORCPT
        <rfc822;linux-api@vger.kernel.org>); Wed, 16 Feb 2022 11:04:42 -0500
Received: from out02.mta.xmission.com (out02.mta.xmission.com [166.70.13.232])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BA7AD2A8D07
        for <linux-api@vger.kernel.org>; Wed, 16 Feb 2022 08:04:30 -0800 (PST)
Received: from in01.mta.xmission.com ([166.70.13.51]:49644)
        by out02.mta.xmission.com with esmtps  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.93)
        (envelope-from <ebiederm@xmission.com>)
        id 1nKMfd-001nv3-J2; Wed, 16 Feb 2022 08:56:45 -0700
Received: from ip68-227-174-4.om.om.cox.net ([68.227.174.4]:37420 helo=email.froward.int.ebiederm.org.xmission.com)
        by in01.mta.xmission.com with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.93)
        (envelope-from <ebiederm@xmission.com>)
        id 1nKMfc-002XrX-IJ; Wed, 16 Feb 2022 08:56:45 -0700
From:   "Eric W. Biederman" <ebiederm@xmission.com>
To:     <linux-kernel@vger.kernel.org>
Cc:     Alexey Gladkov <legion@kernel.org>,
        Kees Cook <keescook@chromium.org>,
        Shuah Khan <shuah@kernel.org>,
        Christian Brauner <brauner@kernel.org>,
        Solar Designer <solar@openwall.com>,
        Ran Xiaokai <ran.xiaokai@zte.com.cn>,
        Linux Containers <containers@lists.linux-foundation.org>,
        Michal =?utf-8?Q?Koutn=C3=BD?= <mkoutny@suse.com>,
        <linux-api@vger.kernel.org>
References: <20220207121800.5079-1-mkoutny@suse.com>
        <87o83e2mbu.fsf@email.froward.int.ebiederm.org>
Date:   Wed, 16 Feb 2022 09:56:37 -0600
In-Reply-To: <87o83e2mbu.fsf@email.froward.int.ebiederm.org> (Eric
        W. Biederman's message of "Thu, 10 Feb 2022 20:01:25 -0600")
Message-ID: <87ilteiz4a.fsf_-_@email.froward.int.ebiederm.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/27.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
X-XM-SPF: eid=1nKMfc-002XrX-IJ;;;mid=<87ilteiz4a.fsf_-_@email.froward.int.ebiederm.org>;;;hst=in01.mta.xmission.com;;;ip=68.227.174.4;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX1+/L9et1C/bHc4Ya5pJzRgmcgiNxBncn0I=
X-SA-Exim-Connect-IP: 68.227.174.4
X-SA-Exim-Mail-From: ebiederm@xmission.com
Subject: [PATCH v2 0/5] ucounts: RLIMIT_NPROC fixes
X-SA-Exim-Version: 4.2.1 (built Sat, 08 Feb 2020 21:53:50 +0000)
X-SA-Exim-Scanned: Yes (on in01.mta.xmission.com)
Precedence: bulk
List-ID: <linux-api.vger.kernel.org>
X-Mailing-List: linux-api@vger.kernel.org


Michal Koutný recently found some bugs in the enforcement of
RLIMIT_NPROC in the recent ucount rlimit implementation.

I saw some additional bugs and some cleaner ways to fix the problem so
instead of starting with his fixes these are my own.

I have rewritten about half my fixes since the last time this was
posted.  There is this notion (not entirely wrong) that the code should
be consistent and make sense.  When I dug in I discovered that has not
been the case for the last 20 years.  Fixing the long standing
inconsistencies is something that seems to warrent wider vetting on
linux-api.

So with this set of patches I have developed a very conservative
approach changing only what is necessary to fix the bugs that I can
see clearly.  Cleanups and anything that is making the code more
consistent can follow after we have the code working as it has
historically.

Anyone who can please take a look and tell me if I am doing something silly.

Eric W. Biederman (5):
      rlimit: Fix RLIMIT_NPROC enforcement failure caused by capability calls in set_user
      ucounts: Enforce RLIMIT_NPROC not RLIMIT_NPROC+1
      ucounts: Base set_cred_ucounts changes on the real user
      ucounts: Move RLIMIT_NPROC handling after set_user
      ucounts: Handle wrapping in is_ucounts_overlimit

 kernel/cred.c   |  9 ++-------
 kernel/fork.c   | 10 +++++-----
 kernel/sys.c    | 20 ++++++++++++++------
 kernel/ucount.c |  3 ++-
 4 files changed, 23 insertions(+), 19 deletions(-)

Eric

Return-Path: <linux-api-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CC2BAC6FA82
	for <linux-api@archiver.kernel.org>; Thu, 22 Sep 2022 15:33:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229492AbiIVPdh (ORCPT <rfc822;linux-api@archiver.kernel.org>);
        Thu, 22 Sep 2022 11:33:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37540 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231578AbiIVPda (ORCPT
        <rfc822;linux-api@vger.kernel.org>); Thu, 22 Sep 2022 11:33:30 -0400
Received: from out02.mta.xmission.com (out02.mta.xmission.com [166.70.13.232])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 628C1FE046;
        Thu, 22 Sep 2022 08:33:29 -0700 (PDT)
Received: from in01.mta.xmission.com ([166.70.13.51]:35806)
        by out02.mta.xmission.com with esmtps  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.93)
        (envelope-from <ebiederm@xmission.com>)
        id 1obOCd-006cog-NE; Thu, 22 Sep 2022 09:33:27 -0600
Received: from ip68-110-29-46.om.om.cox.net ([68.110.29.46]:37646 helo=email.froward.int.ebiederm.org.xmission.com)
        by in01.mta.xmission.com with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.93)
        (envelope-from <ebiederm@xmission.com>)
        id 1obOCc-00B3Dh-Re; Thu, 22 Sep 2022 09:33:27 -0600
From:   "Eric W. Biederman" <ebiederm@xmission.com>
To:     cambda@linux.alibaba.com
Cc:     linux-kernel@vger.kernel.org, linux-api@vger.kernel.org,
        Xuan Zhuo <xuanzhuo@linux.alibaba.com>,
        Dust Li <dust.li@linux.alibaba.com>,
        Tony Lu <tonylu@linux.alibaba.com>
References: <69E17223-F0CA-4A4C-AAD7-065D6E6266D9@linux.alibaba.com>
Date:   Thu, 22 Sep 2022 10:33:20 -0500
In-Reply-To: <69E17223-F0CA-4A4C-AAD7-065D6E6266D9@linux.alibaba.com>
        (cambda@linux.alibaba.com's message of "Thu, 22 Sep 2022 17:11:12
        +0800")
Message-ID: <87k05v5sqn.fsf@email.froward.int.ebiederm.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/27.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-SPF: eid=1obOCc-00B3Dh-Re;;;mid=<87k05v5sqn.fsf@email.froward.int.ebiederm.org>;;;hst=in01.mta.xmission.com;;;ip=68.110.29.46;;;frm=ebiederm@xmission.com;;;spf=softfail
X-XM-AID: U2FsdGVkX18/4hzMM+SNTsxDzbpcPfCVlVvmPeUFjts=
X-SA-Exim-Connect-IP: 68.110.29.46
X-SA-Exim-Mail-From: ebiederm@xmission.com
Subject: Re: Syscall kill() can send signal to thread ID
X-SA-Exim-Version: 4.2.1 (built Sat, 08 Feb 2020 21:53:50 +0000)
X-SA-Exim-Scanned: Yes (on in01.mta.xmission.com)
Precedence: bulk
List-ID: <linux-api.vger.kernel.org>
X-Mailing-List: linux-api@vger.kernel.org

cambda@linux.alibaba.com writes:

> I found syscall kill() can send signal to a thread id, which is
> not the TGID. But the Linux manual page kill(2) said:
>
> "The kill() system call can be used to send any signal to any
> process group or process."
>
> And the Linux manual page tkill(2) said:
>
> "tgkill() sends the signal sig to the thread with the thread ID
> tid in the thread group tgid.  (By contrast, kill(2) can be used
> to send a signal only to a process (i.e., thread group) as a
> whole, and the signal will be delivered to an arbitrary thread
> within that process.)"
>
> I don't know whether the meaning of this 'process' should be
> the TGID? Because I found kill(tid, 0) will return ESRCH on FreeBSD,
> while Linux sends signal to the thread group that the thread belongs
> to.
>
> If this is as expected, should we add a notice to the Linux manual
> page? Because it's a syscall and the pids not equal to tgid are not
> listed under /proc. This may be a little confusing, I guess.

How did you come across this?  Were you just experimenting?

I am wondering if you were tracking a bug, or a portability problem
or something else.  If the current behavior is causing problems in
some way instead of just being a detail that no one really cares about
either way it would be worth considering if we want to maintain the
current behavior.

Eric


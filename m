Return-Path: <linux-api-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DAC18C6FA82
	for <linux-api@archiver.kernel.org>; Thu, 22 Sep 2022 15:10:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230036AbiIVPKT (ORCPT <rfc822;linux-api@archiver.kernel.org>);
        Thu, 22 Sep 2022 11:10:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58634 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229718AbiIVPKS (ORCPT
        <rfc822;linux-api@vger.kernel.org>); Thu, 22 Sep 2022 11:10:18 -0400
Received: from out03.mta.xmission.com (out03.mta.xmission.com [166.70.13.233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C7E69AE86B;
        Thu, 22 Sep 2022 08:10:16 -0700 (PDT)
Received: from in02.mta.xmission.com ([166.70.13.52]:41196)
        by out03.mta.xmission.com with esmtps  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.93)
        (envelope-from <ebiederm@xmission.com>)
        id 1obNqA-00FwmU-6k; Thu, 22 Sep 2022 09:10:14 -0600
Received: from ip68-110-29-46.om.om.cox.net ([68.110.29.46]:34042 helo=email.froward.int.ebiederm.org.xmission.com)
        by in02.mta.xmission.com with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.93)
        (envelope-from <ebiederm@xmission.com>)
        id 1obNq9-00GQDv-36; Thu, 22 Sep 2022 09:10:13 -0600
From:   "Eric W. Biederman" <ebiederm@xmission.com>
To:     cambda@linux.alibaba.com
Cc:     linux-kernel@vger.kernel.org, linux-api@vger.kernel.org,
        Xuan Zhuo <xuanzhuo@linux.alibaba.com>,
        Dust Li <dust.li@linux.alibaba.com>,
        Tony Lu <tonylu@linux.alibaba.com>
References: <69E17223-F0CA-4A4C-AAD7-065D6E6266D9@linux.alibaba.com>
Date:   Thu, 22 Sep 2022 10:09:42 -0500
In-Reply-To: <69E17223-F0CA-4A4C-AAD7-065D6E6266D9@linux.alibaba.com>
        (cambda@linux.alibaba.com's message of "Thu, 22 Sep 2022 17:11:12
        +0800")
Message-ID: <87pmfn5tu1.fsf@email.froward.int.ebiederm.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/27.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-SPF: eid=1obNq9-00GQDv-36;;;mid=<87pmfn5tu1.fsf@email.froward.int.ebiederm.org>;;;hst=in02.mta.xmission.com;;;ip=68.110.29.46;;;frm=ebiederm@xmission.com;;;spf=softfail
X-XM-AID: U2FsdGVkX18RaDoF8sElgMZrxR9EIeZmKMHLv4zyg+s=
X-SA-Exim-Connect-IP: 68.110.29.46
X-SA-Exim-Mail-From: ebiederm@xmission.com
Subject: Re: Syscall kill() can send signal to thread ID
X-SA-Exim-Version: 4.2.1 (built Sat, 08 Feb 2020 21:53:50 +0000)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
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

This is as expected.

The bit about is /proc is interesting.  On linux try
"cd /proc; cd tid" and see what happens.

Using the thread id in kill(2) is used to select the process, and the
delivery happens just the same as if the TGID had been used.

It is one of those odd behaviors that we could potentially remove.  It
would require hunting through all of the userspace applications to see
if something happens to depend upon that behavior.  Unless it becomes
expensive to maintain I don't expect we will ever do that.

For the same reason we probably don't want to document it as we don't
want to encourage anyone to use that strange corner case.  As it is when
we break it by accident and noone notices for a couple of years we can
remove the behavior as that will have proved that no one uses it ;)

Eric

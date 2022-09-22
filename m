Return-Path: <linux-api-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0A166C6FA82
	for <linux-api@archiver.kernel.org>; Thu, 22 Sep 2022 09:11:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229788AbiIVJLS (ORCPT <rfc822;linux-api@archiver.kernel.org>);
        Thu, 22 Sep 2022 05:11:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49224 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229498AbiIVJLR (ORCPT
        <rfc822;linux-api@vger.kernel.org>); Thu, 22 Sep 2022 05:11:17 -0400
Received: from out30-133.freemail.mail.aliyun.com (out30-133.freemail.mail.aliyun.com [115.124.30.133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 18A63B1BBB;
        Thu, 22 Sep 2022 02:11:15 -0700 (PDT)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R141e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=ay29a033018046059;MF=cambda@linux.alibaba.com;NM=1;PH=DS;RN=7;SR=0;TI=SMTPD_---0VQS1Tjf_1663837873;
Received: from smtpclient.apple(mailfrom:cambda@linux.alibaba.com fp:SMTPD_---0VQS1Tjf_1663837873)
          by smtp.aliyun-inc.com;
          Thu, 22 Sep 2022 17:11:13 +0800
From:   cambda@linux.alibaba.com
Content-Type: text/plain;
        charset=us-ascii
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3696.120.41.1.1\))
Subject: Syscall kill() can send signal to thread ID
Message-Id: <69E17223-F0CA-4A4C-AAD7-065D6E6266D9@linux.alibaba.com>
Date:   Thu, 22 Sep 2022 17:11:12 +0800
Cc:     linux-api@vger.kernel.org, Xuan Zhuo <xuanzhuo@linux.alibaba.com>,
        Dust Li <dust.li@linux.alibaba.com>,
        Tony Lu <tonylu@linux.alibaba.com>,
        Cambda Zhu <cambda@linux.alibaba.com>
To:     "Eric W. Biederman" <ebiederm@xmission.com>,
        linux-kernel@vger.kernel.org
X-Mailer: Apple Mail (2.3696.120.41.1.1)
Precedence: bulk
List-ID: <linux-api.vger.kernel.org>
X-Mailing-List: linux-api@vger.kernel.org

I found syscall kill() can send signal to a thread id, which is
not the TGID. But the Linux manual page kill(2) said:

"The kill() system call can be used to send any signal to any
process group or process."

And the Linux manual page tkill(2) said:

"tgkill() sends the signal sig to the thread with the thread ID
tid in the thread group tgid.  (By contrast, kill(2) can be used
to send a signal only to a process (i.e., thread group) as a
whole, and the signal will be delivered to an arbitrary thread
within that process.)"

I don't know whether the meaning of this 'process' should be
the TGID? Because I found kill(tid, 0) will return ESRCH on FreeBSD,
while Linux sends signal to the thread group that the thread belongs
to.

If this is as expected, should we add a notice to the Linux manual
page? Because it's a syscall and the pids not equal to tgid are not
listed under /proc. This may be a little confusing, I guess.

Regards,
Cambda

Return-Path: <linux-api-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 25AD3C04A95
	for <linux-api@archiver.kernel.org>; Fri, 23 Sep 2022 21:15:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232712AbiIWVP3 (ORCPT <rfc822;linux-api@archiver.kernel.org>);
        Fri, 23 Sep 2022 17:15:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37680 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229520AbiIWVP2 (ORCPT
        <rfc822;linux-api@vger.kernel.org>); Fri, 23 Sep 2022 17:15:28 -0400
Received: from out01.mta.xmission.com (out01.mta.xmission.com [166.70.13.231])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5146810974A;
        Fri, 23 Sep 2022 14:15:26 -0700 (PDT)
Received: from in02.mta.xmission.com ([166.70.13.52]:41498)
        by out01.mta.xmission.com with esmtps  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.93)
        (envelope-from <ebiederm@xmission.com>)
        id 1obq16-00E7wF-5r; Fri, 23 Sep 2022 15:15:24 -0600
Received: from ip68-110-29-46.om.om.cox.net ([68.110.29.46]:42904 helo=email.froward.int.ebiederm.org.xmission.com)
        by in02.mta.xmission.com with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.93)
        (envelope-from <ebiederm@xmission.com>)
        id 1obq15-002Iu9-9s; Fri, 23 Sep 2022 15:15:23 -0600
From:   "Eric W. Biederman" <ebiederm@xmission.com>
To:     Cambda Zhu <cambda@linux.alibaba.com>
Cc:     Florian Weimer <fweimer@redhat.com>, linux-kernel@vger.kernel.org,
        linux-api@vger.kernel.org, Xuan Zhuo <xuanzhuo@linux.alibaba.com>,
        Dust Li <dust.li@linux.alibaba.com>,
        Tony Lu <tonylu@linux.alibaba.com>
References: <69E17223-F0CA-4A4C-AAD7-065D6E6266D9@linux.alibaba.com>
        <87pmfn5tu1.fsf@email.froward.int.ebiederm.org>
        <87r102ejwo.fsf@oldenburg.str.redhat.com>
        <0CC7D0E7-71C5-4DAC-8A01-F9E13659F864@linux.alibaba.com>
        <87illeedc5.fsf@oldenburg.str.redhat.com>
        <613994F7-054D-4992-A159-96D34B17BC7F@linux.alibaba.com>
Date:   Fri, 23 Sep 2022 16:15:17 -0500
In-Reply-To: <613994F7-054D-4992-A159-96D34B17BC7F@linux.alibaba.com> (Cambda
        Zhu's message of "Fri, 23 Sep 2022 16:40:15 +0800")
Message-ID: <87illd4wt6.fsf@email.froward.int.ebiederm.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/27.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-SPF: eid=1obq15-002Iu9-9s;;;mid=<87illd4wt6.fsf@email.froward.int.ebiederm.org>;;;hst=in02.mta.xmission.com;;;ip=68.110.29.46;;;frm=ebiederm@xmission.com;;;spf=softfail
X-XM-AID: U2FsdGVkX1/4VcLV1GEezk2s9ZhUWxWg4vG40jA8jlg=
X-SA-Exim-Connect-IP: 68.110.29.46
X-SA-Exim-Mail-From: ebiederm@xmission.com
Subject: Re: Syscall kill() can send signal to thread ID
X-SA-Exim-Version: 4.2.1 (built Sat, 08 Feb 2020 21:53:50 +0000)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Precedence: bulk
List-ID: <linux-api.vger.kernel.org>
X-Mailing-List: linux-api@vger.kernel.org

Cambda Zhu <cambda@linux.alibaba.com> writes:

>> On Sep 23, 2022, at 15:53, Florian Weimer <fweimer@redhat.com> wrote:
>> 
>>> I don't quite understand what you mean, sorry. But if kill() returns
>>> -ESRCH for tid which is not equal to tgid, kill() can only send signal
>>> to thread group via main thread id, that is what BSD did and manual
>>> said. It seems not odd?
>> 
>> It's still odd because there's one TID per process that's valid for
>> kill by accident.  That's all.

> As far as I know, there is no rule forbidding 'process ID'(TGID on Linux)
> equals to main thread ID, is it right?

There is an unfortunate guarantee that glibc depends upon that after
exec TGID == TID for the initial thread in a process.  I say unfortunate
because maintaining that guarantee when another thread in the process
calls exec is a bit painful.

> If one wants to send signal to a specific thread, tgkill() can do
> that. As far as I understand, the difference between kill() and
> tgkill() is whether the signal is set on shared_pending, whatever the
> ID is a process ID or a thread ID. For Linux, the main thread ID just
> equals to the process ID.

Correct.  kill and tgkill uses different signal queues.  Kill is global
to the destination process and tgkill is always thread local.

> So the meaning of kill(main_tid, sig) is sending signal to a process,
> of which the PID equals to the first argument. It's not odd, I think.

Yes, the oddity is the TGID and TID share the same value, nothing else.

Eric

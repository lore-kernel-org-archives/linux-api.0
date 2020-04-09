Return-Path: <SRS0=1jdd=5Z=vger.kernel.org=linux-api-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 33FEEC2BA19
	for <linux-api@archiver.kernel.org>; Thu,  9 Apr 2020 21:35:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 00C80206F7
	for <linux-api@archiver.kernel.org>; Thu,  9 Apr 2020 21:35:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726689AbgDIVfQ convert rfc822-to-8bit (ORCPT
        <rfc822;linux-api@archiver.kernel.org>);
        Thu, 9 Apr 2020 17:35:16 -0400
Received: from out03.mta.xmission.com ([166.70.13.233]:45652 "EHLO
        out03.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726638AbgDIVfP (ORCPT
        <rfc822;linux-api@vger.kernel.org>); Thu, 9 Apr 2020 17:35:15 -0400
Received: from in02.mta.xmission.com ([166.70.13.52])
        by out03.mta.xmission.com with esmtps (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.90_1)
        (envelope-from <ebiederm@xmission.com>)
        id 1jMepN-0006bs-Vj; Thu, 09 Apr 2020 15:35:14 -0600
Received: from ip68-227-160-95.om.om.cox.net ([68.227.160.95] helo=x220.xmission.com)
        by in02.mta.xmission.com with esmtpsa (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.87)
        (envelope-from <ebiederm@xmission.com>)
        id 1jMepN-00032q-1R; Thu, 09 Apr 2020 15:35:13 -0600
From:   ebiederm@xmission.com (Eric W. Biederman)
To:     Andrey Vagin <avagin@openvz.org>
Cc:     "Michael Kerrisk \(man-pages\)" <mtk.manpages@gmail.com>,
        Dmitry Safonov <dima@arista.com>,
        Linux API <linux-api@vger.kernel.org>,
        Containers <containers@lists.linux-foundation.org>,
        Dmitry Safonov <0x7f454c46@gmail.com>,
        lkml <linux-kernel@vger.kernel.org>,
        Andy Lutomirski <luto@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Adrian Reber <adrian@lisas.de>
References: <703440af-031c-16b5-c1ff-54fb4bb5e10c@gmail.com>
        <CANaxB-y0ZB223dQgvxvUHRzkn4f-_B2vTzYxe_mi=o+3SJ4yVw@mail.gmail.com>
Date:   Thu, 09 Apr 2020 16:32:21 -0500
In-Reply-To: <CANaxB-y0ZB223dQgvxvUHRzkn4f-_B2vTzYxe_mi=o+3SJ4yVw@mail.gmail.com>
        (Andrey Vagin's message of "Thu, 9 Apr 2020 12:17:52 -0700")
Message-ID: <87a73kny56.fsf@x220.int.ebiederm.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
X-XM-SPF: eid=1jMepN-00032q-1R;;;mid=<87a73kny56.fsf@x220.int.ebiederm.org>;;;hst=in02.mta.xmission.com;;;ip=68.227.160.95;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX18ah23PW2EV6pjinWNRtdlzOJou4jxyK7w=
X-SA-Exim-Connect-IP: 68.227.160.95
X-SA-Exim-Mail-From: ebiederm@xmission.com
Subject: Re: A further though on /proc/PID/timens_offsets
X-SA-Exim-Version: 4.2.1 (built Thu, 05 May 2016 13:38:54 -0600)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-api-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-api.vger.kernel.org>
X-Mailing-List: linux-api@vger.kernel.org

Andrey Vagin <avagin@openvz.org> writes:

> On Tue, Apr 7, 2020 at 6:24 AM Michael Kerrisk (man-pages)
> <mtk.manpages@gmail.com> wrote:
>
>>        The  clock-id  identifies the clock whose offsets are being shown.
>>        This field is either 1, for CLOCK_MONOTONIC, or 7, for CLOCK_BOOT‐
>>        TIME.
>>
>> What was the reason for exposing numeric clock IDs in the
>> timens_offsets file? In API terms, that seems a little ugly.
>>
>> I think it would have been much nicer if the clocks were defined
>> symbolically in this file. I.e., that reading the file would have
>> shown something like
>>
>> monotonic    x    y
>> boottime     x    y
>>
>> And that records similarly with symbolic clock names could have
>> been written to the file. Was there a reason not to do this?
>
> No, there was not except that I haven't thought about this. I agree
> that symbolic clock names looks nicer for humans, but numeric clock
> IDs are a bit more convenient when we  need to set/read offsets from
> code. This interface is in the released kernel, so I think we can't
> change the format of the content of this file. But we can add support
> of symbolic clock names for setting clock offsets. What do you think?

The rule is we can change things as long as userspace doesn't care.  For
very new interfaces like this it is possible there are few enough
userspace programs that nothing cares.

Do you know if someone is using this interface yet?

Eric

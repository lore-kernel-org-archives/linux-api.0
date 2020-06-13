Return-Path: <SRS0=xMRc=72=vger.kernel.org=linux-api-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 361C2C433E0
	for <linux-api@archiver.kernel.org>; Sat, 13 Jun 2020 19:26:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 106082074D
	for <linux-api@archiver.kernel.org>; Sat, 13 Jun 2020 19:26:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726442AbgFMT0B (ORCPT <rfc822;linux-api@archiver.kernel.org>);
        Sat, 13 Jun 2020 15:26:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38550 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726304AbgFMTZ7 (ORCPT
        <rfc822;linux-api@vger.kernel.org>); Sat, 13 Jun 2020 15:25:59 -0400
Received: from bhuna.collabora.co.uk (bhuna.collabora.co.uk [IPv6:2a00:1098:0:82:1000:25:2eeb:e3e3])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 69F3BC03E96F;
        Sat, 13 Jun 2020 12:25:58 -0700 (PDT)
Received: from [127.0.0.1] (localhost [127.0.0.1])
        (Authenticated sender: tonyk)
        with ESMTPSA id A2F4D2A10FC
Subject: Re: [RFC 0/4] futex2: Add new futex interface
To:     "H.J. Lu" <hjl.tools@gmail.com>
Cc:     LKML <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>,
        Florian Weimer <fweimer@redhat.com>, malteskarupke@web.de,
        GNU C Library <libc-alpha@sourceware.org>,
        Linux API <linux-api@vger.kernel.org>,
        Ingo Molnar <mingo@redhat.com>, dvhart@infradead.org,
        kernel@collabora.com, krisman@collabora.com,
        pgriffais@valvesoftware.com
References: <20200612185122.327860-1-andrealmeid@collabora.com>
 <CAMe9rOqnBRzXv4xnhFvOgdVpDo0oRc1SYq38zcJWo9BPZseagg@mail.gmail.com>
From:   =?UTF-8?Q?Andr=c3=a9_Almeida?= <andrealmeid@collabora.com>
Message-ID: <c995708f-95e1-119b-c3ce-5fda27f24a4d@collabora.com>
Date:   Sat, 13 Jun 2020 16:25:46 -0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.9.0
MIME-Version: 1.0
In-Reply-To: <CAMe9rOqnBRzXv4xnhFvOgdVpDo0oRc1SYq38zcJWo9BPZseagg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-api-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-api.vger.kernel.org>
X-Mailing-List: linux-api@vger.kernel.org

Hello H.J.,

On 6/12/20 4:35 PM, H.J. Lu wrote:
> On Fri, Jun 12, 2020 at 11:53 AM André Almeida via Libc-alpha
> <libc-alpha@sourceware.org> wrote:
>> - Is expected to have a x32 ABI implementation as well? In the case of
>>   wait and wake, we could use the same as x86_64 ABI. However, for the
>>   waitv (aka wait on multiple futexes) we would need a proper x32 entry
>>   since we are dealing with 32bit pointers.
> 
> x32 should be able to use the same i386 compat systcall entry.   Will it be
> problem?
> 
Indeed, you are right. In the last iteration of this work, I had some
problems dealing with x32 ABI, but this new interface doesn't have the
same problem anymore. We can use the same sys_waitv_time64 interface for
both i368 and x32.

>>
> 
> H.J.
> 

Thanks,
André

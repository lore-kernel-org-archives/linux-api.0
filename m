Return-Path: <SRS0=82cJ=CU=vger.kernel.org=linux-api-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,UNPARSEABLE_RELAY,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AAA10C433E2
	for <linux-api@archiver.kernel.org>; Fri, 11 Sep 2020 20:11:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 73DE8221E5
	for <linux-api@archiver.kernel.org>; Fri, 11 Sep 2020 20:11:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725787AbgIKULZ (ORCPT <rfc822;linux-api@archiver.kernel.org>);
        Fri, 11 Sep 2020 16:11:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50148 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725783AbgIKULY (ORCPT
        <rfc822;linux-api@vger.kernel.org>); Fri, 11 Sep 2020 16:11:24 -0400
Received: from bhuna.collabora.co.uk (bhuna.collabora.co.uk [IPv6:2a00:1098:0:82:1000:25:2eeb:e3e3])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 20C0BC061573;
        Fri, 11 Sep 2020 13:11:24 -0700 (PDT)
Received: from [127.0.0.1] (localhost [127.0.0.1])
        (Authenticated sender: krisman)
        with ESMTPSA id BA2E029BA66
From:   Gabriel Krisman Bertazi <krisman@collabora.com>
To:     peterz@infradead.org
Cc:     luto@kernel.org, tglx@linutronix.de, keescook@chromium.org,
        x86@kernel.org, linux-kernel@vger.kernel.org,
        linux-api@vger.kernel.org, willy@infradead.org,
        linux-kselftest@vger.kernel.org, shuah@kernel.org,
        kernel@collabora.com
Subject: Re: [PATCH v6 2/9] kernel: entry: Support TIF_SYSCAL_INTERCEPT on common entry code
Organization: Collabora
References: <20200904203147.2908430-1-krisman@collabora.com>
        <20200904203147.2908430-3-krisman@collabora.com>
        <20200911093549.GE1362448@hirez.programming.kicks-ass.net>
Date:   Fri, 11 Sep 2020 16:11:19 -0400
In-Reply-To: <20200911093549.GE1362448@hirez.programming.kicks-ass.net>
        (peterz@infradead.org's message of "Fri, 11 Sep 2020 11:35:49 +0200")
Message-ID: <874ko4nkew.fsf@collabora.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-api-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-api.vger.kernel.org>
X-Mailing-List: linux-api@vger.kernel.org

peterz@infradead.org writes:

> On Fri, Sep 04, 2020 at 04:31:40PM -0400, Gabriel Krisman Bertazi wrote:
>> diff --git a/include/linux/entry-common.h b/include/linux/entry-common.h
>> index efebbffcd5cc..72ce9ca860c6 100644
>> --- a/include/linux/entry-common.h
>> +++ b/include/linux/entry-common.h
>> @@ -21,10 +21,6 @@
>>  # define _TIF_SYSCALL_TRACEPOINT	(0)
>>  #endif
>>  
>> -#ifndef _TIF_SECCOMP
>> -# define _TIF_SECCOMP			(0)
>> -#endif
>> -
>>  #ifndef _TIF_SYSCALL_AUDIT
>>  # define _TIF_SYSCALL_AUDIT		(0)
>>  #endif
>
> Why doesn't this add:
>
> #ifndef _TIF_SYSCALL_INTERCEPT
> #define _TIF_SYSCALL_INTERCEPT		(0)
> #endif
>

I will add in the next version.  Thanks!

-- 
Gabriel Krisman Bertazi

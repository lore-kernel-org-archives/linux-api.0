Return-Path: <linux-api-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_SANE_1 autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2F834C433F5
	for <linux-api@archiver.kernel.org>; Tue, 14 Sep 2021 17:19:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 05D9961130
	for <linux-api@archiver.kernel.org>; Tue, 14 Sep 2021 17:19:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229482AbhINRUZ (ORCPT <rfc822;linux-api@archiver.kernel.org>);
        Tue, 14 Sep 2021 13:20:25 -0400
Received: from bhuna.collabora.co.uk ([46.235.227.227]:52070 "EHLO
        bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229464AbhINRUZ (ORCPT
        <rfc822;linux-api@vger.kernel.org>); Tue, 14 Sep 2021 13:20:25 -0400
Received: from [127.0.0.1] (localhost [127.0.0.1])
        (Authenticated sender: tonyk)
        with ESMTPSA id 517711F41E7E
Message-ID: <58536544-e032-1954-ce30-d131869dc95e@collabora.com>
Date:   Tue, 14 Sep 2021 14:18:58 -0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.1.0
Subject: Re: [PATCH v3 2/6] futex2: Implement vectorized wait
Content-Language: en-US
To:     Gabriel Krisman Bertazi <krisman@collabora.com>
Cc:     Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Darren Hart <dvhart@infradead.org>,
        linux-kernel@vger.kernel.org, Steven Rostedt <rostedt@goodmis.org>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        kernel@collabora.com, linux-api@vger.kernel.org,
        libc-alpha@sourceware.org, mtk.manpages@gmail.com,
        Davidlohr Bueso <dave@stgolabs.net>,
        Arnd Bergmann <arnd@arndb.de>
References: <20210913175249.81074-1-andrealmeid@collabora.com>
 <20210913175249.81074-3-andrealmeid@collabora.com>
 <875yv4ge83.fsf@collabora.com>
From:   =?UTF-8?Q?Andr=c3=a9_Almeida?= <andrealmeid@collabora.com>
In-Reply-To: <875yv4ge83.fsf@collabora.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-api.vger.kernel.org>
X-Mailing-List: linux-api@vger.kernel.org

Hi Gabriel, thanks for the feedback! A few clarifications:

Às 22:03 de 13/09/21, Gabriel Krisman Bertazi escreveu:
> André Almeida <andrealmeid@collabora.com> writes:
> 
>> Add support to wait on multiple futexes. This is the interface
>> implemented by this syscall:
>>

[...]

>>  
>> +/*
>> + * Flags to specify the bit length of the futex word for futex2 syscalls.
>> + * Currently, only 32 is supported.
>> + */
>> +#define FUTEX_32		2
> 
> Why start at 2?

I was planning to do:

FUTEX_8		0
FUTEX_16	1
FUTEX_32	2
FUTEX_64	3

> 
>> +
>> +/*
>> + * Max numbers of elements in a futex_waitv array
>> + */
>> +#define FUTEX_WAITV_MAX		128
>> +
>> +/**
>> + * struct futex_waitv - A waiter for vectorized wait
>> + * @val:	Expected value at uaddr
>> + * @uaddr:	User address to wait on
>> + * @flags:	Flags for this waiter
>> + * @__reserved:	Reserved member to preserve data alignment. Should be 0.
>> + */
>> +struct futex_waitv {
>> +	__u64 val;
>> +	__u64 uaddr;
>> +	__u32 flags;
>> +	__u32 __reserved;
>> +};
> 
> why force uaddr  to be __u64, even for 32-bit?  uaddr could be a (void*) for
> all we care, no?  Also, by adding a reserved field, you are wasting 32
> bits even on 32-bit architectures.
> 

We do that to make the structure layout compatible with both entry
points, remove the need for special cast and duplicated code, as
suggested by Thomas and Arnd:

https://lore.kernel.org/lkml/87v94310gm.ffs@tglx/

https://lore.kernel.org/lkml/CAK8P3a0MO1qJLRkCH8KrZ3+=L66KOsMRmcbrUvYdMoKykdKoyQ@mail.gmail.com/

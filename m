Return-Path: <linux-api-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A64CFC433E6
	for <linux-api@archiver.kernel.org>; Thu, 18 Feb 2021 19:20:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 68B9D64E79
	for <linux-api@archiver.kernel.org>; Thu, 18 Feb 2021 19:20:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232358AbhBRTUI (ORCPT <rfc822;linux-api@archiver.kernel.org>);
        Thu, 18 Feb 2021 14:20:08 -0500
Received: from bhuna.collabora.co.uk ([46.235.227.227]:42370 "EHLO
        bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233968AbhBRTNB (ORCPT
        <rfc822;linux-api@vger.kernel.org>); Thu, 18 Feb 2021 14:13:01 -0500
Received: from [127.0.0.1] (localhost [127.0.0.1])
        (Authenticated sender: tonyk)
        with ESMTPSA id E2A681F45E51
Subject: Re: [RFC PATCH 06/13] docs: locking: futex2: Add documentation
To:     Randy Dunlap <rdunlap@infradead.org>
Cc:     kernel@collabora.com, krisman@collabora.com,
        pgriffais@valvesoftware.com, z.figura12@gmail.com,
        joel@joelfernandes.org, malteskarupke@fastmail.fm,
        linux-api@vger.kernel.org, fweimer@redhat.com,
        libc-alpha@sourceware.org, linux-kselftest@vger.kernel.org,
        Steven Rostedt <rostedt@goodmis.org>, shuah@kernel.org,
        acme@kernel.org, corbet@lwn.net,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@redhat.com>,
        Darren Hart <dvhart@infradead.org>,
        linux-kernel@vger.kernel.org,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>
References: <20210215152404.250281-1-andrealmeid@collabora.com>
 <20210215152404.250281-7-andrealmeid@collabora.com>
 <4e70780e-1a4d-79a9-e183-44a3454e0298@infradead.org>
From:   =?UTF-8?Q?Andr=c3=a9_Almeida?= <andrealmeid@collabora.com>
Message-ID: <2a88124e-6cc1-a886-6076-affeb25039f7@collabora.com>
Date:   Thu, 18 Feb 2021 16:12:09 -0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.1
MIME-Version: 1.0
In-Reply-To: <4e70780e-1a4d-79a9-e183-44a3454e0298@infradead.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-api.vger.kernel.org>
X-Mailing-List: linux-api@vger.kernel.org

Hi Randy,

Thanks for the feedback. All suggestions/fixes were applied for next 
version.

Às 15:34 de 16/02/21, Randy Dunlap escreveu:
> On 2/15/21 7:23 AM, André Almeida wrote:
>> Add a new documentation file specifying both userspace API and internal
>> implementation details of futex2 syscalls.
>>
>> Signed-off-by: André Almeida <andrealmeid@collabora.com>

Return-Path: <linux-api-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 32B1CC63777
	for <linux-api@archiver.kernel.org>; Wed, 18 Nov 2020 17:02:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CDCD824898
	for <linux-api@archiver.kernel.org>; Wed, 18 Nov 2020 17:02:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727235AbgKRRBn (ORCPT <rfc822;linux-api@archiver.kernel.org>);
        Wed, 18 Nov 2020 12:01:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34442 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727226AbgKRRBn (ORCPT
        <rfc822;linux-api@vger.kernel.org>); Wed, 18 Nov 2020 12:01:43 -0500
Received: from bhuna.collabora.co.uk (bhuna.collabora.co.uk [IPv6:2a00:1098:0:82:1000:25:2eeb:e3e3])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E27D7C0613D4;
        Wed, 18 Nov 2020 09:01:42 -0800 (PST)
Received: from [127.0.0.1] (localhost [127.0.0.1])
        (Authenticated sender: krisman)
        with ESMTPSA id E370D1F451B0
From:   Gabriel Krisman Bertazi <krisman@collabora.com>
To:     Florian Weimer <fw@deneb.enyo.de>
Cc:     luto@kernel.org, tglx@linutronix.de, keescook@chromium.org,
        christian.brauner@ubuntu.com, peterz@infradead.org,
        willy@infradead.org, shuah@kernel.org,
        linux-kernel@vger.kernel.org, linux-api@vger.kernel.org,
        linux-kselftest@vger.kernel.org, x86@kernel.org, gofmanp@gmail.com,
        kernel@collabora.com
Subject: Re: [PATCH v7 0/7] Syscall User Dispatch
Organization: Collabora
References: <20201118032840.3429268-1-krisman@collabora.com>
        <87a6vfyrts.fsf@mid.deneb.enyo.de>
Date:   Wed, 18 Nov 2020 12:01:36 -0500
In-Reply-To: <87a6vfyrts.fsf@mid.deneb.enyo.de> (Florian Weimer's message of
        "Wed, 18 Nov 2020 09:47:27 +0100")
Message-ID: <87blfuvbtb.fsf@collabora.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/27.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <linux-api.vger.kernel.org>
X-Mailing-List: linux-api@vger.kernel.org

Florian Weimer <fw@deneb.enyo.de> writes:

> * Gabriel Krisman Bertazi:
>
>> This is the v7 of syscall user dispatch.  This version is a bit
>> different from v6 on the following points, after the modifications
>> requested on that submission.
>
> Is this supposed to work with existing (Linux) libcs, or do you bring
> your own low-level run-time libraries?

Hi Florian,

The main use case is to intercept Windows system calls of an application
running over Wine. While Wine is using an unmodified glibc to execute
its own native Linux syscalls, the Windows libraries might be directly
issuing syscalls that we need to capture. So there is a mix. While this
mechanism is compatible with existing libc, we might have other
libraries executing a syscall instruction directly.

-- 
Gabriel Krisman Bertazi

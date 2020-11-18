Return-Path: <linux-api-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 710CCC5519F
	for <linux-api@archiver.kernel.org>; Wed, 18 Nov 2020 17:31:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 161E0248E5
	for <linux-api@archiver.kernel.org>; Wed, 18 Nov 2020 17:31:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726085AbgKRRb2 (ORCPT <rfc822;linux-api@archiver.kernel.org>);
        Wed, 18 Nov 2020 12:31:28 -0500
Received: from albireo.enyo.de ([37.24.231.21]:42098 "EHLO albireo.enyo.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725774AbgKRRb2 (ORCPT <rfc822;linux-api@vger.kernel.org>);
        Wed, 18 Nov 2020 12:31:28 -0500
Received: from [172.17.203.2] (helo=deneb.enyo.de)
        by albireo.enyo.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        id 1kfRIf-0003M0-M3; Wed, 18 Nov 2020 17:31:21 +0000
Received: from fw by deneb.enyo.de with local (Exim 4.92)
        (envelope-from <fw@deneb.enyo.de>)
        id 1kfRIf-0004SR-K8; Wed, 18 Nov 2020 18:31:21 +0100
From:   Florian Weimer <fw@deneb.enyo.de>
To:     Dave Martin <Dave.Martin@arm.com>
Cc:     Peter Collingbourne <pcc@google.com>, libc-alpha@sourceware.org,
        Catalin Marinas <catalin.marinas@arm.com>,
        Kevin Brodsky <kevin.brodsky@arm.com>,
        linux-api@vger.kernel.org, Kostya Serebryany <kcc@google.com>,
        Evgenii Stepanov <eugenis@google.com>,
        Andrey Konovalov <andreyknvl@google.com>,
        Vincenzo Frascino <vincenzo.frascino@arm.com>,
        Will Deacon <will@kernel.org>,
        Linux ARM <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH v2] arm64: Introduce prctl(PR_PAC_{SET,GET}_ENABLED_KEYS)
References: <20201014055106.25164-1-pcc@google.com>
        <87blfv6fj3.fsf@mid.deneb.enyo.de> <20201118171945.GG6882@arm.com>
Date:   Wed, 18 Nov 2020 18:31:21 +0100
In-Reply-To: <20201118171945.GG6882@arm.com> (Dave Martin's message of "Wed,
        18 Nov 2020 17:19:45 +0000")
Message-ID: <874klmvafq.fsf@mid.deneb.enyo.de>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <linux-api.vger.kernel.org>
X-Mailing-List: linux-api@vger.kernel.org

* Dave Martin:

> IIUC the default compiler options when using PAC will only use the
> A key, and only use the PAC instructions that execute as NOPs when the
> affected key is disabled (precisely so that the code still runs on non-
> PAC supporting hardware).  But you can't simply flip it on and off while
> there are function frames on the stack that assume it's either on or off.

I think we can do the switch at the top-most frame, at least in ld.so.
I have not thought about statically linked binaries. 8-/

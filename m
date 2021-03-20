Return-Path: <linux-api-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2B488C433C1
	for <linux-api@archiver.kernel.org>; Sat, 20 Mar 2021 19:26:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C882B61941
	for <linux-api@archiver.kernel.org>; Sat, 20 Mar 2021 19:26:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229780AbhCTT0J (ORCPT <rfc822;linux-api@archiver.kernel.org>);
        Sat, 20 Mar 2021 15:26:09 -0400
Received: from albireo.enyo.de ([37.24.231.21]:46276 "EHLO albireo.enyo.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229766AbhCTTZh (ORCPT <rfc822;linux-api@vger.kernel.org>);
        Sat, 20 Mar 2021 15:25:37 -0400
X-Greylist: delayed 304 seconds by postgrey-1.27 at vger.kernel.org; Sat, 20 Mar 2021 15:25:36 EDT
Received: from [172.17.203.2] (port=58237 helo=deneb.enyo.de)
        by albireo.enyo.de ([172.17.140.2]) with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        id 1lNh9B-0007LV-FW; Sat, 20 Mar 2021 19:20:29 +0000
Received: from fw by deneb.enyo.de with local (Exim 4.92)
        (envelope-from <fw@deneb.enyo.de>)
        id 1lNh9B-00035B-Aa; Sat, 20 Mar 2021 20:20:29 +0100
From:   Florian Weimer <fw@deneb.enyo.de>
To:     Alexey Dobriyan <adobriyan@gmail.com>
Cc:     Andy Lutomirski <luto@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Linux API <linux-api@vger.kernel.org>
Subject: Re: [PATCH] Document that PF_KTHREAD _is_ ABI
References: <YFYjOB1jpbqyNPAp@localhost.localdomain>
        <CALCETrUPAvUOr8V5db0gu5RKVftKFwbBEkh6Aob57v+D-xdEig@mail.gmail.com>
        <YFYzPcHKWm3U04pN@localhost.localdomain>
Date:   Sat, 20 Mar 2021 20:20:29 +0100
In-Reply-To: <YFYzPcHKWm3U04pN@localhost.localdomain> (Alexey Dobriyan's
        message of "Sat, 20 Mar 2021 20:39:09 +0300")
Message-ID: <87pmztzl6q.fsf@mid.deneb.enyo.de>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <linux-api.vger.kernel.org>
X-Mailing-List: linux-api@vger.kernel.org

* Alexey Dobriyan:

> Some aren't -- PF_FORKNOEXEC. However it is silly for userspace to query it
> because programs knows if it forked but didn't exec without external help.

Libraries typically lack that knowledge, and may have reasons to
detect forks.  But there are probably better ways than this flag, like
a MADV_WIPEONFORK mapping, or comparing counters in MAP_PRIVATE and
MAP_SHARED mappings.

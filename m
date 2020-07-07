Return-Path: <SRS0=QCBU=AS=vger.kernel.org=linux-api-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A63C1C433E0
	for <linux-api@archiver.kernel.org>; Tue,  7 Jul 2020 06:27:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 855BE206CD
	for <linux-api@archiver.kernel.org>; Tue,  7 Jul 2020 06:27:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726869AbgGGG1h (ORCPT <rfc822;linux-api@archiver.kernel.org>);
        Tue, 7 Jul 2020 02:27:37 -0400
Received: from albireo.enyo.de ([37.24.231.21]:47782 "EHLO albireo.enyo.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726825AbgGGG1h (ORCPT <rfc822;linux-api@vger.kernel.org>);
        Tue, 7 Jul 2020 02:27:37 -0400
Received: from [172.17.203.2] (helo=deneb.enyo.de)
        by albireo.enyo.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        id 1jsh4c-00064V-Km; Tue, 07 Jul 2020 06:27:22 +0000
Received: from fw by deneb.enyo.de with local (Exim 4.92)
        (envelope-from <fw@deneb.enyo.de>)
        id 1jsh47-0002gS-Q5; Tue, 07 Jul 2020 08:26:51 +0200
From:   Florian Weimer <fw@deneb.enyo.de>
To:     Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc:     Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org,
        Peter Zijlstra <peterz@infradead.org>,
        "Paul E . McKenney" <paulmck@linux.ibm.com>,
        Boqun Feng <boqun.feng@gmail.com>,
        "H . Peter Anvin" <hpa@zytor.com>, Paul Turner <pjt@google.com>,
        linux-api@vger.kernel.org
Subject: Re: [RFC PATCH for 5.8 0/4] rseq cpu_id ABI fix
References: <20200706204913.20347-1-mathieu.desnoyers@efficios.com>
Date:   Tue, 07 Jul 2020 08:26:51 +0200
In-Reply-To: <20200706204913.20347-1-mathieu.desnoyers@efficios.com> (Mathieu
        Desnoyers's message of "Mon, 6 Jul 2020 16:49:09 -0400")
Message-ID: <87k0zfzvpw.fsf@mid.deneb.enyo.de>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-api-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-api.vger.kernel.org>
X-Mailing-List: linux-api@vger.kernel.org

* Mathieu Desnoyers:

> This is an RFC aiming for quick inclusion into the Linux kernel, unless
> we prefer reverting the entire rseq glibc integration and try again in 6
> months. Their upcoming release is on August 3rd, so we need to take a
> decision on this matter quickly.

Just to clarify here, I don't think it's necessary to change glibc so
that it only enables the rseq functionality if this particular bug is
not present.  From our perspective, it's just another kernel bug.

If you truly feel we must not enable this feature in its present
kernel state, then we need a working patch on all sides by the end of
the week because the hard ABI freeze for glibc 2.32 is coming up, and
at without any other patches, the only safe choice to prevent glibc
from using slightly broken rseq support would be to back out the rseq
patches.

But again, I don't think such drastic action is necessary.

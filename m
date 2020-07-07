Return-Path: <SRS0=QCBU=AS=vger.kernel.org=linux-api-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 83A2BC433E0
	for <linux-api@archiver.kernel.org>; Tue,  7 Jul 2020 14:55:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 68DB820775
	for <linux-api@archiver.kernel.org>; Tue,  7 Jul 2020 14:55:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728272AbgGGOy7 (ORCPT <rfc822;linux-api@archiver.kernel.org>);
        Tue, 7 Jul 2020 10:54:59 -0400
Received: from albireo.enyo.de ([37.24.231.21]:59320 "EHLO albireo.enyo.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728266AbgGGOy7 (ORCPT <rfc822;linux-api@vger.kernel.org>);
        Tue, 7 Jul 2020 10:54:59 -0400
Received: from [172.17.203.2] (helo=deneb.enyo.de)
        by albireo.enyo.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        id 1jsozn-0004vt-47; Tue, 07 Jul 2020 14:54:55 +0000
Received: from fw by deneb.enyo.de with local (Exim 4.92)
        (envelope-from <fw@deneb.enyo.de>)
        id 1jsozn-00064o-0d; Tue, 07 Jul 2020 16:54:55 +0200
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
Date:   Tue, 07 Jul 2020 16:54:55 +0200
In-Reply-To: <20200706204913.20347-1-mathieu.desnoyers@efficios.com> (Mathieu
        Desnoyers's message of "Mon, 6 Jul 2020 16:49:09 -0400")
Message-ID: <87tuyjxtmo.fsf@mid.deneb.enyo.de>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-api-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-api.vger.kernel.org>
X-Mailing-List: linux-api@vger.kernel.org

I would like to point out that the subject is misleading: This is not
an ABI change.  It fixes the contents of the __rseq_abi TLS variable
(as glibc calls it), but that's it.

(Sorry, I should have mentioned this earlier.)

Return-Path: <linux-api-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E41E3C41513
	for <linux-api@archiver.kernel.org>; Mon,  7 Aug 2023 12:37:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233621AbjHGMhY (ORCPT <rfc822;linux-api@archiver.kernel.org>);
        Mon, 7 Aug 2023 08:37:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36556 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233604AbjHGMhT (ORCPT
        <rfc822;linux-api@vger.kernel.org>); Mon, 7 Aug 2023 08:37:19 -0400
Received: from desiato.infradead.org (desiato.infradead.org [IPv6:2001:8b0:10b:1:d65d:64ff:fe57:4e05])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 578301701;
        Mon,  7 Aug 2023 05:37:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=desiato.20200630; h=Subject:Cc:To:From:Date:Message-ID:
        Sender:Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:In-Reply-To:References;
        bh=9/pJsYj1/WijKEZ8K5YnSRYSKdOjes1Urr9WU45qQj4=; b=cC93uDtx74yN9RqC3KO1Jhv9Yj
        POF98BS+EVn0dtbcG4zEuHgfIS3Kyp9hCGW8ja3IlZQCQnvsaAEYWjy+27NobZmBpwMnfCb0nn49Y
        EIFwp3EOJ3wz6w1A9vNBWg5vE29PUdJHzshGMuhiWeEBY4k7i9bIGWJZKjoGMeMUKgCf31BmGkzQQ
        ymG3E3oVjnnl7D/5JmmQkSkR53HRyyEiKZ8A8mzWw8vhP51NHI3Yu01a5yd8t/k5tmYmU3JY/Oo8F
        j50JZBDjMu00XQmdWyRWJmmeLrWsF6FhesBZID6e8AWyo/VLmhVp5eVErS4tICWNQNUFpwQE8qeSH
        G6WM7kXg==;
Received: from j130084.upc-j.chello.nl ([24.132.130.84] helo=noisy.programming.kicks-ass.net)
        by desiato.infradead.org with esmtpsa (Exim 4.96 #2 (Red Hat Linux))
        id 1qSzTk-003oSc-1J;
        Mon, 07 Aug 2023 12:36:56 +0000
Received: from hirez.programming.kicks-ass.net (hirez.programming.kicks-ass.net [192.168.1.225])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits))
        (Client did not present a certificate)
        by noisy.programming.kicks-ass.net (Postfix) with ESMTPS id CFC2E30014A;
        Mon,  7 Aug 2023 14:36:54 +0200 (CEST)
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 0)
        id 849AD202F9535; Mon,  7 Aug 2023 14:36:54 +0200 (CEST)
Message-ID: <20230807121843.710612856@infradead.org>
User-Agent: quilt/0.66
Date:   Mon, 07 Aug 2023 14:18:43 +0200
From:   Peter Zijlstra <peterz@infradead.org>
To:     tglx@linutronix.de, axboe@kernel.dk
Cc:     linux-kernel@vger.kernel.org, peterz@infradead.org,
        mingo@redhat.com, dvhart@infradead.org, dave@stgolabs.net,
        andrealmeid@igalia.com, Andrew Morton <akpm@linux-foundation.org>,
        urezki@gmail.com, hch@infradead.org, lstoakes@gmail.com,
        Arnd Bergmann <arnd@arndb.de>, linux-api@vger.kernel.org,
        linux-mm@kvack.org, linux-arch@vger.kernel.org,
        malteskarupke@web.de
Subject: [PATCH  v2 00/14] futex: More futex2 bits
Precedence: bulk
List-ID: <linux-api.vger.kernel.org>
X-Mailing-List: linux-api@vger.kernel.org

Hi!

New version of the futex2 patches. Futex2 is a new interface to the same 'old'
futex core. An attempt to get away from the multiplex syscall and add a little
room for extentions.

Changes since v1:
 - Moved the FUTEX2_{8,16,32,64} into FUTEX2_SIZE_Un namespace (tglx)
 - Added FUTEX2_SIZE_MASK by popular demand (arnd,tglx)
 - Added more comments (tglx)
 - Updated __NR_compat_syscalls for arm64 (arnd)
 - Folded some tags





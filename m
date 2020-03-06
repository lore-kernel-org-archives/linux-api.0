Return-Path: <SRS0=u3R8=4X=vger.kernel.org=linux-api-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C72FCC10F25
	for <linux-api@archiver.kernel.org>; Fri,  6 Mar 2020 11:14:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A4FC42084E
	for <linux-api@archiver.kernel.org>; Fri,  6 Mar 2020 11:14:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726635AbgCFLOJ (ORCPT <rfc822;linux-api@archiver.kernel.org>);
        Fri, 6 Mar 2020 06:14:09 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:50687 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726162AbgCFLOJ (ORCPT
        <rfc822;linux-api@vger.kernel.org>); Fri, 6 Mar 2020 06:14:09 -0500
Received: from b2b-5-147-251-51.unitymedia.biz ([5.147.251.51] helo=wittgenstein)
        by youngberry.canonical.com with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.86_2)
        (envelope-from <christian.brauner@ubuntu.com>)
        id 1jAAvd-0007RN-Vx; Fri, 06 Mar 2020 11:14:06 +0000
Date:   Fri, 6 Mar 2020 12:14:05 +0100
From:   Christian Brauner <christian.brauner@ubuntu.com>
To:     Minchan Kim <minchan@kernel.org>
Cc:     Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>,
        linux-mm <linux-mm@kvack.org>, linux-api@vger.kernel.org,
        oleksandr@redhat.com, Suren Baghdasaryan <surenb@google.com>,
        Tim Murray <timmurray@google.com>,
        Daniel Colascione <dancol@google.com>,
        Sandeep Patil <sspatil@google.com>,
        Sonny Rao <sonnyrao@google.com>,
        Brian Geffon <bgeffon@google.com>,
        Michal Hocko <mhocko@suse.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Shakeel Butt <shakeelb@google.com>,
        John Dias <joaodias@google.com>,
        Joel Fernandes <joel@joelfernandes.org>,
        Jann Horn <jannh@google.com>,
        alexander.h.duyck@linux.intel.com, sj38.park@gmail.com,
        Christoph Hellwig <hch@infradead.org>,
        Christian Brauner <christian@brauner.io>
Subject: Re: [PATCH v7 4/7] pid: move pidfd_get_pid function to pid.c
Message-ID: <20200306111405.4o6jsmyo6pde3p5p@wittgenstein>
References: <20200302193630.68771-1-minchan@kernel.org>
 <20200302193630.68771-5-minchan@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20200302193630.68771-5-minchan@kernel.org>
Sender: linux-api-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-api.vger.kernel.org>
X-Mailing-List: linux-api@vger.kernel.org

On Mon, Mar 02, 2020 at 11:36:27AM -0800, Minchan Kim wrote:
> process_madvise syscall needs pidfd_get_pid function to translate
> pidfd to pid so this patch move the function to kernel/pid.c.
> 
> Cc: Christoph Hellwig <hch@infradead.org>
> Cc: Christian Brauner <christian@brauner.io>
> Reviewed-by: Suren Baghdasaryan <surenb@google.com>
> Suggested-by: Alexander Duyck <alexander.h.duyck@linux.intel.com>
> Reviewed-by: Alexander Duyck <alexander.h.duyck@linux.intel.com>
> Signed-off-by: Minchan Kim <minchan@kernel.org>

Acked-by: Christian Brauner <christian.brauner@ubuntu.com>

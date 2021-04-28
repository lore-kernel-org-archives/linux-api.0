Return-Path: <linux-api-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-24.8 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1,USER_IN_DEF_DKIM_WL autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8E481C433B4
	for <linux-api@archiver.kernel.org>; Wed, 28 Apr 2021 00:04:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7717161402
	for <linux-api@archiver.kernel.org>; Wed, 28 Apr 2021 00:04:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238512AbhD1AEv (ORCPT <rfc822;linux-api@archiver.kernel.org>);
        Tue, 27 Apr 2021 20:04:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41144 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238462AbhD1AEu (ORCPT
        <rfc822;linux-api@vger.kernel.org>); Tue, 27 Apr 2021 20:04:50 -0400
Received: from mail-oi1-x234.google.com (mail-oi1-x234.google.com [IPv6:2607:f8b0:4864:20::234])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 07713C061761
        for <linux-api@vger.kernel.org>; Tue, 27 Apr 2021 17:04:07 -0700 (PDT)
Received: by mail-oi1-x234.google.com with SMTP id z7so9157088oix.9
        for <linux-api@vger.kernel.org>; Tue, 27 Apr 2021 17:04:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:in-reply-to:message-id:references
         :user-agent:mime-version;
        bh=oAsXSdHV4QEHuWs1CZyCI+yqX4rqMIruOm/fgXYjaRM=;
        b=HWYZM3KyeyimNvegZZQjUm8uQj1OWj5yhq5CWXhgxbKYhQoR30IFdz9niNiKZRg3cz
         4ekDbd28rEMNtS1MUoHtX71oBm71IZfihg2lunPU07LayCLGWQ78GFv5qUuDgW8JYAqS
         jhG1xgILzczsJKqq4q9lU8dPJwu9eQCs5BbWCfOgls83uOzsOqFww735tC6Ekm08MeMO
         fCvL2/mUZWe62n+N1gr95Ek0FNeWOFn6xlh2qIw+MoOPg3RM4UN6UqyFp1lxjLhNg6XS
         jCjDzhzIqAsRs/Um0A42rwoZr+cMJ9c3RQlffD8kEfDp7pL3VLO3RY1Nb8aXKKqU4mTc
         HJVA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:in-reply-to:message-id
         :references:user-agent:mime-version;
        bh=oAsXSdHV4QEHuWs1CZyCI+yqX4rqMIruOm/fgXYjaRM=;
        b=qbhPYhckkDy9gVB5ZtXfAR9Zi67qw9aGhVEkROqAqQQKAnSas54YZnD2fm1tmkk0Sm
         lfgx9Vh6DoFVyoG3EjkcmcCSGJYxslMNqjaTH+c3wOupx1iFQ/IwiNzMI8tYgB9kcE/o
         7mVfbqtDXGLPaEv/lNwNP5GmYlE4BsFn5kcJl7Lp5L6KZOF07xtuOb2sy8ki2IUzKYFr
         xfbzpTFMQBxnqgQQVtnSEAdkpy6kweW5LItMFCegfp/FNAx+LbBy5DATIwExlhsOq/4f
         b4g8VG+A19lXk5AhEkfJFLN/uCA5+/PRO6cBahyHwTagOqhFkSWOMolPo/UcRVsN9Lqs
         5b7g==
X-Gm-Message-State: AOAM530lHepFjrJogTsUA31gqnxstHmUUOYiKToqggUv6Z3Z/nwlvfYR
        SYf5wmzyTmYK2h0Lx0PJ25LJug==
X-Google-Smtp-Source: ABdhPJyLpZfOVebc2s1q9XaKLov1Xm63RPYTSU9kHdX4wvftNcLKJkGcOjT+vbUOmiL1m62W9wQAyQ==
X-Received: by 2002:aca:3bc4:: with SMTP id i187mr624500oia.174.1619568246166;
        Tue, 27 Apr 2021 17:04:06 -0700 (PDT)
Received: from eggly.attlocal.net (172-10-233-147.lightspeed.sntcca.sbcglobal.net. [172.10.233.147])
        by smtp.gmail.com with ESMTPSA id n37sm336776otn.9.2021.04.27.17.04.04
        (version=TLS1 cipher=ECDHE-ECDSA-AES128-SHA bits=128/128);
        Tue, 27 Apr 2021 17:04:05 -0700 (PDT)
Date:   Tue, 27 Apr 2021 17:04:03 -0700 (PDT)
From:   Hugh Dickins <hughd@google.com>
X-X-Sender: hugh@eggly.anvils
To:     Axel Rasmussen <axelrasmussen@google.com>
cc:     Alexander Viro <viro@zeniv.linux.org.uk>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Hugh Dickins <hughd@google.com>,
        Jerome Glisse <jglisse@redhat.com>,
        Joe Perches <joe@perches.com>,
        Lokesh Gidra <lokeshgidra@google.com>,
        Mike Kravetz <mike.kravetz@oracle.com>,
        Mike Rapoport <rppt@linux.vnet.ibm.com>,
        Peter Xu <peterx@redhat.com>, Shaohua Li <shli@fb.com>,
        Shuah Khan <shuah@kernel.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Wang Qing <wangqing@vivo.com>, linux-api@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-kselftest@vger.kernel.org, linux-mm@kvack.org,
        Brian Geffon <bgeffon@google.com>,
        "Dr . David Alan Gilbert" <dgilbert@redhat.com>,
        Mina Almasry <almasrymina@google.com>,
        Oliver Upton <oupton@google.com>
Subject: Re: [PATCH v5 05/10] userfaultfd/shmem: advertise shmem minor fault
 support
In-Reply-To: <20210427225244.4326-6-axelrasmussen@google.com>
Message-ID: <alpine.LSU.2.11.2104271703260.7111@eggly.anvils>
References: <20210427225244.4326-1-axelrasmussen@google.com> <20210427225244.4326-6-axelrasmussen@google.com>
User-Agent: Alpine 2.11 (LSU 23 2013-08-11)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Precedence: bulk
List-ID: <linux-api.vger.kernel.org>
X-Mailing-List: linux-api@vger.kernel.org

On Tue, 27 Apr 2021, Axel Rasmussen wrote:

> Now that the feature is fully implemented (the faulting path hooks exist
> so userspace is notified, and the ioctl to resolve such faults is
> available), advertise this as a supported feature.
> 
> Signed-off-by: Axel Rasmussen <axelrasmussen@google.com>

Acked-by: Hugh Dickins <hughd@google.com>

> ---
>  Documentation/admin-guide/mm/userfaultfd.rst | 3 ++-
>  fs/userfaultfd.c                             | 3 ++-
>  include/uapi/linux/userfaultfd.h             | 7 ++++++-
>  3 files changed, 10 insertions(+), 3 deletions(-)

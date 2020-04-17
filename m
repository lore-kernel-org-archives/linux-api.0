Return-Path: <SRS0=XBkQ=6B=vger.kernel.org=linux-api-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-22.4 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT,USER_IN_DEF_DKIM_WL autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BA991C2D0EF
	for <linux-api@archiver.kernel.org>; Fri, 17 Apr 2020 17:26:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9A4F6208E4
	for <linux-api@archiver.kernel.org>; Fri, 17 Apr 2020 17:26:42 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="m4bHE2uu"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729569AbgDQR0m (ORCPT <rfc822;linux-api@archiver.kernel.org>);
        Fri, 17 Apr 2020 13:26:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34674 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728657AbgDQR0l (ORCPT
        <rfc822;linux-api@vger.kernel.org>); Fri, 17 Apr 2020 13:26:41 -0400
Received: from mail-pg1-x549.google.com (mail-pg1-x549.google.com [IPv6:2607:f8b0:4864:20::549])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A8A9CC061A0F
        for <linux-api@vger.kernel.org>; Fri, 17 Apr 2020 10:26:41 -0700 (PDT)
Received: by mail-pg1-x549.google.com with SMTP id p13so2258708pgk.18
        for <linux-api@vger.kernel.org>; Fri, 17 Apr 2020 10:26:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=ILn9zjMFZixAua0cC92upDzTyUw6GVgLI4zpVX2kQYA=;
        b=m4bHE2uu45HdfP0Wgg1WKeRftDLvdgoru1dUCnwI5N5ZcXIEqAw44ycGeigdhBGqgs
         4gLATlk+W9zI2KZK1Lt/toGa/OCNvjBCx2ZTGALAgAXL+RhHcCPn8vR7s5mVd+9vGY69
         CQ+pEPqimKZwRh8X8sBLe004QRZ4TNCTWpD6qV4Yq9QjjGHJ7rGYCHre7qM0KjOdNOeR
         N5b1Kq84Oa3zmlOGYY5p6Y8ClibEmKG2OJ1oFR3EtapNtR+nxZKKo9mLtDkcBFqMMFlC
         bBNlZwjQ6WwPXp9WTZfdsbV3Y/mil/EBs+SJQkKKWL/1l3XZfMlDpSLCvShvXrO/e1xJ
         eNQA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=ILn9zjMFZixAua0cC92upDzTyUw6GVgLI4zpVX2kQYA=;
        b=uYid7HQHXDfA+V/4/6nqGSbPsVGCOZ8kBbMUDft5Try/QOFcMBV1hO93y5FJzg3WLy
         cE8GI4uuYEiaNRQ4vDIuKrwf9fTZNhdM72X3Qq/u1dByYTEFVpCUDgUeuF7pzdroa0jK
         u2b7VutUy1IYSOfY+QdbTNFUl2ahgZLwmVfeTjS/skNSCfmQrMdyUblfXeKKh6ANlocW
         61p3GhHTJi+KnKVO7bJ4xaU7AgwmygY2wodpE1cchqHqGnITqGBFUxi+JcG5ZivjqbuP
         2HlE2r1Z9GuFjZoBWjfMH1cJWqBagkwNZmbXue2wZ5Xy4U27k8aR8opdJyZu1AB3eBfy
         iufg==
X-Gm-Message-State: AGi0PuZYsGlyYZLm7bfpa+WNbdj9ERkECpxvdkisTQ/oN1tX7I4FNpSY
        bVhqbzmhqy5fYsDUCMNKwyWScf5HOaYB
X-Google-Smtp-Source: APiQypIAfGVzmJZtnCGtNP6az31imBNTuf/QQ7pvHVtqHvvNRVRWycJ+wYPmL/y8uQCLRUrkdLYKhaN81O0s
X-Received: by 2002:a17:90b:3443:: with SMTP id lj3mr5713388pjb.38.1587144401004;
 Fri, 17 Apr 2020 10:26:41 -0700 (PDT)
Date:   Fri, 17 Apr 2020 10:25:56 -0700
Message-Id: <20200417172556.217480-1-bgeffon@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.26.1.301.g55bc3eb7cb9-goog
Subject: [PATCH] mm: Fix MREMAP_DONTUNMAP accounting on VMA merge
From:   Brian Geffon <bgeffon@google.com>
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     Andrew Morton <akpm@linux-foundation.org>,
        Andy Lutomirski <luto@amacapital.net>,
        Sonny Rao <sonnyrao@google.com>,
        Jesse Barnes <jsbarnes@google.com>,
        Dmitry Vyukov <dvyukov@google.com>,
        Minchan Kim <minchan@kernel.org>,
        "Kirill A . Shutemov" <kirill@shutemov.name>,
        Vlastimil Babka <vbabka@suse.cz>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, linux-api@vger.kernel.org,
        Brian Geffon <bgeffon@google.com>,
        syzbot <syzkaller@googlegroups.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-api-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-api.vger.kernel.org>
X-Mailing-List: linux-api@vger.kernel.org

When remapping a mapping where a portion of a VMA is remapped
into another portion of the VMA it can cause the VMA to become
split. During the copy_vma operation the VMA can actually
be remerged if it's an anonymous VMA whose pages have not yet
been faulted. This isn't normally a problem because at the end
of the remap the original portion is unmapped causing it to
become split again.

However, MREMAP_DONTUNMAP leaves that original portion in place which
means that the VMA which was split and then remerged is not actually
split at the end of the mremap. This patch fixes a bug where
we don't detect that the VMAs got remerged and we end up
putting back VM_ACCOUNT on the next mapping which is completely
unreleated. When that next mapping is unmapped it results in
incorrectly unaccounting for the memory which was never accounted,
and eventually we will underflow on the memory comittment.

There is also another issue which is similar, we're currently
accouting for the number of pages in the new_vma but that's wrong.
We need to account for the length of the remap operation as that's
all that is being added. If there was a mapping already at that
location its comittment would have been adjusted as part of
the munmap at the start of the mremap.

A really simple repro can be seen in:
https://gist.github.com/bgaff/e101ce99da7d9a8c60acc641d07f312c

Fixes: e346b3813067 ("mm/mremap: add MREMAP_DONTUNMAP to mremap()")
Reported-by: syzbot <syzkaller@googlegroups.com>
Signed-off-by: Brian Geffon <bgeffon@google.com>
---
 mm/mremap.c | 13 ++++++++++++-
 1 file changed, 12 insertions(+), 1 deletion(-)

diff --git a/mm/mremap.c b/mm/mremap.c
index a7e282ead438..c881abeba0bf 100644
--- a/mm/mremap.c
+++ b/mm/mremap.c
@@ -413,9 +413,20 @@ static unsigned long move_vma(struct vm_area_struct *vma,
 			/* Always put back VM_ACCOUNT since we won't unmap */
 			vma->vm_flags |= VM_ACCOUNT;
 
-			vm_acct_memory(vma_pages(new_vma));
+			vm_acct_memory(new_len >> PAGE_SHIFT);
 		}
 
+		/*
+		 * VMAs can actually be merged back together in copy_vma
+		 * calling merge_vma. This can happen with anonymous vmas
+		 * which have not yet been faulted, so if we were to consider
+		 * this VMA split we'll end up adding VM_ACCOUNT on the
+		 * next VMA, which is completely unrelated if this VMA
+		 * was re-merged.
+		 */
+		if (split && new_vma == vma)
+			split = 0;
+
 		/* We always clear VM_LOCKED[ONFAULT] on the old vma */
 		vma->vm_flags &= VM_LOCKED_CLEAR_MASK;
 
-- 
2.26.1.301.g55bc3eb7cb9-goog


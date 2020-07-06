Return-Path: <SRS0=3WA1=AR=vger.kernel.org=linux-api-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C0460C433E1
	for <linux-api@archiver.kernel.org>; Mon,  6 Jul 2020 17:21:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9ACA720720
	for <linux-api@archiver.kernel.org>; Mon,  6 Jul 2020 17:21:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1594056065;
	bh=MWHYORZMEjUSzCSQkeZzYrQp9re20hGQqezlYYHuB94=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=Vp4ytAtDL5mM/sO6ae6SNkbQDzbtkFTzvBxC55vzp51mWBm4Gre2SdjxF/OnLYIPD
	 rWqP0ZoiYbrlM6iF56aVVUe4Or9ypdPEFcojgnrzQWEvzse9hpBjxvo0FF4Q1vok5N
	 TZtAOJ1ch64ismB2MdXMuDD9L5S8ZByKKyfpc8J0=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729666AbgGFRVF (ORCPT <rfc822;linux-api@archiver.kernel.org>);
        Mon, 6 Jul 2020 13:21:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:55384 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729664AbgGFRVF (ORCPT <rfc822;linux-api@vger.kernel.org>);
        Mon, 6 Jul 2020 13:21:05 -0400
Received: from aquarius.haifa.ibm.com (nesher1.haifa.il.ibm.com [195.110.40.7])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 185372070C;
        Mon,  6 Jul 2020 17:20:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1594056064;
        bh=MWHYORZMEjUSzCSQkeZzYrQp9re20hGQqezlYYHuB94=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=s0pZXDzWq1ti+TdYy2gBZD3Y73VYnvfnm3tEJXPJ88SIvsg6MmXc/qFAFzTIwpFqP
         7TbW5C3oY64sMzALUCOf30npQlHdVoThRIoAdo0uUz+uIycFvotPVG82yGOKJ/oJMg
         1L5566MpNGCUtD5oEaYzAvNOrrsH2kjQEDvmFXfs=
From:   Mike Rapoport <rppt@kernel.org>
To:     linux-kernel@vger.kernel.org
Cc:     Alan Cox <alan@linux.intel.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Andy Lutomirski <luto@kernel.org>,
        Christopher Lameter <cl@linux.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Idan Yaniv <idan.yaniv@ibm.com>,
        James Bottomley <jejb@linux.ibm.com>,
        "Kirill A. Shutemov" <kirill@shutemov.name>,
        Matthew Wilcox <willy@infradead.org>,
        Peter Zijlstra <peterz@infradead.org>,
        "Reshetova, Elena" <elena.reshetova@intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Tycho Andersen <tycho@tycho.ws>, linux-api@vger.kernel.org,
        linux-mm@kvack.org, Mike Rapoport <rppt@linux.ibm.com>
Subject: [RFC PATCH v2 1/5] mm: make HPAGE_PxD_{SHIFT,MASK,SIZE} always available
Date:   Mon,  6 Jul 2020 20:20:47 +0300
Message-Id: <20200706172051.19465-2-rppt@kernel.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200706172051.19465-1-rppt@kernel.org>
References: <20200706172051.19465-1-rppt@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-api-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-api.vger.kernel.org>
X-Mailing-List: linux-api@vger.kernel.org

From: Mike Rapoport <rppt@linux.ibm.com>

The definitions of shift, mask and size for the second and the third level
of the leaf pages are available only when CONFIG_TRANSPARENT_HUGEPAGE is
set. Otherwise they evaluate to BUILD_BUG().

There is no explanation neither in the code nor in the changelog why the
usage of, e.g. HPAGE_PMD_SIZE should be only allowed with THP and forbidden
otherwise while the definitions of HPAGE_PMD_SIZE and HPAGE_PUD_SIZE
express the sizes better than ambiguous HPAGE_SIZE.

Make HPAGE_PxD_{SHIFT,MASK,SIZE} definitions available unconditionally.

Signed-off-by: Mike Rapoport <rppt@linux.ibm.com>
---
 include/linux/huge_mm.h | 10 ++--------
 1 file changed, 2 insertions(+), 8 deletions(-)

diff --git a/include/linux/huge_mm.h b/include/linux/huge_mm.h
index 71f20776b06c..1f4b44a76e31 100644
--- a/include/linux/huge_mm.h
+++ b/include/linux/huge_mm.h
@@ -115,7 +115,6 @@ extern struct kobj_attribute shmem_enabled_attr;
 #define HPAGE_PMD_ORDER (HPAGE_PMD_SHIFT-PAGE_SHIFT)
 #define HPAGE_PMD_NR (1<<HPAGE_PMD_ORDER)
 
-#ifdef CONFIG_TRANSPARENT_HUGEPAGE
 #define HPAGE_PMD_SHIFT PMD_SHIFT
 #define HPAGE_PMD_SIZE	((1UL) << HPAGE_PMD_SHIFT)
 #define HPAGE_PMD_MASK	(~(HPAGE_PMD_SIZE - 1))
@@ -124,6 +123,8 @@ extern struct kobj_attribute shmem_enabled_attr;
 #define HPAGE_PUD_SIZE	((1UL) << HPAGE_PUD_SHIFT)
 #define HPAGE_PUD_MASK	(~(HPAGE_PUD_SIZE - 1))
 
+#ifdef CONFIG_TRANSPARENT_HUGEPAGE
+
 extern unsigned long transparent_hugepage_flags;
 
 /*
@@ -316,13 +317,6 @@ static inline struct list_head *page_deferred_list(struct page *page)
 }
 
 #else /* CONFIG_TRANSPARENT_HUGEPAGE */
-#define HPAGE_PMD_SHIFT ({ BUILD_BUG(); 0; })
-#define HPAGE_PMD_MASK ({ BUILD_BUG(); 0; })
-#define HPAGE_PMD_SIZE ({ BUILD_BUG(); 0; })
-
-#define HPAGE_PUD_SHIFT ({ BUILD_BUG(); 0; })
-#define HPAGE_PUD_MASK ({ BUILD_BUG(); 0; })
-#define HPAGE_PUD_SIZE ({ BUILD_BUG(); 0; })
 
 static inline int hpage_nr_pages(struct page *page)
 {
-- 
2.26.2


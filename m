Return-Path: <linux-api-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3A87BC433DB
	for <linux-api@archiver.kernel.org>; Wed, 17 Feb 2021 17:48:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 09D3864E42
	for <linux-api@archiver.kernel.org>; Wed, 17 Feb 2021 17:48:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234731AbhBQRsl (ORCPT <rfc822;linux-api@archiver.kernel.org>);
        Wed, 17 Feb 2021 12:48:41 -0500
Received: from mx2.suse.de ([195.135.220.15]:44282 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234728AbhBQRsj (ORCPT <rfc822;linux-api@vger.kernel.org>);
        Wed, 17 Feb 2021 12:48:39 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 5D104B087;
        Wed, 17 Feb 2021 17:47:57 +0000 (UTC)
From:   Vlastimil Babka <vbabka@suse.cz>
To:     Andrew Morton <akpm@linux-foundation.org>
Cc:     linux-kernel@vger.kernel.org, linux-api@vger.kernel.org,
        Michael Kerrisk <mtk.manpages@gmail.com>,
        Vlastimil Babka <vbabka@suse.cz>,
        David Hildenbrand <david@redhat.com>
Subject: [PATCH] MAINTAINERS: add uapi directories to API/ABI section
Date:   Wed, 17 Feb 2021 18:47:45 +0100
Message-Id: <20210217174745.13591-1-vbabka@suse.cz>
X-Mailer: git-send-email 2.30.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-api.vger.kernel.org>
X-Mailing-List: linux-api@vger.kernel.org

Let's add include/uapi/ and arch/*/include/uapi/ to API/ABI section, so that
for patches modifying them, get_maintainers.pl suggests CCing linux-api@ so
people don't forget.

Reported-by: David Hildenbrand <david@redhat.com>
Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
---
 MAINTAINERS | 2 ++
 1 file changed, 2 insertions(+)

Not entirely sure about the arch/* part, would it add too much noise? Thoughts?

diff --git a/MAINTAINERS b/MAINTAINERS
index bfc1b86e3e73..d8b994a1b983 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -261,6 +261,8 @@ ABI/API
 L:	linux-api@vger.kernel.org
 F:	include/linux/syscalls.h
 F:	kernel/sys_ni.c
+F:	include/uapi/
+F:	arch/*/include/uapi/
 
 ABIT UGURU 1,2 HARDWARE MONITOR DRIVER
 M:	Hans de Goede <hdegoede@redhat.com>
-- 
2.30.0


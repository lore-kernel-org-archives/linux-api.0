Return-Path: <SRS0=RkrY=C2=vger.kernel.org=linux-api-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 997B8C43461
	for <linux-api@archiver.kernel.org>; Thu, 17 Sep 2020 07:44:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 61D2F2072E
	for <linux-api@archiver.kernel.org>; Thu, 17 Sep 2020 07:44:29 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="WfrFhdlP"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726169AbgIQHoS (ORCPT <rfc822;linux-api@archiver.kernel.org>);
        Thu, 17 Sep 2020 03:44:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52318 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726178AbgIQHoS (ORCPT
        <rfc822;linux-api@vger.kernel.org>); Thu, 17 Sep 2020 03:44:18 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0E7C7C06174A;
        Thu, 17 Sep 2020 00:44:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
        Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
        Content-Description:In-Reply-To:References;
        bh=NYu4MvZkm0oyyCDzdWcR+XJoy3KE75VJawIahYANGko=; b=WfrFhdlP+t7XTZm973AbHO3bCv
        k7hfDhUTmc3Cr4ZQD8nUj0w9GcZrR3ZDvtfL3VKHI3as9TIQYKJ7jHXgbgQP0tQe6OhFNVB+tGIiV
        3w1YKVCSNylbPmrDgmzAgqZrMjJySyf7t50pgfJdcpnwUrwfa6koSp2bhSBudMK3TWU2p9Hgr5enC
        kGjBgO2wf5iVuJbJavMpn9dRa21WHAxqlr/gbWSLTph3+VfMi9DTnThd3cCyXFWR6aYxWp8IxA1fB
        RqnDS3q/tkco/ANEfmPG8AFMS2VJn4HLzzsuJKkv0fSoNRtc+AP3nqWEvGPpPxfAeZFe+Z3i4uMBi
        be1f0I/w==;
Received: from 089144214092.atnat0023.highway.a1.net ([89.144.214.92] helo=localhost)
        by casper.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1kIoaR-0006LZ-Vo; Thu, 17 Sep 2020 07:44:12 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     x86@kernel.org, Jan Kara <jack@suse.com>
Cc:     linux-arm-kernel@lists.infradead.org,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-api@vger.kernel.org, linux-arch@vger.kernel.org
Subject: improve compat handling for the i386 u64 alignment quirk v3
Date:   Thu, 17 Sep 2020 09:41:56 +0200
Message-Id: <20200917074159.2442167-1-hch@lst.de>
X-Mailer: git-send-email 2.28.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-api.vger.kernel.org>
X-Mailing-List: linux-api@vger.kernel.org

Hi all,

the i386 ABI is a little special in that it uses less than natural
alignment for 64-bit integer types (u64 and s64), and a significant
amount of our compat handlers deals with just that.  Unfortunately
there is no good way to check for this specific quirk at runtime,
similar how in_compat_syscall() checks for a compat syscall.  This
series adds such a check, and then uses the quota code as an example
of how this improves the compat handling.  I have a few other places
in mind where this will also be useful going forward.

Changes since v2:
 - drop the patch to use <linux/compat.h> in the arm64 headers

Changes since v1:
 - use asm-generic/compat.h instead of linux/compat.h for
   compat_u64 and compat_s64
 - fix a typo

Diffstat:
 b/arch/arm64/include/asm/compat.h        |    2 
 b/arch/mips/include/asm/compat.h         |    2 
 b/arch/parisc/include/asm/compat.h       |    2 
 b/arch/powerpc/include/asm/compat.h      |    2 
 b/arch/s390/include/asm/compat.h         |    2 
 b/arch/sparc/include/asm/compat.h        |    3 
 b/arch/x86/entry/syscalls/syscall_32.tbl |    2 
 b/arch/x86/include/asm/compat.h          |    3 
 b/fs/quota/Kconfig                       |    5 -
 b/fs/quota/Makefile                      |    1 
 b/fs/quota/compat.h                      |   34 ++++++++
 b/fs/quota/quota.c                       |   73 +++++++++++++++---
 b/include/asm-generic/compat.h           |    8 ++
 b/include/linux/compat.h                 |    9 ++
 b/include/linux/quotaops.h               |    3 
 b/kernel/sys_ni.c                        |    1 
 fs/quota/compat.c                        |  120 -------------------------------
 17 files changed, 113 insertions(+), 159 deletions(-)

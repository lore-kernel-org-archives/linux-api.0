Return-Path: <SRS0=rv4v=6A=vger.kernel.org=linux-api-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E5120C2BB55
	for <linux-api@archiver.kernel.org>; Thu, 16 Apr 2020 11:35:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C14C121D7F
	for <linux-api@archiver.kernel.org>; Thu, 16 Apr 2020 11:35:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1587036900;
	bh=TMMfR8jMQehfnp/7rpYl0nN/kHBVXZuS884Eb6S1ra0=;
	h=From:To:Cc:Subject:Date:List-ID:From;
	b=Ex654HTMVqLw1Emkc+gcB4BPedcbPda0VqizgCFBsKJ4sgA1Dxxv5b7dUKqMrqBvp
	 xy9IFl9Wju5m9Q2gNOGSLSa4aFQcHgTSIcO5AWh9O25UUiGQCO9TaKnLB46L8Rz7Jk
	 IdlpnaxWDUeuO4hy+el5kWz3v0C6gxP6yh2+oQF0=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2633746AbgDPLe5 (ORCPT <rfc822;linux-api@archiver.kernel.org>);
        Thu, 16 Apr 2020 07:34:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:35606 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2506364AbgDPLez (ORCPT <rfc822;linux-api@vger.kernel.org>);
        Thu, 16 Apr 2020 07:34:55 -0400
Received: from tleilax.poochiereds.net (68-20-15-154.lightspeed.rlghnc.sbcglobal.net [68.20.15.154])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3897621D7F;
        Thu, 16 Apr 2020 11:34:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1587036895;
        bh=TMMfR8jMQehfnp/7rpYl0nN/kHBVXZuS884Eb6S1ra0=;
        h=From:To:Cc:Subject:Date:From;
        b=b5ykmFcsbQ8fI1oYE/loZdT7usuZpFJH39y8yBp80iyEjSpXZaaf94MzDXvRDSVbz
         Y0fDUo3giLXBWWoshTb3x2ou1LV6G7CJAnLnhE8K7cLuQ3d+d8o63hqHCa+uS506j/
         RwUDMDd7HGyxBlfgaMJ/LqXn9dnZE5te6iPQdHxI=
From:   Jeff Layton <jlayton@kernel.org>
To:     viro@zeniv.linux.org.uk
Cc:     linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-api@vger.kernel.org, andres@anarazel.de, willy@infradead.org,
        dhowells@redhat.com, hch@infradead.org, jack@suse.cz,
        akpm@linux-foundation.org, david@fromorbit.com
Subject: [PATCH v6 0/2] vfs: have syncfs() return error when there are writeback errors
Date:   Thu, 16 Apr 2020 07:34:51 -0400
Message-Id: <20200416113453.227229-1-jlayton@kernel.org>
X-Mailer: git-send-email 2.25.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-api-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-api.vger.kernel.org>
X-Mailing-List: linux-api@vger.kernel.org

v6:
- use READ_ONCE to ensure that compiler doesn't optimize away local var

The only difference from v5 is the change to use READ_ONCE to fetch the
bd_super pointer, to ensure that the compiler doesn't refetch it
afterward. Many thanks to Jan K. for the explanation!

Jeff Layton (2):
  vfs: track per-sb writeback errors and report them to syncfs
  buffer: record blockdev write errors in super_block that it backs

 drivers/dax/device.c    |  1 +
 fs/buffer.c             |  7 +++++++
 fs/file_table.c         |  1 +
 fs/open.c               |  3 +--
 fs/sync.c               |  6 ++++--
 include/linux/fs.h      | 16 ++++++++++++++++
 include/linux/pagemap.h |  5 ++++-
 7 files changed, 34 insertions(+), 5 deletions(-)

-- 
2.25.2


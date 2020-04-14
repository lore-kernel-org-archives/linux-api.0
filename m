Return-Path: <SRS0=M+tC=56=vger.kernel.org=linux-api-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0EBEEC352B6
	for <linux-api@archiver.kernel.org>; Tue, 14 Apr 2020 12:04:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D991320787
	for <linux-api@archiver.kernel.org>; Tue, 14 Apr 2020 12:04:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1586865858;
	bh=dUeyL9occ1LadJp/YkgyEFBnPUbUwozdIxbmk4qkG6I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=ueu4Hs1/fpNv+a/bD/uRHSd+DAC1Dlq1Je+f7abY2Y2aPSCNDn9xfTNFVIqdWilvD
	 OPfyW7Iqr2fTBcR3qPTh/a7TK9KDJ/y8BYIPLXawshQhZcktXlqvn2C4IVM4Mdxzrw
	 rQqX3EnL4OwoGAj2K69+eI4aRvQN7ekYKKWAomxA=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2439816AbgDNMER (ORCPT <rfc822;linux-api@archiver.kernel.org>);
        Tue, 14 Apr 2020 08:04:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:35264 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2439808AbgDNMEO (ORCPT <rfc822;linux-api@vger.kernel.org>);
        Tue, 14 Apr 2020 08:04:14 -0400
Received: from tleilax.com (68-20-15-154.lightspeed.rlghnc.sbcglobal.net [68.20.15.154])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E8C712076B;
        Tue, 14 Apr 2020 12:04:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1586865853;
        bh=dUeyL9occ1LadJp/YkgyEFBnPUbUwozdIxbmk4qkG6I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=D40h5ckhi3GEWYC1jSo/8d5JhiNN18OfiGl6Crk4JTEhlkB4kDpOvEVtd7UPqIKTL
         EWNjrFziaIWg0wBpq7bKhzQopenc5qtJXzWNCPtQpZHaCe+0j9hLX2vvWurnmf5LF8
         eiuMaUY8GUbMO4OoGR+YXiF755razhzWl//KyDFk=
From:   Jeff Layton <jlayton@kernel.org>
To:     viro@zeniv.linux.org.uk
Cc:     linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-api@vger.kernel.org, andres@anarazel.de, willy@infradead.org,
        dhowells@redhat.com, hch@infradead.org, jack@suse.cz,
        akpm@linux-foundation.org, david@fromorbit.com
Subject: [PATCH v4 RESEND 2/2] buffer: record blockdev write errors in super_block that it backs
Date:   Tue, 14 Apr 2020 08:04:09 -0400
Message-Id: <20200414120409.293749-3-jlayton@kernel.org>
X-Mailer: git-send-email 2.25.2
In-Reply-To: <20200414120409.293749-1-jlayton@kernel.org>
References: <20200414120409.293749-1-jlayton@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-api-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-api.vger.kernel.org>
X-Mailing-List: linux-api@vger.kernel.org

From: Jeff Layton <jlayton@redhat.com>

When syncing out a block device (a'la __sync_blockdev), any error
encountered will only be recorded in the bd_inode's mapping. When the
blockdev contains a filesystem however, we'd like to also record the
error in the super_block that's stored there.

Make mark_buffer_write_io_error also record the error in the
corresponding super_block when a writeback error occurs and the block
device contains a mounted superblock.

Signed-off-by: Jeff Layton <jlayton@kernel.org>
---
 fs/buffer.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/buffer.c b/fs/buffer.c
index f73276d746bb..a9d986d27fa1 100644
--- a/fs/buffer.c
+++ b/fs/buffer.c
@@ -1160,6 +1160,8 @@ void mark_buffer_write_io_error(struct buffer_head *bh)
 		mapping_set_error(bh->b_page->mapping, -EIO);
 	if (bh->b_assoc_map)
 		mapping_set_error(bh->b_assoc_map, -EIO);
+	if (bh->b_bdev->bd_super)
+		errseq_set(&bh->b_bdev->bd_super->s_wb_err, -EIO);
 }
 EXPORT_SYMBOL(mark_buffer_write_io_error);
 
-- 
2.25.2


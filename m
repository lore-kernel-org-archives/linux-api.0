Return-Path: <SRS0=IXk3=6M=vger.kernel.org=linux-api-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E99F5C83000
	for <linux-api@archiver.kernel.org>; Tue, 28 Apr 2020 13:52:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BF9F8206B9
	for <linux-api@archiver.kernel.org>; Tue, 28 Apr 2020 13:52:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1588081926;
	bh=5DdCwI3stPz5DcXHNz6QeRl8dl1BU5K/ki0kBBLSF+g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=O8CTpCWkXuO+Dh5QRNbYnazWeTcFZ5TL+pUYm3c6TodKY0B86LKKvRQ/BKwjYbUDA
	 nEp3/Jv/CHSzZxEc5kaFxjy0LU8ZjaT3N0x4FHPVfl4OqhAESXlv4P7O932nxnw1hr
	 3sqytqSiSyS7lFEFELMhQN5IuCDTdiFdCv7/AaoY=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727962AbgD1NwF (ORCPT <rfc822;linux-api@archiver.kernel.org>);
        Tue, 28 Apr 2020 09:52:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:40764 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726946AbgD1NwB (ORCPT <rfc822;linux-api@vger.kernel.org>);
        Tue, 28 Apr 2020 09:52:01 -0400
Received: from tleilax.com (68-20-15-154.lightspeed.rlghnc.sbcglobal.net [68.20.15.154])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C1955206E2;
        Tue, 28 Apr 2020 13:51:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588081920;
        bh=5DdCwI3stPz5DcXHNz6QeRl8dl1BU5K/ki0kBBLSF+g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=eye04z2GXBaS6y4uVXFqR7zpeMHKS/A7d842gJM3kyTlZYGDkjg/xx1Cs+ICtVGbw
         FjIvVY+uANXXSHOJ5uay18mIOXrMe9vgjwsUM6zL+IWt00iN0QVo8xwm+B5adhgp+T
         CuAyfLDXjV58jghwU42H73NSaMO1D5NKtJmmizA4=
From:   Jeff Layton <jlayton@kernel.org>
To:     viro@zeniv.linux.org.uk, akpm@linux-foundation.org
Cc:     linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-api@vger.kernel.org, andres@anarazel.de, willy@infradead.org,
        dhowells@redhat.com, hch@infradead.org, jack@suse.cz,
        david@fromorbit.com
Subject: [PATCH v6 RESEND 2/2] buffer: record blockdev write errors in super_block that it backs
Date:   Tue, 28 Apr 2020 09:51:55 -0400
Message-Id: <20200428135155.19223-3-jlayton@kernel.org>
X-Mailer: git-send-email 2.26.1
In-Reply-To: <20200428135155.19223-1-jlayton@kernel.org>
References: <20200428135155.19223-1-jlayton@kernel.org>
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

Since superblocks are RCU freed, hold the rcu_read_lock to ensure
that the superblock doesn't go away while we're marking it.

Reviewed-by: Jan Kara <jack@suse.cz>
Signed-off-by: Jeff Layton <jlayton@kernel.org>
---
 fs/buffer.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/fs/buffer.c b/fs/buffer.c
index f73276d746bb..71be7e6cabca 100644
--- a/fs/buffer.c
+++ b/fs/buffer.c
@@ -1154,12 +1154,19 @@ EXPORT_SYMBOL(mark_buffer_dirty);
 
 void mark_buffer_write_io_error(struct buffer_head *bh)
 {
+	struct super_block *sb;
+
 	set_buffer_write_io_error(bh);
 	/* FIXME: do we need to set this in both places? */
 	if (bh->b_page && bh->b_page->mapping)
 		mapping_set_error(bh->b_page->mapping, -EIO);
 	if (bh->b_assoc_map)
 		mapping_set_error(bh->b_assoc_map, -EIO);
+	rcu_read_lock();
+	sb = READ_ONCE(bh->b_bdev->bd_super);
+	if (sb)
+		errseq_set(&sb->s_wb_err, -EIO);
+	rcu_read_unlock();
 }
 EXPORT_SYMBOL(mark_buffer_write_io_error);
 
-- 
2.26.1


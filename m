Return-Path: <SRS0=rv4v=6A=vger.kernel.org=linux-api-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 956A1C2BB85
	for <linux-api@archiver.kernel.org>; Thu, 16 Apr 2020 11:44:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 80698221EA
	for <linux-api@archiver.kernel.org>; Thu, 16 Apr 2020 11:44:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2633902AbgDPLoI (ORCPT <rfc822;linux-api@archiver.kernel.org>);
        Thu, 16 Apr 2020 07:44:08 -0400
Received: from mx2.suse.de ([195.135.220.15]:59710 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2633877AbgDPLlm (ORCPT <rfc822;linux-api@vger.kernel.org>);
        Thu, 16 Apr 2020 07:41:42 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 97206AF95;
        Thu, 16 Apr 2020 11:41:40 +0000 (UTC)
Received: by quack2.suse.cz (Postfix, from userid 1000)
        id 41F311E1250; Thu, 16 Apr 2020 13:41:39 +0200 (CEST)
Date:   Thu, 16 Apr 2020 13:41:39 +0200
From:   Jan Kara <jack@suse.cz>
To:     Jeff Layton <jlayton@kernel.org>
Cc:     viro@zeniv.linux.org.uk, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-api@vger.kernel.org,
        andres@anarazel.de, willy@infradead.org, dhowells@redhat.com,
        hch@infradead.org, jack@suse.cz, akpm@linux-foundation.org,
        david@fromorbit.com
Subject: Re: [PATCH v6 2/2] buffer: record blockdev write errors in
 super_block that it backs
Message-ID: <20200416114139.GH23739@quack2.suse.cz>
References: <20200416113453.227229-1-jlayton@kernel.org>
 <20200416113453.227229-3-jlayton@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200416113453.227229-3-jlayton@kernel.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-api-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-api.vger.kernel.org>
X-Mailing-List: linux-api@vger.kernel.org

On Thu 16-04-20 07:34:53, Jeff Layton wrote:
> From: Jeff Layton <jlayton@redhat.com>
> 
> When syncing out a block device (a'la __sync_blockdev), any error
> encountered will only be recorded in the bd_inode's mapping. When the
> blockdev contains a filesystem however, we'd like to also record the
> error in the super_block that's stored there.
> 
> Make mark_buffer_write_io_error also record the error in the
> corresponding super_block when a writeback error occurs and the block
> device contains a mounted superblock.
> 
> Since superblocks are RCU freed, hold the rcu_read_lock to ensure
> that the superblock doesn't go away while we're marking it.
> 
> Signed-off-by: Jeff Layton <jlayton@kernel.org>

Looks good to me now. You can add:

Reviewed-by: Jan Kara <jack@suse.cz>

								Honza


> ---
>  fs/buffer.c | 7 +++++++
>  1 file changed, 7 insertions(+)
> 
> diff --git a/fs/buffer.c b/fs/buffer.c
> index f73276d746bb..71be7e6cabca 100644
> --- a/fs/buffer.c
> +++ b/fs/buffer.c
> @@ -1154,12 +1154,19 @@ EXPORT_SYMBOL(mark_buffer_dirty);
>  
>  void mark_buffer_write_io_error(struct buffer_head *bh)
>  {
> +	struct super_block *sb;
> +
>  	set_buffer_write_io_error(bh);
>  	/* FIXME: do we need to set this in both places? */
>  	if (bh->b_page && bh->b_page->mapping)
>  		mapping_set_error(bh->b_page->mapping, -EIO);
>  	if (bh->b_assoc_map)
>  		mapping_set_error(bh->b_assoc_map, -EIO);
> +	rcu_read_lock();
> +	sb = READ_ONCE(bh->b_bdev->bd_super);
> +	if (sb)
> +		errseq_set(&sb->s_wb_err, -EIO);
> +	rcu_read_unlock();
>  }
>  EXPORT_SYMBOL(mark_buffer_write_io_error);
>  
> -- 
> 2.25.2
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR

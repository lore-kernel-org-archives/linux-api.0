Return-Path: <SRS0=M+tC=56=vger.kernel.org=linux-api-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 32C2EC2BB85
	for <linux-api@archiver.kernel.org>; Tue, 14 Apr 2020 16:26:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 100AF2075E
	for <linux-api@archiver.kernel.org>; Tue, 14 Apr 2020 16:26:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391481AbgDNQ0o (ORCPT <rfc822;linux-api@archiver.kernel.org>);
        Tue, 14 Apr 2020 12:26:44 -0400
Received: from mx2.suse.de ([195.135.220.15]:52020 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391518AbgDNQ0m (ORCPT <rfc822;linux-api@vger.kernel.org>);
        Tue, 14 Apr 2020 12:26:42 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id B6A76ABCE;
        Tue, 14 Apr 2020 16:26:39 +0000 (UTC)
Received: by quack2.suse.cz (Postfix, from userid 1000)
        id D5DA71E0E3B; Tue, 14 Apr 2020 18:26:39 +0200 (CEST)
Date:   Tue, 14 Apr 2020 18:26:39 +0200
From:   Jan Kara <jack@suse.cz>
To:     Jeff Layton <jlayton@kernel.org>
Cc:     viro@zeniv.linux.org.uk, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-api@vger.kernel.org,
        andres@anarazel.de, willy@infradead.org, dhowells@redhat.com,
        hch@infradead.org, jack@suse.cz, akpm@linux-foundation.org,
        david@fromorbit.com
Subject: Re: [PATCH v4 RESEND 2/2] buffer: record blockdev write errors in
 super_block that it backs
Message-ID: <20200414162639.GK28226@quack2.suse.cz>
References: <20200414120409.293749-1-jlayton@kernel.org>
 <20200414120409.293749-3-jlayton@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200414120409.293749-3-jlayton@kernel.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-api-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-api.vger.kernel.org>
X-Mailing-List: linux-api@vger.kernel.org

On Tue 14-04-20 08:04:09, Jeff Layton wrote:
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
> Signed-off-by: Jeff Layton <jlayton@kernel.org>

The patch looks good to me. I'd just note that bh->b_bdev->bd_super
dereference is safe only because we will flush all dirty data when
unmounting a filesystem which is somewhat tricky. Maybe that warrants a
comment? Otherwise feel free to add:

Reviewed-by: Jan Kara <jack@suse.cz>

								Honza

> ---
>  fs/buffer.c | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/fs/buffer.c b/fs/buffer.c
> index f73276d746bb..a9d986d27fa1 100644
> --- a/fs/buffer.c
> +++ b/fs/buffer.c
> @@ -1160,6 +1160,8 @@ void mark_buffer_write_io_error(struct buffer_head *bh)
>  		mapping_set_error(bh->b_page->mapping, -EIO);
>  	if (bh->b_assoc_map)
>  		mapping_set_error(bh->b_assoc_map, -EIO);
> +	if (bh->b_bdev->bd_super)
> +		errseq_set(&bh->b_bdev->bd_super->s_wb_err, -EIO);
>  }
>  EXPORT_SYMBOL(mark_buffer_write_io_error);
>  
> -- 
> 2.25.2
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR

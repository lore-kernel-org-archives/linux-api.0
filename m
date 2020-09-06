Return-Path: <SRS0=6e2o=CP=vger.kernel.org=linux-api-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 61855C433E2
	for <linux-api@archiver.kernel.org>; Sun,  6 Sep 2020 06:26:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 124C220796
	for <linux-api@archiver.kernel.org>; Sun,  6 Sep 2020 06:26:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1599373611;
	bh=Al17Upt/3HUnjrxFfYN0TQG+Cu4xYfONnUIt+wXFCfM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:List-ID:From;
	b=JoBRjNEg70cZT9kstkmdPbAzRi199cNBt3iDFFw0eUT5qH57OAijauk9Jkp45Ee8T
	 tY3WAxJ9XVotyWqjrNsFb5+jMX0Q3WjpFABqNzNAuaoOUvXiAihvzyFRXnZ6eWthSo
	 2s0G7F1Avi501DfFhgvc9U0pOqZHWMFyrZdRXRNc=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725306AbgIFG0u (ORCPT <rfc822;linux-api@archiver.kernel.org>);
        Sun, 6 Sep 2020 02:26:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:51034 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725283AbgIFG0t (ORCPT <rfc822;linux-api@vger.kernel.org>);
        Sun, 6 Sep 2020 02:26:49 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E300E20714;
        Sun,  6 Sep 2020 06:26:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1599373609;
        bh=Al17Upt/3HUnjrxFfYN0TQG+Cu4xYfONnUIt+wXFCfM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=yvo8k6sfH+WIQye4nQCg5OFGLhRPL20UODI9G1qU3+qVXpt7A3jcM5Q/W/4mwDL0X
         9Ttalh3ILiBTBtkaxk9zHlRxbxuzN2eYrp4zG+MOGIqb1TAwe8vkhn2SwVE/SVpVtT
         DawFHG+smqMdfhTXVnXR5p9Us/65asN0mP0x6a8k=
Date:   Sun, 6 Sep 2020 08:26:46 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Tom Yan <tom.ty89@gmail.com>
Cc:     linux-scsi@vger.kernel.org, dgilbert@interlog.com,
        bvanassche@acm.org, stern@rowland.harvard.edu,
        akinobu.mita@gmail.com, hch@lst.de, linux-api@vger.kernel.org
Subject: Re: [PATCH RESEND 3/4] scsi: sg: use queue_logical_sector_size() in
 max_sectors_bytes()
Message-ID: <20200906062646.GA200844@kroah.com>
References: <CAGnHSE=bhpL4REG5PXST6dF3gSWeewg1Eqr+sLw_9rtqL-ToFQ@mail.gmail.com>
 <20200906012716.1553-1-tom.ty89@gmail.com>
 <20200906012716.1553-3-tom.ty89@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200906012716.1553-3-tom.ty89@gmail.com>
Sender: linux-api-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-api.vger.kernel.org>
X-Mailing-List: linux-api@vger.kernel.org

On Sun, Sep 06, 2020 at 09:27:15AM +0800, Tom Yan wrote:
> Signed-off-by: Tom Yan <tom.ty89@gmail.com>
> ---
>  drivers/scsi/sg.c | 5 +++--
>  1 file changed, 3 insertions(+), 2 deletions(-)

I know I don't take patches without any changelog text at all, but maybe
the scsi maintainers are more leniant.

You should write changelogs that explain _why_ you are doing what you
are doing, you just say what you did, with no reasoning at all.

Same for another patch in this series.

thanks,

greg k-h

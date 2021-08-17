Return-Path: <linux-api-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.5 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 087A9C4338F
	for <linux-api@archiver.kernel.org>; Tue, 17 Aug 2021 13:08:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D8B7760F5C
	for <linux-api@archiver.kernel.org>; Tue, 17 Aug 2021 13:08:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237490AbhHQNJU (ORCPT <rfc822;linux-api@archiver.kernel.org>);
        Tue, 17 Aug 2021 09:09:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:46706 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230251AbhHQNJT (ORCPT <rfc822;linux-api@vger.kernel.org>);
        Tue, 17 Aug 2021 09:09:19 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C925E6054F;
        Tue, 17 Aug 2021 13:08:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1629205726;
        bh=J1u5EkWGe1vhFroD1IkbImRAmY2cS/NhgJTldLkgdQ0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=G4sEWuIHg7dPIAdb+CNrXrzTwB17LGwdPnAKkHBjeFaDSeu0zgdgJ3WtuSvwm7Ke5
         qxE2jqR/gnytpY4Px0tGv4k+kTSRxfZiGjlylGou8T6pgSEfNOHaYfOBoA5tol2NwA
         1w+n/Xyy20t5QAhTAy0o9AYp+44fdacT9SJtE6lI=
Date:   Tue, 17 Aug 2021 15:08:43 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     SelvaKumar S <selvakuma.s1@samsung.com>
Cc:     linux-nvme@lists.infradead.org, linux-block@vger.kernel.org,
        linux-api@vger.kernel.org, linux-scsi@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, dm-devel@redhat.com,
        kbusch@kernel.org, axboe@kernel.dk, damien.lemoal@wdc.com,
        asml.silence@gmail.com, johannes.thumshirn@wdc.com, hch@lst.de,
        willy@infradead.org, kch@kernel.org, martin.petersen@oracle.com,
        mpatocka@redhat.com, bvanassche@acm.org, djwong@kernel.org,
        snitzer@redhat.com, agk@redhat.com, selvajove@gmail.com,
        joshiiitr@gmail.com, nj.shetty@samsung.com,
        nitheshshetty@gmail.com, joshi.k@samsung.com,
        javier.gonz@samsung.com
Subject: Re: [PATCH 2/7] block: Introduce queue limits for copy-offload
 support
Message-ID: <YRu02+RgnZekKSqi@kroah.com>
References: <20210817101423.12367-1-selvakuma.s1@samsung.com>
 <CGME20210817101753epcas5p4f4257f8edda27e184ecbb273b700ccbc@epcas5p4.samsung.com>
 <20210817101423.12367-3-selvakuma.s1@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210817101423.12367-3-selvakuma.s1@samsung.com>
Precedence: bulk
List-ID: <linux-api.vger.kernel.org>
X-Mailing-List: linux-api@vger.kernel.org

On Tue, Aug 17, 2021 at 03:44:18PM +0530, SelvaKumar S wrote:
> From: Nitesh Shetty <nj.shetty@samsung.com>
> 
> Add device limits as sysfs entries,
>         - copy_offload (READ_WRITE)
>         - max_copy_sectors (READ_ONLY)
>         - max_copy_ranges_sectors (READ_ONLY)
>         - max_copy_nr_ranges (READ_ONLY)

You forgot to add Documentation/ABI/ entries for your new sysfs files,
so we can't properly review them :(

thanks,

greg k-h

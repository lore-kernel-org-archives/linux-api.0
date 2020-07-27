Return-Path: <SRS0=1IKn=BG=vger.kernel.org=linux-api-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E952EC433E5
	for <linux-api@archiver.kernel.org>; Mon, 27 Jul 2020 15:56:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D3BE321D95
	for <linux-api@archiver.kernel.org>; Mon, 27 Jul 2020 15:56:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728053AbgG0P4X (ORCPT <rfc822;linux-api@archiver.kernel.org>);
        Mon, 27 Jul 2020 11:56:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52042 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726944AbgG0P4W (ORCPT
        <rfc822;linux-api@vger.kernel.org>); Mon, 27 Jul 2020 11:56:22 -0400
Received: from ZenIV.linux.org.uk (zeniv.linux.org.uk [IPv6:2002:c35c:fd02::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BFE91C061794;
        Mon, 27 Jul 2020 08:56:22 -0700 (PDT)
Received: from viro by ZenIV.linux.org.uk with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1k05U8-003kGF-BB; Mon, 27 Jul 2020 15:56:16 +0000
Date:   Mon, 27 Jul 2020 16:56:16 +0100
From:   Al Viro <viro@zeniv.linux.org.uk>
To:     Jan Kara <jack@suse.cz>
Cc:     Christoph Hellwig <hch@lst.de>, x86@kernel.org,
        Jan Kara <jack@suse.com>, linux-arm-kernel@lists.infradead.org,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-api@vger.kernel.org, linux-arch@vger.kernel.org
Subject: Re: [PATCH 4/4] quota: simplify the quotactl compat handling
Message-ID: <20200727155616.GF794331@ZenIV.linux.org.uk>
References: <20200726160401.311569-1-hch@lst.de>
 <20200726160401.311569-5-hch@lst.de>
 <20200727124127.GO23179@quack2.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200727124127.GO23179@quack2.suse.cz>
Sender: linux-api-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-api.vger.kernel.org>
X-Mailing-List: linux-api@vger.kernel.org

On Mon, Jul 27, 2020 at 02:41:27PM +0200, Jan Kara wrote:
> On Sun 26-07-20 18:04:01, Christoph Hellwig wrote:
> > Fold the misaligned u64 workarounds into the main quotactl flow instead
> > of implementing a separate compat syscall handler.
> > 
> > Signed-off-by: Christoph Hellwig <hch@lst.de>
> 
> The patch looks good to me and it saves a lot of boiler-plate code so feel
> free to add:
> 
> Acked-by: Jan Kara <jack@suse.cz>

Which tree do we put that through?  I can grab it into vfs.git, but IIRC usually
you put quota-related stuff through yours...

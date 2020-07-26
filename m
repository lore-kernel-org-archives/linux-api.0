Return-Path: <SRS0=pxsc=BF=vger.kernel.org=linux-api-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6DEDBC433E0
	for <linux-api@archiver.kernel.org>; Sun, 26 Jul 2020 16:32:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5694B2065F
	for <linux-api@archiver.kernel.org>; Sun, 26 Jul 2020 16:32:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727032AbgGZQcV (ORCPT <rfc822;linux-api@archiver.kernel.org>);
        Sun, 26 Jul 2020 12:32:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32824 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726044AbgGZQcV (ORCPT
        <rfc822;linux-api@vger.kernel.org>); Sun, 26 Jul 2020 12:32:21 -0400
Received: from ZenIV.linux.org.uk (zeniv.linux.org.uk [IPv6:2002:c35c:fd02::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 03B4EC0619D2;
        Sun, 26 Jul 2020 09:32:21 -0700 (PDT)
Received: from viro by ZenIV.linux.org.uk with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jzjZO-0035x3-IE; Sun, 26 Jul 2020 16:32:14 +0000
Date:   Sun, 26 Jul 2020 17:32:14 +0100
From:   Al Viro <viro@zeniv.linux.org.uk>
To:     Christoph Hellwig <hch@lst.de>
Cc:     x86@kernel.org, Jan Kara <jack@suse.com>,
        linux-arm-kernel@lists.infradead.org,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-api@vger.kernel.org, linux-arch@vger.kernel.org
Subject: Re: [PATCH 4/4] quota: simplify the quotactl compat handling
Message-ID: <20200726163214.GS2786714@ZenIV.linux.org.uk>
References: <20200726160401.311569-1-hch@lst.de>
 <20200726160401.311569-5-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200726160401.311569-5-hch@lst.de>
Sender: linux-api-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-api.vger.kernel.org>
X-Mailing-List: linux-api@vger.kernel.org

On Sun, Jul 26, 2020 at 06:04:01PM +0200, Christoph Hellwig wrote:
> Fold the misaligned u64 workarounds into the main quotactl flow instead
> of implementing a separate compat syscall handler.

I can live with that (and drop the local quota-related stuff from
copy_in_user/compat_alloc_user_space elimination series).  One question,
though:

> +static int compat_copy_fs_qfilestat(struct compat_fs_qfilestat __user *to,
> +		struct fs_qfilestat *from)
> +{
> +	if (copy_to_user(to, from, sizeof(*to)) ||
> +	    put_user(from->qfs_nextents, &to->qfs_nextents))
> +		return -EFAULT;
> +	return 0;
> +}

do we have any need of that put_user()?  Note that you don't even call
that thing unless compat_need_64bit_alignment_fixup() is true.  And AFAICS
all such cases are little-endian...

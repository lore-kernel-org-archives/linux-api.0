Return-Path: <SRS0=pxsc=BF=vger.kernel.org=linux-api-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 94C88C433EB
	for <linux-api@archiver.kernel.org>; Sun, 26 Jul 2020 16:34:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7FBF22065F
	for <linux-api@archiver.kernel.org>; Sun, 26 Jul 2020 16:34:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727977AbgGZQe0 (ORCPT <rfc822;linux-api@archiver.kernel.org>);
        Sun, 26 Jul 2020 12:34:26 -0400
Received: from verein.lst.de ([213.95.11.211]:40876 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725949AbgGZQe0 (ORCPT <rfc822;linux-api@vger.kernel.org>);
        Sun, 26 Jul 2020 12:34:26 -0400
Received: by verein.lst.de (Postfix, from userid 2407)
        id BF3B368B05; Sun, 26 Jul 2020 18:34:22 +0200 (CEST)
Date:   Sun, 26 Jul 2020 18:34:22 +0200
From:   Christoph Hellwig <hch@lst.de>
To:     Al Viro <viro@zeniv.linux.org.uk>
Cc:     Christoph Hellwig <hch@lst.de>, x86@kernel.org,
        Jan Kara <jack@suse.com>, linux-arm-kernel@lists.infradead.org,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-api@vger.kernel.org, linux-arch@vger.kernel.org
Subject: Re: [PATCH 4/4] quota: simplify the quotactl compat handling
Message-ID: <20200726163422.GA24657@lst.de>
References: <20200726160401.311569-1-hch@lst.de> <20200726160401.311569-5-hch@lst.de> <20200726163214.GS2786714@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200726163214.GS2786714@ZenIV.linux.org.uk>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-api-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-api.vger.kernel.org>
X-Mailing-List: linux-api@vger.kernel.org

On Sun, Jul 26, 2020 at 05:32:14PM +0100, Al Viro wrote:
> > +static int compat_copy_fs_qfilestat(struct compat_fs_qfilestat __user *to,
> > +		struct fs_qfilestat *from)
> > +{
> > +	if (copy_to_user(to, from, sizeof(*to)) ||
> > +	    put_user(from->qfs_nextents, &to->qfs_nextents))
> > +		return -EFAULT;
> > +	return 0;
> > +}
> 
> do we have any need of that put_user()?  Note that you don't even call
> that thing unless compat_need_64bit_alignment_fixup() is true.  And AFAICS
> all such cases are little-endian...

The main reason it is there is to preserve the previous semantics.
And no, I don't think we actually need it on x86.  But what if some
poor souls adds a BE version that needs this?  E.g. arm oabi has similar
weird alignment, and now imagine someone adding arm64 compat code for
that..

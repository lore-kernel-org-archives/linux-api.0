Return-Path: <SRS0=vP9q=CZ=vger.kernel.org=linux-api-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.5 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 00B1CC43461
	for <linux-api@archiver.kernel.org>; Wed, 16 Sep 2020 06:23:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B3931206B5
	for <linux-api@archiver.kernel.org>; Wed, 16 Sep 2020 06:23:09 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="Je8keS+B"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726269AbgIPGXJ (ORCPT <rfc822;linux-api@archiver.kernel.org>);
        Wed, 16 Sep 2020 02:23:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41464 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726376AbgIPGXH (ORCPT
        <rfc822;linux-api@vger.kernel.org>); Wed, 16 Sep 2020 02:23:07 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D34C1C06174A;
        Tue, 15 Sep 2020 23:23:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=GIuJACXDqRQn158Nzy0RYapTVzHeVav6evih4PqISa8=; b=Je8keS+BKmOmABK7Ae3+2AGN5R
        x9h2/kRzXT0poM6NwiRUUTwZPfBPr9E+tI7MbvgoC+3jVwZb8PkFGMmhjbs0FFrHv55MwWMDAc7oW
        rVntaaHYdCcRGnyUGktC+sB1a8J5Y88Clu0aLwmgCjB0mVyoycPJhksee566g4bP0Msnoedbp+hbz
        Q49qC5+fyhoey1jq4wOlYyx6Y9lwQqHKS8Q+uKJoCYvNJezubmLiUYEa7+tIHfZ0YNiND+MQ1c6l9
        8b/EyiQU67nPibI/Zg3/gtZBVmQP/8ruINhLM1UJS/KWRw0VTy+mjpdaAHfpZOd3QRD77ZQLYY8qy
        6B0ykUQw==;
Received: from hch by casper.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1kIQqK-0007Ip-T4; Wed, 16 Sep 2020 06:23:00 +0000
Date:   Wed, 16 Sep 2020 07:23:00 +0100
From:   Christoph Hellwig <hch@infradead.org>
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     Rich Felker <dalias@libc.org>, linux-api@vger.kernel.org,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Christoph Hellwig <hch@infradead.org>,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 1/2] vfs: block chmod of symlinks
Message-ID: <20200916062300.GA27867@infradead.org>
References: <20200916002157.GO3265@brightrain.aerifal.cx>
 <20200916002253.GP3265@brightrain.aerifal.cx>
 <20200916061815.GB142621@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200916061815.GB142621@kroah.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-api-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-api.vger.kernel.org>
X-Mailing-List: linux-api@vger.kernel.org

On Wed, Sep 16, 2020 at 08:18:15AM +0200, Greg KH wrote:
> On Tue, Sep 15, 2020 at 08:22:54PM -0400, Rich Felker wrote:
> > It was discovered while implementing userspace emulation of fchmodat
> > AT_SYMLINK_NOFOLLOW (using O_PATH and procfs magic symlinks; otherwise
> > it's not possible to target symlinks with chmod operations) that some
> > filesystems erroneously allow access mode of symlinks to be changed,
> > but return failure with EOPNOTSUPP (see glibc issue #14578 and commit
> > a492b1e5ef). This inconsistency is non-conforming and wrong, and the
> > consensus seems to be that it was unintentional to allow link modes to
> > be changed in the first place.
> > 
> > Signed-off-by: Rich Felker <dalias@libc.org>
> > ---
> >  fs/open.c | 6 ++++++
> >  1 file changed, 6 insertions(+)
> > 
> > diff --git a/fs/open.c b/fs/open.c
> > index 9af548fb841b..cdb7964aaa6e 100644
> > --- a/fs/open.c
> > +++ b/fs/open.c
> > @@ -570,6 +570,12 @@ int chmod_common(const struct path *path, umode_t mode)
> >  	struct iattr newattrs;
> >  	int error;
> >  
> > +	/* Block chmod from getting to fs layer. Ideally the fs would either
> > +	 * allow it or fail with EOPNOTSUPP, but some are buggy and return
> > +	 * an error but change the mode, which is non-conforming and wrong. */
> > +	if (S_ISLNK(inode->i_mode))
> > +		return -EOPNOTSUPP;
> 
> I still fail to understand why these "buggy" filesystems can not be
> fixed.  Why are you papering over a filesystem-specific-bug with this
> core kernel change that we will forever have to keep?

Because checking this once in the VFS is much saner than trying to
patch up a gazillion file systems.

Return-Path: <SRS0=z1zy=DG=vger.kernel.org=linux-api-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.9 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1950BC47420
	for <linux-api@archiver.kernel.org>; Tue, 29 Sep 2020 17:49:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A0E9D20848
	for <linux-api@archiver.kernel.org>; Tue, 29 Sep 2020 17:49:47 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="mr2/M4LF"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728198AbgI2Rtq (ORCPT <rfc822;linux-api@archiver.kernel.org>);
        Tue, 29 Sep 2020 13:49:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39678 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728873AbgI2Rto (ORCPT
        <rfc822;linux-api@vger.kernel.org>); Tue, 29 Sep 2020 13:49:44 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 99487C061755;
        Tue, 29 Sep 2020 10:49:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=Z4bIZczZgSdfctyfiYPgZ9POZhSeE5GL4TFVh+Ur6B8=; b=mr2/M4LFKfI9pYOS+/sqfVOWxb
        F9ssviDA2PE09FjvHabOifjY/CE3VCW6Ff/5Fh5do/y0P7NRkADBSb3zrSuyaBFJN2IIZdvTTReNM
        ZoO4El6frgkFKbPxtlShNY4p8XhQ5nvFjCReDmRKZzsPHHf0krJJ+yhh2vo8xCEtZ6t54ZYdVFBz6
        R5+NkpGgqqg+sljJRRwT4Haotr0LdLH6KutKf5SSlKoKkaJQWg64DOBuzMegLnlBUzSe3TeAvwpQm
        q+k5+wqNw55tl5P+mQtfgdR9wZRfoRJvclSctdaQPs7ZyPk2XMEaKjTeQ41qArzfSH4ig3zL7uLAQ
        19xrYqKw==;
Received: from hch by casper.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1kNJl0-0000PI-4a; Tue, 29 Sep 2020 17:49:42 +0000
Date:   Tue, 29 Sep 2020 18:49:42 +0100
From:   Christoph Hellwig <hch@infradead.org>
To:     Al Viro <viro@zeniv.linux.org.uk>
Cc:     Christoph Hellwig <hch@infradead.org>,
        Rich Felker <dalias@libc.org>, linux-api@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 1/2] vfs: block chmod of symlinks
Message-ID: <20200929174942.GA1379@infradead.org>
References: <20200916002157.GO3265@brightrain.aerifal.cx>
 <20200916002253.GP3265@brightrain.aerifal.cx>
 <20200916062553.GB27867@infradead.org>
 <20200917040715.GS3421308@ZenIV.linux.org.uk>
 <20200917041503.GT3421308@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200917041503.GT3421308@ZenIV.linux.org.uk>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-api.vger.kernel.org>
X-Mailing-List: linux-api@vger.kernel.org

On Thu, Sep 17, 2020 at 05:15:03AM +0100, Al Viro wrote:
> Arrgh...  That'd break shmem and similar filesystems...  Still, it
> feels like we should _not_ bother in cases when there's no ACL
> for that sucker; after all, if get_acl() returns NULL, we quietly
> return 0 and that's it.
> 
> How about something like this instead?

Do you plan to turn this into a submission?

Rich, can you share your original reproducer?  I would be really
helpful to have it wired up in xfstests as a regression tests.

Return-Path: <linux-api-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ADE05C48BDF
	for <linux-api@archiver.kernel.org>; Thu, 24 Jun 2021 06:42:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9114D6112D
	for <linux-api@archiver.kernel.org>; Thu, 24 Jun 2021 06:42:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231352AbhFXGol (ORCPT <rfc822;linux-api@archiver.kernel.org>);
        Thu, 24 Jun 2021 02:44:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50804 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231145AbhFXGok (ORCPT
        <rfc822;linux-api@vger.kernel.org>); Thu, 24 Jun 2021 02:44:40 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 368CBC061574;
        Wed, 23 Jun 2021 23:42:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=VTp4ERIHfZ74eGmRGc/ixEZgfb274FHoLoJXb8aHGKc=; b=UUHFVGEv9UaLDXHzBvsrdkaA7g
        nrqXIXFwrdw/YwOYS3+v9jAkcH0Q+k3+IQ365DFaLqmlPRmruZ9md1tcG3dydjtLp2NeUonhpIZHx
        WXxuny/Vt+kgh/nxgilKlIEYF19oOib4HOedpv/VDD6AmiRygch6mqEiI72NsRVdkKi8qddeodwiN
        YuFd36djBHlyoCaz1aocwnoxaQsMV8ehXrsFOqEPZKpyxaSxpYkwVdGCiqNhyFAnIgOlRAReFikQI
        BF3pZ5gNMGSDYNpodJrAxbUuaAEBoaCvgZN2MxVwm86F5DD0ETCswC3deCqVFcRW/Ok+hH0/X5gpF
        Tx9T5QhQ==;
Received: from hch by casper.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1lwJ32-00GGVd-KS; Thu, 24 Jun 2021 06:41:22 +0000
Date:   Thu, 24 Jun 2021 07:41:12 +0100
From:   Christoph Hellwig <hch@infradead.org>
To:     Matthew Wilcox <willy@infradead.org>
Cc:     Omar Sandoval <osandov@osandov.com>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Dave Chinner <david@fromorbit.com>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        linux-btrfs <linux-btrfs@vger.kernel.org>,
        Linux API <linux-api@vger.kernel.org>,
        Kernel Team <kernel-team@fb.com>,
        Dave Chinner <dchinner@redhat.com>
Subject: Re: [PATCH RESEND x3 v9 1/9] iov_iter: add copy_struct_from_iter()
Message-ID: <YNQpCGQUIv3kvvPQ@infradead.org>
References: <CAHk-=wh+-otnW30V7BUuBLF7Dg0mYaBTpdkH90Ov=zwLQorkQw@mail.gmail.com>
 <YND6jOrku2JDgqjt@relinquished.localdomain>
 <YND8p7ioQRfoWTOU@relinquished.localdomain>
 <20210622220639.GH2419729@dread.disaster.area>
 <YNN0P4KWH+Uj7dTE@relinquished.localdomain>
 <YNOPdy14My+MHmy8@zeniv-ca.linux.org.uk>
 <YNOdunP+Fvhbsixb@relinquished.localdomain>
 <YNOqJIto1t13rPYZ@zeniv-ca.linux.org.uk>
 <YNOuiMfRO51kLcOE@relinquished.localdomain>
 <YNPnRyasHVq9NF79@casper.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YNPnRyasHVq9NF79@casper.infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-api.vger.kernel.org>
X-Mailing-List: linux-api@vger.kernel.org

I'm also really worried with overloading the regular r/w path and
iov_iter with ever more special cases.  We already have various
performance problems in the path, and adding more special cases ain't
gonna help.

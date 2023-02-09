Return-Path: <linux-api-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 02519C61DA4
	for <linux-api@archiver.kernel.org>; Thu,  9 Feb 2023 14:11:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230045AbjBIOLu (ORCPT <rfc822;linux-api@archiver.kernel.org>);
        Thu, 9 Feb 2023 09:11:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40312 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230344AbjBIOLt (ORCPT
        <rfc822;linux-api@vger.kernel.org>); Thu, 9 Feb 2023 09:11:49 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DFAFC5D3D0;
        Thu,  9 Feb 2023 06:11:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=OLfeb/1peUB0Uk6OCxp5bH/mik1H6dPr8FEIIkuL/QU=; b=JbYEsNAVDN51UJgX9qx6k2eWsB
        07OxOMxmQRAsKV4YCUUrdkihKeBBP+2v3yOzF5lMH2RU3uRzAPvxbFhjWsOGAZ5ej64w7YIiUOC/q
        CyqW+bPeytq1LKDKZNG8kHZ40wiRBsT+vZm0yzikNRVt+PamelOijN2LOAX/972YiI2nU3VMfcBwy
        DrNSYpn6HJBxJjd5YrKF++aI3VpeX5P/oiaE/kGnSypHx47JkJ7Bq57GujAobCyZgg+NWgy6XlEso
        32JWzqTYOr8NbgJAitEXC8RG1uA55A7/Tr6RfZ0VXSM4B8rbIOvpQBD9K6YWMJ/c21YD+BkFx2Kif
        EpsWohxw==;
Received: from willy by casper.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1pQ7eC-002Fh2-Uk; Thu, 09 Feb 2023 14:11:36 +0000
Date:   Thu, 9 Feb 2023 14:11:36 +0000
From:   Matthew Wilcox <willy@infradead.org>
To:     Stefan Metzmacher <metze@samba.org>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        Linux API Mailing List <linux-api@vger.kernel.org>,
        io-uring <io-uring@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Samba Technical <samba-technical@lists.samba.org>
Subject: Re: copy on write for splice() from file to pipe?
Message-ID: <Y+T/GE77AKzsPte9@casper.infradead.org>
References: <0cfd9f02-dea7-90e2-e932-c8129b6013c7@samba.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0cfd9f02-dea7-90e2-e932-c8129b6013c7@samba.org>
Precedence: bulk
List-ID: <linux-api.vger.kernel.org>
X-Mailing-List: linux-api@vger.kernel.org

On Thu, Feb 09, 2023 at 02:55:59PM +0100, Stefan Metzmacher wrote:
> Hi Linus and others,
> 
> as written in a private mail before, I'm currently trying to
> make use of IORING_OP_SPLICE in order to get zero copy support
> in Samba.

I have to ask why.  In a modern network, isn't all data encrypted?
So you have to encrypt into a different buffer, and then you checksum
that buffer.  So it doesn't matter if writes can change the page cache
after you called splice(), you just need to have the data be consistent
so the checksum doesn't change.

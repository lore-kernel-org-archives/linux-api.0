Return-Path: <linux-api-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 50968C433EF
	for <linux-api@archiver.kernel.org>; Wed, 23 Mar 2022 07:16:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242135AbiCWHSP (ORCPT <rfc822;linux-api@archiver.kernel.org>);
        Wed, 23 Mar 2022 03:18:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50458 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241199AbiCWHSP (ORCPT
        <rfc822;linux-api@vger.kernel.org>); Wed, 23 Mar 2022 03:18:15 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 206236E8D5;
        Wed, 23 Mar 2022 00:16:46 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B4D1B61669;
        Wed, 23 Mar 2022 07:16:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 64E00C340E8;
        Wed, 23 Mar 2022 07:16:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1648019805;
        bh=4XC3PLaOISkZfKP5g75IqXqQB7yAdHiRHcfda8BXPx8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=rwKitDuGNZc+tcyuJYkRFUevw7fYURBnWE5lmJtdGoU/BdX/M3fhduwnCzh4H1GHJ
         h2VGcpmpcfCEnpr2dBx3/Hu6p+PKBU4zoWv/Q76AztZ1NuXHNVi7/NK8AMMBMNDXjR
         v+f7BkVkucR7KewXCg4VJYAWkB9Jz6uGd1ABG230=
Date:   Wed, 23 Mar 2022 08:16:41 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Miklos Szeredi <mszeredi@redhat.com>
Cc:     linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-api@vger.kernel.org, linux-man@vger.kernel.org,
        linux-security-module@vger.kernel.org, Karel Zak <kzak@redhat.com>,
        Ian Kent <raven@themaw.net>,
        David Howells <dhowells@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Christian Brauner <christian@brauner.io>,
        Amir Goldstein <amir73il@gmail.com>,
        James Bottomley <James.Bottomley@hansenpartnership.com>
Subject: Re: [RFC PATCH] getvalues(2) prototype
Message-ID: <YjrJWf+XMnWVd6K0@kroah.com>
References: <20220322192712.709170-1-mszeredi@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220322192712.709170-1-mszeredi@redhat.com>
Precedence: bulk
List-ID: <linux-api.vger.kernel.org>
X-Mailing-List: linux-api@vger.kernel.org

On Tue, Mar 22, 2022 at 08:27:12PM +0100, Miklos Szeredi wrote:
> Add a new userspace API that allows getting multiple short values in a
> single syscall.
> 
> This would be useful for the following reasons:
> 
> - Calling open/read/close for many small files is inefficient.  E.g. on my
>   desktop invoking lsof(1) results in ~60k open + read + close calls under
>   /proc and 90% of those are 128 bytes or less.

As I found out in testing readfile():
	https://lore.kernel.org/r/20200704140250.423345-1-gregkh@linuxfoundation.org

microbenchmarks do show a tiny improvement in doing something like this,
but that's not a real-world application.

Do you have anything real that can use this that shows a speedup?

thanks,

greg k-h

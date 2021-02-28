Return-Path: <linux-api-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F0408C433E0
	for <linux-api@archiver.kernel.org>; Sun, 28 Feb 2021 02:59:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B123464E0F
	for <linux-api@archiver.kernel.org>; Sun, 28 Feb 2021 02:59:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230040AbhB1C7R (ORCPT <rfc822;linux-api@archiver.kernel.org>);
        Sat, 27 Feb 2021 21:59:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37436 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230008AbhB1C7R (ORCPT
        <rfc822;linux-api@vger.kernel.org>); Sat, 27 Feb 2021 21:59:17 -0500
Received: from zeniv-ca.linux.org.uk (zeniv-ca.linux.org.uk [IPv6:2607:5300:60:148a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3FC27C06174A;
        Sat, 27 Feb 2021 18:58:37 -0800 (PST)
Received: from viro by zeniv-ca.linux.org.uk with local (Exim 4.94 #2 (Red Hat Linux))
        id 1lGCHm-001YgY-OA; Sun, 28 Feb 2021 02:58:22 +0000
Date:   Sun, 28 Feb 2021 02:58:22 +0000
From:   Al Viro <viro@zeniv.linux.org.uk>
To:     Drew DeVault <sir@cmpwn.com>
Cc:     linux-fsdevel@vger.kernel.org, linux-api@vger.kernel.org,
        Aleksa Sarai <cyphar@cyphar.com>
Subject: Re: [RFC PATCH] fs: introduce mkdirat2 syscall for atomic mkdir
Message-ID: <YDsGzhBzLzSp6nPj@zeniv-ca.linux.org.uk>
References: <20210228002500.11483-1-sir@cmpwn.com>
 <YDr8UihFQ3M469x8@zeniv-ca.linux.org.uk>
 <C9KSZTRJ2CL6.DWD539LYTVZX@taiga>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <C9KSZTRJ2CL6.DWD539LYTVZX@taiga>
Sender: Al Viro <viro@ftp.linux.org.uk>
Precedence: bulk
List-ID: <linux-api.vger.kernel.org>
X-Mailing-List: linux-api@vger.kernel.org

On Sat, Feb 27, 2021 at 09:21:09PM -0500, Drew DeVault wrote:
> On Sat Feb 27, 2021 at 9:13 PM EST, Al Viro wrote:
> > No to the ABI part; "on error it returns -E..., on success - 0 or a
> > non-negative number representing a file descriptor (zero also
> > possible, but unlikely)" is bloody awful as calling conventions go,
> > especially since the case when 0 happens to be a descriptor is not
> > going to get a lot of testing on the userland side.
> 
> Hm, I was just trying to mimic the behavior of open(2). Do you have a
> better suggestion?

open() *always* returns descriptor or an error, for one thing.
And quite a few of open() flags are completely wrong for mkdir,
starting with symlink following and truncation.

What's more, your implementation is both racy and deadlock-prone -
it repeats the entire pathwalk with no warranty that it'll
arrive to the object you've created *AND* if you have
something like /foo/bar/baz/../../splat and dentry of bar
gets evicted on memory pressure, that pathwalk will end up
trying to look bar up.  In the already locked /foo, aka
/foo/bar/baz/../..

TBH, I don't understand what are you trying to achieve -
what will that mkdir+open combination buy you, especially
since that atomicity goes straight out of window if you try
to use that on e.g. NFS.  How is the userland supposed to make
use of that thing?

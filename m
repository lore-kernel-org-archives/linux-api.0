Return-Path: <linux-api-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C4C82C433E0
	for <linux-api@archiver.kernel.org>; Mon,  1 Mar 2021 19:07:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 92AE764E45
	for <linux-api@archiver.kernel.org>; Mon,  1 Mar 2021 19:07:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240993AbhCATGr (ORCPT <rfc822;linux-api@archiver.kernel.org>);
        Mon, 1 Mar 2021 14:06:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41744 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236001AbhCATEO (ORCPT
        <rfc822;linux-api@vger.kernel.org>); Mon, 1 Mar 2021 14:04:14 -0500
Received: from fieldses.org (fieldses.org [IPv6:2600:3c00:e000:2f7::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 146F6C061756;
        Mon,  1 Mar 2021 11:03:00 -0800 (PST)
Received: by fieldses.org (Postfix, from userid 2815)
        id 1177725FE; Mon,  1 Mar 2021 14:02:59 -0500 (EST)
DKIM-Filter: OpenDKIM Filter v2.11.0 fieldses.org 1177725FE
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fieldses.org;
        s=default; t=1614625379;
        bh=mxaTekYNEqDdiYO9bMH3o6RRL26uXiJHF5SOuD+r1Sc=;
        h=Date:To:Cc:Subject:References:In-Reply-To:From:From;
        b=fWmjUM4x73v2iYzV6qOdYURZOkzE7G3TZ5AsCJrbp49BX7PtAKjVHoknZLjDHApgr
         lmIGmjISuJGcvyJsNAVtcGj/jwYrriVsJfinvv/u6DFiTgPnhHl2CidBkMx5DGUkxO
         xtbRF3uSxFKFU2yI0EwnZHjydFlEI6gaxHZNK770=
Date:   Mon, 1 Mar 2021 14:02:59 -0500
To:     Al Viro <viro@zeniv.linux.org.uk>
Cc:     Drew DeVault <sir@cmpwn.com>, linux-fsdevel@vger.kernel.org,
        linux-api@vger.kernel.org, Aleksa Sarai <cyphar@cyphar.com>
Subject: Re: [RFC PATCH] fs: introduce mkdirat2 syscall for atomic mkdir
Message-ID: <20210301190259.GC14881@fieldses.org>
References: <20210228002500.11483-1-sir@cmpwn.com>
 <YDr8UihFQ3M469x8@zeniv-ca.linux.org.uk>
 <C9KSZTRJ2CL6.DWD539LYTVZX@taiga>
 <YDsGzhBzLzSp6nPj@zeniv-ca.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YDsGzhBzLzSp6nPj@zeniv-ca.linux.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
From:   bfields@fieldses.org (J. Bruce Fields)
Precedence: bulk
List-ID: <linux-api.vger.kernel.org>
X-Mailing-List: linux-api@vger.kernel.org

On Sun, Feb 28, 2021 at 02:58:22AM +0000, Al Viro wrote:
> TBH, I don't understand what are you trying to achieve -
> what will that mkdir+open combination buy you, especially
> since that atomicity goes straight out of window if you try
> to use that on e.g. NFS.  How is the userland supposed to make
> use of that thing?

For what it's worth, the RPC that creates a directory can also get a
filehandle of the new directory, so I don't think there's anything in
the NFS protocol that would *prevent* implementing this.  (Whether
that's useful, I don't know.)

--b.

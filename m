Return-Path: <SRS0=bke1=BQ=vger.kernel.org=linux-api-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.0 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F25A5C433DF
	for <linux-api@archiver.kernel.org>; Thu,  6 Aug 2020 17:26:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5E3B123119
	for <linux-api@archiver.kernel.org>; Thu,  6 Aug 2020 17:26:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729802AbgHFR0E (ORCPT <rfc822;linux-api@archiver.kernel.org>);
        Thu, 6 Aug 2020 13:26:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45072 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729445AbgHFRCg (ORCPT
        <rfc822;linux-api@vger.kernel.org>); Thu, 6 Aug 2020 13:02:36 -0400
Received: from ZenIV.linux.org.uk (zeniv.linux.org.uk [IPv6:2002:c35c:fd02::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 02DAAC0A8889;
        Thu,  6 Aug 2020 07:32:24 -0700 (PDT)
Received: from viro by ZenIV.linux.org.uk with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1k3gwP-00AXtN-8v; Thu, 06 Aug 2020 14:32:21 +0000
Date:   Thu, 6 Aug 2020 15:32:21 +0100
From:   Al Viro <viro@zeniv.linux.org.uk>
To:     Christoph Hellwig <hch@lst.de>
Cc:     Vikas Kumar <vikas.kumar2@arm.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-api@vger.kernel.org, rafael@kernel.org
Subject: Re: [LTP-FAIL][02/21] fs: refactor ksys_umount
Message-ID: <20200806143221.GQ1236603@ZenIV.linux.org.uk>
References: <d28d2235-9b1c-0403-59ca-e57ac5d0460e@arm.com>
 <20200806141732.GA5902@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200806141732.GA5902@lst.de>
Sender: linux-api-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-api.vger.kernel.org>
X-Mailing-List: linux-api@vger.kernel.org

On Thu, Aug 06, 2020 at 04:17:32PM +0200, Christoph Hellwig wrote:
> Fix for umount03 below.  The other one works fine here, but from
> your logs this might be a follow on if you run it after umount without
> the fix.

Ugh...

How about 
static int may_umount(const struct path *path, int flags)
{
        struct mount *mnt = real_mount(path->mnt);

        if (flags & ~(MNT_FORCE | MNT_DETACH | MNT_EXPIRE | UMOUNT_NOFOLLOW))
                return -EINVAL;
        if (!may_mount())
                return -EPERM;
        if (path->dentry != path->mnt->mnt_root)
                return -EINVAL;
        if (!check_mnt(mnt))
                return -EINVAL;
        if (mnt->mnt.mnt_flags & MNT_LOCKED) /* Check optimistically */
                return -EINVAL;
        if (flags & MNT_FORCE && !capable(CAP_SYS_ADMIN))
                return -EPERM;
	return 0;
}

int path_umount(const struct path *path, int flags)
{
        struct mount *mnt = real_mount(path->mnt);
        int err;

	err = may_umount(path, flags);
	if (!err)
		err = do_umount(mnt, flags);

        /* we mustn't call path_put() as that would clear mnt_expiry_mark */
        dput(path->dentry);
        mntput_no_expire(mnt);
        return err;
}

instead?

Return-Path: <SRS0=ctNE=CI=vger.kernel.org=linux-api-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.5 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DAA5CC433E2
	for <linux-api@archiver.kernel.org>; Sun, 30 Aug 2020 20:00:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id ABF9C206FA
	for <linux-api@archiver.kernel.org>; Sun, 30 Aug 2020 20:00:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726409AbgH3UAb (ORCPT <rfc822;linux-api@archiver.kernel.org>);
        Sun, 30 Aug 2020 16:00:31 -0400
Received: from brightrain.aerifal.cx ([216.12.86.13]:48258 "EHLO
        brightrain.aerifal.cx" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726201AbgH3UAa (ORCPT
        <rfc822;linux-api@vger.kernel.org>); Sun, 30 Aug 2020 16:00:30 -0400
Date:   Sun, 30 Aug 2020 16:00:29 -0400
From:   Rich Felker <dalias@libc.org>
To:     Jann Horn <jannh@google.com>
Cc:     linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        kernel list <linux-kernel@vger.kernel.org>,
        Linux API <linux-api@vger.kernel.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>
Subject: Re: [RESEND PATCH] vfs: add RWF_NOAPPEND flag for pwritev2
Message-ID: <20200830200029.GF3265@brightrain.aerifal.cx>
References: <20200829020002.GC3265@brightrain.aerifal.cx>
 <CAG48ez1BExw7DdCEeRD1hG5ZpRObpGDodnizW2xD5tC0saTDqg@mail.gmail.com>
 <20200830163657.GD3265@brightrain.aerifal.cx>
 <CAG48ez00caDqMomv+PF4dntJkWx7rNYf3E+8gufswis6UFSszw@mail.gmail.com>
 <20200830184334.GE3265@brightrain.aerifal.cx>
 <CAG48ez3LvbWLBsJ+Edc9qCjXDYV0TRjVRrANhiR2im1aRUQ6gQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAG48ez3LvbWLBsJ+Edc9qCjXDYV0TRjVRrANhiR2im1aRUQ6gQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-api-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-api.vger.kernel.org>
X-Mailing-List: linux-api@vger.kernel.org

On Sun, Aug 30, 2020 at 09:02:31PM +0200, Jann Horn wrote:
> On Sun, Aug 30, 2020 at 8:43 PM Rich Felker <dalias@libc.org> wrote:
> > On Sun, Aug 30, 2020 at 08:31:36PM +0200, Jann Horn wrote:
> > > On Sun, Aug 30, 2020 at 6:36 PM Rich Felker <dalias@libc.org> wrote:
> > > > So just checking IS_APPEND in the code paths used by
> > > > pwritev2 (and erroring out rather than silently writing output at the
> > > > wrong place) should suffice to preserve all existing security
> > > > invariants.
> > >
> > > Makes sense.
> >
> > There are 3 places where kiocb_set_rw_flags is called with flags that
> > seem to be controlled by userspace: aio.c, io_uring.c, and
> > read_write.c. Presumably each needs to EPERM out on RWF_NOAPPEND if
> > the underlying inode is S_APPEND. To avoid repeating the same logic in
> > an error-prone way, should kiocb_set_rw_flags's signature be updated
> > to take the filp so that it can obtain the inode and check IS_APPEND
> > before accepting RWF_NOAPPEND? It's inline so this should avoid
> > actually loading anything except in the codepath where
> > flags&RWF_NOAPPEND is nonzero.
> 
> You can get the file pointer from ki->ki_filp. See the RWF_NOWAIT
> branch of kiocb_set_rw_flags().

Thanks. I should have looked for that. OK, so a fixup like this on top
of the existing patch?

diff --git a/include/linux/fs.h b/include/linux/fs.h
index 473289bff4c6..674131e8d139 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -3457,8 +3457,11 @@ static inline int kiocb_set_rw_flags(struct kiocb *ki, rwf_t flags)
 		ki->ki_flags |= (IOCB_DSYNC | IOCB_SYNC);
 	if (flags & RWF_APPEND)
 		ki->ki_flags |= IOCB_APPEND;
-	if (flags & RWF_NOAPPEND)
+	if (flags & RWF_NOAPPEND) {
+		if (IS_APPEND(file_inode(ki->ki_filp)))
+			return -EPERM;
 		ki->ki_flags &= ~IOCB_APPEND;
+	}
 	return 0;
 }
 
If this is good I'll submit a v2 as the above squashed with the
original patch.

Rich

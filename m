Return-Path: <SRS0=vP9q=CZ=vger.kernel.org=linux-api-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D444CC43461
	for <linux-api@archiver.kernel.org>; Wed, 16 Sep 2020 00:23:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A887D2076B
	for <linux-api@archiver.kernel.org>; Wed, 16 Sep 2020 00:23:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727236AbgIPAWz (ORCPT <rfc822;linux-api@archiver.kernel.org>);
        Tue, 15 Sep 2020 20:22:55 -0400
Received: from brightrain.aerifal.cx ([216.12.86.13]:53986 "EHLO
        brightrain.aerifal.cx" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727267AbgIPAWz (ORCPT
        <rfc822;linux-api@vger.kernel.org>); Tue, 15 Sep 2020 20:22:55 -0400
Date:   Tue, 15 Sep 2020 20:22:54 -0400
From:   Rich Felker <dalias@libc.org>
To:     linux-api@vger.kernel.org
Cc:     Alexander Viro <viro@zeniv.linux.org.uk>,
        Christoph Hellwig <hch@infradead.org>,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v2 1/2] vfs: block chmod of symlinks
Message-ID: <20200916002253.GP3265@brightrain.aerifal.cx>
References: <20200916002157.GO3265@brightrain.aerifal.cx>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200916002157.GO3265@brightrain.aerifal.cx>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-api-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-api.vger.kernel.org>
X-Mailing-List: linux-api@vger.kernel.org

It was discovered while implementing userspace emulation of fchmodat
AT_SYMLINK_NOFOLLOW (using O_PATH and procfs magic symlinks; otherwise
it's not possible to target symlinks with chmod operations) that some
filesystems erroneously allow access mode of symlinks to be changed,
but return failure with EOPNOTSUPP (see glibc issue #14578 and commit
a492b1e5ef). This inconsistency is non-conforming and wrong, and the
consensus seems to be that it was unintentional to allow link modes to
be changed in the first place.

Signed-off-by: Rich Felker <dalias@libc.org>
---
 fs/open.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/fs/open.c b/fs/open.c
index 9af548fb841b..cdb7964aaa6e 100644
--- a/fs/open.c
+++ b/fs/open.c
@@ -570,6 +570,12 @@ int chmod_common(const struct path *path, umode_t mode)
 	struct iattr newattrs;
 	int error;
 
+	/* Block chmod from getting to fs layer. Ideally the fs would either
+	 * allow it or fail with EOPNOTSUPP, but some are buggy and return
+	 * an error but change the mode, which is non-conforming and wrong. */
+	if (S_ISLNK(inode->i_mode))
+		return -EOPNOTSUPP;
+
 	error = mnt_want_write(path->mnt);
 	if (error)
 		return error;
-- 
2.21.0


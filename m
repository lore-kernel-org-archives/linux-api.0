Return-Path: <SRS0=K+Eq=4I=vger.kernel.org=linux-api-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 90A0DC11D25
	for <linux-api@archiver.kernel.org>; Thu, 20 Feb 2020 20:51:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7295420801
	for <linux-api@archiver.kernel.org>; Thu, 20 Feb 2020 20:51:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728688AbgBTUvY (ORCPT <rfc822;linux-api@archiver.kernel.org>);
        Thu, 20 Feb 2020 15:51:24 -0500
Received: from out02.mta.xmission.com ([166.70.13.232]:48810 "EHLO
        out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728618AbgBTUvX (ORCPT
        <rfc822;linux-api@vger.kernel.org>); Thu, 20 Feb 2020 15:51:23 -0500
Received: from in01.mta.xmission.com ([166.70.13.51])
        by out02.mta.xmission.com with esmtps (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.90_1)
        (envelope-from <ebiederm@xmission.com>)
        id 1j4sn4-0001ko-94; Thu, 20 Feb 2020 13:51:22 -0700
Received: from ip68-227-160-95.om.om.cox.net ([68.227.160.95] helo=x220.xmission.com)
        by in01.mta.xmission.com with esmtpsa (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.87)
        (envelope-from <ebiederm@xmission.com>)
        id 1j4smw-0005SC-BW; Thu, 20 Feb 2020 13:51:21 -0700
From:   ebiederm@xmission.com (Eric W. Biederman)
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     Al Viro <viro@zeniv.linux.org.uk>,
        LKML <linux-kernel@vger.kernel.org>,
        Kernel Hardening <kernel-hardening@lists.openwall.com>,
        Linux API <linux-api@vger.kernel.org>,
        Linux FS Devel <linux-fsdevel@vger.kernel.org>,
        Linux Security Module <linux-security-module@vger.kernel.org>,
        Akinobu Mita <akinobu.mita@gmail.com>,
        Alexey Dobriyan <adobriyan@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Andy Lutomirski <luto@kernel.org>,
        Daniel Micay <danielmicay@gmail.com>,
        Djalal Harouni <tixxdz@gmail.com>,
        "Dmitry V . Levin" <ldv@altlinux.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Ingo Molnar <mingo@kernel.org>,
        "J . Bruce Fields" <bfields@fieldses.org>,
        Jeff Layton <jlayton@poochiereds.net>,
        Jonathan Corbet <corbet@lwn.net>,
        Kees Cook <keescook@chromium.org>,
        Oleg Nesterov <oleg@redhat.com>,
        Solar Designer <solar@openwall.com>
References: <20200210150519.538333-8-gladkov.alexey@gmail.com>
        <87v9odlxbr.fsf@x220.int.ebiederm.org>
        <20200212144921.sykucj4mekcziicz@comp-core-i7-2640m-0182e6>
        <87tv3vkg1a.fsf@x220.int.ebiederm.org>
        <CAHk-=wg52stFtUxMOxs3afkwDWmWn1JXC7RJ7dPsTrJbnxpZVg@mail.gmail.com>
        <87v9obipk9.fsf@x220.int.ebiederm.org>
        <CAHk-=wgwmu4jpmOqW0+Lz0dcem1Fub=ThLHvmLobf_WqCq7bwg@mail.gmail.com>
        <20200212200335.GO23230@ZenIV.linux.org.uk>
        <CAHk-=wi+1CPShMFvJNPfnrJ8DD8uVKUOQ5TQzQUNGLUkeoahkg@mail.gmail.com>
        <20200212203833.GQ23230@ZenIV.linux.org.uk>
        <20200212204124.GR23230@ZenIV.linux.org.uk>
        <CAHk-=wi5FOGV_3tALK3n6E2fK3Oa_yCYkYQtCSaXLSEm2DUCKg@mail.gmail.com>
        <87lfp7h422.fsf@x220.int.ebiederm.org>
        <CAHk-=wgmn9Qds0VznyphouSZW6e42GWDT5H1dpZg8pyGDGN+=w@mail.gmail.com>
        <87pnejf6fz.fsf@x220.int.ebiederm.org>
        <871rqpaswu.fsf_-_@x220.int.ebiederm.org>
Date:   Thu, 20 Feb 2020 14:49:09 -0600
In-Reply-To: <871rqpaswu.fsf_-_@x220.int.ebiederm.org> (Eric W. Biederman's
        message of "Thu, 20 Feb 2020 14:46:25 -0600")
Message-ID: <87h7zl9e7u.fsf_-_@x220.int.ebiederm.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-SPF: eid=1j4smw-0005SC-BW;;;mid=<87h7zl9e7u.fsf_-_@x220.int.ebiederm.org>;;;hst=in01.mta.xmission.com;;;ip=68.227.160.95;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX18yxsTIN6rEo+POZRFDqs4bpwfG8Bf38/Y=
X-SA-Exim-Connect-IP: 68.227.160.95
X-SA-Exim-Mail-From: ebiederm@xmission.com
Subject: [PATCH 3/7] proc: Mov rcu_read_(lock|unlock) in proc_prune_siblings_dcache
X-SA-Exim-Version: 4.2.1 (built Thu, 05 May 2016 13:38:54 -0600)
X-SA-Exim-Scanned: Yes (on in01.mta.xmission.com)
Sender: linux-api-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-api.vger.kernel.org>
X-Mailing-List: linux-api@vger.kernel.org


Don't make it look like rcu_read_lock is held over the entire loop
instead just take the rcu_read_lock over the part of the loop that
matters.  This makes the intent of the code a little clearer.

Signed-off-by: "Eric W. Biederman" <ebiederm@xmission.com>
---
 fs/proc/inode.c | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/fs/proc/inode.c b/fs/proc/inode.c
index 74ce4a8d05eb..38a7baa41aba 100644
--- a/fs/proc/inode.c
+++ b/fs/proc/inode.c
@@ -110,11 +110,13 @@ void proc_prune_siblings_dcache(struct hlist_head *inodes, spinlock_t *lock)
 	struct hlist_node *node;
 	struct super_block *sb;
 
-	rcu_read_lock();
 	for (;;) {
+		rcu_read_lock();
 		node = hlist_first_rcu(inodes);
-		if (!node)
+		if (!node) {
+			rcu_read_unlock();
 			break;
+		}
 		ei = hlist_entry(node, struct proc_inode, sibling_inodes);
 		spin_lock(lock);
 		hlist_del_init_rcu(&ei->sibling_inodes);
@@ -122,23 +124,21 @@ void proc_prune_siblings_dcache(struct hlist_head *inodes, spinlock_t *lock)
 
 		inode = &ei->vfs_inode;
 		sb = inode->i_sb;
-		if (!atomic_inc_not_zero(&sb->s_active))
+		if (!atomic_inc_not_zero(&sb->s_active)) {
+			rcu_read_unlock();
 			continue;
+		}
 		inode = igrab(inode);
 		rcu_read_unlock();
 		if (unlikely(!inode)) {
 			deactivate_super(sb);
-			rcu_read_lock();
 			continue;
 		}
 
 		d_prune_aliases(inode);
 		iput(inode);
 		deactivate_super(sb);
-
-		rcu_read_lock();
 	}
-	rcu_read_unlock();
 }
 
 static int proc_show_options(struct seq_file *seq, struct dentry *root)
-- 
2.20.1


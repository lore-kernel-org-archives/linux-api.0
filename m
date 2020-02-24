Return-Path: <SRS0=Uuon=4M=vger.kernel.org=linux-api-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 95808C11D2F
	for <linux-api@archiver.kernel.org>; Mon, 24 Feb 2020 16:27:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 681B52080D
	for <linux-api@archiver.kernel.org>; Mon, 24 Feb 2020 16:27:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727802AbgBXQ1X (ORCPT <rfc822;linux-api@archiver.kernel.org>);
        Mon, 24 Feb 2020 11:27:23 -0500
Received: from out02.mta.xmission.com ([166.70.13.232]:48850 "EHLO
        out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727160AbgBXQ1X (ORCPT
        <rfc822;linux-api@vger.kernel.org>); Mon, 24 Feb 2020 11:27:23 -0500
Received: from in01.mta.xmission.com ([166.70.13.51])
        by out02.mta.xmission.com with esmtps (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.90_1)
        (envelope-from <ebiederm@xmission.com>)
        id 1j6GZk-0004Dy-PN; Mon, 24 Feb 2020 09:27:20 -0700
Received: from ip68-227-160-95.om.om.cox.net ([68.227.160.95] helo=x220.xmission.com)
        by in01.mta.xmission.com with esmtpsa (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.87)
        (envelope-from <ebiederm@xmission.com>)
        id 1j6GZk-0007ND-2p; Mon, 24 Feb 2020 09:27:20 -0700
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
        Solar Designer <solar@openwall.com>,
        Alexey Gladkov <gladkov.alexey@gmail.com>
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
Date:   Mon, 24 Feb 2020 10:25:16 -0600
In-Reply-To: <871rqpaswu.fsf_-_@x220.int.ebiederm.org> (Eric W. Biederman's
        message of "Thu, 20 Feb 2020 14:46:25 -0600")
Message-ID: <871rqk2brn.fsf_-_@x220.int.ebiederm.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-SPF: eid=1j6GZk-0007ND-2p;;;mid=<871rqk2brn.fsf_-_@x220.int.ebiederm.org>;;;hst=in01.mta.xmission.com;;;ip=68.227.160.95;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX18r19JNQj7E6kX0G2mdhpQOxD8W+HrcR10=
X-SA-Exim-Connect-IP: 68.227.160.95
X-SA-Exim-Mail-From: ebiederm@xmission.com
Subject: [PATCH v2 0/6] proc: Dentry flushing without proc_mnt
X-SA-Exim-Version: 4.2.1 (built Thu, 05 May 2016 13:38:54 -0600)
X-SA-Exim-Scanned: Yes (on in01.mta.xmission.com)
Sender: linux-api-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-api.vger.kernel.org>
X-Mailing-List: linux-api@vger.kernel.org


I have addressed all of the review comments as I understand them,
and fixed the small oversight the kernel test robot was able to
find. (I had failed to initialize the new field pid->inodes).

I did not hear any concerns from the 10,000 foot level last time
so I am assuming this set of changes (baring bugs) is good to go.

Unless some new issues appear my plan is to put this in my tree
and get this into linux-next.  Which will give Alexey something
to build his changes on.


I tested this set of changes by running:
 (while ls -1 -f /proc > /dev/null ; do :; done ) &
And monitoring the amount of free memory.

With the flushing disabled I saw the used memory in the system grow by
20M before the shrinker would bring it back down to where it started.
With the patch applied I saw the memory usage stay essentially fixed.

So flushing definitely keeps things working better.


If anyone sees any problems with this code please let me know.

Thank you,

Eric W. Biederman (6):
      proc: Rename in proc_inode rename sysctl_inodes sibling_inodes
      proc: Generalize proc_sys_prune_dcache into proc_prune_siblings_dcache
      proc: In proc_prune_siblings_dcache cache an aquired super block
      proc: Use d_invalidate in proc_prune_siblings_dcache
      proc: Clear the pieces of proc_inode that proc_evict_inode cares about
      proc: Use a list of inodes to flush from proc

 fs/proc/base.c          | 111 ++++++++++++++++--------------------------------
 fs/proc/inode.c         |  73 ++++++++++++++++++++++++++++---
 fs/proc/internal.h      |   4 +-
 fs/proc/proc_sysctl.c   |  45 +++-----------------
 include/linux/pid.h     |   1 +
 include/linux/proc_fs.h |   4 +-
 kernel/exit.c           |   4 +-
 kernel/pid.c            |   1 +
 8 files changed, 120 insertions(+), 123 deletions(-)


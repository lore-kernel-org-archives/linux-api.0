Return-Path: <SRS0=Hu9T=4C=vger.kernel.org=linux-api-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 57BFEC35242
	for <linux-api@archiver.kernel.org>; Fri, 14 Feb 2020 03:51:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2CF982187F
	for <linux-api@archiver.kernel.org>; Fri, 14 Feb 2020 03:51:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728520AbgBNDvR (ORCPT <rfc822;linux-api@archiver.kernel.org>);
        Thu, 13 Feb 2020 22:51:17 -0500
Received: from out02.mta.xmission.com ([166.70.13.232]:35780 "EHLO
        out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728154AbgBNDvR (ORCPT
        <rfc822;linux-api@vger.kernel.org>); Thu, 13 Feb 2020 22:51:17 -0500
Received: from in01.mta.xmission.com ([166.70.13.51])
        by out02.mta.xmission.com with esmtps (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.90_1)
        (envelope-from <ebiederm@xmission.com>)
        id 1j2S0a-0007Cp-F5; Thu, 13 Feb 2020 20:51:16 -0700
Received: from ip68-227-160-95.om.om.cox.net ([68.227.160.95] helo=x220.xmission.com)
        by in01.mta.xmission.com with esmtpsa (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.87)
        (envelope-from <ebiederm@xmission.com>)
        id 1j2S0Z-0006vA-4D; Thu, 13 Feb 2020 20:51:16 -0700
From:   ebiederm@xmission.com (Eric W. Biederman)
To:     Al Viro <viro@zeniv.linux.org.uk>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
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
References: <20200210150519.538333-1-gladkov.alexey@gmail.com>
        <20200210150519.538333-8-gladkov.alexey@gmail.com>
        <87v9odlxbr.fsf@x220.int.ebiederm.org>
        <20200212144921.sykucj4mekcziicz@comp-core-i7-2640m-0182e6>
        <87tv3vkg1a.fsf@x220.int.ebiederm.org>
        <CAHk-=wg52stFtUxMOxs3afkwDWmWn1JXC7RJ7dPsTrJbnxpZVg@mail.gmail.com>
        <87v9obipk9.fsf@x220.int.ebiederm.org>
        <CAHk-=wgwmu4jpmOqW0+Lz0dcem1Fub=ThLHvmLobf_WqCq7bwg@mail.gmail.com>
        <20200212200335.GO23230@ZenIV.linux.org.uk>
        <CAHk-=wi+1CPShMFvJNPfnrJ8DD8uVKUOQ5TQzQUNGLUkeoahkg@mail.gmail.com>
        <20200212203833.GQ23230@ZenIV.linux.org.uk>
Date:   Thu, 13 Feb 2020 21:49:20 -0600
In-Reply-To: <20200212203833.GQ23230@ZenIV.linux.org.uk> (Al Viro's message of
        "Wed, 12 Feb 2020 20:38:33 +0000")
Message-ID: <87sgjdde0v.fsf@x220.int.ebiederm.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-SPF: eid=1j2S0Z-0006vA-4D;;;mid=<87sgjdde0v.fsf@x220.int.ebiederm.org>;;;hst=in01.mta.xmission.com;;;ip=68.227.160.95;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX18hwn2iY2MOovMvLUTHlMeKjuKGlG2T5jo=
X-SA-Exim-Connect-IP: 68.227.160.95
X-SA-Exim-Mail-From: ebiederm@xmission.com
Subject: Re: [PATCH v8 07/11] proc: flush task dcache entries from all procfs instances
X-SA-Exim-Version: 4.2.1 (built Thu, 05 May 2016 13:38:54 -0600)
X-SA-Exim-Scanned: Yes (on in01.mta.xmission.com)
Sender: linux-api-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-api.vger.kernel.org>
X-Mailing-List: linux-api@vger.kernel.org

Al Viro <viro@zeniv.linux.org.uk> writes:

> On Wed, Feb 12, 2020 at 12:35:04PM -0800, Linus Torvalds wrote:
>> On Wed, Feb 12, 2020 at 12:03 PM Al Viro <viro@zeniv.linux.org.uk> wrote:
>> >
>> > What's to prevent racing with fs shutdown while you are doing the second part?
>> 
>> I was thinking that only the proc_flush_task() code would do this.
>> 
>> And that holds a ref to the vfsmount through upid->ns.
>> 
>> So I wasn't suggesting doing this in general - just splitting up the
>> implementation of d_invalidate() so that proc_flush_task_mnt() could
>> delay the complex part to after having traversed the RCU-protected
>> list.
>> 
>> But hey - I missed this part of the problem originally, so maybe I'm
>> just missing something else this time. Wouldn't be the first time.
>
> Wait, I thought the whole point of that had been to allow multiple
> procfs instances for the same userns?  Confused...

Multiple procfs instances for the same pidns.  Exactly.

Which would let people have their own set of procfs mount
options without having to worry about stomping on someone else.

The fundamental problem with multiple procfs instances per pidns
is there isn't an obvous place to put a vfs mount.


...


Which means we need some way to keep the file system from going away
while anyone in the kernel is running proc_flush_task.

One was I can see to solve this that would give us cheap readers, is to
have a percpu count of the number of processes in proc_flush_task.
That would work something like mnt_count.

Then forbid proc_kill_sb from removing any super block from the list
or otherwise making progress until the proc_flush_task_count goes
to zero.


f we wanted cheap readers and an expensive writer
kind of flag that proc_kill_sb can

Thinking out loud perhaps we have add a list_head on task_struct
and a list_head in proc_inode.  That would let us find the inodes
and by extention the dentries we care about quickly.

Then in evict_inode we could remove the proc_inode from the list.


Eric


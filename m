Return-Path: <SRS0=K+Eq=4I=vger.kernel.org=linux-api-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 763FAC11D00
	for <linux-api@archiver.kernel.org>; Thu, 20 Feb 2020 23:39:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 48CDA208CD
	for <linux-api@archiver.kernel.org>; Thu, 20 Feb 2020 23:39:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729306AbgBTXjr (ORCPT <rfc822;linux-api@archiver.kernel.org>);
        Thu, 20 Feb 2020 18:39:47 -0500
Received: from out01.mta.xmission.com ([166.70.13.231]:43782 "EHLO
        out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727135AbgBTXjr (ORCPT
        <rfc822;linux-api@vger.kernel.org>); Thu, 20 Feb 2020 18:39:47 -0500
Received: from in02.mta.xmission.com ([166.70.13.52])
        by out01.mta.xmission.com with esmtps (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.90_1)
        (envelope-from <ebiederm@xmission.com>)
        id 1j4vQ1-0006zU-4k; Thu, 20 Feb 2020 16:39:45 -0700
Received: from ip68-227-160-95.om.om.cox.net ([68.227.160.95] helo=x220.xmission.com)
        by in02.mta.xmission.com with esmtpsa (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.87)
        (envelope-from <ebiederm@xmission.com>)
        id 1j4vQ0-0006jR-EQ; Thu, 20 Feb 2020 16:39:44 -0700
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
References: <20200212200335.GO23230@ZenIV.linux.org.uk>
        <CAHk-=wi+1CPShMFvJNPfnrJ8DD8uVKUOQ5TQzQUNGLUkeoahkg@mail.gmail.com>
        <20200212203833.GQ23230@ZenIV.linux.org.uk>
        <20200212204124.GR23230@ZenIV.linux.org.uk>
        <CAHk-=wi5FOGV_3tALK3n6E2fK3Oa_yCYkYQtCSaXLSEm2DUCKg@mail.gmail.com>
        <87lfp7h422.fsf@x220.int.ebiederm.org>
        <CAHk-=wgmn9Qds0VznyphouSZW6e42GWDT5H1dpZg8pyGDGN+=w@mail.gmail.com>
        <87pnejf6fz.fsf@x220.int.ebiederm.org>
        <871rqpaswu.fsf_-_@x220.int.ebiederm.org>
        <CAHk-=whX7UmXgCKPPvjyQFqBiKw-Zsgj22_rH8epDPoWswAnLA@mail.gmail.com>
        <20200220230758.GT23230@ZenIV.linux.org.uk>
Date:   Thu, 20 Feb 2020 17:37:44 -0600
In-Reply-To: <20200220230758.GT23230@ZenIV.linux.org.uk> (Al Viro's message of
        "Thu, 20 Feb 2020 23:07:58 +0000")
Message-ID: <87mu9c7ruf.fsf@x220.int.ebiederm.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-SPF: eid=1j4vQ0-0006jR-EQ;;;mid=<87mu9c7ruf.fsf@x220.int.ebiederm.org>;;;hst=in02.mta.xmission.com;;;ip=68.227.160.95;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX18cMc7gMcKxQtdSwR/g1EJXnhEFC3gu5r8=
X-SA-Exim-Connect-IP: 68.227.160.95
X-SA-Exim-Mail-From: ebiederm@xmission.com
Subject: Re: [PATCH 0/7] proc: Dentry flushing without proc_mnt
X-SA-Exim-Version: 4.2.1 (built Thu, 05 May 2016 13:38:54 -0600)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-api-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-api.vger.kernel.org>
X-Mailing-List: linux-api@vger.kernel.org

Al Viro <viro@zeniv.linux.org.uk> writes:

> On Thu, Feb 20, 2020 at 03:02:22PM -0800, Linus Torvalds wrote:
>> On Thu, Feb 20, 2020 at 12:48 PM Eric W. Biederman
>> <ebiederm@xmission.com> wrote:
>> >
>> > Linus, does this approach look like something you can stand?
>> 
>> A couple of worries, although one of them seem to have already been
>> resolved by Al.
>> 
>> I think the real gatekeeper should be Al in general.  But other than
>> the small comments I had, I think this might work just fine.
>> 
>> Al?
>
> I'll need to finish RTFS there; I have initially misread that patch,
> actually - Eric _is_ using that thing both for those directories
> and for sysctl inodes.  And the prototype for that machinery (the
> one he'd pulled from proc_sysctl.c) is playing with pinning superblocks
> way too much; for per-pid directories that's not an issue, but
> for sysctl table removal you are very likely to hit a bunch of
> evictees on the same superblock...

I saw that was possible.  If the broad strokes look correct I don't have
a problem at all with optimizing for the case where many of the entries
are for inodes on the same superblock.  I just had enough other details
on my mind I was afraid if I got a little more clever I would have
introduced a typo somewhere.


I wish I could limit the sysctl parts to just directories, but
unfortunately the sysctl tables don't always give a guarantee that a
directory is what will be removed.  But sysctls do have one name per
inode invarant like fat.  There is no way to express a sysctl
table that doesn't have that invariant.

As for d_find_alias/d_invalidate.

Just for completeness I wanted to write a loop:

	while (dentry = d_find_alias(inode)) {
        	d_invalidate(dentry);
                dput(dentry);
        }

Unfortunately that breaks on directories, because for directories
d_find_alias turns into d_find_any_alias, and continues to return aliases
even when they are unhashed.

It might be nice to write a cousin of d_prune_aliases call
it d_invalidate_aliases that just does that loop the correct way
in dcache.c

Eric

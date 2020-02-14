Return-Path: <SRS0=Hu9T=4C=vger.kernel.org=linux-api-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2DAF8C35242
	for <linux-api@archiver.kernel.org>; Fri, 14 Feb 2020 05:36:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id EBE67217F4
	for <linux-api@archiver.kernel.org>; Fri, 14 Feb 2020 05:36:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726092AbgBNFgO (ORCPT <rfc822;linux-api@archiver.kernel.org>);
        Fri, 14 Feb 2020 00:36:14 -0500
Received: from out03.mta.xmission.com ([166.70.13.233]:40568 "EHLO
        out03.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725975AbgBNFgO (ORCPT
        <rfc822;linux-api@vger.kernel.org>); Fri, 14 Feb 2020 00:36:14 -0500
X-Greylist: delayed 6310 seconds by postgrey-1.27 at vger.kernel.org; Fri, 14 Feb 2020 00:36:13 EST
Received: from in01.mta.xmission.com ([166.70.13.51])
        by out03.mta.xmission.com with esmtps (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.90_1)
        (envelope-from <ebiederm@xmission.com>)
        id 1j2S0H-0007eG-Fg; Thu, 13 Feb 2020 20:50:57 -0700
Received: from ip68-227-160-95.om.om.cox.net ([68.227.160.95] helo=x220.xmission.com)
        by in01.mta.xmission.com with esmtpsa (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.87)
        (envelope-from <ebiederm@xmission.com>)
        id 1j2S04-0006sC-0X; Thu, 13 Feb 2020 20:50:57 -0700
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
References: <87v9obipk9.fsf@x220.int.ebiederm.org>
        <CAHk-=wgwmu4jpmOqW0+Lz0dcem1Fub=ThLHvmLobf_WqCq7bwg@mail.gmail.com>
        <20200212200335.GO23230@ZenIV.linux.org.uk>
        <CAHk-=wi+1CPShMFvJNPfnrJ8DD8uVKUOQ5TQzQUNGLUkeoahkg@mail.gmail.com>
        <20200212203833.GQ23230@ZenIV.linux.org.uk>
        <20200212204124.GR23230@ZenIV.linux.org.uk>
        <CAHk-=wi5FOGV_3tALK3n6E2fK3Oa_yCYkYQtCSaXLSEm2DUCKg@mail.gmail.com>
        <87lfp7h422.fsf@x220.int.ebiederm.org>
        <CAHk-=wgmn9Qds0VznyphouSZW6e42GWDT5H1dpZg8pyGDGN+=w@mail.gmail.com>
        <87pnejf6fz.fsf@x220.int.ebiederm.org>
        <20200213055527.GS23230@ZenIV.linux.org.uk>
Date:   Thu, 13 Feb 2020 21:48:48 -0600
In-Reply-To: <20200213055527.GS23230@ZenIV.linux.org.uk> (Al Viro's message of
        "Thu, 13 Feb 2020 05:55:27 +0000")
Message-ID: <87tv3tde1r.fsf@x220.int.ebiederm.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-SPF: eid=1j2S04-0006sC-0X;;;mid=<87tv3tde1r.fsf@x220.int.ebiederm.org>;;;hst=in01.mta.xmission.com;;;ip=68.227.160.95;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX1/1dFI6wvja0DiTAq8ebep58YMngTYQfmY=
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

> On Wed, Feb 12, 2020 at 10:37:52PM -0600, Eric W. Biederman wrote:
>
>> I think I have an alternate idea that could work.  Add some extra code
>> into proc_task_readdir, that would look for dentries that no longer
>> point to tasks and d_invalidate them.  With the same logic probably
>> being called from a few more places as well like proc_pid_readdir,
>> proc_task_lookup, and proc_pid_lookup.
>> 
>> We could even optimize it and have a process died flag we set in the
>> superblock.
>> 
>> That would would batch up the freeing work until the next time someone
>> reads from proc in a way that would create more dentries.  So it would
>> prevent dentries from reaped zombies from growing without bound.
>> 
>> Hmm.  Given the existence of proc_fill_cache it would really be a good
>> idea if readdir and lookup performed some of the freeing work as well.
>> As on readdir we always populate the dcache for all of the directory
>> entries.
>
> First of all, that won't do a damn thing when nobody is accessing
> given superblock.  What's more, readdir in root of that procfs instance
> is not enough - you need it in task/ of group leader.

It should give a rough bound on the number of stale dentries a
superblock can have.  The same basic concept has been used very
successfully in many incremental garbage collectors.  In those malloc
(or the equivalent) does a finite amount of garbage collection work to
roughly balance out the amount of memory allocated.  I am proposing
something similar for proc instances.

Further if no one is accessing a superblock we don't have a problem
either.


> What I don't understand is the insistence on getting those dentries
> via dcache lookups.  _IF_ we are willing to live with cacheline
> contention (on ->d_lock of root dentry, if nothing else), why not
> do the following:

No insistence from this side.

I was not seeing atomic_inc_not_zero(sb->s_active) from rcu
context as option earlier.  But it is an option.

> 	* put all dentries of such directories ([0-9]* and [0-9]*/task/*)
> into a list anchored in task_struct; have non-counting reference to
> task_struct stored in them (might simplify part of get_proc_task() users,
> BTW - avoids pid-to-task_struct lookups if we have a dentry and not just
> the inode; many callers do)
> 	* have ->d_release() remove from it (protecting per-task_struct lock
> nested outside of all ->d_lock)
> 	* on exit:
> 	lock the (per-task_struct) list
> 	while list is non-empty
> 		pick the first dentry
> 		remove from the list
> 		sb = dentry->d_sb
> 		try to bump sb->s_active (if non-zero, that is).
> 		if failed
> 			continue // move on to the next one - nothing to do here
> 		grab ->d_lock
> 		res = handle_it(dentry, &temp_list)
> 		drop ->d_lock
> 		unlock the list
> 		if (!list_empty(&temp_list))
> 			shrink_dentry_list(&temp_list)
> 		if (res)
> 			d_invalidate(dentry)
> 			dput(dentry)
> 		deactivate_super(sb)
> 		lock the list
> 	unlock the list
>
> handle_it(dentry, temp_list) // ->d_lock held; that one should be in dcache.c
> 	if ->d_count is negative // unlikely
> 		return 0;
> 	if ->d_count is positive,
> 		increment ->d_count
> 		return 1;
> 	// OK, it's still alive, but ->d_count is 0
> 	__d_drop	// equivalent of d_invalidate in this case
> 	if not on a shrink list // otherwise it's not our headache
> 		if on lru list
> 			d_lru_del
> 		d_shrink_add dentry to temp_list
> 	return 0;
>
> And yeah, that'll dirty ->s_active for each procfs superblock that
> has dentry for our process present in dcache.  On exit()...


I would thread the whole thing through the proc_inode instead of coming
up with a new allocation per dentry so an extra memory allocation isn't
needed.  We already have i_dentry.  So going from the vfs_inode to
the dentry is trivial.



But truthfully I don't like proc_flush_task.

The problem is that proc_flush_task is a layering violation and magic
code that pretty much no one understands.  We have some very weird
cases where dput or d_invalidate wound up triggering ext3 code.  It has
been fixed for a long time now, but it wasy crazy weird unexpected
stuff.


Al your logic above just feels very clever, and like many pieces of the
kernel have to know how other pieces of the kernel work.  If we can find
something stupid and simple that also solves the problem I would be much
happier.   Than anyone could understand and fix it if something goes
wrong.

Eric







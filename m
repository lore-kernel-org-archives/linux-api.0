Return-Path: <SRS0=tdOb=4B=vger.kernel.org=linux-api-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 58B04C352A3
	for <linux-api@archiver.kernel.org>; Thu, 13 Feb 2020 04:39:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2FD4B206D7
	for <linux-api@archiver.kernel.org>; Thu, 13 Feb 2020 04:39:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729487AbgBMEjw (ORCPT <rfc822;linux-api@archiver.kernel.org>);
        Wed, 12 Feb 2020 23:39:52 -0500
Received: from out02.mta.xmission.com ([166.70.13.232]:49932 "EHLO
        out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727076AbgBMEjv (ORCPT
        <rfc822;linux-api@vger.kernel.org>); Wed, 12 Feb 2020 23:39:51 -0500
Received: from in01.mta.xmission.com ([166.70.13.51])
        by out02.mta.xmission.com with esmtps (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.90_1)
        (envelope-from <ebiederm@xmission.com>)
        id 1j26Hz-0000O1-MU; Wed, 12 Feb 2020 21:39:47 -0700
Received: from ip68-227-160-95.om.om.cox.net ([68.227.160.95] helo=x220.xmission.com)
        by in01.mta.xmission.com with esmtpsa (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.87)
        (envelope-from <ebiederm@xmission.com>)
        id 1j26Hy-0006WH-VI; Wed, 12 Feb 2020 21:39:47 -0700
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
Date:   Wed, 12 Feb 2020 22:37:52 -0600
In-Reply-To: <CAHk-=wgmn9Qds0VznyphouSZW6e42GWDT5H1dpZg8pyGDGN+=w@mail.gmail.com>
        (Linus Torvalds's message of "Wed, 12 Feb 2020 16:48:14 -0800")
Message-ID: <87pnejf6fz.fsf@x220.int.ebiederm.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-SPF: eid=1j26Hy-0006WH-VI;;;mid=<87pnejf6fz.fsf@x220.int.ebiederm.org>;;;hst=in01.mta.xmission.com;;;ip=68.227.160.95;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX184mp0tBu1N+5TIPW3et7RBWpPrbgy8SaE=
X-SA-Exim-Connect-IP: 68.227.160.95
X-SA-Exim-Mail-From: ebiederm@xmission.com
Subject: Re: [PATCH v8 07/11] proc: flush task dcache entries from all procfs instances
X-SA-Exim-Version: 4.2.1 (built Thu, 05 May 2016 13:38:54 -0600)
X-SA-Exim-Scanned: Yes (on in01.mta.xmission.com)
Sender: linux-api-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-api.vger.kernel.org>
X-Mailing-List: linux-api@vger.kernel.org

Linus Torvalds <torvalds@linux-foundation.org> writes:

> On Wed, Feb 12, 2020 at 1:48 PM Eric W. Biederman <ebiederm@xmission.com> wrote:
>>
>> The good news is proc_flush_task isn't exactly called from process exit.
>> proc_flush_task is called during zombie clean up. AKA release_task.
>
> Yeah, that at least avoids some of the nasty locking while dying debug problems.
>
> But the one I was more worried about was actually the lock contention
> issue with lots of processes. The lock is basically a single global
> lock in many situations - yes, it's technically per-ns, but in a lot
> of cases you really only have one namespace anyway.
>
> And we've had problems with global locks in this area before, notably
> the one you call out:
>
>> Further after proc_flush_task does it's thing the code goes
>> and does "write_lock_irq(&task_list_lock);"
>
> Yeah, so it's not introducing a new issue, but it is potentially
> making something we already know is bad even worse.
>
>> What would be downside of having a mutex for a list of proc superblocks?
>> A mutex that is taken for both reading and writing the list.
>
> That's what the original patch actually was, and I was hoping we could
> avoid that thing.
>
> An rwsem would be possibly better, since most cases by far are likely
> about reading.
>
> And yes, I'm very aware of the task_list_lock, but it's literally why
> I don't want to make a new one.
>
> I'm _hoping_ we can some day come up with something better than
> task_list_lock.

Yes.  I understand that.

I occassionally play with ideas, and converted all of proc to rcu
to help with situation but I haven't come up with anything clearly
better.


All of this is why I was really hoping we could have a change in
strategy and see if we can make the shrinker be able to better prune
proc inodes.



I think I have an alternate idea that could work.  Add some extra code
into proc_task_readdir, that would look for dentries that no longer
point to tasks and d_invalidate them.  With the same logic probably
being called from a few more places as well like proc_pid_readdir,
proc_task_lookup, and proc_pid_lookup.

We could even optimize it and have a process died flag we set in the
superblock.

That would would batch up the freeing work until the next time someone
reads from proc in a way that would create more dentries.  So it would
prevent dentries from reaped zombies from growing without bound.

Hmm.  Given the existence of proc_fill_cache it would really be a good
idea if readdir and lookup performed some of the freeing work as well.
As on readdir we always populate the dcache for all of the directory
entries.

I am booked solid for the next little while but if no one beats me to it
I will try and code something like that up where at least readdir
looks for and invalidates stale dentries.

Eric

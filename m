Return-Path: <SRS0=K+Eq=4I=vger.kernel.org=linux-api-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1987BC11D00
	for <linux-api@archiver.kernel.org>; Thu, 20 Feb 2020 23:41:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E9F06208CD
	for <linux-api@archiver.kernel.org>; Thu, 20 Feb 2020 23:41:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729347AbgBTXlR (ORCPT <rfc822;linux-api@archiver.kernel.org>);
        Thu, 20 Feb 2020 18:41:17 -0500
Received: from out02.mta.xmission.com ([166.70.13.232]:38500 "EHLO
        out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729234AbgBTXlR (ORCPT
        <rfc822;linux-api@vger.kernel.org>); Thu, 20 Feb 2020 18:41:17 -0500
Received: from in01.mta.xmission.com ([166.70.13.51])
        by out02.mta.xmission.com with esmtps (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.90_1)
        (envelope-from <ebiederm@xmission.com>)
        id 1j4vRT-0002Tu-CA; Thu, 20 Feb 2020 16:41:15 -0700
Received: from ip68-227-160-95.om.om.cox.net ([68.227.160.95] helo=x220.xmission.com)
        by in01.mta.xmission.com with esmtpsa (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.87)
        (envelope-from <ebiederm@xmission.com>)
        id 1j4vRS-0003Oz-LG; Thu, 20 Feb 2020 16:41:15 -0700
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
References: <CAHk-=wi+1CPShMFvJNPfnrJ8DD8uVKUOQ5TQzQUNGLUkeoahkg@mail.gmail.com>
        <20200212203833.GQ23230@ZenIV.linux.org.uk>
        <20200212204124.GR23230@ZenIV.linux.org.uk>
        <CAHk-=wi5FOGV_3tALK3n6E2fK3Oa_yCYkYQtCSaXLSEm2DUCKg@mail.gmail.com>
        <87lfp7h422.fsf@x220.int.ebiederm.org>
        <CAHk-=wgmn9Qds0VznyphouSZW6e42GWDT5H1dpZg8pyGDGN+=w@mail.gmail.com>
        <87pnejf6fz.fsf@x220.int.ebiederm.org>
        <871rqpaswu.fsf_-_@x220.int.ebiederm.org>
        <87blpt9e6m.fsf_-_@x220.int.ebiederm.org>
        <20200220225420.GR23230@ZenIV.linux.org.uk>
        <20200220230309.GS23230@ZenIV.linux.org.uk>
Date:   Thu, 20 Feb 2020 17:39:14 -0600
In-Reply-To: <20200220230309.GS23230@ZenIV.linux.org.uk> (Al Viro's message of
        "Thu, 20 Feb 2020 23:03:09 +0000")
Message-ID: <87blps7rrx.fsf@x220.int.ebiederm.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-SPF: eid=1j4vRS-0003Oz-LG;;;mid=<87blps7rrx.fsf@x220.int.ebiederm.org>;;;hst=in01.mta.xmission.com;;;ip=68.227.160.95;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX19OdZjKNTBNxrAmd9oO+cyfw3wUEl55Vpc=
X-SA-Exim-Connect-IP: 68.227.160.95
X-SA-Exim-Mail-From: ebiederm@xmission.com
Subject: Re: [PATCH 4/7] proc: Use d_invalidate in proc_prune_siblings_dcache
X-SA-Exim-Version: 4.2.1 (built Thu, 05 May 2016 13:38:54 -0600)
X-SA-Exim-Scanned: Yes (on in01.mta.xmission.com)
Sender: linux-api-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-api.vger.kernel.org>
X-Mailing-List: linux-api@vger.kernel.org

Al Viro <viro@zeniv.linux.org.uk> writes:

> On Thu, Feb 20, 2020 at 10:54:20PM +0000, Al Viro wrote:
>> On Thu, Feb 20, 2020 at 02:49:53PM -0600, Eric W. Biederman wrote:
>> > 
>> > The function d_prune_aliases has the problem that it will only prune
>> > aliases thare are completely unused.  It will not remove aliases for
>> > the dcache or even think of removing mounts from the dcache.  For that
>> > behavior d_invalidate is needed.
>> > 
>> > To use d_invalidate replace d_prune_aliases with d_find_alias
>> > followed by d_invalidate and dput.  This is safe and complete
>> > because no inode in proc has any hardlinks or aliases.
>> 
>> s/no inode.*/it's a fucking directory inode./
>
> Wait... You are using it for sysctls as well?  Ho-hum...  The thing is,
> for sysctls you are likely to run into consequent entries with the
> same superblock, making for a big pile of useless playing with
> ->s_active...  And yes, that applied to mainline as well

Which is why I worked to merge the two cases since they were so close.
Fewer things to fix and more eyeballs on the code.

Eric



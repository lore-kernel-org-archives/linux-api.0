Return-Path: <linux-api-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3A42BC433F5
	for <linux-api@archiver.kernel.org>; Fri,  5 Nov 2021 16:38:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2357D61037
	for <linux-api@archiver.kernel.org>; Fri,  5 Nov 2021 16:38:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232990AbhKEQlI (ORCPT <rfc822;linux-api@archiver.kernel.org>);
        Fri, 5 Nov 2021 12:41:08 -0400
Received: from out01.mta.xmission.com ([166.70.13.231]:58662 "EHLO
        out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233366AbhKEQlH (ORCPT
        <rfc822;linux-api@vger.kernel.org>); Fri, 5 Nov 2021 12:41:07 -0400
Received: from in01.mta.xmission.com ([166.70.13.51]:42698)
        by out01.mta.xmission.com with esmtps  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.93)
        (envelope-from <ebiederm@xmission.com>)
        id 1mj2ET-0040wi-Cl; Fri, 05 Nov 2021 10:38:25 -0600
Received: from ip68-227-160-95.om.om.cox.net ([68.227.160.95]:47856 helo=email.xmission.com)
        by in01.mta.xmission.com with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.93)
        (envelope-from <ebiederm@xmission.com>)
        id 1mj2ER-005uAo-CI; Fri, 05 Nov 2021 10:38:24 -0600
From:   ebiederm@xmission.com (Eric W. Biederman)
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Oleg Nesterov <oleg@redhat.com>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Kees Cook <keescook@chromium.org>,
        Linux API <linux-api@vger.kernel.org>
References: <878ry512iv.fsf@disp2133>
        <CAHk-=wivLcb3ELGSf=fM0u=PxP5m1=jRrVXDOr0+QJZRZggaHg@mail.gmail.com>
Date:   Fri, 05 Nov 2021 11:37:55 -0500
In-Reply-To: <CAHk-=wivLcb3ELGSf=fM0u=PxP5m1=jRrVXDOr0+QJZRZggaHg@mail.gmail.com>
        (Linus Torvalds's message of "Wed, 3 Nov 2021 12:34:44 -0700")
Message-ID: <871r3uy2vw.fsf@disp2133>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-SPF: eid=1mj2ER-005uAo-CI;;;mid=<871r3uy2vw.fsf@disp2133>;;;hst=in01.mta.xmission.com;;;ip=68.227.160.95;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX19VqaJj8/S8xVQx26R9tPAt2wUIi1RqVro=
X-SA-Exim-Connect-IP: 68.227.160.95
X-SA-Exim-Mail-From: ebiederm@xmission.com
Subject: Re: [GIT PULL] per signal_struct coredumps
X-SA-Exim-Version: 4.2.1 (built Sat, 08 Feb 2020 21:53:50 +0000)
X-SA-Exim-Scanned: Yes (on in01.mta.xmission.com)
Precedence: bulk
List-ID: <linux-api.vger.kernel.org>
X-Mailing-List: linux-api@vger.kernel.org

Linus Torvalds <torvalds@linux-foundation.org> writes:

> On Wed, Nov 3, 2021 at 12:07 PM Eric W. Biederman <ebiederm@xmission.com> wrote:
>>
>> Please pull the per_signal_struct_coredumps-for-v5.16 branch
>
> I've pulled it, but I'm not convinced about that odd extra merge
> commit that contains the commentary.
>
> That's what signed tags are for, and they have that explanation that
> then makes it into the merge - plus they have the crypto signature to
> show it all comes from you.
>
> So that would have been the much better model than a fake extra merge.
>
> But at least that extra merge did have explanations, so at least it
> doesn't trigger me on _that_ level.

I have been creating those when I place a patchset with an interesting
cover letter in a branch.  Now with the entire branch being just that
patchset, it doesn't make a lot of sense (except as somewhere to store
that cover letter so I don't loose it).  At other times when there are
multiple sets of changes on a single branch I think it makes more sense.

Am I missing a better way to preserve the cover letter for the
changes when multiple sets of changes land in a single branch?

Eric

Return-Path: <linux-api-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A0C6BC5517A
	for <linux-api@archiver.kernel.org>; Tue, 10 Nov 2020 15:38:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5AB932068D
	for <linux-api@archiver.kernel.org>; Tue, 10 Nov 2020 15:38:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732628AbgKJPir (ORCPT <rfc822;linux-api@archiver.kernel.org>);
        Tue, 10 Nov 2020 10:38:47 -0500
Received: from out01.mta.xmission.com ([166.70.13.231]:44394 "EHLO
        out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732625AbgKJPir (ORCPT
        <rfc822;linux-api@vger.kernel.org>); Tue, 10 Nov 2020 10:38:47 -0500
Received: from in01.mta.xmission.com ([166.70.13.51])
        by out01.mta.xmission.com with esmtps  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
        (Exim 4.93)
        (envelope-from <ebiederm@xmission.com>)
        id 1kcVjJ-001ycA-0Y; Tue, 10 Nov 2020 08:38:45 -0700
Received: from ip68-227-160-95.om.om.cox.net ([68.227.160.95] helo=x220.xmission.com)
        by in01.mta.xmission.com with esmtpsa (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.87)
        (envelope-from <ebiederm@xmission.com>)
        id 1kcVjI-0006WK-0f; Tue, 10 Nov 2020 08:38:44 -0700
From:   ebiederm@xmission.com (Eric W. Biederman)
To:     Peter Collingbourne <pcc@google.com>
Cc:     Catalin Marinas <catalin.marinas@arm.com>,
        Evgenii Stepanov <eugenis@google.com>,
        Kostya Serebryany <kcc@google.com>,
        Vincenzo Frascino <vincenzo.frascino@arm.com>,
        Dave Martin <Dave.Martin@arm.com>,
        Will Deacon <will@kernel.org>, Oleg Nesterov <oleg@redhat.com>,
        "James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>,
        Linux ARM <linux-arm-kernel@lists.infradead.org>,
        Kevin Brodsky <kevin.brodsky@arm.com>,
        Andrey Konovalov <andreyknvl@google.com>,
        Richard Henderson <rth@twiddle.net>,
        Linux API <linux-api@vger.kernel.org>,
        Helge Deller <deller@gmx.de>,
        David Spickett <david.spickett@linaro.org>
References: <cover.1604523707.git.pcc@google.com>
        <4d826a62121153d54d7e36fc8a402c97e2106764.1604523707.git.pcc@google.com>
        <87lffa11sa.fsf@x220.int.ebiederm.org>
        <CAMn1gO63+7ZxcvSyHt1nrTQ+N=zk=xGYNiToRxwRcP5=UsQmsQ@mail.gmail.com>
Date:   Tue, 10 Nov 2020 09:38:34 -0600
In-Reply-To: <CAMn1gO63+7ZxcvSyHt1nrTQ+N=zk=xGYNiToRxwRcP5=UsQmsQ@mail.gmail.com>
        (Peter Collingbourne's message of "Mon, 9 Nov 2020 18:37:36 -0800")
Message-ID: <875z6dte6d.fsf@x220.int.ebiederm.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-SPF: eid=1kcVjI-0006WK-0f;;;mid=<875z6dte6d.fsf@x220.int.ebiederm.org>;;;hst=in01.mta.xmission.com;;;ip=68.227.160.95;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX1/qYS2D7zgHzmBolnqloWRSVcj8hZZqxIo=
X-SA-Exim-Connect-IP: 68.227.160.95
X-SA-Exim-Mail-From: ebiederm@xmission.com
Subject: Re: [PATCH v14 4/8] signal: deduplicate code dealing with common _sigfault fields
X-SA-Exim-Version: 4.2.1 (built Thu, 05 May 2016 13:38:54 -0600)
X-SA-Exim-Scanned: Yes (on in01.mta.xmission.com)
Precedence: bulk
List-ID: <linux-api.vger.kernel.org>
X-Mailing-List: linux-api@vger.kernel.org

Peter Collingbourne <pcc@google.com> writes:

> On Mon, Nov 9, 2020 at 4:41 PM Eric W. Biederman <ebiederm@xmission.com> wrote:
>>
>> Peter Collingbourne <pcc@google.com> writes:
>>
>> > We're about to add more common _sigfault fields, so deduplicate the
>> > existing code for initializing _sigfault fields in {send,force}_sig_*,
>> > and for copying _sigfault fields in copy_siginfo_to_external32 and
>> > post_copy_siginfo_from_user32, to reduce the number of places that
>> > will need to be updated by upcoming changes.
>>
>> Acked-by: "Eric W. Biederman" <ebiederm@xmission.com>
>
> Thanks for the review.
>
>> No real objection but I am wondering if it might be better to
>> introduce two small inline functions for setting common fields
>> instead of:
>>
>> > +     if (siginfo_layout_is_fault(layout)) {
>> > +             to->si_addr = ptr_to_compat(from->si_addr);
>> > +#ifdef __ARCH_SI_TRAPNO
>> > +             to->si_trapno = from->si_trapno;
>> > +#endif
>> > +     }
>>
>> and
>>
>> > +     if (siginfo_layout_is_fault(layout)) {
>> > +             to->si_addr = compat_ptr(from->si_addr);
>> > +#ifdef __ARCH_SI_TRAPNO
>> > +             to->si_trapno = from->si_trapno;
>> > +#endif
>> > +     }
>>
>> perhaps called:
>> copy_sigfault_common_to_external32
>> post_copy_sigfault_common_from_user32
>>
>> I have not benchmarked or anything but my gut says one less conditional
>> branch to worry about makes dealing with spectre easier and probably
>> produces faster code as well.  Possibly even smaller code.
>
> Dave made the same proposal on an earlier version of the patch which I
> responded to in [1]. The main reason for keeping things as I
> implemented them was because of the ptrace handling but if we do end
> up dropping that as you proposed on the other patch then I think I'd
> be happy to move the code into helper functions.
>
> Peter
>
> [1] https://lore.kernel.org/linux-parisc/CAMn1gO42arQKGBj1Nnbs86TGYyogpRR_t73H=GbTmQrbAbV30A@mail.gmail.com/

That makes sense.

Eric

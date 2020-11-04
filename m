Return-Path: <SRS0=tld+=EK=vger.kernel.org=linux-api-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EE5D5C2D0A3
	for <linux-api@archiver.kernel.org>; Wed,  4 Nov 2020 17:36:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B339420759
	for <linux-api@archiver.kernel.org>; Wed,  4 Nov 2020 17:36:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731660AbgKDRgW (ORCPT <rfc822;linux-api@archiver.kernel.org>);
        Wed, 4 Nov 2020 12:36:22 -0500
Received: from out03.mta.xmission.com ([166.70.13.233]:45744 "EHLO
        out03.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730254AbgKDRgV (ORCPT
        <rfc822;linux-api@vger.kernel.org>); Wed, 4 Nov 2020 12:36:21 -0500
Received: from in01.mta.xmission.com ([166.70.13.51])
        by out03.mta.xmission.com with esmtps  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
        (Exim 4.93)
        (envelope-from <ebiederm@xmission.com>)
        id 1kaMhi-00APEI-C1; Wed, 04 Nov 2020 10:36:14 -0700
Received: from ip68-227-160-95.om.om.cox.net ([68.227.160.95] helo=x220.xmission.com)
        by in01.mta.xmission.com with esmtpsa (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.87)
        (envelope-from <ebiederm@xmission.com>)
        id 1kaMhh-0005Qj-Ij; Wed, 04 Nov 2020 10:36:14 -0700
From:   ebiederm@xmission.com (Eric W. Biederman)
To:     Catalin Marinas <catalin.marinas@arm.com>
Cc:     Peter Collingbourne <pcc@google.com>,
        Evgenii Stepanov <eugenis@google.com>,
        Kostya Serebryany <kcc@google.com>,
        Vincenzo Frascino <vincenzo.frascino@arm.com>,
        Dave Martin <Dave.Martin@arm.com>,
        Will Deacon <will@kernel.org>, Oleg Nesterov <oleg@redhat.com>,
        "James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>,
        Linux ARM <linux-arm-kernel@lists.infradead.org>,
        Kevin Brodsky <kevin.brodsky@arm.com>,
        Andrey Konovalov <andreyknvl@google.com>,
        Richard Henderson <rth@twiddle.net>, linux-api@vger.kernel.org,
        Helge Deller <deller@gmx.de>,
        David Spickett <david.spickett@linaro.org>
References: <cover.1604376407.git.pcc@google.com>
        <7e26600459cb08c5016611b37fe88c23098b40eb.1604376407.git.pcc@google.com>
        <87a6vx6p11.fsf@x220.int.ebiederm.org> <20201104172447.GF28902@gaia>
Date:   Wed, 04 Nov 2020 11:36:10 -0600
In-Reply-To: <20201104172447.GF28902@gaia> (Catalin Marinas's message of "Wed,
        4 Nov 2020 17:24:48 +0000")
Message-ID: <87wnz158j9.fsf@x220.int.ebiederm.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-SPF: eid=1kaMhh-0005Qj-Ij;;;mid=<87wnz158j9.fsf@x220.int.ebiederm.org>;;;hst=in01.mta.xmission.com;;;ip=68.227.160.95;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX19wDmSuxLiGAq/37pZxeGaX+VODqDFxCx0=
X-SA-Exim-Connect-IP: 68.227.160.95
X-SA-Exim-Mail-From: ebiederm@xmission.com
Subject: Re: [PATCH v13 1/8] parisc: Drop parisc special case for __sighandler_t
X-SA-Exim-Version: 4.2.1 (built Thu, 05 May 2016 13:38:54 -0600)
X-SA-Exim-Scanned: Yes (on in01.mta.xmission.com)
Precedence: bulk
List-ID: <linux-api.vger.kernel.org>
X-Mailing-List: linux-api@vger.kernel.org

Catalin Marinas <catalin.marinas@arm.com> writes:

> On Wed, Nov 04, 2020 at 10:54:34AM -0600, Eric W. Biederman wrote:
>> Peter Collingbourne <pcc@google.com> writes:
>> > From: Helge Deller <deller@gmx.de>
>> >
>> > I believe we can and *should* drop this parisc-specific typedef for
>> > __sighandler_t when compiling a 64-bit kernel. The reasons:
>> >
>> > 1. We don't have a 64-bit userspace yet, so nothing (on userspace side)
>> > can break.
>> >
>> > 2. Inside the Linux kernel, this is only used in kernel/signal.c, in
>> > function kernel_sigaction() where the signal handler is compared against
>> > SIG_IGN.  SIG_IGN is defined as (__sighandler_t)1), so only the pointers
>> > are compared.
>> >
>> > 3. Even when a 64-bit userspace gets added at some point, I think
>> > __sighandler_t should be defined what it is: a function pointer struct.
>> >
>> > I compiled kernel/signal.c with and without the patch, and the produced code
>> > is identical in both cases.
>> >
>> > Signed-off-by: Helge Deller <deller@gmx.de>
>> > Reviewed-by: Peter Collingbourne <pcc@google.com>
>> > Link:
>> > https://linux-review.googlesource.com/id/I21c43f21b264f339e3aa395626af838646f62d97
>> 
>> Peter as you have sent this, this also needs your Signed-off-by.
>> 
>> Otherwise this looks reasonable to me.
>> Acked-by: "Eric W. Biederman" <ebiederm@xmission.com>
>> 
>> While the final bits look like they are still under discussion it looks
>> like the preceding cleanups are pretty solid at this point.
>
> Minor nits, unless you nak the whole approach of SA_FAULTFLAGS and
> SA_UNSUPPORTED ;) (it looks a bit complicated to me but I don't have a
> better idea for a generic implementation).
>
>> Any chance we can get the cleanups into a tree in linux-next so that
>> the discussion can focus on the core parts of this work?
>> 
>> Perhaps I should pick up the clenaups?
>
> However you prefer (I usually start queuing patches at -rc3). If you
> pick them up, please provide a stable branch somewhere so that we can
> add the others on top.

I just want to make certain the cleanups don't get lost in the shuffle.

If we are almost there then I will focus my energy on reviewing the
patches and make certain there isn't something important that has been
overlooked.  I don't expect there is.


Eric



Return-Path: <linux-api-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3B86BC2D0E4
	for <linux-api@archiver.kernel.org>; Mon, 23 Nov 2020 16:19:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E6A4E2080A
	for <linux-api@archiver.kernel.org>; Mon, 23 Nov 2020 16:19:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387415AbgKWQRt (ORCPT <rfc822;linux-api@archiver.kernel.org>);
        Mon, 23 Nov 2020 11:17:49 -0500
Received: from out01.mta.xmission.com ([166.70.13.231]:59876 "EHLO
        out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732638AbgKWQRt (ORCPT
        <rfc822;linux-api@vger.kernel.org>); Mon, 23 Nov 2020 11:17:49 -0500
Received: from in02.mta.xmission.com ([166.70.13.52])
        by out01.mta.xmission.com with esmtps  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.93)
        (envelope-from <ebiederm@xmission.com>)
        id 1khEXA-00AmYV-1A; Mon, 23 Nov 2020 09:17:44 -0700
Received: from ip68-227-160-95.om.om.cox.net ([68.227.160.95] helo=x220.xmission.com)
        by in02.mta.xmission.com with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.93)
        (envelope-from <ebiederm@xmission.com>)
        id 1khEX9-002ZCM-0A; Mon, 23 Nov 2020 09:17:43 -0700
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
        linux-api@vger.kernel.org, Helge Deller <deller@gmx.de>,
        David Spickett <david.spickett@linaro.org>
References: <13cf24d00ebdd8e1f55caf1821c7c29d54100191.1605904350.git.pcc@google.com>
        <87h7pj1ulp.fsf@x220.int.ebiederm.org> <20201123114935.GD17833@gaia>
        <87y2isysra.fsf@x220.int.ebiederm.org> <20201123155946.GA2438@gaia>
Date:   Mon, 23 Nov 2020 10:17:20 -0600
In-Reply-To: <20201123155946.GA2438@gaia> (Catalin Marinas's message of "Mon,
        23 Nov 2020 15:59:47 +0000")
Message-ID: <87sg90xd2n.fsf@x220.int.ebiederm.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-SPF: eid=1khEX9-002ZCM-0A;;;mid=<87sg90xd2n.fsf@x220.int.ebiederm.org>;;;hst=in02.mta.xmission.com;;;ip=68.227.160.95;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX18erZ+UCQJB7rNjNglNN5M3m5mrrnkIt5s=
X-SA-Exim-Connect-IP: 68.227.160.95
X-SA-Exim-Mail-From: ebiederm@xmission.com
Subject: Re: [PATCH v21 1/2] signal: define the SA_EXPOSE_TAGBITS bit in sa_flags
X-SA-Exim-Version: 4.2.1 (built Sat, 08 Feb 2020 21:53:50 +0000)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Precedence: bulk
List-ID: <linux-api.vger.kernel.org>
X-Mailing-List: linux-api@vger.kernel.org

Catalin Marinas <catalin.marinas@arm.com> writes:

> On Mon, Nov 23, 2020 at 09:53:13AM -0600, Eric W. Biederman wrote:
>> Catalin Marinas <catalin.marinas@arm.com> writes:
>> > On Fri, Nov 20, 2020 at 05:22:58PM -0600, Eric W. Biederman wrote:
>> >> Peter Collingbourne <pcc@google.com> writes:
>> >> > Architectures that support address tagging, such as arm64, may want to
>> >> > expose fault address tag bits to the signal handler to help diagnose
>> >> > memory errors. However, these bits have not been previously set,
>> >> > and their presence may confuse unaware user applications. Therefore,
>> >> > introduce a SA_EXPOSE_TAGBITS flag bit in sa_flags that a signal
>> >> > handler may use to explicitly request that the bits are set.
>> >> >
>> >> > The generic signal handler APIs expect to receive tagged addresses.
>> >> > Architectures may specify how to untag addresses in the case where
>> >> > SA_EXPOSE_TAGBITS is clear by defining the arch_untagged_si_addr
>> >> > function.
>> >> >
>> >> > Signed-off-by: Peter Collingbourne <pcc@google.com>
>> >> > Acked-by: "Eric W. Biederman" <ebiederm@xmission.com>
>> >> > Link: https://linux-review.googlesource.com/id/I16dd0ed2081f091fce97be0190cb8caa874c26cb
>> >> > ---
>> >> > To be applied on top of:
>> >> > https://git.kernel.org/pub/scm/linux/kernel/git/ebiederm/user-namespace.git signal-for-v5.11
>> >> 
>> >> I have merged this first patch into signal-for-v5.11 and pushed
>> >> everything out to linux-next.
>> >
>> > Thank you Eric. Assuming this branch won't be rebased, I'll apply the
>> > arm64 changes on top (well, if you rebase it, just let me know so that
>> > we don't end up with duplicate commits in mainline).
>> 
>> No.  I won't be rebasing it.  Not unless something serious problem shows
>> up, and at that point I will be more likely to apply a corrective change
>> on top that you can also grab.
>
> Thanks Eric. During the merging window, I'll probably wait for you to
> send the pull request first just to keep the arm64 diffstat simpler.
>
> BTW, did you mean to base them on v5.10-rc3-391-g9cfd9c45994b or just
> v5.10-rc3? It doesn't matter much as I'll generate the diffstat manually
> anyway in my pull request as I have different bases in other branches.

Crap.  How did that happen?  I thought for certain I had based them on
v5.10-rc3.  Some random git commit is not a good base.  I think the
better part of valor is to just admit I goofed and not rebase even now.

It it would make your life easier I will be happy to rebase (onto
v5.10-rc3?).  I just wanted to get these into my tree so that we could
incremetnally commit to the changes that makes sense and be certain not
to loose them.

Eric



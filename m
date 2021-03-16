Return-Path: <linux-api-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EF315C433E6
	for <linux-api@archiver.kernel.org>; Tue, 16 Mar 2021 11:53:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BD88E6504B
	for <linux-api@archiver.kernel.org>; Tue, 16 Mar 2021 11:53:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230158AbhCPLxG (ORCPT <rfc822;linux-api@archiver.kernel.org>);
        Tue, 16 Mar 2021 07:53:06 -0400
Received: from mx2.suse.de ([195.135.220.15]:58294 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229826AbhCPLww (ORCPT <rfc822;linux-api@vger.kernel.org>);
        Tue, 16 Mar 2021 07:52:52 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id B988CAE56;
        Tue, 16 Mar 2021 11:52:50 +0000 (UTC)
Date:   Tue, 16 Mar 2021 12:52:48 +0100
From:   Borislav Petkov <bp@suse.de>
To:     "Chang S. Bae" <chang.seok.bae@intel.com>
Cc:     tglx@linutronix.de, mingo@kernel.org, luto@kernel.org,
        x86@kernel.org, len.brown@intel.com, dave.hansen@intel.com,
        hjl.tools@gmail.com, Dave.Martin@arm.com, jannh@google.com,
        mpe@ellerman.id.au, carlos@redhat.com, tony.luck@intel.com,
        ravi.v.shankar@intel.com, libc-alpha@sourceware.org,
        linux-arch@vger.kernel.org, linux-api@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v7 5/6] x86/signal: Detect and prevent an alternate
 signal stack overflow
Message-ID: <20210316115248.GB18822@zn.tnic>
References: <20210316065215.23768-1-chang.seok.bae@intel.com>
 <20210316065215.23768-6-chang.seok.bae@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20210316065215.23768-6-chang.seok.bae@intel.com>
Precedence: bulk
List-ID: <linux-api.vger.kernel.org>
X-Mailing-List: linux-api@vger.kernel.org

On Mon, Mar 15, 2021 at 11:52:14PM -0700, Chang S. Bae wrote:
> @@ -272,7 +275,8 @@ get_sigframe(struct k_sigaction *ka, struct pt_regs *regs, size_t frame_size,
>  	 * If we are on the alternate signal stack and would overflow it, don't.
>  	 * Return an always-bogus address instead so we will die with SIGSEGV.
>  	 */
> -	if (onsigstack && !likely(on_sig_stack(sp)))
> +	if (onsigstack && unlikely(sp <= current->sas_ss_sp ||
> +				   sp - current->sas_ss_sp > current->sas_ss_size))
>  		return (void __user *)-1L;

So clearly I'm missing something because trying to trigger the test case
in the bugzilla:

https://bugzilla.kernel.org/show_bug.cgi?id=153531

on current tip/master doesn't work. Runs with MY_MINSIGSTKSZ under 2048
fail with:

tst-minsigstksz-2: sigaltstack: Cannot allocate memory

and above 2048 don't overwrite bytes below the stack.

So something else is missing. How did you test this patch?

Thx.

-- 
Regards/Gruss,
    Boris.

SUSE Software Solutions Germany GmbH, GF: Felix Imendörffer, HRB 36809, AG Nürnberg

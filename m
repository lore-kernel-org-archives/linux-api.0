Return-Path: <linux-api-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 69D6BC433E0
	for <linux-api@archiver.kernel.org>; Fri,  8 Jan 2021 18:08:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0490523A68
	for <linux-api@archiver.kernel.org>; Fri,  8 Jan 2021 18:08:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728442AbhAHSIS (ORCPT <rfc822;linux-api@archiver.kernel.org>);
        Fri, 8 Jan 2021 13:08:18 -0500
Received: from mx2.suse.de ([195.135.220.15]:56354 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727648AbhAHSIS (ORCPT <rfc822;linux-api@vger.kernel.org>);
        Fri, 8 Jan 2021 13:08:18 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id A12F2AD1E;
        Fri,  8 Jan 2021 18:07:36 +0000 (UTC)
Date:   Fri, 8 Jan 2021 19:07:23 +0100
From:   Borislav Petkov <bp@suse.de>
To:     "Chang S. Bae" <chang.seok.bae@intel.com>
Cc:     tglx@linutronix.de, mingo@kernel.org, luto@kernel.org,
        x86@kernel.org, len.brown@intel.com, dave.hansen@intel.com,
        hjl.tools@gmail.com, Dave.Martin@arm.com, jannh@google.com,
        mpe@ellerman.id.au, tony.luck@intel.com, ravi.v.shankar@intel.com,
        libc-alpha@sourceware.org, linux-arch@vger.kernel.org,
        linux-api@vger.kernel.org, linux-kernel@vger.kernel.org,
        Borislav Petkov <bp@alien8.de>, linux-kselftest@vger.kernel.org
Subject: Re: [PATCH v3 4/4] selftest/x86/signal: Include test cases for
 validating sigaltstack
Message-ID: <20210108180716.GA12995@zn.tnic>
References: <20201223015312.4882-1-chang.seok.bae@intel.com>
 <20201223015312.4882-5-chang.seok.bae@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20201223015312.4882-5-chang.seok.bae@intel.com>
Precedence: bulk
List-ID: <linux-api.vger.kernel.org>
X-Mailing-List: linux-api@vger.kernel.org

On Tue, Dec 22, 2020 at 05:53:12PM -0800, Chang S. Bae wrote:
> +static int setup_altstack(void *start, unsigned long size)
> +{
> +	stack_t ss;
> +
> +	memset(&ss, 0, sizeof(ss));
> +	ss.ss_size = size;
> +	ss.ss_sp = start;
> +
> +	return sigaltstack(&ss, NULL);
> +}
> +
> +static jmp_buf jmpbuf;
> +
> +static void sigsegv(int sig, siginfo_t *info, void *ctx_void)
> +{
> +	if (sigalrm_expected) {
> +		printf("[FAIL]\tSIGSEGV signal delivery is wrong.\n");

			 	"Wrong signal delivered: SIGSEGV (expected SIGALRM)."

> +		nerrs++;
> +	} else {
> +		printf("[OK]\tSIGSEGV signal is delivered.\n");

					s/is //

> +	}
> +
> +	siglongjmp(jmpbuf, 1);
> +}
> +
> +static void sigalrm(int sig, siginfo_t *info, void *ctx_void)
> +{
> +	if (!sigalrm_expected) {
> +		printf("[FAIL]\tSIGALRM sigal delivery is wrong.\n");

See above.

> +		nerrs++;
> +	} else {
> +		printf("[OK]\tSIGALRM signal is delivered.\n");

Ditto.

> +	}
> +}
> +
> +static void test_sigaltstack(void *altstack, unsigned long size)
> +{
> +	if (setup_altstack(altstack, size))
> +		err(1, "sigaltstack()");
> +
> +	sigalrm_expected = (size > at_minstack_size) ? true : false;
> +
> +	sethandler(SIGSEGV, sigsegv, 0);
> +	sethandler(SIGALRM, sigalrm, SA_ONSTACK);
> +
> +	if (sigsetjmp(jmpbuf, 1) == 0) {

	if (!sigsetjmp...)

> +		printf("[RUN]\tTest an (%s) alternate signal stack\n",

			"Test an alternate signal stack of %ssufficient size.\n"

> +		       sigalrm_expected ? "enough" : "too-small");

					 "" : "in");

> +		printf("\tRaise SIGALRM. %s is expected to be delivered.\n",
> +		       sigalrm_expected ? "It" : "But SIGSEGV");

					"It" : "SIGSEGV"

Drop "But".

Ask if something's not clear.

-- 
Regards/Gruss,
    Boris.

SUSE Software Solutions Germany GmbH, GF: Felix Imendörffer, HRB 36809, AG Nürnberg

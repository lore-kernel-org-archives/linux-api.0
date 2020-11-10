Return-Path: <linux-api-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-14.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8AF47C56201
	for <linux-api@archiver.kernel.org>; Tue, 10 Nov 2020 00:35:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 447F6207D3
	for <linux-api@archiver.kernel.org>; Tue, 10 Nov 2020 00:35:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729493AbgKJAft (ORCPT <rfc822;linux-api@archiver.kernel.org>);
        Mon, 9 Nov 2020 19:35:49 -0500
Received: from out02.mta.xmission.com ([166.70.13.232]:33478 "EHLO
        out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727311AbgKJAft (ORCPT
        <rfc822;linux-api@vger.kernel.org>); Mon, 9 Nov 2020 19:35:49 -0500
Received: from in01.mta.xmission.com ([166.70.13.51])
        by out02.mta.xmission.com with esmtps  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
        (Exim 4.93)
        (envelope-from <ebiederm@xmission.com>)
        id 1kcHdM-00GYZ3-4Z; Mon, 09 Nov 2020 17:35:40 -0700
Received: from ip68-227-160-95.om.om.cox.net ([68.227.160.95] helo=x220.xmission.com)
        by in01.mta.xmission.com with esmtpsa (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.87)
        (envelope-from <ebiederm@xmission.com>)
        id 1kcHdL-0003E3-0O; Mon, 09 Nov 2020 17:35:39 -0700
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
        Richard Henderson <rth@twiddle.net>, linux-api@vger.kernel.org,
        Helge Deller <deller@gmx.de>,
        David Spickett <david.spickett@linaro.org>
References: <cover.1604523707.git.pcc@google.com>
        <039adb228822eb1f0c90cbfc716fc28fa298c58e.1604523707.git.pcc@google.com>
Date:   Mon, 09 Nov 2020 18:35:30 -0600
In-Reply-To: <039adb228822eb1f0c90cbfc716fc28fa298c58e.1604523707.git.pcc@google.com>
        (Peter Collingbourne's message of "Wed, 4 Nov 2020 13:18:08 -0800")
Message-ID: <871rh22gml.fsf@x220.int.ebiederm.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-SPF: eid=1kcHdL-0003E3-0O;;;mid=<871rh22gml.fsf@x220.int.ebiederm.org>;;;hst=in01.mta.xmission.com;;;ip=68.227.160.95;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX19IeiFdJHKcCdmfQl9JzeTgiPv7LeNnlxQ=
X-SA-Exim-Connect-IP: 68.227.160.95
X-SA-Exim-Mail-From: ebiederm@xmission.com
Subject: Re: [PATCH v14 5/8] signal: clear non-uapi flag bits when passing/returning sa_flags
X-SA-Exim-Version: 4.2.1 (built Thu, 05 May 2016 13:38:54 -0600)
X-SA-Exim-Scanned: Yes (on in01.mta.xmission.com)
Precedence: bulk
List-ID: <linux-api.vger.kernel.org>
X-Mailing-List: linux-api@vger.kernel.org

Peter Collingbourne <pcc@google.com> writes:

2> Previously we were not clearing non-uapi flag bits in
> sigaction.sa_flags when storing the userspace-provided sa_flags or
> when returning them via oldact. Start doing so.
>
> This allows userspace to detect missing support for flag bits and
> allows the kernel to use non-uapi bits internally, as we are already
> doing in arch/x86 for two flag bits. Now that this change is in
> place, we no longer need the code in arch/x86 that was hiding these
> bits from userspace, so remove it.
>
> This is technically a userspace-visible behavior change for sigaction, as
> the unknown bits returned via oldact.sa_flags are no longer set. However,
> we are free to define the behavior for unknown bits exactly because
> their behavior is currently undefined, so for now we can define the
> meaning of each of them to be "clear the bit in oldact.sa_flags unless
> the bit becomes known in the future". Furthermore, this behavior is
> consistent with OpenBSD [1], illumos [2] and XNU [3] (FreeBSD [4] and
> NetBSD [5] fail the syscall if unknown bits are set). So there is some
> precedent for this behavior in other kernels, and in particular in XNU,
> which is probably the most popular kernel among those that I looked at,
> which means that this change is less likely to be a compatibility
> issue.

Acked-by: "Eric W. Biederman" <ebiederm@xmission.com>

Yes.  The x86_64 case and general good sense suggests that this patch
will be harmless.

I suspect we should at least try and take this one step farther
(with an additional patch) that causes an error if any new flags
are passed.  Or do we know of some userspace application that
currently passes bogus flags?



> Link: [1] https://github.com/openbsd/src/blob/f634a6a4b5bf832e9c1de77f7894ae2625e74484/sys/kern/kern_sig.c#L278
> Link: [2] https://github.com/illumos/illumos-gate/blob/76f19f5fdc974fe5be5c82a556e43a4df93f1de1/usr/src/uts/common/syscall/sigaction.c#L86
> Link: [3] https://github.com/apple/darwin-xnu/blob/a449c6a3b8014d9406c2ddbdc81795da24aa7443/bsd/kern/kern_sig.c#L480
> Link: [4] https://github.com/freebsd/freebsd/blob/eded70c37057857c6e23fae51f86b8f8f43cd2d0/sys/kern/kern_sig.c#L699
> Link: [5] https://github.com/NetBSD/src/blob/3365779becdcedfca206091a645a0e8e22b2946e/sys/kern/sys_sig.c#L473
> Signed-off-by: Peter Collingbourne <pcc@google.com>
> Reviewed-by: Dave Martin <Dave.Martin@arm.com>
> Link: https://linux-review.googlesource.com/id/I35aab6f5be932505d90f3b3450c083b4db1eca86
> ---
> v10:
> - rename SA_UAPI_FLAGS -> UAPI_SA_FLAGS
> - refactor how we define it to avoid mentioning flags more
>   than once
>
>  arch/arm/include/asm/signal.h    |  2 ++
>  arch/parisc/include/asm/signal.h |  2 ++
>  arch/x86/kernel/signal_compat.c  |  7 -------
>  include/linux/signal_types.h     | 12 ++++++++++++
>  kernel/signal.c                  | 10 ++++++++++
>  5 files changed, 26 insertions(+), 7 deletions(-)
>
> diff --git a/arch/arm/include/asm/signal.h b/arch/arm/include/asm/signal.h
> index 65530a042009..430be7774402 100644
> --- a/arch/arm/include/asm/signal.h
> +++ b/arch/arm/include/asm/signal.h
> @@ -17,6 +17,8 @@ typedef struct {
>  	unsigned long sig[_NSIG_WORDS];
>  } sigset_t;
>  
> +#define __ARCH_UAPI_SA_FLAGS	(SA_THIRTYTWO | SA_RESTORER)
> +
>  #define __ARCH_HAS_SA_RESTORER
>  
>  #include <asm/sigcontext.h>
> diff --git a/arch/parisc/include/asm/signal.h b/arch/parisc/include/asm/signal.h
> index 715c96ba2ec8..30dd1e43ef88 100644
> --- a/arch/parisc/include/asm/signal.h
> +++ b/arch/parisc/include/asm/signal.h
> @@ -21,6 +21,8 @@ typedef struct {
>  	unsigned long sig[_NSIG_WORDS];
>  } sigset_t;
>  
> +#define __ARCH_UAPI_SA_FLAGS	_SA_SIGGFAULT
> +
>  #include <asm/sigcontext.h>
>  
>  #endif /* !__ASSEMBLY */
> diff --git a/arch/x86/kernel/signal_compat.c b/arch/x86/kernel/signal_compat.c
> index a7f3e12cfbdb..ddfd919be46c 100644
> --- a/arch/x86/kernel/signal_compat.c
> +++ b/arch/x86/kernel/signal_compat.c
> @@ -165,16 +165,9 @@ void sigaction_compat_abi(struct k_sigaction *act, struct k_sigaction *oact)
>  {
>  	signal_compat_build_tests();
>  
> -	/* Don't leak in-kernel non-uapi flags to user-space */
> -	if (oact)
> -		oact->sa.sa_flags &= ~(SA_IA32_ABI | SA_X32_ABI);
> -
>  	if (!act)
>  		return;
>  
> -	/* Don't let flags to be set from userspace */
> -	act->sa.sa_flags &= ~(SA_IA32_ABI | SA_X32_ABI);
> -
>  	if (in_ia32_syscall())
>  		act->sa.sa_flags |= SA_IA32_ABI;
>  	if (in_x32_syscall())
> diff --git a/include/linux/signal_types.h b/include/linux/signal_types.h
> index f8a90ae9c6ec..a7887ad84d36 100644
> --- a/include/linux/signal_types.h
> +++ b/include/linux/signal_types.h
> @@ -68,4 +68,16 @@ struct ksignal {
>  	int sig;
>  };
>  
> +#ifndef __ARCH_UAPI_SA_FLAGS
> +#ifdef SA_RESTORER
> +#define __ARCH_UAPI_SA_FLAGS	SA_RESTORER
> +#else
> +#define __ARCH_UAPI_SA_FLAGS	0
> +#endif
> +#endif
> +
> +#define UAPI_SA_FLAGS                                                          \
> +	(SA_NOCLDSTOP | SA_NOCLDWAIT | SA_SIGINFO | SA_ONSTACK | SA_RESTART |  \
> +	 SA_NODEFER | SA_RESETHAND | __ARCH_UAPI_SA_FLAGS)
> +
>  #endif /* _LINUX_SIGNAL_TYPES_H */
> diff --git a/kernel/signal.c b/kernel/signal.c
> index 74e7315c24db..832b654dee8c 100644
> --- a/kernel/signal.c
> +++ b/kernel/signal.c
> @@ -3964,6 +3964,16 @@ int do_sigaction(int sig, struct k_sigaction *act, struct k_sigaction *oact)
>  	if (oact)
>  		*oact = *k;
>  
> +	/*
> +	 * Clear unknown flag bits in order to allow userspace to detect missing
> +	 * support for flag bits and to allow the kernel to use non-uapi bits
> +	 * internally.
> +	 */
> +	if (act)
> +		act->sa.sa_flags &= UAPI_SA_FLAGS;
> +	if (oact)
> +		oact->sa.sa_flags &= UAPI_SA_FLAGS;
> +
>  	sigaction_compat_abi(act, oact);
>  
>  	if (act) {

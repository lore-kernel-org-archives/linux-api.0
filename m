Return-Path: <linux-api-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 82551C2D0A3
	for <linux-api@archiver.kernel.org>; Tue, 10 Nov 2020 00:41:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 18A91205CA
	for <linux-api@archiver.kernel.org>; Tue, 10 Nov 2020 00:41:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729243AbgKJAll (ORCPT <rfc822;linux-api@archiver.kernel.org>);
        Mon, 9 Nov 2020 19:41:41 -0500
Received: from out03.mta.xmission.com ([166.70.13.233]:49946 "EHLO
        out03.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727311AbgKJAlk (ORCPT
        <rfc822;linux-api@vger.kernel.org>); Mon, 9 Nov 2020 19:41:40 -0500
Received: from in01.mta.xmission.com ([166.70.13.51])
        by out03.mta.xmission.com with esmtps  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
        (Exim 4.93)
        (envelope-from <ebiederm@xmission.com>)
        id 1kcHj5-002kUH-DJ; Mon, 09 Nov 2020 17:41:35 -0700
Received: from ip68-227-160-95.om.om.cox.net ([68.227.160.95] helo=x220.xmission.com)
        by in01.mta.xmission.com with esmtpsa (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.87)
        (envelope-from <ebiederm@xmission.com>)
        id 1kcHj3-0003kM-My; Mon, 09 Nov 2020 17:41:34 -0700
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
        <4d826a62121153d54d7e36fc8a402c97e2106764.1604523707.git.pcc@google.com>
Date:   Mon, 09 Nov 2020 18:41:25 -0600
In-Reply-To: <4d826a62121153d54d7e36fc8a402c97e2106764.1604523707.git.pcc@google.com>
        (Peter Collingbourne's message of "Wed, 4 Nov 2020 13:18:07 -0800")
Message-ID: <87lffa11sa.fsf@x220.int.ebiederm.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-SPF: eid=1kcHj3-0003kM-My;;;mid=<87lffa11sa.fsf@x220.int.ebiederm.org>;;;hst=in01.mta.xmission.com;;;ip=68.227.160.95;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX1+wMvcfKZWnmaNzIHKA2RgWQVEIlzcmCbg=
X-SA-Exim-Connect-IP: 68.227.160.95
X-SA-Exim-Mail-From: ebiederm@xmission.com
Subject: Re: [PATCH v14 4/8] signal: deduplicate code dealing with common _sigfault fields
X-SA-Exim-Version: 4.2.1 (built Thu, 05 May 2016 13:38:54 -0600)
X-SA-Exim-Scanned: Yes (on in01.mta.xmission.com)
Precedence: bulk
List-ID: <linux-api.vger.kernel.org>
X-Mailing-List: linux-api@vger.kernel.org

Peter Collingbourne <pcc@google.com> writes:

> We're about to add more common _sigfault fields, so deduplicate the
> existing code for initializing _sigfault fields in {send,force}_sig_*,
> and for copying _sigfault fields in copy_siginfo_to_external32 and
> post_copy_siginfo_from_user32, to reduce the number of places that
> will need to be updated by upcoming changes.

Acked-by: "Eric W. Biederman" <ebiederm@xmission.com>


No real objection but I am wondering if it might be better to
introduce two small inline functions for setting common fields
instead of:

> +	if (siginfo_layout_is_fault(layout)) {
> +		to->si_addr = ptr_to_compat(from->si_addr);
> +#ifdef __ARCH_SI_TRAPNO
> +		to->si_trapno = from->si_trapno;
> +#endif
> +	}

and 

> +	if (siginfo_layout_is_fault(layout)) {
> +		to->si_addr = compat_ptr(from->si_addr);
> +#ifdef __ARCH_SI_TRAPNO
> +		to->si_trapno = from->si_trapno;
> +#endif
> +	}

perhaps called:
copy_sigfault_common_to_external32
post_copy_sigfault_common_from_user32

I have not benchmarked or anything but my gut says one less conditional
branch to worry about makes dealing with spectre easier and probably
produces faster code as well.  Possibly even smaller code.

Eric

> Signed-off-by: Peter Collingbourne <pcc@google.com>
> Link: https://linux-review.googlesource.com/id/I4f56174e1b7b2bf4a3c8139e6879cbfd52750a24
> ---
>  include/linux/signal.h |  13 ++++++
>  kernel/signal.c        | 101 ++++++++++++++++-------------------------
>  2 files changed, 53 insertions(+), 61 deletions(-)
>
> diff --git a/include/linux/signal.h b/include/linux/signal.h
> index b256f9c65661..e9fb05041e7a 100644
> --- a/include/linux/signal.h
> +++ b/include/linux/signal.h
> @@ -50,6 +50,19 @@ enum siginfo_layout {
>  
>  enum siginfo_layout siginfo_layout(unsigned sig, int si_code);
>  
> +static inline bool siginfo_layout_is_fault(enum siginfo_layout layout)
> +{
> +	switch (layout) {
> +	case SIL_FAULT:
> +	case SIL_FAULT_MCEERR:
> +	case SIL_FAULT_BNDERR:
> +	case SIL_FAULT_PKUERR:
> +		return true;
> +	default:
> +		return false;
> +	}
> +}
> +
>  /*
>   * Define some primitives to manipulate sigset_t.
>   */
> diff --git a/kernel/signal.c b/kernel/signal.c
> index ef8f2a28d37c..74e7315c24db 100644
> --- a/kernel/signal.c
> +++ b/kernel/signal.c
> @@ -1650,6 +1650,15 @@ void force_sigsegv(int sig)
>  	force_sig(SIGSEGV);
>  }
>  
> +static void set_sigfault_common_fields(struct kernel_siginfo *info, int sig,
> +				       int code, void __user *addr)
> +{
> +	info->si_signo = sig;
> +	info->si_errno = 0;
> +	info->si_code = code;
> +	info->si_addr = addr;
> +}
> +
>  int force_sig_fault_to_task(int sig, int code, void __user *addr
>  	___ARCH_SI_TRAPNO(int trapno)
>  	___ARCH_SI_IA64(int imm, unsigned int flags, unsigned long isr)
> @@ -1658,10 +1667,7 @@ int force_sig_fault_to_task(int sig, int code, void __user *addr
>  	struct kernel_siginfo info;
>  
>  	clear_siginfo(&info);
> -	info.si_signo = sig;
> -	info.si_errno = 0;
> -	info.si_code  = code;
> -	info.si_addr  = addr;
> +	set_sigfault_common_fields(&info, sig, code, addr);
>  #ifdef __ARCH_SI_TRAPNO
>  	info.si_trapno = trapno;
>  #endif
> @@ -1690,10 +1696,7 @@ int send_sig_fault(int sig, int code, void __user *addr
>  	struct kernel_siginfo info;
>  
>  	clear_siginfo(&info);
> -	info.si_signo = sig;
> -	info.si_errno = 0;
> -	info.si_code  = code;
> -	info.si_addr  = addr;
> +	set_sigfault_common_fields(&info, sig, code, addr);
>  #ifdef __ARCH_SI_TRAPNO
>  	info.si_trapno = trapno;
>  #endif
> @@ -1711,10 +1714,7 @@ int force_sig_mceerr(int code, void __user *addr, short lsb)
>  
>  	WARN_ON((code != BUS_MCEERR_AO) && (code != BUS_MCEERR_AR));
>  	clear_siginfo(&info);
> -	info.si_signo = SIGBUS;
> -	info.si_errno = 0;
> -	info.si_code = code;
> -	info.si_addr = addr;
> +	set_sigfault_common_fields(&info, SIGBUS, code, addr);
>  	info.si_addr_lsb = lsb;
>  	return force_sig_info(&info);
>  }
> @@ -1725,10 +1725,7 @@ int send_sig_mceerr(int code, void __user *addr, short lsb, struct task_struct *
>  
>  	WARN_ON((code != BUS_MCEERR_AO) && (code != BUS_MCEERR_AR));
>  	clear_siginfo(&info);
> -	info.si_signo = SIGBUS;
> -	info.si_errno = 0;
> -	info.si_code = code;
> -	info.si_addr = addr;
> +	set_sigfault_common_fields(&info, SIGBUS, code, addr);
>  	info.si_addr_lsb = lsb;
>  	return send_sig_info(info.si_signo, &info, t);
>  }
> @@ -1739,10 +1736,7 @@ int force_sig_bnderr(void __user *addr, void __user *lower, void __user *upper)
>  	struct kernel_siginfo info;
>  
>  	clear_siginfo(&info);
> -	info.si_signo = SIGSEGV;
> -	info.si_errno = 0;
> -	info.si_code  = SEGV_BNDERR;
> -	info.si_addr  = addr;
> +	set_sigfault_common_fields(&info, SIGSEGV, SEGV_BNDERR, addr);
>  	info.si_lower = lower;
>  	info.si_upper = upper;
>  	return force_sig_info(&info);
> @@ -1754,10 +1748,7 @@ int force_sig_pkuerr(void __user *addr, u32 pkey)
>  	struct kernel_siginfo info;
>  
>  	clear_siginfo(&info);
> -	info.si_signo = SIGSEGV;
> -	info.si_errno = 0;
> -	info.si_code  = SEGV_PKUERR;
> -	info.si_addr  = addr;
> +	set_sigfault_common_fields(&info, SIGSEGV, SEGV_PKUERR, addr);
>  	info.si_pkey  = pkey;
>  	return force_sig_info(&info);
>  }
> @@ -1771,10 +1762,8 @@ int force_sig_ptrace_errno_trap(int errno, void __user *addr)
>  	struct kernel_siginfo info;
>  
>  	clear_siginfo(&info);
> -	info.si_signo = SIGTRAP;
> +	set_sigfault_common_fields(&info, SIGTRAP, TRAP_HWBKPT, addr);
>  	info.si_errno = errno;
> -	info.si_code  = TRAP_HWBKPT;
> -	info.si_addr  = addr;
>  	return force_sig_info(&info);
>  }
>  
> @@ -3267,12 +3256,23 @@ int copy_siginfo_from_user(kernel_siginfo_t *to, const siginfo_t __user *from)
>  void copy_siginfo_to_external32(struct compat_siginfo *to,
>  		const struct kernel_siginfo *from)
>  {
> +	enum siginfo_layout layout =
> +		siginfo_layout(from->si_signo, from->si_code);
> +
>  	memset(to, 0, sizeof(*to));
>  
>  	to->si_signo = from->si_signo;
>  	to->si_errno = from->si_errno;
>  	to->si_code  = from->si_code;
> -	switch(siginfo_layout(from->si_signo, from->si_code)) {
> +
> +	if (siginfo_layout_is_fault(layout)) {
> +		to->si_addr = ptr_to_compat(from->si_addr);
> +#ifdef __ARCH_SI_TRAPNO
> +		to->si_trapno = from->si_trapno;
> +#endif
> +	}
> +
> +	switch (layout) {
>  	case SIL_KILL:
>  		to->si_pid = from->si_pid;
>  		to->si_uid = from->si_uid;
> @@ -3287,31 +3287,15 @@ void copy_siginfo_to_external32(struct compat_siginfo *to,
>  		to->si_fd   = from->si_fd;
>  		break;
>  	case SIL_FAULT:
> -		to->si_addr = ptr_to_compat(from->si_addr);
> -#ifdef __ARCH_SI_TRAPNO
> -		to->si_trapno = from->si_trapno;
> -#endif
>  		break;
>  	case SIL_FAULT_MCEERR:
> -		to->si_addr = ptr_to_compat(from->si_addr);
> -#ifdef __ARCH_SI_TRAPNO
> -		to->si_trapno = from->si_trapno;
> -#endif
>  		to->si_addr_lsb = from->si_addr_lsb;
>  		break;
>  	case SIL_FAULT_BNDERR:
> -		to->si_addr = ptr_to_compat(from->si_addr);
> -#ifdef __ARCH_SI_TRAPNO
> -		to->si_trapno = from->si_trapno;
> -#endif
>  		to->si_lower = ptr_to_compat(from->si_lower);
>  		to->si_upper = ptr_to_compat(from->si_upper);
>  		break;
>  	case SIL_FAULT_PKUERR:
> -		to->si_addr = ptr_to_compat(from->si_addr);
> -#ifdef __ARCH_SI_TRAPNO
> -		to->si_trapno = from->si_trapno;
> -#endif
>  		to->si_pkey = from->si_pkey;
>  		break;
>  	case SIL_CHLD:
> @@ -3348,11 +3332,22 @@ int __copy_siginfo_to_user32(struct compat_siginfo __user *to,
>  static int post_copy_siginfo_from_user32(kernel_siginfo_t *to,
>  					 const struct compat_siginfo *from)
>  {
> +	enum siginfo_layout layout =
> +		siginfo_layout(from->si_signo, from->si_code);
> +
>  	clear_siginfo(to);
>  	to->si_signo = from->si_signo;
>  	to->si_errno = from->si_errno;
>  	to->si_code  = from->si_code;
> -	switch(siginfo_layout(from->si_signo, from->si_code)) {
> +
> +	if (siginfo_layout_is_fault(layout)) {
> +		to->si_addr = compat_ptr(from->si_addr);
> +#ifdef __ARCH_SI_TRAPNO
> +		to->si_trapno = from->si_trapno;
> +#endif
> +	}
> +
> +	switch (layout) {
>  	case SIL_KILL:
>  		to->si_pid = from->si_pid;
>  		to->si_uid = from->si_uid;
> @@ -3367,31 +3362,15 @@ static int post_copy_siginfo_from_user32(kernel_siginfo_t *to,
>  		to->si_fd   = from->si_fd;
>  		break;
>  	case SIL_FAULT:
> -		to->si_addr = compat_ptr(from->si_addr);
> -#ifdef __ARCH_SI_TRAPNO
> -		to->si_trapno = from->si_trapno;
> -#endif
>  		break;
>  	case SIL_FAULT_MCEERR:
> -		to->si_addr = compat_ptr(from->si_addr);
> -#ifdef __ARCH_SI_TRAPNO
> -		to->si_trapno = from->si_trapno;
> -#endif
>  		to->si_addr_lsb = from->si_addr_lsb;
>  		break;
>  	case SIL_FAULT_BNDERR:
> -		to->si_addr = compat_ptr(from->si_addr);
> -#ifdef __ARCH_SI_TRAPNO
> -		to->si_trapno = from->si_trapno;
> -#endif
>  		to->si_lower = compat_ptr(from->si_lower);
>  		to->si_upper = compat_ptr(from->si_upper);
>  		break;
>  	case SIL_FAULT_PKUERR:
> -		to->si_addr = compat_ptr(from->si_addr);
> -#ifdef __ARCH_SI_TRAPNO
> -		to->si_trapno = from->si_trapno;
> -#endif
>  		to->si_pkey = from->si_pkey;
>  		break;
>  	case SIL_CHLD:

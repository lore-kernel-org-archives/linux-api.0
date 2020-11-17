Return-Path: <linux-api-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 84FD3C2D0E4
	for <linux-api@archiver.kernel.org>; Tue, 17 Nov 2020 21:37:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2B4AC24655
	for <linux-api@archiver.kernel.org>; Tue, 17 Nov 2020 21:37:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727701AbgKQVha (ORCPT <rfc822;linux-api@archiver.kernel.org>);
        Tue, 17 Nov 2020 16:37:30 -0500
Received: from out01.mta.xmission.com ([166.70.13.231]:56384 "EHLO
        out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726107AbgKQVha (ORCPT
        <rfc822;linux-api@vger.kernel.org>); Tue, 17 Nov 2020 16:37:30 -0500
Received: from in02.mta.xmission.com ([166.70.13.52])
        by out01.mta.xmission.com with esmtps  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.93)
        (envelope-from <ebiederm@xmission.com>)
        id 1kf8fC-00G0So-N6; Tue, 17 Nov 2020 14:37:22 -0700
Received: from ip68-227-160-95.om.om.cox.net ([68.227.160.95] helo=x220.xmission.com)
        by in02.mta.xmission.com with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.93)
        (envelope-from <ebiederm@xmission.com>)
        id 1kf8fB-005RjH-JB; Tue, 17 Nov 2020 14:37:22 -0700
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
        linux-api@vger.kernel.org, Helge Deller <deller@gmx.de>,
        David Spickett <david.spickett@linaro.org>
References: <20201117195205.645925-1-pcc@google.com>
Date:   Tue, 17 Nov 2020 15:37:04 -0600
In-Reply-To: <20201117195205.645925-1-pcc@google.com> (Peter Collingbourne's
        message of "Tue, 17 Nov 2020 11:52:05 -0800")
Message-ID: <877dqj8y2n.fsf@x220.int.ebiederm.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-SPF: eid=1kf8fB-005RjH-JB;;;mid=<877dqj8y2n.fsf@x220.int.ebiederm.org>;;;hst=in02.mta.xmission.com;;;ip=68.227.160.95;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX1//OgS3vP5N5WfdqdyQHB6ATPU+1uS93zE=
X-SA-Exim-Connect-IP: 68.227.160.95
X-SA-Exim-Mail-From: ebiederm@xmission.com
Subject: Re: [PATCH v18] arm64: expose FAR_EL1 tag bits in siginfo
X-SA-Exim-Version: 4.2.1 (built Sat, 08 Feb 2020 21:53:50 +0000)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Precedence: bulk
List-ID: <linux-api.vger.kernel.org>
X-Mailing-List: linux-api@vger.kernel.org

Peter Collingbourne <pcc@google.com> writes:

> diff --git a/include/uapi/asm-generic/signal-defs.h b/include/uapi/asm-generic/signal-defs.h
> index c790f67304ba..fe929e7b77ca 100644
> --- a/include/uapi/asm-generic/signal-defs.h
> +++ b/include/uapi/asm-generic/signal-defs.h
> @@ -20,6 +20,8 @@
>   * so this bit allows flag bit support to be detected from userspace while
>   * allowing an old kernel to be distinguished from a kernel that supports every
>   * flag bit.
> + * SA_EXPOSE_TAGBITS exposes an architecture-defined set of tag bits in
> + * siginfo.si_addr.

Do we perhaps want to say the high bits of si_addr?

>   *
>   * SA_ONESHOT and SA_NOMASK are the historical Linux names for the Single
>   * Unix names RESETHAND and NODEFER respectively.
> @@ -41,6 +43,7 @@
>  /* 0x00000100 used on sparc */
>  /* 0x00000200 used on sparc */
>  #define SA_UNSUPPORTED	0x00000400
> +#define SA_EXPOSE_TAGBITS	0x00000800
>  /* 0x00010000 used on mips */
>  /* 0x01000000 used on x86 */
>  /* 0x02000000 used on x86 */
> diff --git a/kernel/signal.c b/kernel/signal.c
> index 8f34819e80de..576de3d9bd86 100644
> --- a/kernel/signal.c
> +++ b/kernel/signal.c
> @@ -2658,6 +2658,26 @@ bool get_signal(struct ksignal *ksig)
>  
>  		ka = &sighand->action[signr-1];
>  
> +		if (!(ka->sa.sa_flags & SA_EXPOSE_TAGBITS)) {
> +			switch (siginfo_layout(signr, ksig->info.si_code)) {
> +			case SIL_FAULT:
> +			case SIL_FAULT_MCEERR:
> +			case SIL_FAULT_BNDERR:
> +			case SIL_FAULT_PKUERR:
> +				ksig->info.si_addr = arch_untagged_si_addr(
> +					ksig->info.si_addr, signr,
> +					ksig->info.si_code);
> +				break;
> +			case SIL_KILL:
> +			case SIL_TIMER:
> +			case SIL_POLL:
> +			case SIL_CHLD:
> +			case SIL_RT:
> +			case SIL_SYS:
> +				break;
> +			}
> +		}
> +
>  		/* Trace actually delivered signals. */
>  		trace_signal_deliver(signr, &ksig->info, ka);

Overall this looks good.

It is a common path so I wonder about the generated code, and how close
to a noop this becomes on x86 and other architetures without tag bits.

Can you put this blob of code in it's own function (perhaps called
hide_si_addr_tag_bits) and call it right after "ksig->sig = signr" line?

Effectively that is the same place in the code but it gets it outside of
the sighand lock.  The tracing code does not care as it does not look at
si_addr.

I am concerned with the complexity of reading get_signal and using a
well named inline function should make it unnecessary to read that
code unless you care about what is going on.

Further having the code outside of the lock at the end of get_signal
with nothing else going on seems much easier to reason about.  The code
is get_signal is something that needs reading and reasoning about.

Eric

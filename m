Return-Path: <SRS0=tld+=EK=vger.kernel.org=linux-api-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B8427C2D0A3
	for <linux-api@archiver.kernel.org>; Wed,  4 Nov 2020 18:48:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5FC3820782
	for <linux-api@archiver.kernel.org>; Wed,  4 Nov 2020 18:48:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726737AbgKDSsB (ORCPT <rfc822;linux-api@archiver.kernel.org>);
        Wed, 4 Nov 2020 13:48:01 -0500
Received: from out02.mta.xmission.com ([166.70.13.232]:40546 "EHLO
        out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726636AbgKDSsB (ORCPT
        <rfc822;linux-api@vger.kernel.org>); Wed, 4 Nov 2020 13:48:01 -0500
Received: from in02.mta.xmission.com ([166.70.13.52])
        by out02.mta.xmission.com with esmtps  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.93)
        (envelope-from <ebiederm@xmission.com>)
        id 1kaNot-006Wiq-TI; Wed, 04 Nov 2020 11:47:43 -0700
Received: from ip68-227-160-95.om.om.cox.net ([68.227.160.95] helo=x220.xmission.com)
        by in02.mta.xmission.com with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.93)
        (envelope-from <ebiederm@xmission.com>)
        id 1kaNos-00EZCN-Pp; Wed, 04 Nov 2020 11:47:43 -0700
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
        David Spickett <david.spickett@linaro.org>,
        Geert Uytterhoeven <geert@linux-m68k.org>
References: <cover.1604376407.git.pcc@google.com>
        <a309f8baa7c342536c17832cf604fad00aac486c.1604376407.git.pcc@google.com>
Date:   Wed, 04 Nov 2020 12:47:39 -0600
In-Reply-To: <a309f8baa7c342536c17832cf604fad00aac486c.1604376407.git.pcc@google.com>
        (Peter Collingbourne's message of "Mon, 2 Nov 2020 20:09:39 -0800")
Message-ID: <87h7q55584.fsf@x220.int.ebiederm.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-SPF: eid=1kaNos-00EZCN-Pp;;;mid=<87h7q55584.fsf@x220.int.ebiederm.org>;;;hst=in02.mta.xmission.com;;;ip=68.227.160.95;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX1811kUSvbjFrFbUGdgjE0HQ3122cGMp5Gk=
X-SA-Exim-Connect-IP: 68.227.160.95
X-SA-Exim-Mail-From: ebiederm@xmission.com
Subject: Re: [PATCH v13 3/8] arch: move SA_* definitions to generic headers
X-SA-Exim-Version: 4.2.1 (built Sat, 08 Feb 2020 21:53:50 +0000)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Precedence: bulk
List-ID: <linux-api.vger.kernel.org>
X-Mailing-List: linux-api@vger.kernel.org

Peter Collingbourne <pcc@google.com> writes:

> Most architectures with the exception of alpha, mips, parisc and
> sparc use the same values for these flags. Move their definitions into
> asm-generic/signal-defs.h and allow the architectures with non-standard
> values to override them. Also, document the non-standard flag values
> in order to make it easier to add new generic flags in the future.
>
> A consequence of this change is that on powerpc and x86, the constants'
> values aside from SA_RESETHAND change signedness from unsigned
> to signed. This is not expected to impact realistic use of these
> constants. In particular the typical use of the constants where they
> are or'ed together and assigned to sa_flags (or another int variable)
> would not be affected.

Except for the removal of SA_RESTORER on arm (see below).
Acked-by: "Eric W. Biederman" <ebiederm@xmission.com>

>
> Signed-off-by: Peter Collingbourne <pcc@google.com>
> Acked-by: Geert Uytterhoeven <geert@linux-m68k.org>
> Reviewed-by: Dave Martin <Dave.Martin@arm.com>
> Link: https://linux-review.googlesource.com/id/Ia3849f18b8009bf41faca374e701cdca36974528
> ---
> v11:
> - tweak the commit message to point out the change from unsigned
>   to signed
>
> v10:
> - move the comments around and add one for SA_SIGINFO
>

> diff --git a/arch/arm/include/uapi/asm/signal.h b/arch/arm/include/uapi/asm/signal.h
> index 9b4185ba4f8a..7727f0984d26 100644
> --- a/arch/arm/include/uapi/asm/signal.h
> +++ b/arch/arm/include/uapi/asm/signal.h
> @@ -60,33 +60,11 @@ typedef unsigned long sigset_t;
>  #define SIGSWI		32
>  
>  /*
> - * SA_FLAGS values:
> - *
> - * SA_NOCLDSTOP		flag to turn off SIGCHLD when children stop.
> - * SA_NOCLDWAIT		flag on SIGCHLD to inhibit zombies.
> - * SA_SIGINFO		deliver the signal with SIGINFO structs
> - * SA_THIRTYTWO		delivers the signal in 32-bit mode, even if the task 
> - *			is running in 26-bit.
> - * SA_ONSTACK		allows alternate signal stacks (see sigaltstack(2)).
> - * SA_RESTART		flag to get restarting signals (which were the default long ago)
> - * SA_NODEFER		prevents the current signal from being masked in the handler.
> - * SA_RESETHAND		clears the handler when the signal is delivered.
> - *
> - * SA_ONESHOT and SA_NOMASK are the historical Linux names for the Single
> - * Unix names RESETHAND and NODEFER respectively.
> + * SA_THIRTYTWO historically meant deliver the signal in 32-bit mode, even if
> + * the task is running in 26-bit. But since the kernel no longer supports
> + * 26-bit mode, the flag has no effect.
>   */
> -#define SA_NOCLDSTOP	0x00000001
> -#define SA_NOCLDWAIT	0x00000002
> -#define SA_SIGINFO	0x00000004
>  #define SA_THIRTYTWO	0x02000000

> -#define SA_RESTORER	0x04000000
   ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Was removing SA_RESTOER from arm a typo?
If not it is probably better to move the removal into a separate patch.


> -#define SA_ONSTACK	0x08000000
> -#define SA_RESTART	0x10000000
> -#define SA_NODEFER	0x40000000
> -#define SA_RESETHAND	0x80000000
> -
> -#define SA_NOMASK	SA_NODEFER
> -#define SA_ONESHOT	SA_RESETHAND
>  
>  #define MINSIGSTKSZ	2048
>  #define SIGSTKSZ	8192

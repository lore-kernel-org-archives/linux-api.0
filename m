Return-Path: <SRS0=tld+=EK=vger.kernel.org=linux-api-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 20B07C2D0A3
	for <linux-api@archiver.kernel.org>; Wed,  4 Nov 2020 16:55:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B77582080D
	for <linux-api@archiver.kernel.org>; Wed,  4 Nov 2020 16:55:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729679AbgKDQzI (ORCPT <rfc822;linux-api@archiver.kernel.org>);
        Wed, 4 Nov 2020 11:55:08 -0500
Received: from out01.mta.xmission.com ([166.70.13.231]:45296 "EHLO
        out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729430AbgKDQzH (ORCPT
        <rfc822;linux-api@vger.kernel.org>); Wed, 4 Nov 2020 11:55:07 -0500
Received: from in01.mta.xmission.com ([166.70.13.51])
        by out01.mta.xmission.com with esmtps  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
        (Exim 4.93)
        (envelope-from <ebiederm@xmission.com>)
        id 1kaM3S-007l6D-Bu; Wed, 04 Nov 2020 09:54:38 -0700
Received: from ip68-227-160-95.om.om.cox.net ([68.227.160.95] helo=x220.xmission.com)
        by in01.mta.xmission.com with esmtpsa (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.87)
        (envelope-from <ebiederm@xmission.com>)
        id 1kaM3R-0004lB-C6; Wed, 04 Nov 2020 09:54:38 -0700
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
References: <cover.1604376407.git.pcc@google.com>
        <7e26600459cb08c5016611b37fe88c23098b40eb.1604376407.git.pcc@google.com>
Date:   Wed, 04 Nov 2020 10:54:34 -0600
In-Reply-To: <7e26600459cb08c5016611b37fe88c23098b40eb.1604376407.git.pcc@google.com>
        (Peter Collingbourne's message of "Mon, 2 Nov 2020 20:09:37 -0800")
Message-ID: <87a6vx6p11.fsf@x220.int.ebiederm.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-SPF: eid=1kaM3R-0004lB-C6;;;mid=<87a6vx6p11.fsf@x220.int.ebiederm.org>;;;hst=in01.mta.xmission.com;;;ip=68.227.160.95;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX18kWKJVLqoX1XbrReT7yyy6uVwGbRy1A/w=
X-SA-Exim-Connect-IP: 68.227.160.95
X-SA-Exim-Mail-From: ebiederm@xmission.com
Subject: Re: [PATCH v13 1/8] parisc: Drop parisc special case for __sighandler_t
X-SA-Exim-Version: 4.2.1 (built Thu, 05 May 2016 13:38:54 -0600)
X-SA-Exim-Scanned: Yes (on in01.mta.xmission.com)
Precedence: bulk
List-ID: <linux-api.vger.kernel.org>
X-Mailing-List: linux-api@vger.kernel.org

Peter Collingbourne <pcc@google.com> writes:

> From: Helge Deller <deller@gmx.de>
>
> I believe we can and *should* drop this parisc-specific typedef for
> __sighandler_t when compiling a 64-bit kernel. The reasons:
>
> 1. We don't have a 64-bit userspace yet, so nothing (on userspace side)
> can break.
>
> 2. Inside the Linux kernel, this is only used in kernel/signal.c, in
> function kernel_sigaction() where the signal handler is compared against
> SIG_IGN.  SIG_IGN is defined as (__sighandler_t)1), so only the pointers
> are compared.
>
> 3. Even when a 64-bit userspace gets added at some point, I think
> __sighandler_t should be defined what it is: a function pointer struct.
>
> I compiled kernel/signal.c with and without the patch, and the produced code
> is identical in both cases.
>
> Signed-off-by: Helge Deller <deller@gmx.de>
> Reviewed-by: Peter Collingbourne <pcc@google.com>
> Link:
> https://linux-review.googlesource.com/id/I21c43f21b264f339e3aa395626af838646f62d97

Peter as you have sent this, this also needs your Signed-off-by.

Otherwise this looks reasonable to me.
Acked-by: "Eric W. Biederman" <ebiederm@xmission.com>

While the final bits look like they are still under discussion it looks
like the preceding cleanups are pretty solid at this point.

Any chance we can get the cleanups into a tree in linux-next so that
the discussion can focus on the core parts of this work?

Perhaps I should pick up the clenaups?

Eric



> ---
>  arch/parisc/include/uapi/asm/signal.h | 8 --------
>  1 file changed, 8 deletions(-)
>
> diff --git a/arch/parisc/include/uapi/asm/signal.h b/arch/parisc/include/uapi/asm/signal.h
> index e605197b462c..d9c51769851a 100644
> --- a/arch/parisc/include/uapi/asm/signal.h
> +++ b/arch/parisc/include/uapi/asm/signal.h
> @@ -85,16 +85,8 @@
>  struct siginfo;
>  
>  /* Type of a signal handler.  */
> -#if defined(__LP64__)
> -/* function pointers on 64-bit parisc are pointers to little structs and the
> - * compiler doesn't support code which changes or tests the address of
> - * the function in the little struct.  This is really ugly -PB
> - */
> -typedef char __user *__sighandler_t;
> -#else
>  typedef void __signalfn_t(int);
>  typedef __signalfn_t __user *__sighandler_t;
> -#endif
>  
>  typedef struct sigaltstack {
>  	void __user *ss_sp;

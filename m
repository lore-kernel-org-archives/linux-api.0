Return-Path: <SRS0=tld+=EK=vger.kernel.org=linux-api-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A5EC1C2D0A3
	for <linux-api@archiver.kernel.org>; Wed,  4 Nov 2020 18:05:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 51D2F20825
	for <linux-api@archiver.kernel.org>; Wed,  4 Nov 2020 18:05:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727098AbgKDSFn (ORCPT <rfc822;linux-api@archiver.kernel.org>);
        Wed, 4 Nov 2020 13:05:43 -0500
Received: from out02.mta.xmission.com ([166.70.13.232]:50996 "EHLO
        out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726608AbgKDSFm (ORCPT
        <rfc822;linux-api@vger.kernel.org>); Wed, 4 Nov 2020 13:05:42 -0500
Received: from in01.mta.xmission.com ([166.70.13.51])
        by out02.mta.xmission.com with esmtps  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
        (Exim 4.93)
        (envelope-from <ebiederm@xmission.com>)
        id 1kaNA8-006Rnf-0m; Wed, 04 Nov 2020 11:05:36 -0700
Received: from ip68-227-160-95.om.om.cox.net ([68.227.160.95] helo=x220.xmission.com)
        by in01.mta.xmission.com with esmtpsa (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.87)
        (envelope-from <ebiederm@xmission.com>)
        id 1kaNA7-0003so-4W; Wed, 04 Nov 2020 11:05:35 -0700
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
        <e67e653cd06c573e932e7d72223dd7d48fcd21d3.1604376407.git.pcc@google.com>
Date:   Wed, 04 Nov 2020 12:05:31 -0600
In-Reply-To: <e67e653cd06c573e932e7d72223dd7d48fcd21d3.1604376407.git.pcc@google.com>
        (Peter Collingbourne's message of "Mon, 2 Nov 2020 20:09:38 -0800")
Message-ID: <87r1p9576c.fsf@x220.int.ebiederm.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-SPF: eid=1kaNA7-0003so-4W;;;mid=<87r1p9576c.fsf@x220.int.ebiederm.org>;;;hst=in01.mta.xmission.com;;;ip=68.227.160.95;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX1++bJSHWtQNH7zBfGB2JU+iGKcjfoK+Ahk=
X-SA-Exim-Connect-IP: 68.227.160.95
X-SA-Exim-Mail-From: ebiederm@xmission.com
Subject: Re: [PATCH v13 2/8] parisc: start using signal-defs.h
X-SA-Exim-Version: 4.2.1 (built Thu, 05 May 2016 13:38:54 -0600)
X-SA-Exim-Scanned: Yes (on in01.mta.xmission.com)
Precedence: bulk
List-ID: <linux-api.vger.kernel.org>
X-Mailing-List: linux-api@vger.kernel.org

Peter Collingbourne <pcc@google.com> writes:

> We currently include signal-defs.h on all architectures except parisc.
> Make parisc fall in line. This will make maintenance easier once the
> flag bits are moved here.
>
> Signed-off-by: Peter Collingbourne <pcc@google.com>
> Acked-by: Helge Deller <deller@gmx.de>
> Link: https://linux-review.googlesource.com/id/If03a5135fb514fe96548fb74610e6c3586a04064

Acked-by: "Eric W. Biederman" <ebiederm@xmission.com>

> ---
>  arch/parisc/include/uapi/asm/signal.h | 13 +------------
>  1 file changed, 1 insertion(+), 12 deletions(-)
>
> diff --git a/arch/parisc/include/uapi/asm/signal.h b/arch/parisc/include/uapi/asm/signal.h
> index d9c51769851a..9e6f87bc8a73 100644
> --- a/arch/parisc/include/uapi/asm/signal.h
> +++ b/arch/parisc/include/uapi/asm/signal.h
> @@ -68,14 +68,7 @@
>  #define MINSIGSTKSZ	2048
>  #define SIGSTKSZ	8192
>  
> -
> -#define SIG_BLOCK          0	/* for blocking signals */
> -#define SIG_UNBLOCK        1	/* for unblocking signals */
> -#define SIG_SETMASK        2	/* for setting the signal mask */
> -
> -#define SIG_DFL	((__sighandler_t)0)	/* default signal handling */
> -#define SIG_IGN	((__sighandler_t)1)	/* ignore signal */
> -#define SIG_ERR	((__sighandler_t)-1)	/* error return from signal */
> +#include <asm-generic/signal-defs.h>
>  
>  # ifndef __ASSEMBLY__
>  
> @@ -84,10 +77,6 @@
>  /* Avoid too many header ordering problems.  */
>  struct siginfo;
>  
> -/* Type of a signal handler.  */
> -typedef void __signalfn_t(int);
> -typedef __signalfn_t __user *__sighandler_t;
> -
>  typedef struct sigaltstack {
>  	void __user *ss_sp;
>  	int ss_flags;

Return-Path: <linux-api-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D9781C2D0E4
	for <linux-api@archiver.kernel.org>; Thu, 19 Nov 2020 13:11:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 813072222F
	for <linux-api@archiver.kernel.org>; Thu, 19 Nov 2020 13:11:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726691AbgKSNKo (ORCPT <rfc822;linux-api@archiver.kernel.org>);
        Thu, 19 Nov 2020 08:10:44 -0500
Received: from out03.mta.xmission.com ([166.70.13.233]:34510 "EHLO
        out03.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726480AbgKSNKn (ORCPT
        <rfc822;linux-api@vger.kernel.org>); Thu, 19 Nov 2020 08:10:43 -0500
Received: from in02.mta.xmission.com ([166.70.13.52])
        by out03.mta.xmission.com with esmtps  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.93)
        (envelope-from <ebiederm@xmission.com>)
        id 1kfjhs-003mfm-46; Thu, 19 Nov 2020 06:10:36 -0700
Received: from ip68-227-160-95.om.om.cox.net ([68.227.160.95] helo=x220.xmission.com)
        by in02.mta.xmission.com with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.93)
        (envelope-from <ebiederm@xmission.com>)
        id 1kfjhq-00AQiA-Tk; Thu, 19 Nov 2020 06:10:35 -0700
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
References: <20201118003853.926143-1-pcc@google.com>
Date:   Thu, 19 Nov 2020 07:10:15 -0600
In-Reply-To: <20201118003853.926143-1-pcc@google.com> (Peter Collingbourne's
        message of "Tue, 17 Nov 2020 16:38:53 -0800")
Message-ID: <87d0095w7c.fsf@x220.int.ebiederm.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-SPF: eid=1kfjhq-00AQiA-Tk;;;mid=<87d0095w7c.fsf@x220.int.ebiederm.org>;;;hst=in02.mta.xmission.com;;;ip=68.227.160.95;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX1+WshTqlvQExp62nNunxhMf47paEadUJp4=
X-SA-Exim-Connect-IP: 68.227.160.95
X-SA-Exim-Mail-From: ebiederm@xmission.com
Subject: Re: [PATCH v19] arm64: expose FAR_EL1 tag bits in siginfo
X-SA-Exim-Version: 4.2.1 (built Sat, 08 Feb 2020 21:53:50 +0000)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Precedence: bulk
List-ID: <linux-api.vger.kernel.org>
X-Mailing-List: linux-api@vger.kernel.org

Peter Collingbourne <pcc@google.com> writes:

> diff --git a/kernel/signal.c b/kernel/signal.c
> index 8f34819e80de..678cdeb235ae 100644
> --- a/kernel/signal.c
> +++ b/kernel/signal.c
> @@ -2524,6 +2524,26 @@ static int ptrace_signal(int signr, kernel_siginfo_t *info)
>  	return signr;
>  }
>  
> +static void hide_si_addr_tag_bits(struct ksignal *ksig)
> +{
> +	switch (siginfo_layout(ksig->sig, ksig->info.si_code)) {
> +	case SIL_FAULT:
> +	case SIL_FAULT_MCEERR:
> +	case SIL_FAULT_BNDERR:
> +	case SIL_FAULT_PKUERR:
> +		ksig->info.si_addr = arch_untagged_si_addr(
> +			ksig->info.si_addr, ksig->sig, ksig->info.si_code);
> +		break;
> +	case SIL_KILL:
> +	case SIL_TIMER:
> +	case SIL_POLL:
> +	case SIL_CHLD:
> +	case SIL_RT:
> +	case SIL_SYS:
> +		break;
> +	}
> +}
> +
>  bool get_signal(struct ksignal *ksig)
>  {
>  	struct sighand_struct *sighand = current->sighand;
> @@ -2761,6 +2781,10 @@ bool get_signal(struct ksignal *ksig)
>  	spin_unlock_irq(&sighand->siglock);
>  
>  	ksig->sig = signr;
> +
> +	if (!(sighand->action[signr - 1].sa.sa_flags & SA_EXPOSE_TAGBITS))
> +		hide_si_addr_tag_bits(ksig);
> +
>  	return ksig->sig > 0;
>  }

Ok.  Seeing that this code compiles out I don't have any concerns about
it's impact on other architectures.  And I like having it always
present as that makes all of the concerns the code has to deal with
easier to discover.

There is one small issue.  The test should be:
	if (!(ksig->ka.sa.sa_flags & SA_EXPOSE_TAGBITS))
		hide_si_addr_tag_bits(ksig);

Outside of sighand->siglock it is racy to access sighand->action and we
already have an atomic snapshot of the values for exactly this reason.

Is there some reason you didn't use ksig->ka?  Am I missing something?

I agree that our consumption of SA bits is slow enough that my other
concerns are a non-issue.

Eric

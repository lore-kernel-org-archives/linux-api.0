Return-Path: <linux-api-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 13A3FC4741F
	for <linux-api@archiver.kernel.org>; Tue, 10 Nov 2020 01:55:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B0E1E207D3
	for <linux-api@archiver.kernel.org>; Tue, 10 Nov 2020 01:55:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729847AbgKJBzY (ORCPT <rfc822;linux-api@archiver.kernel.org>);
        Mon, 9 Nov 2020 20:55:24 -0500
Received: from out02.mta.xmission.com ([166.70.13.232]:44600 "EHLO
        out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729648AbgKJBzY (ORCPT
        <rfc822;linux-api@vger.kernel.org>); Mon, 9 Nov 2020 20:55:24 -0500
Received: from in01.mta.xmission.com ([166.70.13.51])
        by out02.mta.xmission.com with esmtps  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
        (Exim 4.93)
        (envelope-from <ebiederm@xmission.com>)
        id 1kcIrz-00Ge4e-9r; Mon, 09 Nov 2020 18:54:51 -0700
Received: from ip68-227-160-95.om.om.cox.net ([68.227.160.95] helo=x220.xmission.com)
        by in01.mta.xmission.com with esmtpsa (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.87)
        (envelope-from <ebiederm@xmission.com>)
        id 1kcIry-0003Fo-Ds; Mon, 09 Nov 2020 18:54:51 -0700
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
        Haren Myneni <haren@linux.ibm.com>,
        Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>,
        Michael Ellerman <mpe@ellerman.id.au>
References: <cover.1604523707.git.pcc@google.com>
        <0eb601a5d1906fadd7099149eb605181911cfc04.1604523707.git.pcc@google.com>
Date:   Mon, 09 Nov 2020 19:54:41 -0600
In-Reply-To: <0eb601a5d1906fadd7099149eb605181911cfc04.1604523707.git.pcc@google.com>
        (Peter Collingbourne's message of "Wed, 4 Nov 2020 13:18:10 -0800")
Message-ID: <878sbavuvy.fsf@x220.int.ebiederm.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-SPF: eid=1kcIry-0003Fo-Ds;;;mid=<878sbavuvy.fsf@x220.int.ebiederm.org>;;;hst=in01.mta.xmission.com;;;ip=68.227.160.95;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX18QKp48VgGmpVZnr/9O10wTf/d0kgEIB6o=
X-SA-Exim-Connect-IP: 68.227.160.95
X-SA-Exim-Mail-From: ebiederm@xmission.com
Subject: Re: [PATCH v14 7/8] signal: define the field siginfo.si_faultflags
X-SA-Exim-Version: 4.2.1 (built Thu, 05 May 2016 13:38:54 -0600)
X-SA-Exim-Scanned: Yes (on in01.mta.xmission.com)
Precedence: bulk
List-ID: <linux-api.vger.kernel.org>
X-Mailing-List: linux-api@vger.kernel.org


Peter you are patching buggy code for your siginfo extension can
you please ignore vas-fault.c.  The code in vas-fault.c should
be fixed separately.  Futher it uses clear_siginfo so you should
get well defined behavior even if your new field is not initialized.

I have copied the powerpc folks so hopefully this buggy code
can be fixed.

> diff --git a/arch/powerpc/platforms/powernv/vas-fault.c b/arch/powerpc/platforms/powernv/vas-fault.c
> index 3d21fce254b7..877e7d5fb4a2 100644
> --- a/arch/powerpc/platforms/powernv/vas-fault.c
> +++ b/arch/powerpc/platforms/powernv/vas-fault.c
> @@ -154,6 +154,7 @@ static void update_csb(struct vas_window *window,
>  	info.si_errno = EFAULT;
>  	info.si_code = SEGV_MAPERR;
>  	info.si_addr = csb_addr;
> +	info.si_faultflags = 0;


Powerpc folks.  This code was introduced in c96c4436aba4 ("powerpc/vas:
Update CSB and notify process for fault CRBs") and is badly buggy.

Let me count the bugs:

a) Using kill_pid_info.  That performs a permission check that
   does not make sense from a kernel thread.

b) Manually filling in struct siginfo.  Everyone gets it wrong
   and the powerpc code is no exception setting si_errno when
   that is something Linux as a rule does not do.

Technically we have send_sig_fault to handle sending
a fault from a non-sychrnous context but I am not convinced
it make sense in this case.

c) Sending an asynchronous SIGSEGV with the si_code set to SEGV_MAPERR.
   How can userspace detect it is an asynchronous signal?  What can
   userspace do if it detects an asynchronous signal?  If userspace is
   so buggered as to give your kernel thread a bogus address I suspect
   uncerimonious sending SIGKILL is probably the best you can do.

There are some additional questionable things in that code like taking a
task_struct reference simply to be able to test tsk->flags but no
locks are held to ensure that tsk->flags are meaningful.  Nor are
any tests performed to see if the task being tested still uses
the designated mm.  I suspect exec could have been called.

In which case the code needs to check the mm, or at least play with
exec_id to ensure you are not improperly signaling a process after exec.

None of this is to say that update_csb is fundmentally bad or hard to
correct just that it has some significant defects in it's implementation
right now that need to be corrected.  I am hoping a detailed accounting
and pointing out those defects will allow the bug to be fixed.

Thank you,
Eric

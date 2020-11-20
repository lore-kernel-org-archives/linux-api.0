Return-Path: <linux-api-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.3 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_IN_DEF_DKIM_WL autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DA44AC2D0E4
	for <linux-api@archiver.kernel.org>; Fri, 20 Nov 2020 23:05:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 85D752408E
	for <linux-api@archiver.kernel.org>; Fri, 20 Nov 2020 23:05:07 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="LULwD43R"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728360AbgKTXFH (ORCPT <rfc822;linux-api@archiver.kernel.org>);
        Fri, 20 Nov 2020 18:05:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56012 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727241AbgKTXFG (ORCPT
        <rfc822;linux-api@vger.kernel.org>); Fri, 20 Nov 2020 18:05:06 -0500
Received: from mail-lj1-x243.google.com (mail-lj1-x243.google.com [IPv6:2a00:1450:4864:20::243])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 22D8CC0613CF
        for <linux-api@vger.kernel.org>; Fri, 20 Nov 2020 15:05:06 -0800 (PST)
Received: by mail-lj1-x243.google.com with SMTP id 11so11745088ljf.2
        for <linux-api@vger.kernel.org>; Fri, 20 Nov 2020 15:05:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=WsItiRlY2ZsY1kLHaN9bW+mg6xUUzDuK1HmeXy3qoOM=;
        b=LULwD43R9K6cuWxcFQ3hXHCXYhiJN+3GbIfFgwF3U+9D4uK3QRYGXhUNIUm/phAvgJ
         O1+dQBQPdrOTkni7W+oLdBOBc2AuCnoiRAW66303aXkiViycOcEDheImdEnAvuTIjXzp
         eLP5Sjq1o7lBd24nmSshBGwl7Y0U5t7ogW/mH3gP2dUJ1nM4usf4NwpQS82BRv6K9Yap
         EMrQjrG/eD9JrD4ypfMMHEas9+4anxoeUxQJeMNfyj46BkBpdcwCf7RtWmInwVepP2GK
         gV24+8jJQZTCASDuFsakteAbIMTSJCXGpatnCUddjQGQYa13xtA2KiDV3arQoVCzVSqZ
         QhLw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=WsItiRlY2ZsY1kLHaN9bW+mg6xUUzDuK1HmeXy3qoOM=;
        b=h90qocGQRtHP6VdknoiSFS0vw+JJUN1OF2UqyA8RGCZPfHoe0PN+4do+jm1IzZ+P9+
         tgG/5w0vqvVtHoi1BpAvww976KyvV4x30gQaD4ESh291N3kXbuTH41js69StP2V2GvUa
         +tuoKtWLLexXRhtsmyydZZYiYwbtcz8E9wM2cQK/nekaUebU56I68kmyw2l/sd1X9+vR
         S5jgXp8JVo+UHs5Z7Q46D/BoRxXQoVDGuRDL/Ozd/DzptoaM5kfPimnYfIs5yxyI25aN
         CrGBWDyJzYCMNRLs8635TmDC7bhD3gJHmRGuOVCOyfv1AcqwenH5nG3QRTG9J4acT5kP
         +3zA==
X-Gm-Message-State: AOAM533E9G6K3dsl5g+dPNoDYQhQVa185Cg0YsWRjNf50vd+No3TeOVR
        gOqs7OOKXIElnQLP8+NiPpVsVSuFo1I5wzrxAxc2sQ==
X-Google-Smtp-Source: ABdhPJymlpDCBYMRse6yxmhBac3FkYvw4MIKvsrIx7Zv7EbYRWZkOmL5ixX8POB9rfwViL1vOrupv+a/zLsoSj3iJio=
X-Received: by 2002:a2e:8891:: with SMTP id k17mr8457473lji.326.1605913504291;
 Fri, 20 Nov 2020 15:05:04 -0800 (PST)
MIME-Version: 1.0
References: <20201119190237.626-1-chang.seok.bae@intel.com> <20201119190237.626-4-chang.seok.bae@intel.com>
In-Reply-To: <20201119190237.626-4-chang.seok.bae@intel.com>
From:   Jann Horn <jannh@google.com>
Date:   Sat, 21 Nov 2020 00:04:38 +0100
Message-ID: <CAG48ez1aKtwYMEHfGX6_FuX9fOruwvCqEGYVL8eLdV8bg-wHCQ@mail.gmail.com>
Subject: Re: [PATCH v2 3/4] x86/signal: Prevent an alternate stack overflow
 before a signal delivery
To:     "Chang S. Bae" <chang.seok.bae@intel.com>
Cc:     Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@kernel.org>, Borislav Petkov <bp@suse.de>,
        Andy Lutomirski <luto@kernel.org>,
        "the arch/x86 maintainers" <x86@kernel.org>,
        Len Brown <len.brown@intel.com>,
        Dave Hansen <dave.hansen@intel.com>,
        "H.J. Lu" <hjl.tools@gmail.com>, Dave Martin <Dave.Martin@arm.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Tony Luck <tony.luck@intel.com>,
        "Ravi V. Shankar" <ravi.v.shankar@intel.com>,
        libc-alpha@sourceware.org, linux-arch <linux-arch@vger.kernel.org>,
        Linux API <linux-api@vger.kernel.org>,
        kernel list <linux-kernel@vger.kernel.org>,
        Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>,
        Roland McGrath <roland@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-api.vger.kernel.org>
X-Mailing-List: linux-api@vger.kernel.org

On Thu, Nov 19, 2020 at 8:40 PM Chang S. Bae <chang.seok.bae@intel.com> wrote:
> The kernel pushes data on the userspace stack when entering a signal. If
> using a sigaltstack(), the kernel precisely knows the user stack size.
>
> When the kernel knows that the user stack is too small, avoid the overflow
> and do an immediate SIGSEGV instead.
>
> This overflow is known to occur on systems with large XSAVE state. The
> effort to increase the size typically used for altstacks reduces the
> frequency of these overflows, but this approach is still useful for legacy
> binaries.
>
> Here the kernel expects a bit conservative stack size (for 64-bit apps).
> Legacy binaries used a too-small sigaltstack would be already overflowed
> before this change, if they run on modern hardware.
[...]
> diff --git a/arch/x86/kernel/signal.c b/arch/x86/kernel/signal.c
> index ee6f1ceaa7a2..cee41d684dc2 100644
> --- a/arch/x86/kernel/signal.c
> +++ b/arch/x86/kernel/signal.c
> @@ -251,8 +251,13 @@ get_sigframe(struct k_sigaction *ka, struct pt_regs *regs, size_t frame_size,
>
>         /* This is the X/Open sanctioned signal stack switching.  */
>         if (ka->sa.sa_flags & SA_ONSTACK) {
> -               if (sas_ss_flags(sp) == 0)
> +               if (sas_ss_flags(sp) == 0) {
> +                       /* If the altstack might overflow, die with SIGSEGV: */
> +                       if (!altstack_size_ok(current))
> +                               return (void __user *)-1L;
> +
>                         sp = current->sas_ss_sp + current->sas_ss_size;
> +               }

A couple lines further down, we have this (since commit 14fc9fbc700d):

        /*
         * If we are on the alternate signal stack and would overflow it, don't.
         * Return an always-bogus address instead so we will die with SIGSEGV.
         */
        if (onsigstack && !likely(on_sig_stack(sp)))
                return (void __user *)-1L;

Is that not working?


(It won't handle the case where the kernel fills up almost all of the
alternate stack, and the userspace signal handler then overflows out
of the alternate signal stack. But there isn't much the kernel can do
about that...)

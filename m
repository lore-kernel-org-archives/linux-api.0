Return-Path: <linux-api-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.2 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_IN_DEF_DKIM_WL autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BE828C433E0
	for <linux-api@archiver.kernel.org>; Wed, 23 Dec 2020 06:56:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7BD6B207C9
	for <linux-api@archiver.kernel.org>; Wed, 23 Dec 2020 06:56:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726960AbgLWG42 (ORCPT <rfc822;linux-api@archiver.kernel.org>);
        Wed, 23 Dec 2020 01:56:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50150 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726912AbgLWG42 (ORCPT
        <rfc822;linux-api@vger.kernel.org>); Wed, 23 Dec 2020 01:56:28 -0500
Received: from mail-lf1-x135.google.com (mail-lf1-x135.google.com [IPv6:2a00:1450:4864:20::135])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 20AFEC061793
        for <linux-api@vger.kernel.org>; Tue, 22 Dec 2020 22:55:48 -0800 (PST)
Received: by mail-lf1-x135.google.com with SMTP id l11so37800940lfg.0
        for <linux-api@vger.kernel.org>; Tue, 22 Dec 2020 22:55:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=cZrzhSr/pdKYEZLCm/lYn281E5FTFj+lBXgzuYqewis=;
        b=nUiKhlODqvOOJyPNarx/Nboy2R+vlNQKWf2xevquzD2q9ylevyGtjrnYv73ZgaKGCl
         AhgxNvlObBaRR6giZMiP9DG25vWreYD/plnVWYqnGexQPZCI/Ny/i8DcpmFWmujU4+x4
         dQ0dOkYZhLM9RFfp+uMm5Xv5nG23kXo+gRCH+Tr+Fr90EKuF12OAdXtu+lsCMhyAj0Dm
         mF7Ph7YEzlls+FiS2B/dAqbwVMR+uuTt2fJ4GJH3035s3I2mWJ3oNkLsZHgD9FqEP9Dm
         UZYWri/e6+oeKz0nLPKlMleF3U/zdQkZHqaXHjHk+CmLG785I/7iSP24lFFpI9WRPmSD
         vdWg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=cZrzhSr/pdKYEZLCm/lYn281E5FTFj+lBXgzuYqewis=;
        b=kR0PVORb/jDXypWlwCLGCmrtZ8Amau4lAgS+6xcXbudqgF7jLzibgYxZ5P1+DAGyDO
         j2+cn2SXx2YibK7IGbWn0YJMu7peWKMClLC+VbA2wjGsgVWCk7LVjg2xDuHeDVV063Eg
         Hu8lnKi2LYui//YIAyY1cK+YJEBCNmjFQqeRJuX67B0ABM2yzIRm2ADEagbYHJCiYiIH
         HagF7Q3L93kpNlsn4iXU+Gtu7bYzhg8RfAUjCO8309ztjWJ/cmqmW7kIH2IF1kEecWqZ
         kzWtOpN8T1RtrOVWeKcTMyXI6dj1WAsN2L55NM618Ukeiw0EosLEA9Ey0u2aoS0B65H/
         ju2Q==
X-Gm-Message-State: AOAM530+Yq693At7JjHoe3pYIRut62tUmJ2xa+6gq3rglvayjZOiWzro
        SnFkISxhdVkHYbNOUuBQNikXlNPTl9SxM37yW+QPkQ==
X-Google-Smtp-Source: ABdhPJzUibak7saO69q2IER/bv8m/ek3L5xMqti48cwKFVaG0wWfgD/FVu6xgRAegVLz7MKomb65av51F9mk94AENWY=
X-Received: by 2002:a19:c8cc:: with SMTP id y195mr10145396lff.352.1608706546238;
 Tue, 22 Dec 2020 22:55:46 -0800 (PST)
MIME-Version: 1.0
References: <20201223015312.4882-1-chang.seok.bae@intel.com> <20201223015312.4882-4-chang.seok.bae@intel.com>
In-Reply-To: <20201223015312.4882-4-chang.seok.bae@intel.com>
From:   Jann Horn <jannh@google.com>
Date:   Wed, 23 Dec 2020 07:55:20 +0100
Message-ID: <CAG48ez1yZBYPXvqxW8k7uH+jAFkkLK1KNijgPPw+Kp-8gnp-sQ@mail.gmail.com>
Subject: Re: [PATCH v3 3/4] x86/signal: Prevent an alternate stack overflow
 before a signal delivery
To:     "Chang S. Bae" <chang.seok.bae@intel.com>
Cc:     Borislav Petkov <bp@suse.de>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@kernel.org>,
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
        kernel list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-api.vger.kernel.org>
X-Mailing-List: linux-api@vger.kernel.org

On Wed, Dec 23, 2020 at 2:57 AM Chang S. Bae <chang.seok.bae@intel.com> wrote:
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
> Suggested-by: Jann Horn <jannh@google.com>
> Signed-off-by: Chang S. Bae <chang.seok.bae@intel.com>
> Reviewed-by: Len Brown <len.brown@intel.com>
> Cc: Jann Horn <jannh@google.com>
> Cc: x86@kernel.org
> Cc: linux-kernel@vger.kernel.org

Reviewed-by: Jann Horn <jannh@google.com>

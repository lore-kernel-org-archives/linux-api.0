Return-Path: <linux-api-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F0B53C433DB
	for <linux-api@archiver.kernel.org>; Fri,  5 Feb 2021 18:30:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9AD0764F03
	for <linux-api@archiver.kernel.org>; Fri,  5 Feb 2021 18:30:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233331AbhBEQrW (ORCPT <rfc822;linux-api@archiver.kernel.org>);
        Fri, 5 Feb 2021 11:47:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45058 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233453AbhBEQpN (ORCPT
        <rfc822;linux-api@vger.kernel.org>); Fri, 5 Feb 2021 11:45:13 -0500
Received: from mail-pf1-x435.google.com (mail-pf1-x435.google.com [IPv6:2607:f8b0:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0EDBFC061756
        for <linux-api@vger.kernel.org>; Fri,  5 Feb 2021 10:26:55 -0800 (PST)
Received: by mail-pf1-x435.google.com with SMTP id b145so4893345pfb.4
        for <linux-api@vger.kernel.org>; Fri, 05 Feb 2021 10:26:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=9PTifcKN8spL3ClpqXcFGHeUFpoZ67atZiPMBU3wuDs=;
        b=HS3+D2H5qhhSXm5Mhv9pAeIQrIxIDrLLhrbubqDRQEHMzcshMMVXCtDGapcRO+w0Mh
         Ry8wZrTRSu5DzM6JkcjQdB4e+rwquqcyHdk4BllNxbt4vd8dhxxn1Gu3pKXPPcBOYGMW
         19euoavfkMowdIXaQ6HyNSFWSTVzj4YuS1o84=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=9PTifcKN8spL3ClpqXcFGHeUFpoZ67atZiPMBU3wuDs=;
        b=IQg05aM/PgoLfQSB6+MvxbGmgFRr9OYB6BBSRyK8RIJO+iOK+IA8sHjLxYHdZzTULr
         rDnbwwoMEkoqiodOZ/vDe4eybvXx3F8fpnUt+KuXmdEQLSVOd+c17iWkxord/T1GBlue
         L38ywoP/imHjjEgowFW4UP8EYJg+s5znioewPOqGaop4BPVHpzVAu7k0XVk4n0kH9tlD
         XQLedEML1ifGg7KW0N5lCAVHqEsBlxiXUJHQThsh2gUFE3BZBGJT4i6qmVcSwhirk6lI
         cCdLyzGtrP4dybGUyN6uOzlU+V95nbAEJeNBEHbnPGzeqd7oWSgi+IjGDDkLBfELvruB
         t5eQ==
X-Gm-Message-State: AOAM531BXYd3D6hgRAAik39mZ0FTzXPEbkNVz5tWfKVI6Lh6olfp7hR4
        qjacqqdZBC840ti4lIZJk4Xnuw==
X-Google-Smtp-Source: ABdhPJyovoQ5m59St1KtJeobhPYp42OO5wY6rGeSKoIt1K/gK6R9dUzhVZK3/QwGz1Hw+E4zxyllEA==
X-Received: by 2002:a63:1c08:: with SMTP id c8mr5528896pgc.228.1612549614604;
        Fri, 05 Feb 2021 10:26:54 -0800 (PST)
Received: from www.outflux.net (smtp.outflux.net. [198.145.64.163])
        by smtp.gmail.com with ESMTPSA id m4sm3441246pfd.130.2021.02.05.10.26.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 05 Feb 2021 10:26:53 -0800 (PST)
Date:   Fri, 5 Feb 2021 10:26:52 -0800
From:   Kees Cook <keescook@chromium.org>
To:     "Yu, Yu-cheng" <yu-cheng.yu@intel.com>
Cc:     x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-mm@kvack.org,
        linux-arch@vger.kernel.org, linux-api@vger.kernel.org,
        Arnd Bergmann <arnd@arndb.de>,
        Andy Lutomirski <luto@kernel.org>,
        Balbir Singh <bsingharora@gmail.com>,
        Borislav Petkov <bp@alien8.de>,
        Cyrill Gorcunov <gorcunov@gmail.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Eugene Syromiatnikov <esyr@redhat.com>,
        Florian Weimer <fweimer@redhat.com>,
        "H.J. Lu" <hjl.tools@gmail.com>, Jann Horn <jannh@google.com>,
        Jonathan Corbet <corbet@lwn.net>,
        Mike Kravetz <mike.kravetz@oracle.com>,
        Nadav Amit <nadav.amit@gmail.com>,
        Oleg Nesterov <oleg@redhat.com>, Pavel Machek <pavel@ucw.cz>,
        Peter Zijlstra <peterz@infradead.org>,
        Randy Dunlap <rdunlap@infradead.org>,
        "Ravi V. Shankar" <ravi.v.shankar@intel.com>,
        Vedvyas Shanbhogue <vedvyas.shanbhogue@intel.com>,
        Dave Martin <Dave.Martin@arm.com>,
        Weijiang Yang <weijiang.yang@intel.com>,
        Pengfei Xu <pengfei.xu@intel.com>
Subject: Re: [PATCH v19 24/25] x86/cet/shstk: Add arch_prctl functions for
 shadow stack
Message-ID: <202102051026.B250352D4@keescook>
References: <20210203225547.32221-1-yu-cheng.yu@intel.com>
 <20210203225547.32221-25-yu-cheng.yu@intel.com>
 <202102041235.BA6C4982F@keescook>
 <6d7dd90f-dc03-06ce-57a2-57e4c2f803f3@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6d7dd90f-dc03-06ce-57a2-57e4c2f803f3@intel.com>
Precedence: bulk
List-ID: <linux-api.vger.kernel.org>
X-Mailing-List: linux-api@vger.kernel.org

On Thu, Feb 04, 2021 at 03:41:59PM -0800, Yu, Yu-cheng wrote:
> On 2/4/2021 12:35 PM, Kees Cook wrote:
> > On Wed, Feb 03, 2021 at 02:55:46PM -0800, Yu-cheng Yu wrote:
> > > arch_prctl(ARCH_X86_CET_STATUS, u64 *args)
> > >      Get CET feature status.
> > > 
> > >      The parameter 'args' is a pointer to a user buffer.  The kernel returns
> > >      the following information:
> > > 
> > >      *args = shadow stack/IBT status
> > >      *(args + 1) = shadow stack base address
> > >      *(args + 2) = shadow stack size
> > 
> > What happens if this needs to grow in the future? Should the first u64
> > contain the array size?
> > 
> > Otherwise, looks sensible.
> > 
> > -Kees
> > 
> 
> The first item is a bitmap, and there are two possible bits.  Should there
> be a need, we can then do things about it.  My thought at the moment is, we
> may not meet the situation.  Can we keep this for now?

Ah, good point. Yes, since that's a bitmap it ends up describing what
follows. This is fine as-is. Thanks!

Reviewed-by: Kees Cook <keescook@chromium.org>


-- 
Kees Cook

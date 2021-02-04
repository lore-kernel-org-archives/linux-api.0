Return-Path: <linux-api-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F051CC433E0
	for <linux-api@archiver.kernel.org>; Thu,  4 Feb 2021 20:31:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A0B4264E35
	for <linux-api@archiver.kernel.org>; Thu,  4 Feb 2021 20:31:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240152AbhBDUbN (ORCPT <rfc822;linux-api@archiver.kernel.org>);
        Thu, 4 Feb 2021 15:31:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47480 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240194AbhBDUaj (ORCPT
        <rfc822;linux-api@vger.kernel.org>); Thu, 4 Feb 2021 15:30:39 -0500
Received: from mail-pj1-x102e.google.com (mail-pj1-x102e.google.com [IPv6:2607:f8b0:4864:20::102e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9DC88C061797
        for <linux-api@vger.kernel.org>; Thu,  4 Feb 2021 12:29:58 -0800 (PST)
Received: by mail-pj1-x102e.google.com with SMTP id z9so2485867pjl.5
        for <linux-api@vger.kernel.org>; Thu, 04 Feb 2021 12:29:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=MzlCpCkLmxVsznheZI3EKTdR1f5kwqDGSaj2tE3igtU=;
        b=Gvshsbpw/2T8JIx2xC/Yj1b2gosWPoRbQqc9xnkQx6kZGmYOkUDhIB27gDkHZnhhkP
         YdNd6b0Qa3SsOJVZqFNbXe8+62GV0NeDEla1b6JqwqrIG28L1AlU7jaybevMTho6JcaU
         mRQIoa+gy6PKrbFD08moLs/Jau2larhRyAN+o=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=MzlCpCkLmxVsznheZI3EKTdR1f5kwqDGSaj2tE3igtU=;
        b=Wxg/JLJsxHhDAUt2vqHt0P0gkskSL3JMYXQrIpz+9Un2CX/uXYHpf7fpPEI/SycHY2
         rEyaWNS74j9RITtydGvAzJXkOZ63jpKIhLYqxGVA/tibhsXT3ZbqLqLsLrQmY3xs5Gj1
         HeYozpEGht15EvkQKzIOp8Esr8QNebSCDK6BLtySlddQz6vSAFcSh/Oti5BaaIZ3zpSw
         37z7H0yH6rQvnS5igqkId/UmQckS1GKAw8uJYy8mSwmrUp/lCSGLKdY4FyQ91XWmjbLV
         fXKjnGF8OtYR8VOQ5z1OVgeLBQQKSbMEE2Ha5ht4wW3czSXtyNWwFg0rJX7S0nzb9Yv5
         eKlA==
X-Gm-Message-State: AOAM5319kU2kFh7KXC1l9j44qvR8K6uIBEYk4uZgetKNmOPYyeB1BXoB
        aUOIFXcv/whQU87lYuxCPfddqA==
X-Google-Smtp-Source: ABdhPJwZQMO8NMtHz9UcwGY1H2/3ntfrSkqcPsM14xB1bASd6IqHz3hxpya84TyWYDZMuPiE8WFqIA==
X-Received: by 2002:a17:90b:949:: with SMTP id dw9mr788298pjb.20.1612470598230;
        Thu, 04 Feb 2021 12:29:58 -0800 (PST)
Received: from www.outflux.net (smtp.outflux.net. [198.145.64.163])
        by smtp.gmail.com with ESMTPSA id j1sm6846456pfr.78.2021.02.04.12.29.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 04 Feb 2021 12:29:57 -0800 (PST)
Date:   Thu, 4 Feb 2021 12:29:56 -0800
From:   Kees Cook <keescook@chromium.org>
To:     Yu-cheng Yu <yu-cheng.yu@intel.com>
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
Subject: Re: [PATCH v19 20/25] x86/cet/shstk: User-mode shadow stack support
Message-ID: <202102041229.237544D@keescook>
References: <20210203225547.32221-1-yu-cheng.yu@intel.com>
 <20210203225547.32221-21-yu-cheng.yu@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210203225547.32221-21-yu-cheng.yu@intel.com>
Precedence: bulk
List-ID: <linux-api.vger.kernel.org>
X-Mailing-List: linux-api@vger.kernel.org

On Wed, Feb 03, 2021 at 02:55:42PM -0800, Yu-cheng Yu wrote:
> Introduce basic shadow stack enabling/disabling/allocation routines.
> A task's shadow stack is allocated from memory with VM_SHSTK flag and has
> a fixed size of min(RLIMIT_STACK, 4GB).
> 
> Signed-off-by: Yu-cheng Yu <yu-cheng.yu@intel.com>

Reviewed-by: Kees Cook <keescook@chromium.org>

-- 
Kees Cook

Return-Path: <linux-api-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 20363C433DB
	for <linux-api@archiver.kernel.org>; Thu,  4 Feb 2021 20:29:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DE57B64E3F
	for <linux-api@archiver.kernel.org>; Thu,  4 Feb 2021 20:29:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239250AbhBDU3B (ORCPT <rfc822;linux-api@archiver.kernel.org>);
        Thu, 4 Feb 2021 15:29:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47070 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240175AbhBDU2u (ORCPT
        <rfc822;linux-api@vger.kernel.org>); Thu, 4 Feb 2021 15:28:50 -0500
Received: from mail-pl1-x632.google.com (mail-pl1-x632.google.com [IPv6:2607:f8b0:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4EEEAC06178B
        for <linux-api@vger.kernel.org>; Thu,  4 Feb 2021 12:28:09 -0800 (PST)
Received: by mail-pl1-x632.google.com with SMTP id j11so2358554plt.11
        for <linux-api@vger.kernel.org>; Thu, 04 Feb 2021 12:28:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=IZXHMkkF5la794RToqIjRZW5Sf0o5ADpzH8P/DUSqM8=;
        b=WPv79kCio4eGaa+1n6kJbUiCr+03EUTatrYglWJE03qfeFrKHQzZVbBtF49ld+k4ze
         7lEEgOI28vEeRahv9M+5hNCWfrIKDpDdagm/LThs/rcnb6mqbDMlpyjeSuswWn5/cjQF
         8HEg8Q2Ubdq/QtSINwilr9Xr1IyuglpkxjnlI=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=IZXHMkkF5la794RToqIjRZW5Sf0o5ADpzH8P/DUSqM8=;
        b=LUeAtnJ9wAbEnheXey/erB9kzsNtdzpiyRojolUh3HsoBOH00AkJ3bktL4mpe5pwZK
         JZybQgW3FV7E/HE26FIj24+H7XWZQI5fqe5fYYfUFAaNwSEvKC07uTbHEIaGK4AUoWke
         72SkR8leSuBipzIHau4AKpeXpvdKjL3fqgl7yvEzDxNZX6IHRFFJzd818vXqkiILvESA
         +jhgCqXq67/ER4iLGZVkvi4WZfo0f0fsHNrG0/xlTmx8i8WnPA6WJ5cM/li8X26dQhgf
         5tm9bZ/zxaJPe9gGLynh/oD6nKZoTeu9BxDydTGGEQVDDoAlPcOMYOjAbHRSD9DRCQFp
         bxDQ==
X-Gm-Message-State: AOAM532+IUhX74YuOS6Ulk0s1kXv1aXKEKqigwphwJ93RTpO6ZdG/mGA
        UErSOZMs3ixBhEfCyjpCktQjTw==
X-Google-Smtp-Source: ABdhPJxaLK/3FaRcCdBuM/ynvQhoUqRuwNE06CjEMBKRxvH0MC7s6Ljyc3PQcHyuCfh0R5pvWUrRfw==
X-Received: by 2002:a17:90b:4d06:: with SMTP id mw6mr708971pjb.24.1612470488976;
        Thu, 04 Feb 2021 12:28:08 -0800 (PST)
Received: from www.outflux.net (smtp.outflux.net. [198.145.64.163])
        by smtp.gmail.com with ESMTPSA id b26sm6838438pfo.202.2021.02.04.12.28.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 04 Feb 2021 12:28:08 -0800 (PST)
Date:   Thu, 4 Feb 2021 12:28:07 -0800
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
        Pengfei Xu <pengfei.xu@intel.com>,
        Peter Collingbourne <pcc@google.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH v19 19/25] mm: Re-introduce vm_flags to do_mmap()
Message-ID: <202102041228.E6FED55C@keescook>
References: <20210203225547.32221-1-yu-cheng.yu@intel.com>
 <20210203225547.32221-20-yu-cheng.yu@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210203225547.32221-20-yu-cheng.yu@intel.com>
Precedence: bulk
List-ID: <linux-api.vger.kernel.org>
X-Mailing-List: linux-api@vger.kernel.org

On Wed, Feb 03, 2021 at 02:55:41PM -0800, Yu-cheng Yu wrote:
> There was no more caller passing vm_flags to do_mmap(), and vm_flags was
> removed from the function's input by:
> 
>     commit 45e55300f114 ("mm: remove unnecessary wrapper function do_mmap_pgoff()").
> 
> There is a new user now.  Shadow stack allocation passes VM_SHSTK to
> do_mmap().  Re-introduce vm_flags to do_mmap(), but without the old wrapper
> do_mmap_pgoff().  Instead, make all callers of the wrapper pass a zero
> vm_flags to do_mmap().
> 
> Signed-off-by: Yu-cheng Yu <yu-cheng.yu@intel.com>

Reviewed-by: Kees Cook <keescook@chromium.org>

-- 
Kees Cook

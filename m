Return-Path: <linux-api-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CC8FAC433E0
	for <linux-api@archiver.kernel.org>; Thu,  4 Feb 2021 19:54:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8C84964E02
	for <linux-api@archiver.kernel.org>; Thu,  4 Feb 2021 19:54:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239229AbhBDTyQ (ORCPT <rfc822;linux-api@archiver.kernel.org>);
        Thu, 4 Feb 2021 14:54:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38896 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237957AbhBDTv7 (ORCPT
        <rfc822;linux-api@vger.kernel.org>); Thu, 4 Feb 2021 14:51:59 -0500
Received: from mail-pf1-x430.google.com (mail-pf1-x430.google.com [IPv6:2607:f8b0:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6005EC06121F
        for <linux-api@vger.kernel.org>; Thu,  4 Feb 2021 11:50:23 -0800 (PST)
Received: by mail-pf1-x430.google.com with SMTP id o20so2793394pfu.0
        for <linux-api@vger.kernel.org>; Thu, 04 Feb 2021 11:50:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=OCBNpOzMc8CAOBfAgX/jLAhp/SQecCvHp/iShWPRCZQ=;
        b=UzKHJoHstJUn1+EShPvxaJaqClm9LA26kdmfw9zDnAdyzrAY6CqEgnlW45I0CJthX4
         DDUOM1Ntq+iwMd+/8nEiBF24eu4IJc41zF9EcSwZWNb05Nf6D9yLHf7Eb2Pyi63otlod
         3RwHieM8ryVd+jiq/SMM936MFgxNwHfq3RlWc=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=OCBNpOzMc8CAOBfAgX/jLAhp/SQecCvHp/iShWPRCZQ=;
        b=HKH3dl7XGXB4FNDbZbq++/eVQ1y1TNCgd57KuRqhYwZkg5fJ5WndiAmKBXd4XiBApF
         Lkju1ESg88KzYozqr3/GOBR2Vcg16+gW+hfTNt+9GBCamAUPRaYwHzIzHJm+ECCtD8sQ
         VleRewZfKKuaDzc53LJwxInFRF2schYHfojP2QN2n4guqZ121boN2lqvBgWgKQZWhudL
         N5epp62HJWa+R6lwsdP7Ad8n3q8q6NxkzSKy5Ewn1vffSReLjWH00cjjMHEkXdyKWP1E
         k9rNsJp0u0fpV9sTyM6YypogjtXCaVprqmMf/rmVDrepRnRWO/2XM+0zABrMDPowRRD+
         httw==
X-Gm-Message-State: AOAM532zIv5fPnDcHagugXkoa/aWFPXqVQ23PTMnCfkdY0+Alnd5bS95
        WCdHxD8QH9gTu/lWZkX9/XLVtg==
X-Google-Smtp-Source: ABdhPJwi3qGotMQdzbjuJor6PdBiBP52TZP1QRJ9SqH5R+oUXMnOHkiFLvDUNqFp4od9u/7BXFE1Fw==
X-Received: by 2002:a63:794a:: with SMTP id u71mr592348pgc.91.1612468222994;
        Thu, 04 Feb 2021 11:50:22 -0800 (PST)
Received: from www.outflux.net (smtp.outflux.net. [198.145.64.163])
        by smtp.gmail.com with ESMTPSA id r7sm6299408pfc.26.2021.02.04.11.50.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 04 Feb 2021 11:50:22 -0800 (PST)
Date:   Thu, 4 Feb 2021 11:50:21 -0800
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
Subject: Re: [PATCH v19 5/7] x86/cet/ibt: Update arch_prctl functions for
 Indirect Branch Tracking
Message-ID: <202102041150.6186296C3@keescook>
References: <20210203225902.479-1-yu-cheng.yu@intel.com>
 <20210203225902.479-6-yu-cheng.yu@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210203225902.479-6-yu-cheng.yu@intel.com>
Precedence: bulk
List-ID: <linux-api.vger.kernel.org>
X-Mailing-List: linux-api@vger.kernel.org

On Wed, Feb 03, 2021 at 02:59:00PM -0800, Yu-cheng Yu wrote:
> From: "H.J. Lu" <hjl.tools@gmail.com>
> 
> Update ARCH_X86_CET_STATUS and ARCH_X86_CET_DISABLE for Indirect Branch
> Tracking.
> 
> Signed-off-by: H.J. Lu <hjl.tools@gmail.com>

Reviewed-by: Kees Cook <keescook@chromium.org>

-- 
Kees Cook

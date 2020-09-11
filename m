Return-Path: <SRS0=82cJ=CU=vger.kernel.org=linux-api-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.5 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C5BF3C43461
	for <linux-api@archiver.kernel.org>; Fri, 11 Sep 2020 09:35:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6AB3F20735
	for <linux-api@archiver.kernel.org>; Fri, 11 Sep 2020 09:35:57 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="OHP6NY3a"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725766AbgIKJf5 (ORCPT <rfc822;linux-api@archiver.kernel.org>);
        Fri, 11 Sep 2020 05:35:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35824 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725710AbgIKJf4 (ORCPT
        <rfc822;linux-api@vger.kernel.org>); Fri, 11 Sep 2020 05:35:56 -0400
Received: from merlin.infradead.org (merlin.infradead.org [IPv6:2001:8b0:10b:1231::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4544FC061573;
        Fri, 11 Sep 2020 02:35:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=merlin.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=ahpwR8TBD77mfd9yBZswIDaF9X/0frtlU0juWV51o08=; b=OHP6NY3aVOUVW3+DAGp1oAqGkO
        q3PdpUUqSCkfF2gvVwOHaYA1ry/mGdx4NY0KusJ8T3y7ESDvIy9Q3PzZa68tAt8/H9oyoaW1xriGW
        Z71b19zBiFVDB/Do1FW0CXVKFQceiAXqjginTsLNoWrg0Gj1J0Rk4fFefOJ6waWqmZK6nlAItoVXV
        hvfUdoJkDMViNd463bFeki5JX+mmuG3QRGWDHUNHh+4GrloMX/mCD96nF8NVD6pSR5iLeJp8hesWK
        ZRDcf3a4f4Qw4/NsEwCa2CBLwx+y5RydyMtBaFHhA1ORp9zatiRuY5mfj6E8BNmNbyF9CMZRDTlTd
        6ekTfp9g==;
Received: from j217100.upc-j.chello.nl ([24.132.217.100] helo=noisy.programming.kicks-ass.net)
        by merlin.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1kGfTC-0003fQ-SK; Fri, 11 Sep 2020 09:35:51 +0000
Received: from hirez.programming.kicks-ass.net (hirez.programming.kicks-ass.net [192.168.1.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (Client did not present a certificate)
        by noisy.programming.kicks-ass.net (Postfix) with ESMTPS id AA6143003D8;
        Fri, 11 Sep 2020 11:35:49 +0200 (CEST)
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 1000)
        id 92EE52B06B001; Fri, 11 Sep 2020 11:35:49 +0200 (CEST)
Date:   Fri, 11 Sep 2020 11:35:49 +0200
From:   peterz@infradead.org
To:     Gabriel Krisman Bertazi <krisman@collabora.com>
Cc:     luto@kernel.org, tglx@linutronix.de, keescook@chromium.org,
        x86@kernel.org, linux-kernel@vger.kernel.org,
        linux-api@vger.kernel.org, willy@infradead.org,
        linux-kselftest@vger.kernel.org, shuah@kernel.org,
        kernel@collabora.com
Subject: Re: [PATCH v6 2/9] kernel: entry: Support TIF_SYSCAL_INTERCEPT on
 common entry code
Message-ID: <20200911093549.GE1362448@hirez.programming.kicks-ass.net>
References: <20200904203147.2908430-1-krisman@collabora.com>
 <20200904203147.2908430-3-krisman@collabora.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200904203147.2908430-3-krisman@collabora.com>
Sender: linux-api-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-api.vger.kernel.org>
X-Mailing-List: linux-api@vger.kernel.org

On Fri, Sep 04, 2020 at 04:31:40PM -0400, Gabriel Krisman Bertazi wrote:
> diff --git a/include/linux/entry-common.h b/include/linux/entry-common.h
> index efebbffcd5cc..72ce9ca860c6 100644
> --- a/include/linux/entry-common.h
> +++ b/include/linux/entry-common.h
> @@ -21,10 +21,6 @@
>  # define _TIF_SYSCALL_TRACEPOINT	(0)
>  #endif
>  
> -#ifndef _TIF_SECCOMP
> -# define _TIF_SECCOMP			(0)
> -#endif
> -
>  #ifndef _TIF_SYSCALL_AUDIT
>  # define _TIF_SYSCALL_AUDIT		(0)
>  #endif

Why doesn't this add:

#ifndef _TIF_SYSCALL_INTERCEPT
#define _TIF_SYSCALL_INTERCEPT		(0)
#endif

?


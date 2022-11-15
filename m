Return-Path: <linux-api-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E6D3CC4332F
	for <linux-api@archiver.kernel.org>; Tue, 15 Nov 2022 21:21:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230150AbiKOVVx (ORCPT <rfc822;linux-api@archiver.kernel.org>);
        Tue, 15 Nov 2022 16:21:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45958 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238721AbiKOVVi (ORCPT
        <rfc822;linux-api@vger.kernel.org>); Tue, 15 Nov 2022 16:21:38 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D6CA622BE2;
        Tue, 15 Nov 2022 13:21:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=jyzmEr4cHGVGKNQhNNbBOlgxr4jXKGD4BchDIVtlcro=; b=NwPV9AHgyIRQlucAh4FcsMwAOs
        sVX8UcmQCWS2heUX7yeqIIKYCW8O+SgIYVss4Frf/CZCwbcorV5LNergejNUOnGucbifrCwQrD2wY
        erASJ9KzLY+H9oxQGqzih5UjNMAsgEaSblPAO1xo3T5745Y4CxbnEIAT6A9rG++PWmM/POe76j3z/
        r9p3Zuh48h7BQPO02U2V2LAi4LpgB0dId3Nnxqhsyiysn4x1bCSRHGSwot7yLicCEXv2K3Ij2wZr6
        x775LQ7L1mTW5ss6YM6Inz4YyMZFwhXEB/UKcVb5NNmVVBHKtWfeTKDt6158rRsLMKUWAYaE/Y9PR
        nAXBtW6Q==;
Received: from j130084.upc-j.chello.nl ([24.132.130.84] helo=noisy.programming.kicks-ass.net)
        by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1ov3Ml-00Gf7A-9s; Tue, 15 Nov 2022 21:21:11 +0000
Received: from hirez.programming.kicks-ass.net (hirez.programming.kicks-ass.net [192.168.1.225])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits))
        (Client did not present a certificate)
        by noisy.programming.kicks-ass.net (Postfix) with ESMTPS id 412C8300244;
        Tue, 15 Nov 2022 22:21:04 +0100 (CET)
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 1000)
        id 2A30A2C0E2D26; Tue, 15 Nov 2022 22:21:04 +0100 (CET)
Date:   Tue, 15 Nov 2022 22:21:04 +0100
From:   Peter Zijlstra <peterz@infradead.org>
To:     Dave Hansen <dave.hansen@intel.com>
Cc:     "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>,
        "bsingharora@gmail.com" <bsingharora@gmail.com>,
        "hpa@zytor.com" <hpa@zytor.com>,
        "Syromiatnikov, Eugene" <esyr@redhat.com>,
        "rdunlap@infradead.org" <rdunlap@infradead.org>,
        "keescook@chromium.org" <keescook@chromium.org>,
        "dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>,
        "kirill.shutemov@linux.intel.com" <kirill.shutemov@linux.intel.com>,
        "Eranian, Stephane" <eranian@google.com>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "fweimer@redhat.com" <fweimer@redhat.com>,
        "nadav.amit@gmail.com" <nadav.amit@gmail.com>,
        "jannh@google.com" <jannh@google.com>,
        "dethoma@microsoft.com" <dethoma@microsoft.com>,
        "rppt@linux.ibm.com" <rppt@linux.ibm.com>,
        "linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>,
        "kcc@google.com" <kcc@google.com>, "bp@alien8.de" <bp@alien8.de>,
        "oleg@redhat.com" <oleg@redhat.com>,
        "hjl.tools@gmail.com" <hjl.tools@gmail.com>,
        "Yang, Weijiang" <weijiang.yang@intel.com>,
        "Lutomirski, Andy" <luto@kernel.org>,
        "pavel@ucw.cz" <pavel@ucw.cz>, "arnd@arndb.de" <arnd@arndb.de>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "mike.kravetz@oracle.com" <mike.kravetz@oracle.com>,
        "x86@kernel.org" <x86@kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "jamorris@linux.microsoft.com" <jamorris@linux.microsoft.com>,
        "rppt@kernel.org" <rppt@kernel.org>,
        "john.allen@amd.com" <john.allen@amd.com>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "Shankar, Ravi V" <ravi.v.shankar@intel.com>,
        "corbet@lwn.net" <corbet@lwn.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-api@vger.kernel.org" <linux-api@vger.kernel.org>,
        "gorcunov@gmail.com" <gorcunov@gmail.com>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>
Subject: Re: [PATCH v3 36/37] x86/cet/shstk: Add ARCH_CET_UNLOCK
Message-ID: <Y3QCwOJ6Soqnecrt@hirez.programming.kicks-ass.net>
References: <20221104223604.29615-1-rick.p.edgecombe@intel.com>
 <20221104223604.29615-37-rick.p.edgecombe@intel.com>
 <Y3OmaSjhCtjht1nS@hirez.programming.kicks-ass.net>
 <4273232513cd178be303d817b15e442703bda637.camel@intel.com>
 <Y3P9V1c0ytuC2/3g@hirez.programming.kicks-ass.net>
 <93029063-4a68-d275-b437-12930e119347@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <93029063-4a68-d275-b437-12930e119347@intel.com>
Precedence: bulk
List-ID: <linux-api.vger.kernel.org>
X-Mailing-List: linux-api@vger.kernel.org

On Tue, Nov 15, 2022 at 01:00:40PM -0800, Dave Hansen wrote:
> On 11/15/22 12:57, Peter Zijlstra wrote:
> > On Tue, Nov 15, 2022 at 08:01:12PM +0000, Edgecombe, Rick P wrote:
> >>>> +	if (task != current) {
> >>>> +		if (option == ARCH_CET_UNLOCK &&
> >>>> IS_ENABLED(CONFIG_CHECKPOINT_RESTORE)) {
> >>> Why make this conditional on CRIU at all?
> >> Kees asked for it, I think he was worried about attackers using it to
> >> unlock and disable shadow stack. So wanted to lock it down to the
> >> maximum.
> > Well, distros will all have this stuff enabled no? So not much
> > protection in practise.
> 
> Yeah, that's true for the distros.
> 
> But, I would imagine that our more paranoid friends like the ChromeOS
> folks might appreciate this.

ptrace can modify text, I'm not sure what if anything we're protecting
against.

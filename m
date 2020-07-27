Return-Path: <SRS0=1IKn=BG=vger.kernel.org=linux-api-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D09CFC433EB
	for <linux-api@archiver.kernel.org>; Mon, 27 Jul 2020 17:11:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B2FD52078E
	for <linux-api@archiver.kernel.org>; Mon, 27 Jul 2020 17:11:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1595869883;
	bh=XLRy4SH6xYtcSpdHOrlqOGtGsA5ScggILcg7hMblP4k=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:List-ID:From;
	b=POSQE8v+dDLjdGuMS8yuw5QXxDJaPhaWDMZHi8yFtmY+tH+Lep8BX9+mQuqy5fOb4
	 QiwegmcbazQICm139VuEkxvfKNsSt6KItGfHeoernSTIP+aw6C6WEd4EDadw2YlTUm
	 zfGB9X8Et9yuhIig0OzUOArhYQqvHPlxNVL8kZ54=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729094AbgG0RLS (ORCPT <rfc822;linux-api@archiver.kernel.org>);
        Mon, 27 Jul 2020 13:11:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:45584 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728712AbgG0RLR (ORCPT <rfc822;linux-api@vger.kernel.org>);
        Mon, 27 Jul 2020 13:11:17 -0400
Received: from kernel.org (unknown [87.71.40.38])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3AAEB206E7;
        Mon, 27 Jul 2020 17:11:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1595869877;
        bh=XLRy4SH6xYtcSpdHOrlqOGtGsA5ScggILcg7hMblP4k=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=RGlKfXBUd26L5XDA1ssqNMsN524ad4SB5OWposrAfAR1GqXXVCoku8j2/PxKiDDlt
         ZjgCXf8wWE4+IGmxJrktVr72zad9jL8jTfqjGu+VoAyYWbVCO1WDhniWv6reqEeMu8
         mqapPlh3w6TjsmKchi6eYJoHQoysiCGjddWIxmbQ=
Date:   Mon, 27 Jul 2020 20:11:02 +0300
From:   Mike Rapoport <rppt@kernel.org>
To:     linux-kernel@vger.kernel.org
Cc:     Alexander Viro <viro@zeniv.linux.org.uk>,
        Andrew Morton <akpm@linux-foundation.org>,
        Andy Lutomirski <luto@kernel.org>,
        Arnd Bergmann <arnd@arndb.de>, Borislav Petkov <bp@alien8.de>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Christopher Lameter <cl@linux.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Elena Reshetova <elena.reshetova@intel.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Idan Yaniv <idan.yaniv@ibm.com>,
        Ingo Molnar <mingo@redhat.com>,
        James Bottomley <jejb@linux.ibm.com>,
        "Kirill A. Shutemov" <kirill@shutemov.name>,
        Matthew Wilcox <willy@infradead.org>,
        Mike Rapoport <rppt@linux.ibm.com>,
        Michael Kerrisk <mtk.manpages@gmail.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Tycho Andersen <tycho@tycho.ws>, Will Deacon <will@kernel.org>,
        linux-api@vger.kernel.org, linux-arch@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
        linux-nvdimm@lists.01.org, linux-riscv@lists.infradead.org,
        x86@kernel.org
Subject: Re: [PATCH v2 7/7] mm: secretmem: add ability to reserve memory at
 boot
Message-ID: <20200727171102.GA3655207@kernel.org>
References: <20200727162935.31714-1-rppt@kernel.org>
 <20200727162935.31714-8-rppt@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200727162935.31714-8-rppt@kernel.org>
Sender: linux-api-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-api.vger.kernel.org>
X-Mailing-List: linux-api@vger.kernel.org

Oops, something went wrong with the rebase, this should have been
squashed into the previous patch...

On Mon, Jul 27, 2020 at 07:29:35PM +0300, Mike Rapoport wrote:
> From: Mike Rapoport <rppt@linux.ibm.com>
> 
> Taking pages out from the direct map and bringing them back may create
> undesired fragmentation and usage of the smaller pages in the direct
> mapping of the physical memory.
> 
> This can be avoided if a significantly large area of the physical memory
> would be reserved for secretmem purposes at boot time.
> 
> Add ability to reserve physical memory for secretmem at boot time using
> "secretmem" kernel parameter and then use that reserved memory as a global
> pool for secret memory needs.
> 
> Signed-off-by: Mike Rapoport <rppt@linux.ibm.com>
> ---
>  Documentation/admin-guide/kernel-parameters.txt | 4 ++++
>  1 file changed, 4 insertions(+)
> 
> diff --git a/Documentation/admin-guide/kernel-parameters.txt b/Documentation/admin-guide/kernel-parameters.txt
> index fb95fad81c79..6f3c2f28160f 100644
> --- a/Documentation/admin-guide/kernel-parameters.txt
> +++ b/Documentation/admin-guide/kernel-parameters.txt
> @@ -4548,6 +4548,10 @@
>  			Format: integer between 0 and 10
>  			Default is 0.
>  
> +	secretmem=n[KMG]
> +			[KNL,BOOT] Reserve specified amount of memory to
> +			back mappings of secret memory.
> +
>  	skew_tick=	[KNL] Offset the periodic timer tick per cpu to mitigate
>  			xtime_lock contention on larger systems, and/or RCU lock
>  			contention on all systems with CONFIG_MAXSMP set.
> -- 
> 2.26.2
> 

-- 
Sincerely yours,
Mike.

Return-Path: <SRS0=9OaR=DA=vger.kernel.org=linux-api-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 77B4DC4727F
	for <linux-api@archiver.kernel.org>; Wed, 23 Sep 2020 16:06:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3D1E8206A1
	for <linux-api@archiver.kernel.org>; Wed, 23 Sep 2020 16:06:22 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=alien8.de header.i=@alien8.de header.b="VLIuwTxo"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726718AbgIWQGS (ORCPT <rfc822;linux-api@archiver.kernel.org>);
        Wed, 23 Sep 2020 12:06:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48288 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726156AbgIWQGS (ORCPT
        <rfc822;linux-api@vger.kernel.org>); Wed, 23 Sep 2020 12:06:18 -0400
Received: from mail.skyhub.de (mail.skyhub.de [IPv6:2a01:4f8:190:11c2::b:1457])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1AE47C0613CE;
        Wed, 23 Sep 2020 09:06:18 -0700 (PDT)
Received: from zn.tnic (p200300ec2f0d130017aaf728a0fb4ec3.dip0.t-ipconnect.de [IPv6:2003:ec:2f0d:1300:17aa:f728:a0fb:4ec3])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id E1F481EC02F2;
        Wed, 23 Sep 2020 18:06:15 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
        t=1600877176;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
        bh=343RpSxaPLwXKOF6olutaSZsdcv4UEsmZkrtNn2OpcY=;
        b=VLIuwTxoVNU1goesTkQIAtnSRmkFhM9Q6J3Hc6/77DLuSaIZ1lKbkazp8DbC/sQPzViAKb
        NIUDFuJczQy3px7or/+ld3gN8KOvCrkWguBAbZ1b1odrnjRbuuo6Sa09UrsGJO2274mty9
        BKt497sLS7pMn2fozfJMvCtnNeK+m2c=
Date:   Wed, 23 Sep 2020 18:06:09 +0200
From:   Borislav Petkov <bp@alien8.de>
To:     Jonathan Cameron <Jonathan.Cameron@huawei.com>
Cc:     linux-mm@kvack.org, linux-acpi@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, x86@kernel.org,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
        rafael@kernel.org, Ingo Molnar <mingo@redhat.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        linuxarm@huawei.com, Dan Williams <dan.j.williams@intel.com>,
        Brice Goglin <Brice.Goglin@inria.fr>,
        Sean V Kelley <sean.v.kelley@linux.intel.com>,
        linux-api@vger.kernel.org, Hanjun Guo <guohanjun@huawei.com>
Subject: Re: [PATCH v10 2/6] x86: Support Generic Initiator only proximity
 domains
Message-ID: <20200923160609.GO28545@zn.tnic>
References: <20200907140307.571932-1-Jonathan.Cameron@huawei.com>
 <20200907140307.571932-3-Jonathan.Cameron@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20200907140307.571932-3-Jonathan.Cameron@huawei.com>
Precedence: bulk
List-ID: <linux-api.vger.kernel.org>
X-Mailing-List: linux-api@vger.kernel.org

On Mon, Sep 07, 2020 at 10:03:03PM +0800, Jonathan Cameron wrote:
> In common with memoryless domains we only register GI domains
> if the proximity node is not online. If a domain is already
> a memory containing domain, or a memoryless domain there is
> nothing to do just because it also contains a Generic Initiator.
> 
> Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
> ---
>  arch/x86/include/asm/numa.h |  2 ++
>  arch/x86/kernel/setup.c     |  1 +
>  arch/x86/mm/numa.c          | 14 ++++++++++++++
>  3 files changed, 17 insertions(+)
> 
> diff --git a/arch/x86/include/asm/numa.h b/arch/x86/include/asm/numa.h
> index bbfde3d2662f..f631467272a3 100644
> --- a/arch/x86/include/asm/numa.h
> +++ b/arch/x86/include/asm/numa.h
> @@ -62,12 +62,14 @@ extern void numa_clear_node(int cpu);
>  extern void __init init_cpu_to_node(void);
>  extern void numa_add_cpu(int cpu);
>  extern void numa_remove_cpu(int cpu);
> +extern void init_gi_nodes(void);
>  #else	/* CONFIG_NUMA */
>  static inline void numa_set_node(int cpu, int node)	{ }
>  static inline void numa_clear_node(int cpu)		{ }
>  static inline void init_cpu_to_node(void)		{ }
>  static inline void numa_add_cpu(int cpu)		{ }
>  static inline void numa_remove_cpu(int cpu)		{ }
> +static inline void init_gi_nodes(void)			{ }
>  #endif	/* CONFIG_NUMA */
>  
>  #ifdef CONFIG_DEBUG_PER_CPU_MAPS
> diff --git a/arch/x86/kernel/setup.c b/arch/x86/kernel/setup.c
> index 3511736fbc74..9062c146f03a 100644
> --- a/arch/x86/kernel/setup.c
> +++ b/arch/x86/kernel/setup.c
> @@ -1218,6 +1218,7 @@ void __init setup_arch(char **cmdline_p)
>  	prefill_possible_map();
>  
>  	init_cpu_to_node();
> +	init_gi_nodes();

Can this function be an early_initcall() or so instead which you can
call in numa.c directly instead of exporting it and calling it here?

>  	io_apic_init_mappings();
>  
> diff --git a/arch/x86/mm/numa.c b/arch/x86/mm/numa.c
> index aa76ec2d359b..fc630dc6764e 100644
> --- a/arch/x86/mm/numa.c
> +++ b/arch/x86/mm/numa.c
> @@ -747,6 +747,20 @@ static void __init init_memory_less_node(int nid)
>  	 */
>  }
>  
> +/*
> + * Generic Initiator Nodes may have neither CPU nor Memory.
> + * At this stage if either of the others were present we would

Who's "we"? And what is "either of the others"? The other nodes?

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette

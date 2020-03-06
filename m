Return-Path: <SRS0=u3R8=4X=vger.kernel.org=linux-api-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.6 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 31917C10DCE
	for <linux-api@archiver.kernel.org>; Fri,  6 Mar 2020 15:34:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id F3B532084E
	for <linux-api@archiver.kernel.org>; Fri,  6 Mar 2020 15:34:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1583508891;
	bh=d4u5+JerVMcA5/COi4zSliWCaFEKrXgk9+SBMnBLOzU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:List-ID:From;
	b=ZF8GHYse5q5Ih5w9YfJupdt1MNZOqfkLUP2/Rf5yniS9SaLu7eWgfnm3epJGYDEgc
	 vh0tRH+A9+H8JmZeNxP+ch+h0SzOlqJ1ILOK2lixrPfS+8nXwAIgG9jeC3LgBkgXPh
	 hg+dOFiumzBSHrAiqHpMVxRg/6Ra7yVUjv9IxIVI=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726974AbgCFPeu (ORCPT <rfc822;linux-api@archiver.kernel.org>);
        Fri, 6 Mar 2020 10:34:50 -0500
Received: from mail.kernel.org ([198.145.29.99]:47714 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726973AbgCFPeu (ORCPT <rfc822;linux-api@vger.kernel.org>);
        Fri, 6 Mar 2020 10:34:50 -0500
Received: from localhost (lfbn-ncy-1-985-231.w90-101.abo.wanadoo.fr [90.101.63.231])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5C8EA2073B;
        Fri,  6 Mar 2020 15:34:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1583508889;
        bh=d4u5+JerVMcA5/COi4zSliWCaFEKrXgk9+SBMnBLOzU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=IigMY9bFHGZeibgxLgeU2OPAMia5rClAiOn3x5x6boyTanCM82uTx2yrE3obO+nbQ
         rfjA6187zluExniJ9VUis53RpRrF0D4JO4vg9j/WzEz8oGFhSOg+Iy8mQLQ5gW18Pi
         keEH+ReP/mShGvtx7I0R7UVgxzbmtAkEbMCJx/SI=
Date:   Fri, 6 Mar 2020 16:34:47 +0100
From:   Frederic Weisbecker <frederic@kernel.org>
To:     Alex Belits <abelits@marvell.com>
Cc:     "rostedt@goodmis.org" <rostedt@goodmis.org>,
        "mingo@kernel.org" <mingo@kernel.org>,
        "peterz@infradead.org" <peterz@infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Prasun Kapoor <pkapoor@marvell.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "linux-api@vger.kernel.org" <linux-api@vger.kernel.org>,
        "linux-mm@vger.kernel.org" <linux-mm@vger.kernel.org>,
        "linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>
Subject: Re: [PATCH 11/12] task_isolation: kick_all_cpus_sync: don't kick
 isolated cpus
Message-ID: <20200306153446.GC8590@lenoir>
References: <4473787e1b6bc3cc226067e8d122092a678b63de.camel@marvell.com>
 <dfa5e0e9f34e6ff0ef048c81bc70496354f31300.camel@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <dfa5e0e9f34e6ff0ef048c81bc70496354f31300.camel@marvell.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: linux-api-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-api.vger.kernel.org>
X-Mailing-List: linux-api@vger.kernel.org

On Wed, Mar 04, 2020 at 04:15:24PM +0000, Alex Belits wrote:
> From: Yuri Norov <ynorov@marvell.com>
> 
> Make sure that kick_all_cpus_sync() does not call CPUs that are running
> isolated tasks.
> 
> Signed-off-by: Alex Belits <abelits@marvell.com>
> ---
>  kernel/smp.c | 14 +++++++++++++-
>  1 file changed, 13 insertions(+), 1 deletion(-)
> 
> diff --git a/kernel/smp.c b/kernel/smp.c
> index 3a8bcbdd4ce6..d9b4b2fedfed 100644
> --- a/kernel/smp.c
> +++ b/kernel/smp.c
> @@ -731,9 +731,21 @@ static void do_nothing(void *unused)
>   */
>  void kick_all_cpus_sync(void)
>  {
> +	struct cpumask mask;
> +
>  	/* Make sure the change is visible before we kick the cpus */
>  	smp_mb();
> -	smp_call_function(do_nothing, NULL, 1);
> +
> +	preempt_disable();
> +#ifdef CONFIG_TASK_ISOLATION
> +	cpumask_clear(&mask);
> +	task_isolation_cpumask(&mask);
> +	cpumask_complement(&mask, &mask);
> +#else
> +	cpumask_setall(&mask);
> +#endif
> +	smp_call_function_many(&mask, do_nothing, NULL, 1);
> +	preempt_enable();
>  }

That looks very dangerous, the callers of kick_all_cpus_sync() want to
sync all CPUs for a reason. You will rather need to fix the callers.

Thanks.

>  EXPORT_SYMBOL_GPL(kick_all_cpus_sync);
>  
> -- 
> 2.20.1
> 

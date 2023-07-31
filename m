Return-Path: <linux-api-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 42052C001DC
	for <linux-api@archiver.kernel.org>; Mon, 31 Jul 2023 16:28:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229847AbjGaQ2U (ORCPT <rfc822;linux-api@archiver.kernel.org>);
        Mon, 31 Jul 2023 12:28:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60370 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233420AbjGaQ1m (ORCPT
        <rfc822;linux-api@vger.kernel.org>); Mon, 31 Jul 2023 12:27:42 -0400
Received: from desiato.infradead.org (desiato.infradead.org [IPv6:2001:8b0:10b:1:d65d:64ff:fe57:4e05])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A51272106;
        Mon, 31 Jul 2023 09:27:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=desiato.20200630; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=dU0TNTItAAq53ja17hrx8d+tgkyLwTjLd3CGYi7SCVg=; b=IQvivOIyFLJ0rRqcEK/y/ew/Qa
        GTzQ+Wv3uaAkCg2eE6zbfNI/8TY7jYUtH8gwCBX2uLNYg1qYRgLtpf50OMX2f8R4PiMNheZTqaCMj
        gsDnzbt6iLJ2ogPfXiy5B1yGJkpymooMhJLnbG1gOd9tnpO2ua60Bl8DFJ2nTGFo1jSDYU7EFAj6Z
        qdcX8PhHtdN23Ph3fWI6pmQHf1lPPLdCk3F+8L8puTRHvzPNvH8Od98TqUEFlzVtPnejq2LoTBfEA
        lI6xJpAV+tsOTRcnMbpLBFscQsxkrtJbeoPusjq4HlTexCFBs2auGsrQK1GkQ7QcaTFzOB70AuV+d
        6z58ms9A==;
Received: from j130084.upc-j.chello.nl ([24.132.130.84] helo=noisy.programming.kicks-ass.net)
        by desiato.infradead.org with esmtpsa (Exim 4.96 #2 (Red Hat Linux))
        id 1qQVjM-00Ct4d-0o;
        Mon, 31 Jul 2023 16:26:48 +0000
Received: from hirez.programming.kicks-ass.net (hirez.programming.kicks-ass.net [192.168.1.225])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits))
        (Client did not present a certificate)
        by noisy.programming.kicks-ass.net (Postfix) with ESMTPS id CDC5D300134;
        Mon, 31 Jul 2023 18:26:46 +0200 (CEST)
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 1000)
        id BEB55203C783E; Mon, 31 Jul 2023 18:26:46 +0200 (CEST)
Date:   Mon, 31 Jul 2023 18:26:46 +0200
From:   Peter Zijlstra <peterz@infradead.org>
To:     Thomas Gleixner <tglx@linutronix.de>
Cc:     axboe@kernel.dk, linux-kernel@vger.kernel.org, mingo@redhat.com,
        dvhart@infradead.org, dave@stgolabs.net, andrealmeid@igalia.com,
        Andrew Morton <akpm@linux-foundation.org>, urezki@gmail.com,
        hch@infradead.org, lstoakes@gmail.com,
        Arnd Bergmann <arnd@arndb.de>, linux-api@vger.kernel.org,
        linux-mm@kvack.org, linux-arch@vger.kernel.org,
        malteskarupke@web.de
Subject: Re: [PATCH v1 03/14] futex: Flag conversion
Message-ID: <20230731162646.GO29590@hirez.programming.kicks-ass.net>
References: <20230721102237.268073801@infradead.org>
 <20230721105743.887106899@infradead.org>
 <87bkfsnja3.ffs@tglx>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87bkfsnja3.ffs@tglx>
Precedence: bulk
List-ID: <linux-api.vger.kernel.org>
X-Mailing-List: linux-api@vger.kernel.org

On Mon, Jul 31, 2023 at 06:21:56PM +0200, Thomas Gleixner wrote:
> On Fri, Jul 21 2023 at 12:22, Peter Zijlstra wrote:
> > +
> > +static inline bool futex_flags_valid(unsigned int flags)
> > +{
> > +	/* Only 64bit futexes for 64bit code */
> > +	if (!IS_ENABLED(CONFIG_64BIT) || in_compat_syscall()) {
> > +		if ((flags & FLAGS_SIZE_MASK) == FLAGS_SIZE_64)
> > +			return false;
> > +	}
> > +
> > +	/* Only 32bit futexes are implemented -- for now */
> > +	if ((flags & FLAGS_SIZE_MASK) != FLAGS_SIZE_32)
> > +		return false;
> > +
> > +	return true;
> > +}
> > +
> > +static inline unsigned int futex_size(unsigned int flags)
> > +{
> > +	unsigned int size = flags & FLAGS_SIZE_MASK;
> > +	return 1 << size; /* {0,1,2,3} -> {1,2,4,8} */
> 
> Lacks a new line and the comment is both misplaced and kinda obvious, no?

Yeah, it was a more complicated transform at some point, I'll fix.

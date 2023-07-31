Return-Path: <linux-api-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 37847C001DE
	for <linux-api@archiver.kernel.org>; Mon, 31 Jul 2023 17:15:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233796AbjGaRPk (ORCPT <rfc822;linux-api@archiver.kernel.org>);
        Mon, 31 Jul 2023 13:15:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41324 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232663AbjGaRPP (ORCPT
        <rfc822;linux-api@vger.kernel.org>); Mon, 31 Jul 2023 13:15:15 -0400
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D5AF1185;
        Mon, 31 Jul 2023 10:12:48 -0700 (PDT)
From:   Thomas Gleixner <tglx@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1690823567;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=NVJcIMq+A16+IcB9b23/dJfzVwN2i3jSPnGuLESWXwU=;
        b=Eo+GdN8K0pBmO612+PieVaC3ckEtUeUWiNBdHnP9zA+76wue7l0DTxUuNENb6j0Y62dGmB
        zlROcFdnMNMoN5KF50nw9Zens+gzszFOYX2KrLa9AlpP6pagTvzj+kjJreWRZCd4S+4VFt
        W60Z1///m5n2Xm2EisbxjSr9+SANi9NNLZ11wGkaeyB0F+Gsjr61iISJysYk2U5Znbw2M/
        qZ6ogZwhkx+rXUE5tOqiWJCgdy85NQsGUljrJPkGXDzlRqhdr4RnbH1Auycs6Bm0cFm1rY
        P7fyMrsSvnisqr5BGpEjx4pCOFdrF2Vml2PPeMlSbmuIVI5v28Izu9vGPHV/SQ==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1690823567;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=NVJcIMq+A16+IcB9b23/dJfzVwN2i3jSPnGuLESWXwU=;
        b=hziJ/HSUvoaES2uwBGC27GHIPrlflFgMtjtsRDlBaxjsKM4GLmXBM9mKhYBhkhOW3G1CRF
        7A6QmLUgJhzZz5Cg==
To:     Peter Zijlstra <peterz@infradead.org>, axboe@kernel.dk
Cc:     linux-kernel@vger.kernel.org, peterz@infradead.org,
        mingo@redhat.com, dvhart@infradead.org, dave@stgolabs.net,
        andrealmeid@igalia.com, Andrew Morton <akpm@linux-foundation.org>,
        urezki@gmail.com, hch@infradead.org, lstoakes@gmail.com,
        Arnd Bergmann <arnd@arndb.de>, linux-api@vger.kernel.org,
        linux-mm@kvack.org, linux-arch@vger.kernel.org,
        malteskarupke@web.de
Subject: Re: [PATCH v1 04/14] futex: Validate futex value against futex size
In-Reply-To: <20230721105743.954526690@infradead.org>
References: <20230721102237.268073801@infradead.org>
 <20230721105743.954526690@infradead.org>
Date:   Mon, 31 Jul 2023 19:12:46 +0200
Message-ID: <87y1iwm2cx.ffs@tglx>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <linux-api.vger.kernel.org>
X-Mailing-List: linux-api@vger.kernel.org

On Fri, Jul 21 2023 at 12:22, Peter Zijlstra wrote:
> +static inline bool futex_validate_input(unsigned int flags, u64 val)
> +{
> +	int bits = 8 * futex_size(flags);
> +	if (bits < 64 && (val >> bits))

New line between declaration and code. 

> +		return false;
> +	return true;
> +}

Other than that::

Reviewed-by: Thomas Gleixner <tglx@linutronix.de>

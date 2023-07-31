Return-Path: <linux-api-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9C12BC001DC
	for <linux-api@archiver.kernel.org>; Mon, 31 Jul 2023 16:37:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233440AbjGaQhe (ORCPT <rfc822;linux-api@archiver.kernel.org>);
        Mon, 31 Jul 2023 12:37:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38912 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233392AbjGaQhH (ORCPT
        <rfc822;linux-api@vger.kernel.org>); Mon, 31 Jul 2023 12:37:07 -0400
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 31AE526A2;
        Mon, 31 Jul 2023 09:36:40 -0700 (PDT)
From:   Thomas Gleixner <tglx@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1690821394;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=KNDEtWJdJB9h1rrPcrCeK9q7PZ7gwJaU7MbQA+l9PAg=;
        b=sc9rrtYrzmsYCqgER2ewtme6ZJJsTElkT8KRMypuiRJMMn4jXrr4QPYovcowtJP+l23tTi
        kUhJYpEyTBsFllA8ATIY69a+nsfW27n5oEXDX3VCcb14hYfai6VFDv8wOrJ5XDk2Do1d4V
        gClQ2ahJnxSb8pBgs1DSMv5BOmO2kcq8QKMDZD9/Lmb9CHkyxLogn+vV/iRu/4sXKQX72Y
        viXVL3VcEWWSLK1ECQnDtaaI7S00BXWhUQVLjLBv0iV67Cd8Qzk5WJd4Vsn+/cEr/soJrd
        zDawF7aH2hGSOkT6GSIP3HztnvkG3ZKKB82nDtqU9fd0LsMa80yfrxbdxZJ+rw==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1690821394;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=KNDEtWJdJB9h1rrPcrCeK9q7PZ7gwJaU7MbQA+l9PAg=;
        b=1IssTJbX/0RpxJEw62TRO5jFy5KECxyQBl0yGkQBDFFVOm6LsvNj2nhLpOA7/oXMlCPTEW
        LqY8vfBeA4rwFMBQ==
To:     Peter Zijlstra <peterz@infradead.org>, axboe@kernel.dk
Cc:     linux-kernel@vger.kernel.org, peterz@infradead.org,
        mingo@redhat.com, dvhart@infradead.org, dave@stgolabs.net,
        andrealmeid@igalia.com, Andrew Morton <akpm@linux-foundation.org>,
        urezki@gmail.com, hch@infradead.org, lstoakes@gmail.com,
        Arnd Bergmann <arnd@arndb.de>, linux-api@vger.kernel.org,
        linux-mm@kvack.org, linux-arch@vger.kernel.org,
        malteskarupke@web.de
Subject: Re: [PATCH v1 07/14] futex: Propagate flags into get_futex_key()
In-Reply-To: <20230721105744.160298443@infradead.org>
References: <20230721102237.268073801@infradead.org>
 <20230721105744.160298443@infradead.org>
Date:   Mon, 31 Jul 2023 18:36:34 +0200
Message-ID: <875y60nilp.ffs@tglx>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <linux-api.vger.kernel.org>
X-Mailing-List: linux-api@vger.kernel.org

On Fri, Jul 21 2023 at 12:22, Peter Zijlstra wrote:
> Instead of only passing FLAGS_SHARED as a boolean, pass down flags as
> a whole.
>
> Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>

Reviewed-by: Thomas Gleixner <tglx@linutronix.de>

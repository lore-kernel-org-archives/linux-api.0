Return-Path: <linux-api-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 526C0C6379F
	for <linux-api@archiver.kernel.org>; Tue, 14 Feb 2023 01:22:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229558AbjBNBW2 (ORCPT <rfc822;linux-api@archiver.kernel.org>);
        Mon, 13 Feb 2023 20:22:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38210 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229520AbjBNBW2 (ORCPT
        <rfc822;linux-api@vger.kernel.org>); Mon, 13 Feb 2023 20:22:28 -0500
Received: from formenos.hmeau.com (167-179-156-38.a7b39c.syd.nbn.aussiebb.net [167.179.156.38])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DA6D08A56;
        Mon, 13 Feb 2023 17:22:26 -0800 (PST)
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
        by formenos.hmeau.com with smtp (Exim 4.94.2 #2 (Debian))
        id 1pRk1G-00ArAi-1U; Tue, 14 Feb 2023 09:22:07 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Tue, 14 Feb 2023 09:22:06 +0800
Date:   Tue, 14 Feb 2023 09:22:06 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Andy Lutomirski <luto@kernel.org>
Cc:     Dave Chinner <david@fromorbit.com>, torvalds@linux-foundation.org,
        metze@samba.org, axboe@kernel.dk, linux-fsdevel@vger.kernel.org,
        linux-api@vger.kernel.org, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org, viro@zeniv.linux.org.uk,
        samba-technical@lists.samba.org
Subject: Re: copy on write for splice() from file to pipe?
Message-ID: <Y+riPviz0em9L9BQ@gondor.apana.org.au>
References: <20230210061953.GC2825702@dread.disaster.area>
 <Y+oCBnz2nLtXrz7O@gondor.apana.org.au>
 <CALCETrXKkZw3ojpmTftur1_-dEi6BOo9Q0cems_jgabntNFYig@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CALCETrXKkZw3ojpmTftur1_-dEi6BOo9Q0cems_jgabntNFYig@mail.gmail.com>
Precedence: bulk
List-ID: <linux-api.vger.kernel.org>
X-Mailing-List: linux-api@vger.kernel.org

On Mon, Feb 13, 2023 at 10:01:27AM -0800, Andy Lutomirski wrote:
>
> There's a difference between "kernel speaks TCP (or whatever)
> correctly" and "kernel does what the application needs it to do".

Sure I get where you are coming from.  It's just that the other
participants in the discussion were thinking of stability for the
sake of TCP (or TLS or some other protocol the kernel implements)
and that simply is a non-issue.

Having a better way to communicate completion to the user would be
nice.  The only way to do it right now seems to be polling with
SIOCOUTQ.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt

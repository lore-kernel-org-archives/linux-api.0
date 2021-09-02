Return-Path: <linux-api-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9C862C433F5
	for <linux-api@archiver.kernel.org>; Thu,  2 Sep 2021 18:28:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7845C60F56
	for <linux-api@archiver.kernel.org>; Thu,  2 Sep 2021 18:28:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239508AbhIBS3g (ORCPT <rfc822;linux-api@archiver.kernel.org>);
        Thu, 2 Sep 2021 14:29:36 -0400
Received: from vmicros1.altlinux.org ([194.107.17.57]:54724 "EHLO
        vmicros1.altlinux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346971AbhIBS3e (ORCPT
        <rfc822;linux-api@vger.kernel.org>); Thu, 2 Sep 2021 14:29:34 -0400
Received: from mua.local.altlinux.org (mua.local.altlinux.org [192.168.1.14])
        by vmicros1.altlinux.org (Postfix) with ESMTP id 363AC72C8F8;
        Thu,  2 Sep 2021 21:28:33 +0300 (MSK)
Received: by mua.local.altlinux.org (Postfix, from userid 508)
        id 274F87CF76A; Thu,  2 Sep 2021 21:28:33 +0300 (MSK)
Date:   Thu, 2 Sep 2021 21:28:33 +0300
From:   "Dmitry V. Levin" <ldv@altlinux.org>
To:     Eugene Syromiatnikov <esyr@redhat.com>,
        Steffen Klassert <steffen.klassert@secunet.com>
Cc:     Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Antony Antony <antony.antony@secunet.com>,
        Christian Langrock <christian.langrock@secunet.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-api@vger.kernel.org
Subject: Re: [PATCH] include/uapi/linux/xfrm.h: Fix XFRM_MSG_MAPPING ABI
 breakage
Message-ID: <20210902182832.GB21258@altlinux.org>
References: <20210901153407.GA20446@asgard.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210901153407.GA20446@asgard.redhat.com>
Precedence: bulk
List-ID: <linux-api.vger.kernel.org>
X-Mailing-List: linux-api@vger.kernel.org

On Wed, Sep 01, 2021 at 05:34:07PM +0200, Eugene Syromiatnikov wrote:
> Commit 2d151d39073a ("xfrm: Add possibility to set the default to block
> if we have no policy") broke ABI by changing the value of the XFRM_MSG_MAPPING
> enum item.  Fix it by placing XFRM_MSG_SETDEFAULT/XFRM_MSG_GETDEFAULT
> to the end of the enum, right before __XFRM_MSG_MAX.
> 
> Fixes: 2d151d39073a ("xfrm: Add possibility to set the default to block if we have no policy")
> Signed-off-by: Eugene Syromiatnikov <esyr@redhat.com>

References: https://lore.kernel.org/netdev/20210901151402.GA2557@altlinux.org/
Reviewed-by: Dmitry V. Levin <ldv@altlinux.org>


-- 
ldv

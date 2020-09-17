Return-Path: <SRS0=RkrY=C2=vger.kernel.org=linux-api-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8A325C43461
	for <linux-api@archiver.kernel.org>; Thu, 17 Sep 2020 18:45:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4A2FF206D4
	for <linux-api@archiver.kernel.org>; Thu, 17 Sep 2020 18:45:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728683AbgIQQvf (ORCPT <rfc822;linux-api@archiver.kernel.org>);
        Thu, 17 Sep 2020 12:51:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52926 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728680AbgIQQvE (ORCPT
        <rfc822;linux-api@vger.kernel.org>); Thu, 17 Sep 2020 12:51:04 -0400
Received: from ZenIV.linux.org.uk (zeniv.linux.org.uk [IPv6:2002:c35c:fd02::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 314B7C061756;
        Thu, 17 Sep 2020 09:50:55 -0700 (PDT)
Received: from viro by ZenIV.linux.org.uk with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1kIx7R-000Vhx-9T; Thu, 17 Sep 2020 16:50:49 +0000
Date:   Thu, 17 Sep 2020 17:50:49 +0100
From:   Al Viro <viro@zeniv.linux.org.uk>
To:     Christoph Hellwig <hch@lst.de>
Cc:     x86@kernel.org, Jan Kara <jack@suse.com>,
        linux-arm-kernel@lists.infradead.org,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-api@vger.kernel.org, linux-arch@vger.kernel.org
Subject: Re: [PATCH 1/3] compat: lift compat_s64 and compat_u64 to
 <asm-generic/compat.h>
Message-ID: <20200917165049.GV3421308@ZenIV.linux.org.uk>
References: <20200917074159.2442167-1-hch@lst.de>
 <20200917074159.2442167-2-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200917074159.2442167-2-hch@lst.de>
Precedence: bulk
List-ID: <linux-api.vger.kernel.org>
X-Mailing-List: linux-api@vger.kernel.org

On Thu, Sep 17, 2020 at 09:41:57AM +0200, Christoph Hellwig wrote:
> lift the compat_s64 and compat_u64 definitions into common code using the
> COMPAT_FOR_U64_ALIGNMENT symbol for the x86 special case.

OK...  Unlike the previous series it's not trying to wean arm64 off the
direct includes of asm/compat.h, avoiding the breakage you've got there.

Looks sane, applied.

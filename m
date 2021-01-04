Return-Path: <linux-api-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 53506C433E0
	for <linux-api@archiver.kernel.org>; Mon,  4 Jan 2021 08:39:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1400621E92
	for <linux-api@archiver.kernel.org>; Mon,  4 Jan 2021 08:39:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726019AbhADIjO (ORCPT <rfc822;linux-api@archiver.kernel.org>);
        Mon, 4 Jan 2021 03:39:14 -0500
Received: from verein.lst.de ([213.95.11.211]:56887 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725616AbhADIjO (ORCPT <rfc822;linux-api@vger.kernel.org>);
        Mon, 4 Jan 2021 03:39:14 -0500
Received: by verein.lst.de (Postfix, from userid 2407)
        id 2E0D96736F; Mon,  4 Jan 2021 09:38:31 +0100 (CET)
Date:   Mon, 4 Jan 2021 09:38:30 +0100
From:   Christoph Hellwig <hch@lst.de>
To:     Sargun Dhillon <sargun@sargun.me>
Cc:     Christoph Hellwig <hch@lst.de>, Al Viro <viro@zeniv.linux.org.uk>,
        Kyle Anderson <kylea@netflix.com>,
        Manas Alekar <malekar@netflix.com>,
        linux-fsdevel@vger.kernel.org, linux-api@vger.kernel.org,
        Rob Gulewich <rgulewich@netflix.com>,
        Zoran Simic <zsimic@netflix.com>, stable@vger.kernel.org
Subject: Re: [RESEND PATCH] fs: Validate flags and capabilities before
 looking up path in ksys_umount
Message-ID: <20210104083830.GA28271@lst.de>
References: <20201228204438.1726-1-sargun@sargun.me>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201228204438.1726-1-sargun@sargun.me>
User-Agent: Mutt/1.5.17 (2007-11-01)
Precedence: bulk
List-ID: <linux-api.vger.kernel.org>
X-Mailing-List: linux-api@vger.kernel.org

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>

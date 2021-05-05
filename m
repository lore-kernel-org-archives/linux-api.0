Return-Path: <linux-api-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 90516C433B4
	for <linux-api@archiver.kernel.org>; Wed,  5 May 2021 05:44:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 625F8610D2
	for <linux-api@archiver.kernel.org>; Wed,  5 May 2021 05:44:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231276AbhEEFo4 (ORCPT <rfc822;linux-api@archiver.kernel.org>);
        Wed, 5 May 2021 01:44:56 -0400
Received: from verein.lst.de ([213.95.11.211]:41590 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229653AbhEEFo4 (ORCPT <rfc822;linux-api@vger.kernel.org>);
        Wed, 5 May 2021 01:44:56 -0400
Received: by verein.lst.de (Postfix, from userid 2407)
        id 837E268AFE; Wed,  5 May 2021 07:43:57 +0200 (CEST)
Date:   Wed, 5 May 2021 07:43:57 +0200
From:   Christoph Hellwig <hch@lst.de>
To:     Alex Williamson <alex.williamson@redhat.com>
Cc:     kvm@vger.kernel.org, groug@kaod.org, hch@lst.de,
        gregkh@linuxfoundation.org, daniel@ffwll.ch,
        linux-kernel@vger.kernel.org, linux-api@vger.kernel.org,
        qemu-devel@nongnu.org, linuxppc-dev@lists.ozlabs.org,
        qemu-ppc@nongnu.org
Subject: Re: [PATCH] vfio/pci: Revert nvlink removal uAPI breakage
Message-ID: <20210505054357.GA12728@lst.de>
References: <162014341432.3807030.11054087109120670135.stgit@omen>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <162014341432.3807030.11054087109120670135.stgit@omen>
User-Agent: Mutt/1.5.17 (2007-11-01)
Precedence: bulk
List-ID: <linux-api.vger.kernel.org>
X-Mailing-List: linux-api@vger.kernel.org

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>

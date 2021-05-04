Return-Path: <linux-api-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0EAB4C433ED
	for <linux-api@archiver.kernel.org>; Tue,  4 May 2021 13:00:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CF450613BC
	for <linux-api@archiver.kernel.org>; Tue,  4 May 2021 13:00:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230447AbhEDNBl (ORCPT <rfc822;linux-api@archiver.kernel.org>);
        Tue, 4 May 2021 09:01:41 -0400
Received: from verein.lst.de ([213.95.11.211]:39378 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230373AbhEDNBl (ORCPT <rfc822;linux-api@vger.kernel.org>);
        Tue, 4 May 2021 09:01:41 -0400
Received: by verein.lst.de (Postfix, from userid 2407)
        id CA8C368AFE; Tue,  4 May 2021 15:00:39 +0200 (CEST)
Date:   Tue, 4 May 2021 15:00:39 +0200
From:   Christoph Hellwig <hch@lst.de>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Greg Kurz <groug@kaod.org>, Christoph Hellwig <hch@lst.de>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Alex Williamson <alex.williamson@redhat.com>,
        Jason Gunthorpe <jgg@nvidia.com>, kvm@vger.kernel.org,
        David Airlie <airlied@linux.ie>, linux-kernel@vger.kernel.org,
        dri-devel@lists.freedesktop.org, Paul Mackerras <paulus@samba.org>,
        Daniel Vetter <daniel@ffwll.ch>, linux-api@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org, qemu-devel@nongnu.org,
        qemu-ppc@nongnu.org
Subject: Re: remove the nvlink2 pci_vfio subdriver v2
Message-ID: <20210504130039.GA7711@lst.de>
References: <20210326061311.1497642-1-hch@lst.de> <20210504142236.76994047@bahia.lan> <YJFFG1tSP0dUCxcX@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YJFFG1tSP0dUCxcX@kroah.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Precedence: bulk
List-ID: <linux-api.vger.kernel.org>
X-Mailing-List: linux-api@vger.kernel.org

On Tue, May 04, 2021 at 02:59:07PM +0200, Greg Kroah-Hartman wrote:
> > Hi Christoph,
> > 
> > FYI, these uapi changes break build of QEMU.
> 
> What uapi changes?
> 
> What exactly breaks?
> 
> Why does QEMU require kernel driver stuff?

Looks like it pull in the uapi struct definitions unconditionally
instead of having a local copy.  We could fix that by just putting
them back, but to me this seems like a rather broken configuration
in qemu when it pulls in headers from the running/installed kernel
without any feature checks before using them.

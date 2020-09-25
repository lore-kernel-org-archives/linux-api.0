Return-Path: <SRS0=H7yB=DC=vger.kernel.org=linux-api-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 53512C4727C
	for <linux-api@archiver.kernel.org>; Fri, 25 Sep 2020 15:00:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 05BD62311D
	for <linux-api@archiver.kernel.org>; Fri, 25 Sep 2020 15:00:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1601046003;
	bh=7IYT7UHLCDqtbyK4J+1ahnyggiL4z2CJopESfVBEERw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:List-ID:From;
	b=ZDzE4e5sx9aXL2/YSc3gDGff6KXV/ZlPMBAUojFexlLA5zz/OHVQYSE1XFJk+GnMb
	 VF+VRX001FosSgHhwOeE7VbDawi/yxFI8IAgf2OGqnq6iwwovLWTFRJJXXd4KCFxid
	 WsSgYKDUojDLiLImjQT67jQbRttsTBm4jfKAKUlQ=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729040AbgIYPAC (ORCPT <rfc822;linux-api@archiver.kernel.org>);
        Fri, 25 Sep 2020 11:00:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:42652 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728038AbgIYPAB (ORCPT <rfc822;linux-api@vger.kernel.org>);
        Fri, 25 Sep 2020 11:00:01 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8E85420715;
        Fri, 25 Sep 2020 15:00:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601046001;
        bh=7IYT7UHLCDqtbyK4J+1ahnyggiL4z2CJopESfVBEERw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=MrxJym8UxSkYTz/SVZc3aIPcsYOQYGu3Y5h6n1HgY+aSIvwcZgx1cwXV9ccKxstNb
         ZX5LjGHCsHOkZrk1hK7g1CMBJvf6tp08Y0yOA0ZTf4y5m36LUrxb9xrMUk5hBZBmKL
         GS7QH4CEza3i1iqOEMvj5sX++vJSWYqkCgAUFGI0=
Date:   Fri, 25 Sep 2020 17:00:15 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     David Hildenbrand <david@redhat.com>
Cc:     Gerald Schaefer <gerald.schaefer@linux.ibm.com>,
        Michal Hocko <mhocko@kernel.org>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        Jan =?iso-8859-1?Q?H=F6ppner?= <hoeppner@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        linux-api@vger.kernel.org,
        Dave Hansen <dave.hansen@linux.intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: Ways to deprecate /sys/devices/system/memory/memoryX/phys_device
 ?
Message-ID: <20200925150015.GB3149196@kroah.com>
References: <21852ccb-bd06-9281-7c8e-485ec02f2883@redhat.com>
 <20200922155611.379373f7@thinkpad>
 <a7d02345-2195-3092-a368-ca3209e2c93e@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a7d02345-2195-3092-a368-ca3209e2c93e@redhat.com>
Precedence: bulk
List-ID: <linux-api.vger.kernel.org>
X-Mailing-List: linux-api@vger.kernel.org

On Fri, Sep 25, 2020 at 04:49:28PM +0200, David Hildenbrand wrote:
> >> There were once RFC patches to make use of it in ACPI, but it could be
> >> solved using different interfaces [1].
> >>
> >>
> >> While I'd love to rip it out completely, I think it would break old
> >> lsmem/chmem completely - and I assume that's not acceptable. I was
> >> wondering what would be considered safe to do now/in the future:
> >>
> >> 1. Make it always return 0 (just as if "sclp.rzm" would be set to 0 on
> >> s390x). This will make old lsmem/chmem behave differently after
> >> switching to a new kernel, like if sclp.rzm would not be set by HW -
> >> AFAIU, it will assume all memory is in a single memory increment. Do we
> >> care?
> > 
> > No, at least not until that kernel change would be backported to some
> > old distribution level where we still use lsmem/chmem from s390-tools.
> > Given that this is just some clean-up w/o any functional benefit, and
> > hopefully w/o any negative impact, I think we can safely assume that no
> > distributor will do that "just for fun".
> > 
> > Even if there would be good reasons for backports, then I guess we also
> > have good reasons for backporting / switching to the util-linux version
> > of lsmem / chmem for such distribution levels. Alternatively, adjust the
> > s390-tools lsmem / chmem there.
> > 
> > But I would rather "rip it out completely" than just return 0. You'd
> > need some lsmem / chmem changes anyway, at least in case this would
> > ever be backported.
> 
> Thanks for your input Gerald.
> 
> So unless people would be running shiny new kernels on older
> distributions it shouldn't be a problem (and I don't think we care too
> much about something like that). I don't expect something like that to
> get backported - there is absolutely no reason to do so IMHO.

We do care about this, Andrew used to have an old Fedora 9 box or
something like that, that he tourtured many of us with bug reports when
we broke it :)

So watch out, people keep old userspace around for much longer than you
can possibly imagine because they don't like having their use-cases in
userspace change, and we have made the guarantee to them that they _CAN_
trust us to not break things in userspace.

It's a slow age-out, but watch out, you might have to revert things...

good luck!

greg k-h

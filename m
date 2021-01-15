Return-Path: <linux-api-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0A418C433E6
	for <linux-api@archiver.kernel.org>; Fri, 15 Jan 2021 20:41:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C779423A5E
	for <linux-api@archiver.kernel.org>; Fri, 15 Jan 2021 20:41:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727204AbhAOUlh (ORCPT <rfc822;linux-api@archiver.kernel.org>);
        Fri, 15 Jan 2021 15:41:37 -0500
Received: from smtprelay0138.hostedemail.com ([216.40.44.138]:57824 "EHLO
        smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726467AbhAOUlg (ORCPT
        <rfc822;linux-api@vger.kernel.org>); Fri, 15 Jan 2021 15:41:36 -0500
X-Greylist: delayed 501 seconds by postgrey-1.27 at vger.kernel.org; Fri, 15 Jan 2021 15:41:35 EST
Received: from smtprelay.hostedemail.com (10.5.19.251.rfc1918.com [10.5.19.251])
        by smtpgrave04.hostedemail.com (Postfix) with ESMTP id 8DB8C18272D6F;
        Fri, 15 Jan 2021 20:33:15 +0000 (UTC)
Received: from filter.hostedemail.com (clb03-v110.bra.tucows.net [216.40.38.60])
        by smtprelay02.hostedemail.com (Postfix) with ESMTP id 1334C2703D;
        Fri, 15 Jan 2021 20:32:34 +0000 (UTC)
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-HE-Tag: sound31_4217a7027532
X-Filterd-Recvd-Size: 1605
Received: from [192.168.1.159] (unknown [47.151.137.21])
        (Authenticated sender: joe@perches.com)
        by omf17.hostedemail.com (Postfix) with ESMTPA;
        Fri, 15 Jan 2021 20:32:32 +0000 (UTC)
Message-ID: <8a5ae5f553d3775380f705a05b738c4630721486.camel@perches.com>
Subject: Re: [PATCH v5 1/2] tpm: add sysfs exports for all banks of PCR
 registers
From:   Joe Perches <joe@perches.com>
To:     Greg KH <greg@kroah.com>,
        James Bottomley <James.Bottomley@hansenpartnership.com>
Cc:     linux-integrity@vger.kernel.org, Mimi Zohar <zohar@linux.ibm.com>,
        Jarkko Sakkinen <jarkko@kernel.org>, linux-api@vger.kernel.org
Date:   Fri, 15 Jan 2021 12:32:31 -0800
In-Reply-To: <YAGeez8OZWDXugTW@kroah.com>
References: <20210113232634.23242-1-James.Bottomley@HansenPartnership.com>
         <20210113232634.23242-2-James.Bottomley@HansenPartnership.com>
         <X//55I26mxVQKKOE@kroah.com>
         <ce0ce0c5b3b66e2b1506ab9c4f10ffbbcfa648d8.camel@HansenPartnership.com>
         <YAGeez8OZWDXugTW@kroah.com>
Content-Type: text/plain; charset="ISO-8859-1"
User-Agent: Evolution 3.38.1-1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-api.vger.kernel.org>
X-Mailing-List: linux-api@vger.kernel.org

On Fri, 2021-01-15 at 14:54 +0100, Greg KH wrote:
> On Thu, Jan 14, 2021 at 04:21:08PM -0800, James Bottomley wrote:
[]
> > It looks like we already have a couple of bugs in the kernel introduced
> > by this confusion ...  return sysfs_emit() vs return sysfs_emit_at()
> > being the most tricky ...
> 
> Hm, Joe, you did the conversion to these functions (and wrote the api),
> care to review this?

Can you point me at the original submission?
I don't see it on lore/linux-api



Return-Path: <linux-api-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3CDF4C4361B
	for <linux-api@archiver.kernel.org>; Fri, 18 Dec 2020 08:57:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0C63823A82
	for <linux-api@archiver.kernel.org>; Fri, 18 Dec 2020 08:57:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726103AbgLRI5m (ORCPT <rfc822;linux-api@archiver.kernel.org>);
        Fri, 18 Dec 2020 03:57:42 -0500
Received: from mail.kernel.org ([198.145.29.99]:33334 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725895AbgLRI5m (ORCPT <rfc822;linux-api@vger.kernel.org>);
        Fri, 18 Dec 2020 03:57:42 -0500
Date:   Fri, 18 Dec 2020 09:56:58 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1608281822;
        bh=1VG/EwrugC/Altx7QqgQ3VIQRPgcIxuevom6vPah588=;
        h=From:To:Cc:Subject:References:In-Reply-To:From;
        b=Xus6DAqavI422GFtcVEoPvYHioujbKV8R9R6E9jJBRs5Wg75ykgjTqfIpkgRb1dB6
         xi0eI6aS2A6Rr3ARf7HQgk6Yj8uuK6R9jE1/3AZF8Or9kSfXB7iKQ5IQA5Ub52Lcxr
         /L2p/XJsBf5+z5ULgP7NhmadkhD/XDw1xsnFsiBE=
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Meng Zhuo <mengzhuo1203@gmail.com>
Cc:     linux-api@vger.kernel.org, bpf@vger.kernel.org
Subject: Re: Please remove all bit fields in bpf uapi
Message-ID: <X9xu2q8QFCCf70r7@kroah.com>
References: <CACt3ES2LCfNDq-nskrySJjWD5EO9WCAst_+kJT7UbhYOmD+45g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACt3ES2LCfNDq-nskrySJjWD5EO9WCAst_+kJT7UbhYOmD+45g@mail.gmail.com>
Precedence: bulk
List-ID: <linux-api.vger.kernel.org>
X-Mailing-List: linux-api@vger.kernel.org

On Fri, Dec 18, 2020 at 04:52:15PM +0800, Meng Zhuo wrote:
> Hi, all
> 
> I'm tring to port bpf.h to Go, however it's very hard to make it right
> with cgo since bit fields some fields didn't match any type of Go.
> 
> i.e.
> struct bpf_prog_info {
>         /* .... */
>         __u32 gpl_compatible:1;             <-- boolean ?
>         __u32 :31; /* alignment pad */   <--- padding with 31 ?
> 
> UAPI(User application interface) not just for GCC only right? If it's
> true, I think remove all bit fields is more appropriate.

It's a bit late to change a user-visable api, sorry.  Go has to have
some way of properly handling bit fields, this isn't a new thing :)

good luck!

greg k-h

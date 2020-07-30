Return-Path: <SRS0=Vdze=BJ=vger.kernel.org=linux-api-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 31EEEC433E0
	for <linux-api@archiver.kernel.org>; Thu, 30 Jul 2020 09:06:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0D32D2082E
	for <linux-api@archiver.kernel.org>; Thu, 30 Jul 2020 09:06:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1596099985;
	bh=ieC3UQSH9xTQQlFP1mBTpQK8Jaet0JuMdqnPvTiLzSc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:List-ID:From;
	b=us+VPqSlS4sjA5dzg6bgK9FXkaT5GokRKxFqu6zItdDyrhdMypdwehzK8Dzczc062
	 Dh3ZVpcm+OWIU13nU0836JWQKxroxRrNrraqb/5Ecg6VyUiBkT4BgELTu8EUoOkVVI
	 C9mS9044hNHPn+3DwpKb77vu6/7NMc0vXpizSJbQ=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728817AbgG3JGY (ORCPT <rfc822;linux-api@archiver.kernel.org>);
        Thu, 30 Jul 2020 05:06:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:42144 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728528AbgG3JGX (ORCPT <rfc822;linux-api@vger.kernel.org>);
        Thu, 30 Jul 2020 05:06:23 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CFDC92072A;
        Thu, 30 Jul 2020 09:06:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1596099983;
        bh=ieC3UQSH9xTQQlFP1mBTpQK8Jaet0JuMdqnPvTiLzSc=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Z/OlMNCjgJjVCDEAUFFVbS7j9qnE79NsrCIar3YE+oLzkykZo4SyLPjtjBmvhhkcD
         T9PkgtjWLgbnsiDPD6gD6YwuUd+7hajjK66mABoLrTUlc/yFV744DxvWyv+/e12Zv2
         o7cXTtiuU4bHGqJbB2DKVrNBS9iI30MBTfDZpeMY=
Date:   Thu, 30 Jul 2020 11:06:12 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     madvenka@linux.microsoft.com
Cc:     kernel-hardening@lists.openwall.com, linux-api@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-fsdevel@vger.kernel.org, linux-integrity@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        linux-security-module@vger.kernel.org, oleg@redhat.com,
        x86@kernel.org
Subject: Re: [PATCH v1 2/4] [RFC] x86/trampfd: Provide support for the
 trampoline file descriptor
Message-ID: <20200730090612.GA900546@kroah.com>
References: <aefc85852ea518982e74b233e11e16d2e707bc32>
 <20200728131050.24443-1-madvenka@linux.microsoft.com>
 <20200728131050.24443-3-madvenka@linux.microsoft.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200728131050.24443-3-madvenka@linux.microsoft.com>
Sender: linux-api-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-api.vger.kernel.org>
X-Mailing-List: linux-api@vger.kernel.org

On Tue, Jul 28, 2020 at 08:10:48AM -0500, madvenka@linux.microsoft.com wrote:
> +EXPORT_SYMBOL_GPL(trampfd_valid_regs);

Why are all of these exported?  I don't see a module user in this
series, or did I miss it somehow?

EXPORT_SYMBOL* is only needed for symbols to be used by modules, not by
code that is built into the kernel.

thanks,

greg k-h

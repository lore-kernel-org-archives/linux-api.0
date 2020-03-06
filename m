Return-Path: <SRS0=u3R8=4X=vger.kernel.org=linux-api-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6E2B2C10F00
	for <linux-api@archiver.kernel.org>; Fri,  6 Mar 2020 08:15:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 50EC02166E
	for <linux-api@archiver.kernel.org>; Fri,  6 Mar 2020 08:15:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726070AbgCFIPk (ORCPT <rfc822;linux-api@archiver.kernel.org>);
        Fri, 6 Mar 2020 03:15:40 -0500
Received: from albireo.enyo.de ([37.24.231.21]:54478 "EHLO albireo.enyo.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725869AbgCFIPk (ORCPT <rfc822;linux-api@vger.kernel.org>);
        Fri, 6 Mar 2020 03:15:40 -0500
Received: from [172.17.203.2] (helo=deneb.enyo.de)
        by albireo.enyo.de with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        id 1jA88n-0008VD-Dn; Fri, 06 Mar 2020 08:15:29 +0000
Received: from fw by deneb.enyo.de with local (Exim 4.92)
        (envelope-from <fw@deneb.enyo.de>)
        id 1jA87C-0001li-5M; Fri, 06 Mar 2020 09:13:50 +0100
From:   Florian Weimer <fw@deneb.enyo.de>
To:     YunQiang Su <syq@debian.org>
Cc:     torvalds@linux-foundation.org, gregkh@linuxfoundation.org,
        akpm@linux-foundation.org, viro@zeniv.linux.org.uk,
        James.Bottomley@hansenpartnership.com,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-arch@vger.kernel.org, linux-api@vger.kernel.org,
        libc-alpha@sourceware.org, Laurent Vivier <laurent@vivier.eu>
Subject: Re: [PATCH] binfmt_misc: pass binfmt_misc P flag to the interpreter
References: <20200306080905.173466-1-syq@debian.org>
Date:   Fri, 06 Mar 2020 09:13:50 +0100
In-Reply-To: <20200306080905.173466-1-syq@debian.org> (YunQiang Su's message
        of "Fri, 6 Mar 2020 16:09:05 +0800")
Message-ID: <87r1y53npd.fsf@mid.deneb.enyo.de>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-api-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-api.vger.kernel.org>
X-Mailing-List: linux-api@vger.kernel.org

* YunQiang Su:

> +	if (bprm->interp_flags & BINPRM_FLAGS_PRESERVE_ARGV0)
> +		flags |= AT_FLAGS_PRESERVE_ARGV0;
> +	NEW_AUX_ENT(AT_FLAGS, flags);

Is it necessary to reuse AT_FLAGS?  I think it's cleaner to define a
separate AT_ tag dedicated to binfmt_misc.

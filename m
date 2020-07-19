Return-Path: <SRS0=n9Uq=A6=vger.kernel.org=linux-api-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.0 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 58A70C433E0
	for <linux-api@archiver.kernel.org>; Sun, 19 Jul 2020 17:55:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3906A208DB
	for <linux-api@archiver.kernel.org>; Sun, 19 Jul 2020 17:55:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726009AbgGSRzN (ORCPT <rfc822;linux-api@archiver.kernel.org>);
        Sun, 19 Jul 2020 13:55:13 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:38660 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725783AbgGSRzN (ORCPT
        <rfc822;linux-api@vger.kernel.org>); Sun, 19 Jul 2020 13:55:13 -0400
Received: from ip5f5af08c.dynamic.kabel-deutschland.de ([95.90.240.140] helo=wittgenstein)
        by youngberry.canonical.com with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.86_2)
        (envelope-from <christian.brauner@ubuntu.com>)
        id 1jxDWl-0001P4-0X; Sun, 19 Jul 2020 17:55:07 +0000
Date:   Sun, 19 Jul 2020 19:55:06 +0200
From:   Christian Brauner <christian.brauner@ubuntu.com>
To:     Al Viro <viro@zeniv.linux.org.uk>
Cc:     David Howells <dhowells@redhat.com>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-api@vger.kernel.org,
        Michael Kerrisk <mtk.manpages@gmail.com>
Subject: Re: [PATCH 0/4] fs: add mount_setattr()
Message-ID: <20200719175506.fwxsb6r6pfrdhvxb@wittgenstein>
References: <20200714161415.3886463-1-christian.brauner@ubuntu.com>
 <20200719171054.GK2786714@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20200719171054.GK2786714@ZenIV.linux.org.uk>
Sender: linux-api-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-api.vger.kernel.org>
X-Mailing-List: linux-api@vger.kernel.org

On Sun, Jul 19, 2020 at 06:10:54PM +0100, Al Viro wrote:
> On Tue, Jul 14, 2020 at 06:14:11PM +0200, Christian Brauner wrote:
> 
> > mount_setattr() can be expected to grow over time and is designed with
> > extensibility in mind. It follows the extensible syscall pattern we have
> > used with other syscalls such as openat2(), clone3(),
> > sched_{set,get}attr(), and others.
> 
> I.e. it's a likely crap insertion vector; any patches around that thing
> will require the same level of review as addition of a brand new syscall.

Which is just how we should and hopefully treat any meaningful
extension, yes. Otherwise let's just never add a flag argument to any
syscall and only have dup()- and accept()-like syscalls.

> And they will be harder to spot - consider the likely subjects for such
> patches and compare to open addition of a new syscall...

In the new revision I have dropped the atime argument because David
already plumbed setting atime into fsmount() via flags and making
userspace jump through more hoops by adding more constants seems
pointless. So the additional arguments can be moved up because we're
below the 6 syscall args limit.

Though I really want to stress that while I see the worry it is less a
technial argument but one for our review process where we should treat
extensions to syscalls as strict as syscall additions. Which yes, very
much so.

Thanks!
Christian

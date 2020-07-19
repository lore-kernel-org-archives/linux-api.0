Return-Path: <SRS0=n9Uq=A6=vger.kernel.org=linux-api-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.0 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 94CE9C433E6
	for <linux-api@archiver.kernel.org>; Sun, 19 Jul 2020 17:11:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7EA3221741
	for <linux-api@archiver.kernel.org>; Sun, 19 Jul 2020 17:11:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726441AbgGSRLD (ORCPT <rfc822;linux-api@archiver.kernel.org>);
        Sun, 19 Jul 2020 13:11:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57414 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725783AbgGSRLD (ORCPT
        <rfc822;linux-api@vger.kernel.org>); Sun, 19 Jul 2020 13:11:03 -0400
Received: from ZenIV.linux.org.uk (zeniv.linux.org.uk [IPv6:2002:c35c:fd02::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 472FBC0619D2;
        Sun, 19 Jul 2020 10:11:03 -0700 (PDT)
Received: from viro by ZenIV.linux.org.uk with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jxCpy-00G1OK-JZ; Sun, 19 Jul 2020 17:10:54 +0000
Date:   Sun, 19 Jul 2020 18:10:54 +0100
From:   Al Viro <viro@zeniv.linux.org.uk>
To:     Christian Brauner <christian.brauner@ubuntu.com>
Cc:     David Howells <dhowells@redhat.com>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-api@vger.kernel.org,
        Michael Kerrisk <mtk.manpages@gmail.com>
Subject: Re: [PATCH 0/4] fs: add mount_setattr()
Message-ID: <20200719171054.GK2786714@ZenIV.linux.org.uk>
References: <20200714161415.3886463-1-christian.brauner@ubuntu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200714161415.3886463-1-christian.brauner@ubuntu.com>
Sender: linux-api-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-api.vger.kernel.org>
X-Mailing-List: linux-api@vger.kernel.org

On Tue, Jul 14, 2020 at 06:14:11PM +0200, Christian Brauner wrote:

> mount_setattr() can be expected to grow over time and is designed with
> extensibility in mind. It follows the extensible syscall pattern we have
> used with other syscalls such as openat2(), clone3(),
> sched_{set,get}attr(), and others.

I.e. it's a likely crap insertion vector; any patches around that thing
will require the same level of review as addition of a brand new syscall.
And they will be harder to spot - consider the likely subjects for such
patches and compare to open addition of a new syscall...

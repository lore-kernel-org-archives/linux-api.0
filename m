Return-Path: <linux-api-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 444B3C433ED
	for <linux-api@archiver.kernel.org>; Sat, 17 Apr 2021 16:28:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 17BD461245
	for <linux-api@archiver.kernel.org>; Sat, 17 Apr 2021 16:28:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236535AbhDQQ3J (ORCPT <rfc822;linux-api@archiver.kernel.org>);
        Sat, 17 Apr 2021 12:29:09 -0400
Received: from ciao.gmane.io ([116.202.254.214]:51766 "EHLO ciao.gmane.io"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236541AbhDQQ3J (ORCPT <rfc822;linux-api@vger.kernel.org>);
        Sat, 17 Apr 2021 12:29:09 -0400
Received: from list by ciao.gmane.io with local (Exim 4.92)
        (envelope-from <glka-linux-api@m.gmane-mx.org>)
        id 1lXnoH-0004yK-BH
        for linux-api@vger.kernel.org; Sat, 17 Apr 2021 18:28:41 +0200
X-Injected-Via-Gmane: http://gmane.org/
To:     linux-api@vger.kernel.org
From:   sbaugh@catern.com
Subject: Re: [PATCH 0/4 POC] Allow executing code and syscalls in another address space
Date:   Sat, 17 Apr 2021 12:28:16 -0400
Message-ID: <87sg3oub8f.fsf@catern.com>
References: <20210414055217.543246-1-avagin@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/28.0.50 (gnu/linux)
Cancel-Lock: sha1:jpMprCTd32MZCM7B3C+YeTVd+a0=
Cc:     linux-kernel@vger.kernel.org, linux-um@lists.infradead.org
Precedence: bulk
List-ID: <linux-api.vger.kernel.org>
X-Mailing-List: linux-api@vger.kernel.org


Just to add to the list of use cases for PROCESS_VM_EXEC_SYSCALL,
another use case is initializing a process from the "outside", instead
of from the "inside" as fork requires.  This can be much easier to work
with.  http://catern.com/rsys21.pdf goes into this use case in some
depth.

It relies heavily on a remote syscall primitive:
https://github.com/catern/rsyscall.  The PROCESS_VM_EXEC_SYSCALL API
proposed in this patch would be a great replacement for the current
implementation, which relies on running code inside the target process.


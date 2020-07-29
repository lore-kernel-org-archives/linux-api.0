Return-Path: <SRS0=f5mu=BI=vger.kernel.org=linux-api-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 00B1BC433E1
	for <linux-api@archiver.kernel.org>; Wed, 29 Jul 2020 13:29:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D5DD020809
	for <linux-api@archiver.kernel.org>; Wed, 29 Jul 2020 13:29:44 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="StrTU9oA"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727115AbgG2N3o (ORCPT <rfc822;linux-api@archiver.kernel.org>);
        Wed, 29 Jul 2020 09:29:44 -0400
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:56816 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727113AbgG2N3m (ORCPT
        <rfc822;linux-api@vger.kernel.org>); Wed, 29 Jul 2020 09:29:42 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1596029380;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=pHdy6Zb9Xi6Br1uklysJIGNGzShuC9IUN8gmmUSKfJ8=;
        b=StrTU9oAaFyMo8uishULmnxLv3sKAnkqy15rvlzA2HfO+NXVnvv0Cspud/eRZeYdSPaht2
        IUV460kzHsVD/jpGuIUtU9OQFwpHqrWvX0TSUKtgr/FCqj8zKLMQQvr+ssay3zVb/xgN/F
        pyba1BecjySRY2XMQ5NeRi6RyZTcoyo=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-185-oUnvNmSeOLyVa6xnjYceCQ-1; Wed, 29 Jul 2020 09:29:36 -0400
X-MC-Unique: oUnvNmSeOLyVa6xnjYceCQ-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id EE5481902EA0;
        Wed, 29 Jul 2020 13:29:34 +0000 (UTC)
Received: from oldenburg2.str.redhat.com (ovpn-113-29.ams2.redhat.com [10.36.113.29])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id B422869327;
        Wed, 29 Jul 2020 13:29:32 +0000 (UTC)
From:   Florian Weimer <fweimer@redhat.com>
To:     Andy Lutomirski <luto@kernel.org>
Cc:     madvenka@linux.microsoft.com,
        Kernel Hardening <kernel-hardening@lists.openwall.com>,
        Linux API <linux-api@vger.kernel.org>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        Linux FS Devel <linux-fsdevel@vger.kernel.org>,
        linux-integrity <linux-integrity@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        LSM List <linux-security-module@vger.kernel.org>,
        Oleg Nesterov <oleg@redhat.com>, X86 ML <x86@kernel.org>
Subject: Re: [PATCH v1 0/4] [RFC] Implement Trampoline File Descriptor
References: <20200728131050.24443-1-madvenka@linux.microsoft.com>
        <CALCETrVy5OMuUx04-wWk9FJbSxkrT2vMfN_kANinudrDwC4Cig@mail.gmail.com>
Date:   Wed, 29 Jul 2020 15:29:31 +0200
In-Reply-To: <CALCETrVy5OMuUx04-wWk9FJbSxkrT2vMfN_kANinudrDwC4Cig@mail.gmail.com>
        (Andy Lutomirski's message of "Tue, 28 Jul 2020 10:31:59 -0700")
Message-ID: <87pn8eo3es.fsf@oldenburg2.str.redhat.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Sender: linux-api-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-api.vger.kernel.org>
X-Mailing-List: linux-api@vger.kernel.org

* Andy Lutomirski:

> This is quite clever, but now I=E2=80=99m wondering just how much kernel =
help
> is really needed. In your series, the trampoline is an non-executable
> page.  I can think of at least two alternative approaches, and I'd
> like to know the pros and cons.
>
> 1. Entirely userspace: a return trampoline would be something like:
>
> 1:
> pushq %rax
> pushq %rbc
> pushq %rcx
> ...
> pushq %r15
> movq %rsp, %rdi # pointer to saved regs
> leaq 1b(%rip), %rsi # pointer to the trampoline itself
> callq trampoline_handler # see below
>
> You would fill a page with a bunch of these, possibly compacted to get
> more per page, and then you would remap as many copies as needed.

libffi does something like this for iOS, I believe.

The only thing you really need is a PC-relative indirect call, with the
target address loaded from a different page.  The trampoline handler can
do all the rest because it can identify the trampoline from the stack.
Having a closure parameter loaded into a register will speed things up,
of course.

I still hope to transition libffi to this model for most Linux targets.
It really simplifies things because you don't have to deal with cache
flushes (on both the data and code aliases for SELinux support).

But the key observation is that efficient trampolines do not need
run-time code generation at all because their code is so regular.

Thanks,
Florian


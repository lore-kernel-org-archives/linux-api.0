Return-Path: <linux-api-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 021B7C433B4
	for <linux-api@archiver.kernel.org>; Tue, 18 May 2021 23:13:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D6C196124C
	for <linux-api@archiver.kernel.org>; Tue, 18 May 2021 23:13:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234443AbhERXOw (ORCPT <rfc822;linux-api@archiver.kernel.org>);
        Tue, 18 May 2021 19:14:52 -0400
Received: from vmicros1.altlinux.org ([194.107.17.57]:55550 "EHLO
        vmicros1.altlinux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229660AbhERXOw (ORCPT
        <rfc822;linux-api@vger.kernel.org>); Tue, 18 May 2021 19:14:52 -0400
Received: from mua.local.altlinux.org (mua.local.altlinux.org [192.168.1.14])
        by vmicros1.altlinux.org (Postfix) with ESMTP id 1223A72C8BA;
        Wed, 19 May 2021 02:13:32 +0300 (MSK)
Received: by mua.local.altlinux.org (Postfix, from userid 508)
        id E4BDE7CC8A6; Wed, 19 May 2021 02:13:31 +0300 (MSK)
Date:   Wed, 19 May 2021 02:13:31 +0300
From:   "Dmitry V. Levin" <ldv@altlinux.org>
To:     Nicholas Piggin <npiggin@gmail.com>,
        Michael Ellerman <mpe@ellerman.id.au>
Cc:     linuxppc-dev@lists.ozlabs.org, musl@lists.openwall.com,
        libc-dev@lists.llvm.org, linux-api@vger.kernel.org
Subject: Re: Linux powerpc new system call instruction and ABI
Message-ID: <20210518231331.GA8464@altlinux.org>
References: <20200611081203.995112-1-npiggin@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200611081203.995112-1-npiggin@gmail.com>
Precedence: bulk
List-ID: <linux-api.vger.kernel.org>
X-Mailing-List: linux-api@vger.kernel.org

Hi,

On Thu, Jun 11, 2020 at 06:12:01PM +1000, Nicholas Piggin wrote:
[...]
> - Error handling: The consensus among kernel, glibc, and musl is to move to
>   using negative return values in r3 rather than CR0[SO]=1 to indicate error,
>   which matches most other architectures, and is closer to a function call.

Apparently, the patchset merged by commit v5.9-rc1~100^2~164 was
incomplete: all functions defined in arch/powerpc/include/asm/ptrace.h and
arch/powerpc/include/asm/syscall.h that use ccr are broken when scv is used.
This includes syscall_get_error() and all its users including
PTRACE_GET_SYSCALL_INFO API, which in turn makes strace unusable
when scv is used.

See also https://bugzilla.redhat.com/1929836


-- 
ldv

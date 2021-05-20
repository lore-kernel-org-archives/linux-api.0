Return-Path: <linux-api-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ACAC5C433B4
	for <linux-api@archiver.kernel.org>; Thu, 20 May 2021 03:06:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 88CCA610CD
	for <linux-api@archiver.kernel.org>; Thu, 20 May 2021 03:06:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229503AbhETDHd (ORCPT <rfc822;linux-api@archiver.kernel.org>);
        Wed, 19 May 2021 23:07:33 -0400
Received: from vmicros1.altlinux.org ([194.107.17.57]:36500 "EHLO
        vmicros1.altlinux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229556AbhETDHd (ORCPT
        <rfc822;linux-api@vger.kernel.org>); Wed, 19 May 2021 23:07:33 -0400
Received: from mua.local.altlinux.org (mua.local.altlinux.org [192.168.1.14])
        by vmicros1.altlinux.org (Postfix) with ESMTP id A429572C8BA;
        Thu, 20 May 2021 06:06:11 +0300 (MSK)
Received: by mua.local.altlinux.org (Postfix, from userid 508)
        id 9778A7CC8A6; Thu, 20 May 2021 06:06:11 +0300 (MSK)
Date:   Thu, 20 May 2021 06:06:11 +0300
From:   "Dmitry V. Levin" <ldv@altlinux.org>
To:     Nicholas Piggin <npiggin@gmail.com>
Cc:     Joakim Tjernlund <Joakim.Tjernlund@infinera.com>,
        libc-alpha@sourceware.org, libc-dev@lists.llvm.org,
        linux-api@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        Michael Ellerman <mpe@ellerman.id.au>,
        Matheus Castanho <msc@linux.ibm.com>, musl@lists.openwall.com
Subject: Re: Linux powerpc new system call instruction and ABI
Message-ID: <20210520030611.GB27081@altlinux.org>
References: <20210519132656.GA17204@altlinux.org>
 <1621464056.o9t21cquw8.astroid@bobo.none>
 <20210519232726.GA24134@altlinux.org>
 <1621478238.xha1ow4ujh.astroid@bobo.none>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1621478238.xha1ow4ujh.astroid@bobo.none>
Precedence: bulk
List-ID: <linux-api.vger.kernel.org>
X-Mailing-List: linux-api@vger.kernel.org

On Thu, May 20, 2021 at 12:40:36PM +1000, Nicholas Piggin wrote:
[...]
> > Looks like struct pt_regs.trap already contains the information that could
> > be used to tell 'sc' from 'scv': if (pt_regs.trap & ~0xf) == 0x3000, then
> > it's scv.  Is my reading of arch/powerpc/include/asm/ptrace.h correct?
> 
> Hmm, I think it is. Certainly in the kernel regs struct it is, I had in 
> my mind that we put it to 0xc00 when populating the user struct for
> compatibility, but it seems not. So I guess this would work.

OK, can we state that (pt_regs.trap & ~0xf) == 0x3000 is a part of the scv
ABI, so it's not going to change and could be relied upon by userspace?
Could this be documented in Documentation/powerpc/syscall64-abi.rst,
please?


-- 
ldv

Return-Path: <SRS0=E/Fr=EJ=vger.kernel.org=linux-api-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1FE56C2D0A3
	for <linux-api@archiver.kernel.org>; Tue,  3 Nov 2020 16:30:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BFB0820870
	for <linux-api@archiver.kernel.org>; Tue,  3 Nov 2020 16:30:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1604421018;
	bh=jYHfX66WW2BdNqS2XWf0ysCG2+5llIa7XFBTFdDX/eI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:List-ID:From;
	b=nnHWD7U+KrHAgGgFrZ53B++PdOIJoPbqqD+XlRNHz4S8pCRXfmkw+2d5665meXVMC
	 5lzmfqoAQ/ffRmTk3tqSsg5KxvulaEAhiEEuS9i2swfgGT97/8hk7Y5CSIbTykeVBf
	 4gFTqAf4esxS9HgHCqtycjwk0AxSXHo5bQvW0oGM=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728299AbgKCQaS (ORCPT <rfc822;linux-api@archiver.kernel.org>);
        Tue, 3 Nov 2020 11:30:18 -0500
Received: from mail.kernel.org ([198.145.29.99]:53470 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728082AbgKCQaS (ORCPT <rfc822;linux-api@vger.kernel.org>);
        Tue, 3 Nov 2020 11:30:18 -0500
Received: from kernel.org (unknown [87.71.17.26])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8FB1C206DF;
        Tue,  3 Nov 2020 16:30:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604421016;
        bh=jYHfX66WW2BdNqS2XWf0ysCG2+5llIa7XFBTFdDX/eI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=aIT9WT+BvHALjjzBR+JANCva7x0iax3JsHcWBCEfbBEXiFyByvncM0vQDEjoMsNzh
         qIUHx4c/P1fmtrQLv9EIQHUB/NNPUa0sJ3XCbfY5Co0b/q6PUKAT7BitPwWCXDu5+c
         05kTyD2Qgu6hQisAN/yBj1hMLhxnioRXXIEvqYek=
Date:   Tue, 3 Nov 2020 18:30:02 +0200
From:   Mike Rapoport <rppt@kernel.org>
To:     Hagen Paul Pfeifer <hagen@jauu.net>
Cc:     Andrew Morton <akpm@linux-foundation.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Andy Lutomirski <luto@kernel.org>,
        Arnd Bergmann <arnd@arndb.de>, Borislav Petkov <bp@alien8.de>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Christopher Lameter <cl@linux.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        David Hildenbrand <david@redhat.com>,
        Elena Reshetova <elena.reshetova@intel.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Idan Yaniv <idan.yaniv@ibm.com>,
        Ingo Molnar <mingo@redhat.com>,
        James Bottomley <jejb@linux.ibm.com>,
        "Kirill A. Shutemov" <kirill@shutemov.name>,
        Matthew Wilcox <willy@infradead.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Mike Rapoport <rppt@linux.ibm.com>,
        Michael Kerrisk <mtk.manpages@gmail.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Shuah Khan <shuah@kernel.org>, Tycho Andersen <tycho@tycho.ws>,
        Will Deacon <will@kernel.org>, linux-api@vger.kernel.org,
        linux-arch@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org,
        linux-nvdimm@lists.01.org, linux-riscv@lists.infradead.org,
        x86@kernel.org
Subject: Re: [PATCH v6 0/6] mm: introduce memfd_secret system call to create
 "secret" memory areas
Message-ID: <20201103163002.GK4879@kernel.org>
References: <20200924132904.1391-1-rppt@kernel.org>
 <20201101110935.GA4105325@laniakea>
 <20201102154028.GD4879@kernel.org>
 <1547601988.128687.1604411534845@office.mailbox.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1547601988.128687.1604411534845@office.mailbox.org>
Precedence: bulk
List-ID: <linux-api.vger.kernel.org>
X-Mailing-List: linux-api@vger.kernel.org

On Tue, Nov 03, 2020 at 02:52:14PM +0100, Hagen Paul Pfeifer wrote:
> > On 11/02/2020 4:40 PM Mike Rapoport <rppt@kernel.org> wrote:
> 
> > > Isn't memfd_secret currently *unnecessarily* designed to be a "one task
> > > feature"? memfd_secret fulfills exactly two (generic) features:
> > > 
> > > - address space isolation from kernel (aka SECRET_EXCLUSIVE, not in kernel's
> > >   direct map) - hide from kernel, great
> > > - disabling processor's memory caches against speculative-execution vulnerabilities
> > >   (spectre and friends, aka SECRET_UNCACHED), also great
> > > 
> > > But, what about the following use-case: implementing a hardened IPC mechanism
> > > where even the kernel is not aware of any data and optionally via SECRET_UNCACHED
> > > even the hardware caches are bypassed! With the patches we are so close to
> > > achieving this.
> > > 
> > > How? Shared, SECRET_EXCLUSIVE and SECRET_UNCACHED mmaped pages for IPC
> > > involved tasks required to know this mapping (and memfd_secret fd). After IPC
> > > is done, tasks can copy sensitive data from IPC pages into memfd_secret()
> > > pages, un-sensitive data can be used/copied everywhere.
> > 
> > As long as the task share the file descriptor, they can share the
> > secretmem pages, pretty much like normal memfd.
> 
> Including process_vm_readv() and process_vm_writev()? Let's take a hypothetical
> "dbus-daemon-secure" service that receives data from process A and wants to
> copy/distribute it to data areas of N other processes. Much like dbus but without
> SOCK_DGRAM rather direct copy into secretmem/mmap pages (ring-buffer). Should be
> possible, right?

I'm not sure I follow you here.
For process_vm_readv() and process_vm_writev() secremem will be only
accessible on the local part, but not on the remote.
So copying data to secretmem pages using process_vm_writev wouldn't
work.

> > > One missing piece is still the secure zeroization of the page(s) if the
> > > mapping is closed by last process to guarantee a secure cleanup. This can
> > > probably done as an general mmap feature, not coupled to memfd_secret() and
> > > can be done independently ("reverse" MAP_UNINITIALIZED feature).
> > 
> > There are "init_on_alloc" and "init_on_free" kernel parameters that
> > enable zeroing of the pages on alloc and on free globally.
> > Anyway, I'll add zeroing of the freed memory to secretmem.
> 
> Great, this allows page-specific (thus runtime-performance-optimized) zeroing
> of secured pages. init_on_free lowers the performance to much and is not precice
> enough.
> 
> Hagen

-- 
Sincerely yours,
Mike.

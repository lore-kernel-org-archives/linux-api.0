Return-Path: <linux-api-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 26FB7C433EF
	for <linux-api@archiver.kernel.org>; Wed, 20 Apr 2022 17:15:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233251AbiDTRSL (ORCPT <rfc822;linux-api@archiver.kernel.org>);
        Wed, 20 Apr 2022 13:18:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35154 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1381040AbiDTRRq (ORCPT
        <rfc822;linux-api@vger.kernel.org>); Wed, 20 Apr 2022 13:17:46 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 28C062AEE;
        Wed, 20 Apr 2022 10:14:57 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 6F8ADCE1F38;
        Wed, 20 Apr 2022 17:14:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 658ECC385A1;
        Wed, 20 Apr 2022 17:14:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1650474894;
        bh=BOE8M66NoW0jpL4xn18L8Ak7nnXuciSXX4ZW9yjMTx8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=B5i5y2BkRjc1O3qYYtgxfPRCQamSS1CNqYHSvulOq4k2kR62dTLYjpA/xzaNQAeQv
         oYnTQWwzwQ4JzG5n9YiRcIVBbMheUduyZhQu681ld+qq2KUcg3ubJuRBvXBa3bKGri
         vdn895iW6K7cyNXiAvkmCfuP8YfTeEALw97x8j8Y=
Date:   Wed, 20 Apr 2022 19:14:52 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Spencer Baugh <sbaugh@catern.com>
Cc:     linux-api@vger.kernel.org, linux-kernel@vger.kernel.org,
        marcin@juszkiewicz.com.pl, torvalds@linux-foundation.org,
        arnd@arndb.de
Subject: Re: Explicitly defining the userspace API
Message-ID: <YmA/jFztk5GkjIr2@kroah.com>
References: <874k2nhgtg.fsf@catern.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <874k2nhgtg.fsf@catern.com>
Precedence: bulk
List-ID: <linux-api.vger.kernel.org>
X-Mailing-List: linux-api@vger.kernel.org

On Wed, Apr 20, 2022 at 04:15:25PM +0000, Spencer Baugh wrote:
> 
> Linux guarantees the stability of its userspace API, but the API
> itself is only informally described, primarily with English prose.  I
> want to add an explicit, authoritative machine-readable definition of
> the Linux userspace API.
> 
> As background, in a conventional libc like glibc, read(2) calls the
> Linux system call read, passing arguments in an architecture-specific
> way according to the specific details of read.
> 
> The details of these syscalls are at best documented in manpages, and
> often defined only by the implementation.  Anyone else who wants to
> work with a syscall, in any way, needs to duplicate all those details.
> 
> So the most basic definition of the API would just represent the
> information already present in SYSCALL_DEFINE macros: the C types of
> arguments and return values.  More usefully, it would describe the
> formats of those arguments and return values: that the first argument
> to read is a file descriptor rather than an arbitrary integer, and
> what flags are valid in the flags argument of openat, and that open
> returns a file descriptor.  A step beyond that would be describing, in
> some limited way, the effects of syscalls; for example, that read
> writes into the passed buffer the number of bytes that it returned.

So how would you define read() in this format in a way that has not
already been attempted in the past?  How are you going to define a
format that explains functionality in a way that is not just the
implementation in the end?

> One step in this direction is Documentation/ABI, which specifies the
> stability guarantees for different userspace APIs in a semi-formal
> way.  But it doesn't specify the actual content of those APIs, and it
> doesn't cover individual syscalls at all.

The content is described in Documentation/ABI/ entries, where do you see
that missing?

And you are correct, that place does not describe syscalls, or other
user/kernel interfaces that predate sysfs.

good luck!

greg k-h

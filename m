Return-Path: <SRS0=QVgP=BA=vger.kernel.org=linux-api-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5CA84C433E8
	for <linux-api@archiver.kernel.org>; Tue, 21 Jul 2020 17:25:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2EB6D2068F
	for <linux-api@archiver.kernel.org>; Tue, 21 Jul 2020 17:25:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1595352342;
	bh=RKV0BW+9C8tbyA2otgwhYFbwcP7+9Ge72XqOAPbxQ8E=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:List-ID:From;
	b=GGO7noZMlebN03kWnZDnPuPZcI2r2xKU64q8+99MpqBhZaqpsgDFyDscGERTOGPC3
	 cF46mdWqCsvb7tv9fsCHmFbsoKKld33/G7VUEw7FSlRx+m8ij4o4d2mrtnJMi/Zkvx
	 c+uEgYG/pTuMEkMZGvsHFZIMzpFqPbdEtcyll0yk=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728550AbgGURZi (ORCPT <rfc822;linux-api@archiver.kernel.org>);
        Tue, 21 Jul 2020 13:25:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:58998 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728600AbgGURZh (ORCPT <rfc822;linux-api@vger.kernel.org>);
        Tue, 21 Jul 2020 13:25:37 -0400
Received: from mail-wr1-f54.google.com (mail-wr1-f54.google.com [209.85.221.54])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 008B520720
        for <linux-api@vger.kernel.org>; Tue, 21 Jul 2020 17:25:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1595352337;
        bh=RKV0BW+9C8tbyA2otgwhYFbwcP7+9Ge72XqOAPbxQ8E=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=jAPq9v3BGHemfkujTIuG3ZqyDILVFZKDieQ9PnauZyxdybPri0Rk7zvR5TaW+x6lu
         b9lQuEB76XCTQHcF0W10LhSheHFqSZHYw7sbNFwuh4YhROQorjgEmoqxLkTwzwB3/a
         fhSXhZN+b1UnlENBla7DuCUmsj37/gLzp4m+2RvM=
Received: by mail-wr1-f54.google.com with SMTP id a15so7034385wrh.10
        for <linux-api@vger.kernel.org>; Tue, 21 Jul 2020 10:25:36 -0700 (PDT)
X-Gm-Message-State: AOAM533nikvF/l9bTwl8bf87mLkCHt1FFJeIueR94rF1SEm94z/GREDP
        TYFd716ffvaUyM1vbZ5X+lymvfp5VJQIhM2gDv5JZw==
X-Google-Smtp-Source: ABdhPJxhK47OGKg5u9wulGLbiutPzOKjaFb1WaziXlqqFghfIN1JaY+AIUojD2fdQbL4Ey8ktxLwrw3b08ACtiFgUv8=
X-Received: by 2002:adf:e482:: with SMTP id i2mr26959033wrm.75.1595352335661;
 Tue, 21 Jul 2020 10:25:35 -0700 (PDT)
MIME-Version: 1.0
References: <b754dad5-ee85-8a2f-f41a-8bdc56de42e8@kernel.dk>
 <8987E376-6B13-4798-BDBA-616A457447CF@amacapital.net> <20200721070709.GB11432@lst.de>
 <CALCETrXWZBXZuCeRYvYY8AWG51e_P3bOeNeqc8zXPLOTDTHY0g@mail.gmail.com> <20200721143412.GA8099@lst.de>
In-Reply-To: <20200721143412.GA8099@lst.de>
From:   Andy Lutomirski <luto@kernel.org>
Date:   Tue, 21 Jul 2020 10:25:24 -0700
X-Gmail-Original-Message-ID: <CALCETrWMQpKe7jqw2t39yn4HgGhGTSEFGK6MPR4wPs=tBBhjbg@mail.gmail.com>
Message-ID: <CALCETrWMQpKe7jqw2t39yn4HgGhGTSEFGK6MPR4wPs=tBBhjbg@mail.gmail.com>
Subject: Re: io_uring vs in_compat_syscall()
To:     Christoph Hellwig <hch@lst.de>
Cc:     Andy Lutomirski <luto@kernel.org>, Jens Axboe <axboe@kernel.dk>,
        linux-arch <linux-arch@vger.kernel.org>,
        Linux API <linux-api@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, io-uring@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-api-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-api.vger.kernel.org>
X-Mailing-List: linux-api@vger.kernel.org

On Tue, Jul 21, 2020 at 7:34 AM Christoph Hellwig <hch@lst.de> wrote:
>
> On Tue, Jul 21, 2020 at 07:31:02AM -0700, Andy Lutomirski wrote:
> > > What do you mean with "properly wired up".  Do you really want to spread
> > > ->compat_foo methods everywhere, including read and write?  I found
> > > in_compat_syscall() a lot small and easier to maintain than all the
> > > separate compat cruft.
> >
> > I was imagining using a flag.  Some of the net code uses
> > MSG_CMSG_COMPAT for this purpose.
>
> Killing that nightmarish monster is what actually got me into looking
> io_uring and starting this thread.

I agree that MSG_CMSG_COMPAT is nasty, but I think the concept is
sound -- rather than tracking whether we're compat by using a
different function or a per-thread variable, actually explicitly
tracking the mode seems sensible.

If we're going to play in_compat_syscall() games, let's please make
io_uring_enter() return -EINVAL if in_compat_syscall() != ctx->compat.

--Andy

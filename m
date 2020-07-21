Return-Path: <SRS0=QVgP=BA=vger.kernel.org=linux-api-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7917FC433DF
	for <linux-api@archiver.kernel.org>; Tue, 21 Jul 2020 14:31:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4C07A20714
	for <linux-api@archiver.kernel.org>; Tue, 21 Jul 2020 14:31:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1595341877;
	bh=ZE6hi4D69jtIEwF4BK+ARV2G4sOs0NzxotlkHEFjWG4=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:List-ID:From;
	b=uNxJH6qKKLABpJ/K92vTS5euWY9IE0onToKyR6ezXEOAOgbUhV93La3UWZpp2o+/J
	 a7/qcydxfGm1LwPFPVOiLVo5pc1fintarONVR9248zSFhMIZfSCd2Py7sT9vBPZdjK
	 MzQeIdQL53/nVu70LuhT9HVoKJ8rkE8susQpMKDA=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728600AbgGUObR (ORCPT <rfc822;linux-api@archiver.kernel.org>);
        Tue, 21 Jul 2020 10:31:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:59786 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728834AbgGUObQ (ORCPT <rfc822;linux-api@vger.kernel.org>);
        Tue, 21 Jul 2020 10:31:16 -0400
Received: from mail-wr1-f45.google.com (mail-wr1-f45.google.com [209.85.221.45])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A166C206E3
        for <linux-api@vger.kernel.org>; Tue, 21 Jul 2020 14:31:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1595341875;
        bh=ZE6hi4D69jtIEwF4BK+ARV2G4sOs0NzxotlkHEFjWG4=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=FIXVpqVFnHQzBx1VxkA+w+YDqLVl/RYm7UoTNMrv6VIfV3Gx70W/8SZNe7ugJDPwE
         Q7kMMy3pIo+MOFCVP3IQEsZUPEdSFAapyQ0sVcFBEmuxuc/FyVc+GeXQgT7dAQZF88
         rieidcedEQn8J3xa6mzwXSYOCfwJdTFgwOpCzaEU=
Received: by mail-wr1-f45.google.com with SMTP id b6so21406897wrs.11
        for <linux-api@vger.kernel.org>; Tue, 21 Jul 2020 07:31:15 -0700 (PDT)
X-Gm-Message-State: AOAM530Lb/b54gX7lGJTHtkMPdRiOPOA6vpJqlNnkv//tK5i9TgiuB3J
        xjRMNrAGqCx2R6Oy7t8W/bFfohLPAdlU7D/yGA03GA==
X-Google-Smtp-Source: ABdhPJw/7CumpJZn1noOG3gEVkvKehtOzAIzBE6N+K2KUxpRc884jpKivBoW8ylKLLoLPKUKu+sZEUhK0Bp+TCxwfCw=
X-Received: by 2002:a5d:5273:: with SMTP id l19mr17580739wrc.257.1595341874203;
 Tue, 21 Jul 2020 07:31:14 -0700 (PDT)
MIME-Version: 1.0
References: <b754dad5-ee85-8a2f-f41a-8bdc56de42e8@kernel.dk>
 <8987E376-6B13-4798-BDBA-616A457447CF@amacapital.net> <20200721070709.GB11432@lst.de>
In-Reply-To: <20200721070709.GB11432@lst.de>
From:   Andy Lutomirski <luto@kernel.org>
Date:   Tue, 21 Jul 2020 07:31:02 -0700
X-Gmail-Original-Message-ID: <CALCETrXWZBXZuCeRYvYY8AWG51e_P3bOeNeqc8zXPLOTDTHY0g@mail.gmail.com>
Message-ID: <CALCETrXWZBXZuCeRYvYY8AWG51e_P3bOeNeqc8zXPLOTDTHY0g@mail.gmail.com>
Subject: Re: io_uring vs in_compat_syscall()
To:     Christoph Hellwig <hch@lst.de>
Cc:     Jens Axboe <axboe@kernel.dk>,
        linux-arch <linux-arch@vger.kernel.org>,
        Linux API <linux-api@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, io-uring@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-api-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-api.vger.kernel.org>
X-Mailing-List: linux-api@vger.kernel.org

On Tue, Jul 21, 2020 at 12:07 AM Christoph Hellwig <hch@lst.de> wrote:
>
> On Mon, Jul 20, 2020 at 10:28:55AM -0700, Andy Lutomirski wrote:
> > > Sure, I'd consider that implementation detail for the actual patch(es=
)
> > > for this issue.
> >
> > There=E2=80=99s a corner case, though: doesn=E2=80=99t io_uring submiss=
ion frequently do the work synchronously in the context of the calling thre=
ad?
>
> Yes.
>
> > If so, can a thread do a 64-bit submit with 32-bit work or vice versa?
>
> In theory you could share an fd created in a 32-bit thread to a 64-bit
> thread or vice versa, but I think at that point you absolutely are in
> "you get to keep the pieces" land.

That seems potentially okay as long as these are pieces of userspace
and not pieces of the kernel.  If the kernel freaks out, we have a
problem.

>
> > Sometimes I think that in_compat_syscall() should have a mode in which =
calling it warns (e.g. not actually in a syscall when doing things in io_ur=
ing).  And the relevant operations should be properly wired up to avoid glo=
bal state like this.
>
> What do you mean with "properly wired up".  Do you really want to spread
> ->compat_foo methods everywhere, including read and write?  I found
> in_compat_syscall() a lot small and easier to maintain than all the
> separate compat cruft.

I was imagining using a flag.  Some of the net code uses
MSG_CMSG_COMPAT for this purpose.

--Andy

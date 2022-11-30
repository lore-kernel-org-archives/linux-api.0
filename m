Return-Path: <linux-api-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D55A4C433FE
	for <linux-api@archiver.kernel.org>; Wed, 30 Nov 2022 10:06:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235482AbiK3KGz (ORCPT <rfc822;linux-api@archiver.kernel.org>);
        Wed, 30 Nov 2022 05:06:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36888 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235451AbiK3KGv (ORCPT
        <rfc822;linux-api@vger.kernel.org>); Wed, 30 Nov 2022 05:06:51 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F17442FA4D;
        Wed, 30 Nov 2022 02:06:50 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A083EB81A7C;
        Wed, 30 Nov 2022 10:06:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BB4E9C433D6;
        Wed, 30 Nov 2022 10:06:46 +0000 (UTC)
Authentication-Results: smtp.kernel.org;
        dkim=pass (1024-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b="bviZgfjr"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zx2c4.com; s=20210105;
        t=1669802804;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=QHaLJoXz+lC9Wofr7nMpzVPQqEpDYfg9bt0J6FDLCDk=;
        b=bviZgfjrON/lxa7Ch44JjNxgQYoEbP23uCE/+8yl6p40eNN+hvJwChL+MloHeoSVGGJ4ev
        WZrJI0xlrAwHl/6a1ajpPPWOLuLq1Y/9EAvy5YLyPeFuyCwHy6sjVLhHlGoMZ+Ht+nzGFF
        UlAkcn5F91O2LulDbTBP4bkyIQhEYfA=
Received: by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id 396f555f (TLSv1.3:TLS_AES_256_GCM_SHA384:256:NO);
        Wed, 30 Nov 2022 10:06:44 +0000 (UTC)
Date:   Wed, 30 Nov 2022 11:06:39 +0100
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
To:     Geert Uytterhoeven <geert@linux-m68k.org>
Cc:     linux-kernel@vger.kernel.org, patches@lists.linux.dev,
        tglx@linutronix.de, linux-crypto@vger.kernel.org,
        linux-api@vger.kernel.org, x86@kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Adhemerval Zanella Netto <adhemerval.zanella@linaro.org>,
        Carlos O'Donell <carlos@redhat.com>,
        Florian Weimer <fweimer@redhat.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Christian Brauner <brauner@kernel.org>
Subject: Re: [PATCH v10 2/4] arch: allocate vgetrandom_alloc() syscall number
Message-ID: <Y4crL0dqX7U4wnHH@zx2c4.com>
References: <20221129210639.42233-1-Jason@zx2c4.com>
 <20221129210639.42233-3-Jason@zx2c4.com>
 <CAMuHMdUGkhFu7X8eUMU1qqTOLKC=xsXWG2obPUeTwzyMGD8grw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CAMuHMdUGkhFu7X8eUMU1qqTOLKC=xsXWG2obPUeTwzyMGD8grw@mail.gmail.com>
Precedence: bulk
List-ID: <linux-api.vger.kernel.org>
X-Mailing-List: linux-api@vger.kernel.org

Hi Geert,

On Wed, Nov 30, 2022 at 09:56:06AM +0100, Geert Uytterhoeven wrote:
> Hi Jason,
> 
> On Tue, Nov 29, 2022 at 10:09 PM Jason A. Donenfeld <Jason@zx2c4.com> wrote:
> > Add vgetrandom_alloc() as syscall 451 (or 561 on alpha) by adding it to
> > all of the various syscall.tbl and unistd.h files.
> >
> > Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
> 
> Thanks for your patch!
> 
> What's the policy regarding adding syscall numbers for VDSO-related
> syscalls on architectures that do not support VDSOs yet?

I don't know exactly what the /policy/ is, but not wanting to rock the
boat, the first iterations of this series only added it to x86. But then
Arnd joined the thread and said I should add it to all of them all at
once and separate that out into this commit, so that's what we have
here. I think the idea is to keep syscall numbers synchronized these
days between archs if possible.

Jason

Return-Path: <linux-api-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 57168C4332F
	for <linux-api@archiver.kernel.org>; Wed, 21 Dec 2022 14:04:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231154AbiLUOEd (ORCPT <rfc822;linux-api@archiver.kernel.org>);
        Wed, 21 Dec 2022 09:04:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51244 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229694AbiLUOEb (ORCPT
        <rfc822;linux-api@vger.kernel.org>); Wed, 21 Dec 2022 09:04:31 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8D67E1C921;
        Wed, 21 Dec 2022 06:04:29 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id E45F0CE1801;
        Wed, 21 Dec 2022 14:04:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4B314C433EF;
        Wed, 21 Dec 2022 14:04:24 +0000 (UTC)
Authentication-Results: smtp.kernel.org;
        dkim=pass (1024-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b="lagTYOtC"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zx2c4.com; s=20210105;
        t=1671631461;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=IGwYRqmYe1tulaCQh1AZycwBWtT5OF47TSgo9FHLK5I=;
        b=lagTYOtCAGuSUYb+3GhNLPs3gh4BK/ut2Ty1C0Zx/sNDZM3HKgGiXpx98TDP1cPHAMtqLv
        oAGcsn0dxWMuMfzdzx69weIAPh2P482PdMfkYbtTgVx2dppl2WcyBQlOxO5xiwZ63ZAEh1
        fIqORygw+AM/2k3hIVRyob1MkEkdBHc=
Received: by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id 65bed60f (TLSv1.3:TLS_AES_256_GCM_SHA384:256:NO);
        Wed, 21 Dec 2022 14:04:21 +0000 (UTC)
Date:   Wed, 21 Dec 2022 15:04:17 +0100
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
To:     Christophe Leroy <christophe.leroy@csgroup.eu>
Cc:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "patches@lists.linux.dev" <patches@lists.linux.dev>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "linux-api@vger.kernel.org" <linux-api@vger.kernel.org>,
        "x86@kernel.org" <x86@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Adhemerval Zanella Netto <adhemerval.zanella@linaro.org>,
        Carlos O'Donell <carlos@redhat.com>,
        Florian Weimer <fweimer@redhat.com>,
        Arnd Bergmann <arnd@arndb.de>, Jann Horn <jannh@google.com>,
        Christian Brauner <brauner@kernel.org>,
        "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>
Subject: Re: [PATCH v12 0/6] implement getrandom() in vDSO
Message-ID: <Y6MSYWHl1dV2nFzK@zx2c4.com>
References: <20221212185347.1286824-1-Jason@zx2c4.com>
 <86cfa465-2485-ff24-16f5-9014e25a0e98@csgroup.eu>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <86cfa465-2485-ff24-16f5-9014e25a0e98@csgroup.eu>
Precedence: bulk
List-ID: <linux-api.vger.kernel.org>
X-Mailing-List: linux-api@vger.kernel.org

On Tue, Dec 20, 2022 at 05:17:52PM +0000, Christophe Leroy wrote:
> I would have liked to give it a try on powerpc, but the series 
> conflicts. I tried both on v6.1 and on linus/master from now:

I'll send a rebased v+1 shortly.

Jason

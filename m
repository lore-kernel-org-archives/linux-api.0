Return-Path: <linux-api-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2A637C43334
	for <linux-api@archiver.kernel.org>; Tue, 21 Jun 2022 14:13:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230191AbiFUOM7 (ORCPT <rfc822;linux-api@archiver.kernel.org>);
        Tue, 21 Jun 2022 10:12:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57388 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229641AbiFUOM7 (ORCPT
        <rfc822;linux-api@vger.kernel.org>); Tue, 21 Jun 2022 10:12:59 -0400
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ACE27B82;
        Tue, 21 Jun 2022 07:12:57 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id 3DEF821C3D;
        Tue, 21 Jun 2022 14:12:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
        t=1655820776; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=/+TeT4ZwFQudR9WGTQ/brWI4SLn3ea8f0ve/OTXW8J8=;
        b=FkJDVNq+fbKgSXE/PJ6skJHye5TdJhqoPviTJ1hYeIh59AynIzNpftdaRw2UfOtJEAWM7v
        VOlTlpoxseYKhD3zmDVvWAfiP/kZ2wvTPaDUp0GWoPQCQzrIjq+zC9txIkwGYX3uISOz4E
        SDwBnuwMZ8sxao3CxNXxK+vw9riL2Iw=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
        s=susede2_ed25519; t=1655820776;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=/+TeT4ZwFQudR9WGTQ/brWI4SLn3ea8f0ve/OTXW8J8=;
        b=EKN4j9hcVE2niktqIwU1dVwdk8nh9cS+9l1edB0ZmJHvrZf09FjuKBXzZTVVbbSQfuG/zF
        0zLrbshZ4gvpVxDg==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 267C013638;
        Tue, 21 Jun 2022 14:12:56 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id C9CGCOjRsWIRRQAAMHmgww
        (envelope-from <chrubis@suse.cz>); Tue, 21 Jun 2022 14:12:56 +0000
Date:   Tue, 21 Jun 2022 16:15:04 +0200
From:   Cyril Hrubis <chrubis@suse.cz>
To:     David Laight <David.Laight@ACULAB.COM>
Cc:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>,
        "linux-api@vger.kernel.org" <linux-api@vger.kernel.org>,
        "libc-alpha@sourceware.org" <libc-alpha@sourceware.org>,
        "arnd@arndb.de" <arnd@arndb.de>,
        "ltp@lists.linux.it" <ltp@lists.linux.it>,
        "zack@owlfolio.org" <zack@owlfolio.org>,
        "dhowells@redhat.com" <dhowells@redhat.com>
Subject: Re: [PATCH v3] uapi: Make __{u,s}64 match {u,}int64_t in userspace
Message-ID: <YrHSaLombzbJwLhF@yuki>
References: <20220621120355.2903-1-chrubis@suse.cz>
 <a26ab9bfc27a430bb8a7b6aa2f39d724@AcuMS.aculab.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a26ab9bfc27a430bb8a7b6aa2f39d724@AcuMS.aculab.com>
Precedence: bulk
List-ID: <linux-api.vger.kernel.org>
X-Mailing-List: linux-api@vger.kernel.org

Hi!
> > This changes the __u64 and __s64 in userspace on 64bit platforms from
> > long long (unsigned) int to just long (unsigned) int in order to match
> > the uint64_t and int64_t size in userspace for C code.
> > 
> > We cannot make the change for C++ since that would be non-backwards
> > compatible change and may cause possible regressions and even
> > compilation failures, e.g. overloaded function may no longer find a
> > correct match.
> 
> Isn't is enough just to mention C++ name mangling?

I just picked up the argument that was brought up in the discussion
about the v1 patch and used it as a concrete example. Mangling is I
guess more straightforward example of a breakage. I can change the
description if there is consensus that such description would be better.

-- 
Cyril Hrubis
chrubis@suse.cz

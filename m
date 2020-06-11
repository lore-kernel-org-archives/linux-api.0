Return-Path: <SRS0=gqds=7Y=vger.kernel.org=linux-api-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7BCE0C433DF
	for <linux-api@archiver.kernel.org>; Thu, 11 Jun 2020 20:02:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 58B462073E
	for <linux-api@archiver.kernel.org>; Thu, 11 Jun 2020 20:02:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1591905722;
	bh=2F5hGGrUeQ0C63PcX7MsuKTPazI5GiLI6z0kuAJAO7Q=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:List-ID:From;
	b=d7FT0NCypoJGut0NMCgmqgwt2kOyn00ENIhesbayePN7Y5o5/z50ssw+cTL2Ei0G5
	 ZGBW9lL+CGjCluDXJhicJN7ZaWvbCNMq5nEGoKxgZXwe1neiSKMlv5ERc2YaGZwnHl
	 +WNrQhg1YTgbfJ9WEYGMkLiacwHBDl34sO76WcZg=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726332AbgFKUCB (ORCPT <rfc822;linux-api@archiver.kernel.org>);
        Thu, 11 Jun 2020 16:02:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54902 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726294AbgFKUCA (ORCPT
        <rfc822;linux-api@vger.kernel.org>); Thu, 11 Jun 2020 16:02:00 -0400
Received: from mail-lj1-x242.google.com (mail-lj1-x242.google.com [IPv6:2a00:1450:4864:20::242])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 64A6FC08C5C1
        for <linux-api@vger.kernel.org>; Thu, 11 Jun 2020 13:02:00 -0700 (PDT)
Received: by mail-lj1-x242.google.com with SMTP id n24so8389820lji.10
        for <linux-api@vger.kernel.org>; Thu, 11 Jun 2020 13:02:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=qXdR9jEbPC6QtrXif5jAFVgZtIRshSIS1Sry2sO/A/4=;
        b=VsSOPH8NNu/nLb4adDvZsuI4bT9ltONlHcacYOPJ75SSntNn2GxVgLooSAVIAvuLt3
         o2E1CXlYMDtjczxJJ0/k8EsKjkNKXlGreLBLc4oOZu59eN3sk5xkDrRegQKbl8m+G5RO
         FQjnfbgC3qfEuoVv9AALOGIDg6/kXE7Us2luk=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=qXdR9jEbPC6QtrXif5jAFVgZtIRshSIS1Sry2sO/A/4=;
        b=EgEAQxyKKNfa4YZDexF8cCvZaVvQ/fu3lk+kFgPWqvQZ3SFMrpikVsbYwzh9+3fqEN
         nX24kpCnxtq8kYs4L+tap3uzaHDM2huY+aCxqxRjCqW/5w++C6tA/EruxalJeHx/tG6M
         evBMjluH0iayOXUwUWpL6ABvESsgiLrSa78IJFi18h6R2epDVGs+pgU7i+3FsO/hoG/H
         dPgS9Df4kOBRq6Ai/cbOBADziWjZbn8THkZ/zUX/IWyS3FqctGkR/Ou0I0L3IRueNlE5
         YBMBjzXbL2luE3TM4SiqGgvXnPJ34rsACKio3in29pjrBSkCP6XeuM7mYnRilj5LDT8p
         YOLw==
X-Gm-Message-State: AOAM53070Yxc03GM3cd4UHkvhM+kNNbmCToXm66sezv1F7914bZAdJAm
        ibC7OcjN+R0XmFL0BZAWl2WycXKlvvo=
X-Google-Smtp-Source: ABdhPJzdEXiAoN5MJXblweXXRD8NL+I7WJVFRrMZDmwINRh4olRt7gStvf6xb6dUTMUGEVSqnmGzkg==
X-Received: by 2002:a2e:701a:: with SMTP id l26mr5455846ljc.88.1591905718184;
        Thu, 11 Jun 2020 13:01:58 -0700 (PDT)
Received: from mail-lj1-f179.google.com (mail-lj1-f179.google.com. [209.85.208.179])
        by smtp.gmail.com with ESMTPSA id v126sm1063580lfa.50.2020.06.11.13.01.56
        for <linux-api@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 11 Jun 2020 13:01:57 -0700 (PDT)
Received: by mail-lj1-f179.google.com with SMTP id e4so8454479ljn.4
        for <linux-api@vger.kernel.org>; Thu, 11 Jun 2020 13:01:56 -0700 (PDT)
X-Received: by 2002:a2e:9cd4:: with SMTP id g20mr5017432ljj.371.1591905716438;
 Thu, 11 Jun 2020 13:01:56 -0700 (PDT)
MIME-Version: 1.0
References: <20200611010115.GZ23230@ZenIV.linux.org.uk> <20200611152344.GA1693733@ZenIV.linux.org.uk>
In-Reply-To: <20200611152344.GA1693733@ZenIV.linux.org.uk>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Thu, 11 Jun 2020 13:01:40 -0700
X-Gmail-Original-Message-ID: <CAHk-=wijbWCfZaiYO68MSfxz-UMuJCuO1Sr9O1x4BTPpMjm4gw@mail.gmail.com>
Message-ID: <CAHk-=wijbWCfZaiYO68MSfxz-UMuJCuO1Sr9O1x4BTPpMjm4gw@mail.gmail.com>
Subject: Re: [RFC] unexport linux/elfcore.h
To:     Al Viro <viro@zeniv.linux.org.uk>
Cc:     Linux API <linux-api@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-api-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-api.vger.kernel.org>
X-Mailing-List: linux-api@vger.kernel.org

On Thu, Jun 11, 2020 at 8:23 AM Al Viro <viro@zeniv.linux.org.uk> wrote:
>
> I mean something like this.  Objections?

I'm not seeing that alot of people would care.

That said, is there any reason not to try to fix it instead and expose
elf_gregset_t some way?

But I do suspect it all really boils down to "nobody cares". If you
can't find somebody to speak up for it, might as well remove it.

              Linus

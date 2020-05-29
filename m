Return-Path: <SRS0=WRS6=7L=vger.kernel.org=linux-api-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.7 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 84857C433E0
	for <linux-api@archiver.kernel.org>; Fri, 29 May 2020 13:30:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5297D206F0
	for <linux-api@archiver.kernel.org>; Fri, 29 May 2020 13:30:37 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=tycho-ws.20150623.gappssmtp.com header.i=@tycho-ws.20150623.gappssmtp.com header.b="Ndvs3U44"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726903AbgE2Nag (ORCPT <rfc822;linux-api@archiver.kernel.org>);
        Fri, 29 May 2020 09:30:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59506 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726638AbgE2Nag (ORCPT
        <rfc822;linux-api@vger.kernel.org>); Fri, 29 May 2020 09:30:36 -0400
Received: from mail-pg1-x542.google.com (mail-pg1-x542.google.com [IPv6:2607:f8b0:4864:20::542])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 28352C08C5C6
        for <linux-api@vger.kernel.org>; Fri, 29 May 2020 06:30:36 -0700 (PDT)
Received: by mail-pg1-x542.google.com with SMTP id p21so1481958pgm.13
        for <linux-api@vger.kernel.org>; Fri, 29 May 2020 06:30:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=tycho-ws.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=TJ7zUBn/1EtMVIsuEd6ucJcE9PEXKgaIH6QKYb6De0c=;
        b=Ndvs3U44bxlo/W4/EUfnTls5W99+nDWMgdjffe3ksAJYIzmh8ocNi0ctdtvi7Hxv0H
         UcaazW8RhKLFeKSMydTBx4QeqzHIAyCG6vDORUxuowY7LsTTjwTEIJDKCTcxwMByf5hH
         gEIHVWsW33Ke5PRFG4S5Yeu5WyXUY9NQ3ebcdJhcmRjrsYjZ87UEerDRp7aZXVSwtGrZ
         bdhJMug1mURMwlMEEuL8fJOxLK6LpXMDOH18W/ut7cQgQFfjqIUjclylM//mKCbniTT5
         Ur67sxka9x931YfnnXPrwNAyMbYyxeNVKIfvzFYCeN4amLNCWHr0x7JtpdbDJeEU+Ufb
         HMCg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=TJ7zUBn/1EtMVIsuEd6ucJcE9PEXKgaIH6QKYb6De0c=;
        b=OZRaTpv7olUFIycJMBk+jVav+hWfAU+jEmty16Gf6LCX6hp+hIgg4ff3yfx56PnLF9
         5Q7KXbCV9t7o+CSiQ2dCDfdYtHJczaBPh3VknqFvMiIVfbQgMwCA7FbTWyk8LhUsmxRT
         RW6Eo04v0IvVBtPROZUB70hXPrNF0e++QybRAuakXykPwrs0c1Fnt0yzGdKkTMU/Opvn
         VL5VMkV4ycN2GZ2JrgE1SKhmUWbPTdV73gdi+mu1SX9pDU2OZMODfd2YLDuQmDGgR3ya
         pE7og5eCUczRhruMn3GA7lmlaO1nhbt4aaXVONHiBeX8loQY/EhOJkgUkdwUEnHcW4Ae
         OvkQ==
X-Gm-Message-State: AOAM531zN/n+iWFKaVvAEVyZp2PJQ+8Sfbn09e6mLCtuFfJkbVAHdfHk
        bNsTrKp4M7A3jHGFyqk0CpZ/SA==
X-Google-Smtp-Source: ABdhPJwYVn+PWn8rGaeYNdC2SlEzfNWzSoCvGSixBPLDNv8MOMfV1sO+viLpCVOJrMxaSgUBOYKhTA==
X-Received: by 2002:a63:9d81:: with SMTP id i123mr8299732pgd.176.1590759035541;
        Fri, 29 May 2020 06:30:35 -0700 (PDT)
Received: from cisco ([2001:420:c0c8:1002::476])
        by smtp.gmail.com with ESMTPSA id d2sm7593246pfc.7.2020.05.29.06.30.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 29 May 2020 06:30:34 -0700 (PDT)
Date:   Fri, 29 May 2020 07:30:40 -0600
From:   Tycho Andersen <tycho@tycho.ws>
To:     Sargun Dhillon <sargun@sargun.me>
Cc:     keescook@chromium.org, christian.brauner@ubuntu.com,
        containers@lists.linux-foundation.org, cyphar@cyphar.com,
        jannh@google.com, jeffv@google.com, linux-api@vger.kernel.org,
        linux-kernel@vger.kernel.org, palmer@google.com, rsesek@google.com
Subject: Re: [PATCH v2 0/3]  Add seccomp notifier ioctl that enables adding
 fds
Message-ID: <20200529133040.GE429721@cisco>
References: <20200528110858.3265-1-sargun@sargun.me>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200528110858.3265-1-sargun@sargun.me>
Sender: linux-api-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-api.vger.kernel.org>
X-Mailing-List: linux-api@vger.kernel.org

On Thu, May 28, 2020 at 04:08:55AM -0700, Sargun Dhillon wrote:
> This adds the capability for seccomp notifier listeners to add file
> descriptors

Modulo the changes suggested by others, you can consider this series:

Reviewed-by: Tycho Andersen <tycho@tycho.ws>

Return-Path: <SRS0=y6mp=BY=vger.kernel.org=linux-api-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.0 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8FBABC433DF
	for <linux-api@archiver.kernel.org>; Fri, 14 Aug 2020 05:49:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3EBCD206A4
	for <linux-api@archiver.kernel.org>; Fri, 14 Aug 2020 05:49:10 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=tfz-net.20150623.gappssmtp.com header.i=@tfz-net.20150623.gappssmtp.com header.b="cvBvSNsG"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726124AbgHNFtJ (ORCPT <rfc822;linux-api@archiver.kernel.org>);
        Fri, 14 Aug 2020 01:49:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42506 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726006AbgHNFtH (ORCPT
        <rfc822;linux-api@vger.kernel.org>); Fri, 14 Aug 2020 01:49:07 -0400
Received: from mail-wm1-x343.google.com (mail-wm1-x343.google.com [IPv6:2a00:1450:4864:20::343])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 71911C061757
        for <linux-api@vger.kernel.org>; Thu, 13 Aug 2020 22:49:07 -0700 (PDT)
Received: by mail-wm1-x343.google.com with SMTP id d190so6482194wmd.4
        for <linux-api@vger.kernel.org>; Thu, 13 Aug 2020 22:49:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=tfz-net.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=fBBZ1VE6Pl61w02scuLSTrYPkXkkmltKzTwwdi9Dq0s=;
        b=cvBvSNsGQMXqH9DBta9cyj9+60K2gEDrczZHyxiE8AJxJRKljzClHw97cLtJ2F07aW
         jswI2vSz37+TmOVWQFyqYFrCFMNaRh3Vc9wE0fxjHcNjto+yZaFcbEpQy+MKkzLBufLu
         AkOHko/GEmRONQjkTQ4mZ3G3AEI8SX6yV3rPr0ZVIm9J7fGisb+kbHJWf1x86bnHsKr3
         3/MtNrjD7waRFt6sUM0f/2BIoXNbufacioD1ZVbHY+ZusXgJM9PNp7iQ+he+amu3U9Xc
         qNVrG52Qft+BPLUAmqlG1i4TeCsna6iyk2EtqF8zJzrr3VwjEOPtrt3fRwCXRly++M7Y
         TgRg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=fBBZ1VE6Pl61w02scuLSTrYPkXkkmltKzTwwdi9Dq0s=;
        b=ZRJlHPxd++kPNfidhMg2wvXTY03mv3uFGCkpXLYmXXrVBPMpX4GZpXWn4HAypn22VT
         UZJwZTVPlyNID0aK6ZpXpUBhemNOIkJmIDQ9pjtfz+taS6sy6mtLAzys9TgjKzMzVCP7
         Q2NEcykQN6jX/nsH/7MQXR9XXMg6NOoaaXcqycCUs2VPA19qhiu/83SQSTwUzTeL1s8w
         D/HiGFRDldJgdGTyM7rtr2orTiJ4dzhO4cXRwIMOSJC2NpIuvCV/IG+hgExhue6y6ZeC
         R4/J51/3+CmOoo+0NUY/AvfjuapFewj/8r6I84tTcM4TJM9GQabfsI95NCJLhrOdumLX
         mXLQ==
X-Gm-Message-State: AOAM533Ev5r6y+7YwmSr/rBtasxmI/5fZX8Zx1qia+Yq9POdYLDgTKJD
        HbswpCTg2U2/9r+7RkaT+rbybdvv5YTL2kjFkuCNRQ==
X-Google-Smtp-Source: ABdhPJzmBEbq57a5AKVMkRh0f1Dj6D+omdtilofEgPXHIXGj3ylfJN8FqdFPh71kSsTOYaOAgWrNM0Gf9GAGwnRCIOI=
X-Received: by 2002:a1c:bd56:: with SMTP id n83mr916007wmf.64.1597384145882;
 Thu, 13 Aug 2020 22:49:05 -0700 (PDT)
MIME-Version: 1.0
References: <20200814035453.210716-1-kalou@tfz.net> <20200814035453.210716-3-kalou@tfz.net>
 <20200814052801.GA10141@infradead.org>
In-Reply-To: <20200814052801.GA10141@infradead.org>
From:   Pascal Bouchareine <kalou@tfz.net>
Date:   Thu, 13 Aug 2020 22:48:55 -0700
Message-ID: <CAGbU3_kOhXEx2s19P==F2-CyHFGbX_qKVWhPi+kPe3tmsY=HfA@mail.gmail.com>
Subject: Re: [PATCH v4 2/2] fcntl: introduce F_SET_DESCRIPTION
To:     Christoph Hellwig <hch@infradead.org>
Cc:     linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-api@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Alexey Dobriyan <adobriyan@gmail.com>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Jeff Layton <jlayton@poochiereds.net>,
        "J. Bruce Fields" <bfields@fieldses.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-api-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-api.vger.kernel.org>
X-Mailing-List: linux-api@vger.kernel.org

On Thu, Aug 13, 2020 at 10:28 PM Christoph Hellwig <hch@infradead.org> wrote:
> > One intended usage is to allow processes to self-document sockets
> > for netstat and friends to report
>
> NAK.  There is no way we're going to bloat a criticial structure like
> struct file for some vanity information like this.

The useful case is for sockets - Is there a more suited place to do that?
Do you think adding a setsockopt and sk_description to struct sock
would work, or would be considered the same?

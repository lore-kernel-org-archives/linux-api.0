Return-Path: <SRS0=BrUl=CA=vger.kernel.org=linux-api-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.5 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 92A2CC433E3
	for <linux-api@archiver.kernel.org>; Sat, 22 Aug 2020 19:59:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 73CB12075E
	for <linux-api@archiver.kernel.org>; Sat, 22 Aug 2020 19:59:25 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=tfz-net.20150623.gappssmtp.com header.i=@tfz-net.20150623.gappssmtp.com header.b="aBihwtoX"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728719AbgHVT7X (ORCPT <rfc822;linux-api@archiver.kernel.org>);
        Sat, 22 Aug 2020 15:59:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35584 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728665AbgHVT7V (ORCPT
        <rfc822;linux-api@vger.kernel.org>); Sat, 22 Aug 2020 15:59:21 -0400
Received: from mail-wm1-x344.google.com (mail-wm1-x344.google.com [IPv6:2a00:1450:4864:20::344])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 31C69C061573
        for <linux-api@vger.kernel.org>; Sat, 22 Aug 2020 12:59:20 -0700 (PDT)
Received: by mail-wm1-x344.google.com with SMTP id p14so4879573wmg.1
        for <linux-api@vger.kernel.org>; Sat, 22 Aug 2020 12:59:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=tfz-net.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=tdwBhPhtCsN/JQvKp7YTOpn4Lpk5w39RK5RYDO92HW4=;
        b=aBihwtoX6UoEawRpRhnhZTU/EV/u5sm2Bvg49HAx4AffL36z8qH992WqOJtRoW7ijR
         +Pa72oGUyYoEONL6qFHeziXobK/N2EfK1x2OAjX+fs7acb2Nkj/PdUQD2Hlami5+GC/j
         Mtmp+9aL7T5iitXJ2GjTxw0Er2lI81dIGxt4QJ15/4MVXVrV1sQ3zWZz3gy3PVbt5+vL
         PfoeXezTX2KvpLiqe8sbsK48nlPJzOPnY2m5QoeBSK1Gd/QO/kYbQJ05kK7PlKvjFiQM
         xXncdZVpykLqVTam6OQDiP4UjJjJF8MVPndp4iUVoN0nIIjrB54j81WX5xu8/6DYiVzI
         na6Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=tdwBhPhtCsN/JQvKp7YTOpn4Lpk5w39RK5RYDO92HW4=;
        b=QRWoXpXgjZcapOIiGyXjKSUe3IAT/kcQwtZNjJzhlkdl8xYIGqr6ROWyvpy5aqDAWp
         gq4ck2/BlxVSVs5RCzOU8sIMoKJjX752E5c+hnT97tAsnKiC/5ZgSNsS1jNLgtVyv5Gc
         FbUkzW+fx4d6ZmjuM1q7E2/L+jobML7Yg3Ns3vW4zQqJat0PeBN9hWRdsz3etrEy/Azu
         LrYh+dLorBOdbS3upqJenRP0DZL1za0eom9RWvgQdVEfm7Y/AVvm5R8iaB+Y1NH0fOdc
         7N2oEX7xVKalNKApMHXZsqovYWgTVtsCec3dPEUcVdMJ/OccIi48Nfly/dyy7UdPZtuW
         3e0w==
X-Gm-Message-State: AOAM530nDAM9z4HfDSwFiubhsbDmewWRvq29i8xbg2v5R+4oo3bwXl79
        71ogbpKJ+GMp8Z/9DUK7zjQdGjtrpdJneHDQEdYXX2Y8Juz/TMbyITo=
X-Google-Smtp-Source: ABdhPJw0/K42CFhQrPnxt7ZAtulKyqck4MJDWapHs8CJeNnb0ySgc12eotg4a5/z2JRlvwYhiXck+CNjPUkFxDAQW7o=
X-Received: by 2002:a7b:c308:: with SMTP id k8mr9273324wmj.90.1598126358713;
 Sat, 22 Aug 2020 12:59:18 -0700 (PDT)
MIME-Version: 1.0
References: <20200815182344.7469-1-kalou@tfz.net> <20200822032827.6386-1-kalou@tfz.net>
 <20200822032827.6386-2-kalou@tfz.net> <20200822.123650.1479943925913245500.davem@davemloft.net>
In-Reply-To: <20200822.123650.1479943925913245500.davem@davemloft.net>
From:   Pascal Bouchareine <kalou@tfz.net>
Date:   Sat, 22 Aug 2020 12:59:08 -0700
Message-ID: <CAGbU3_nRMbe8Syo3OHw6B4LXUheGiXXcLcaEQe0EAFTAB7xgng@mail.gmail.com>
Subject: Re: [PATCH v2 2/2] net: socket: implement SO_DESCRIPTION
To:     David Miller <davem@davemloft.net>
Cc:     linux-kernel@vger.kernel.org, linux-api@vger.kernel.org,
        netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Alexey Dobriyan <adobriyan@gmail.com>,
        Al Viro <viro@zeniv.linux.org.uk>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-api-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-api.vger.kernel.org>
X-Mailing-List: linux-api@vger.kernel.org

Thank you,

On Sat, Aug 22, 2020 at 12:36 PM David Miller <davem@davemloft.net> wrote:
> > We ignore optlen and constrain the string to a static max size
> >
> > Signed-off-by: Pascal Bouchareine <kalou@tfz.net>
>
> This change is really a non-starter unless the information gets
> published somewhere where people actually look at dumped sockets, and
> that's inet_diag and friends.

Would it make sense to also make UDIAG_SHOW_NAME use sk_description?
(And keep the existing change - setsockopt + show_fd_info via
/proc/.../fdinfo/..)

I would feel like adding a pid information (and what else am I missing
here) to inet_diag might also be a good improvement then?

I understand that users have to scan /proc to find the FDs, matching
the inode number for the socket to find the owning process today.

If that's of interest I can explore that too

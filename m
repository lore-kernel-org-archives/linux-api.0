Return-Path: <SRS0=BrUl=CA=vger.kernel.org=linux-api-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.5 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5B55AC433DF
	for <linux-api@archiver.kernel.org>; Sat, 22 Aug 2020 20:53:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 34DEA2072D
	for <linux-api@archiver.kernel.org>; Sat, 22 Aug 2020 20:53:19 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=tfz-net.20150623.gappssmtp.com header.i=@tfz-net.20150623.gappssmtp.com header.b="o9F59WuZ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728334AbgHVUxS (ORCPT <rfc822;linux-api@archiver.kernel.org>);
        Sat, 22 Aug 2020 16:53:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44078 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726535AbgHVUxQ (ORCPT
        <rfc822;linux-api@vger.kernel.org>); Sat, 22 Aug 2020 16:53:16 -0400
Received: from mail-wm1-x343.google.com (mail-wm1-x343.google.com [IPv6:2a00:1450:4864:20::343])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 28BE9C061573
        for <linux-api@vger.kernel.org>; Sat, 22 Aug 2020 13:53:16 -0700 (PDT)
Received: by mail-wm1-x343.google.com with SMTP id p14so4947921wmg.1
        for <linux-api@vger.kernel.org>; Sat, 22 Aug 2020 13:53:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=tfz-net.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=clh+fL1VRaAXvS7YPj75sxOdd6h5p+Cc2IiViY3r6sw=;
        b=o9F59WuZdNDmx5QsBTy7KpMnsvdroC0zSVfzYTHIzall8m0Ei9+MIncUySVYglsOOw
         ZURRs+MstyOjREksAjD6v9W/KF2mgN+EXOVtrRP1GT4aqHo5z+YpQtzdnlHTZVDG5sIP
         qThvmWqpuPpMY3Czodue0yUYpbaIj52FVGaI/PRY4eKq9JJZv5zXHKP0mklc+R/cMakU
         iNLskVDEPxC6whnJb4CZ0wDh67aNsDSKbQhDbiNyzk+syvqX/TbL0WV/8mZKe1EbnB7A
         4UanKTPVZ//IjNn+K+8hxbwVuoPnOvk1n+dG+o3Jh0V8zm8yzkA/5D8cDn2mTMZTPkwq
         w5yA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=clh+fL1VRaAXvS7YPj75sxOdd6h5p+Cc2IiViY3r6sw=;
        b=Rc64PdZbFSNIUb2zjLv142CoOUZ03JnlwuN0mFsr4G62+1B13Cv61Z568uZj5V7wVD
         BmNWF/Hq+xPHBfsSrm67zqEfXEnF0r1PCWv1/lYDPWjZ1IwrRJecI7Sg1Q6s4sIeRZAE
         VhVS+LxhoH5hedsQGFfjf9vt2nF4fbAY31jwiO1+/onHUn148o2vHRcjbMB8rKkq4Xip
         E0dbW2GKXkob+Fraia3th4gNBv46k8vwDkmtGdmohLB0G7MNETNnK/hw/EiF/kVsqmti
         piwC0WRtlfcgha1OS/oRXhzMPxhi8cFD91AErsiQ3XNWnXFOTP1ZWDqnaP8YZb9mEqAZ
         Zr5w==
X-Gm-Message-State: AOAM530EwOGeRN8qTZ3DNducwjiB8EGIQT+JgNnSWnL5b1Zhg1jo29U5
        LiOaioBKH0tigx3ELhVQ1lF1uj8hN3LS8Khe2Jce/g==
X-Google-Smtp-Source: ABdhPJxGqq6utU8WqyfsZRBRrqDRcWC5FsWAIIX2J53U6LHls3YyZw7V8x8SbvK3eDFeVayMc9q9UJvF/bVFc5pN+so=
X-Received: by 2002:a7b:c308:: with SMTP id k8mr9402961wmj.90.1598129594749;
 Sat, 22 Aug 2020 13:53:14 -0700 (PDT)
MIME-Version: 1.0
References: <20200815182344.7469-1-kalou@tfz.net> <20200822032827.6386-1-kalou@tfz.net>
 <20200822032827.6386-2-kalou@tfz.net> <20200822.123650.1479943925913245500.davem@davemloft.net>
 <CAGbU3_nRMbe8Syo3OHw6B4LXUheGiXXcLcaEQe0EAFTAB7xgng@mail.gmail.com> <CAGbU3_=ZywUOP1CKNQ6=P99SgX28_0iXSs81yP=vGFKv7JyMcQ@mail.gmail.com>
In-Reply-To: <CAGbU3_=ZywUOP1CKNQ6=P99SgX28_0iXSs81yP=vGFKv7JyMcQ@mail.gmail.com>
From:   Pascal Bouchareine <kalou@tfz.net>
Date:   Sat, 22 Aug 2020 13:53:03 -0700
Message-ID: <CAGbU3_krnjbeKnm6Zyn-tqYCHVZFBkB+oCP-UF_kVOGz=zkKFQ@mail.gmail.com>
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

On Sat, Aug 22, 2020 at 1:19 PM Pascal Bouchareine <kalou@tfz.net> wrote:
>
> On Sat, Aug 22, 2020 at 12:59 PM Pascal Bouchareine <kalou@tfz.net> wrote:
>
> > Would it make sense to also make UDIAG_SHOW_NAME use sk_description?
> > (And keep the existing change - setsockopt + show_fd_info via
> > /proc/.../fdinfo/..)
>
>
> Ah,very wrong example - to be more precise, I suppose that'd be adding
> a couple idiag_ext for sk_description and pid if possible instead

About the pid part -
On top of multiple pids to scan for a given socket, there's also the
security provided by /proc - I'm not sure what inet_diag does for that
So maybe users calling it will need to scan /proc for a long time anyway...

Or is that doable?

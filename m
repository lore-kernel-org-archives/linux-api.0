Return-Path: <SRS0=egfy=BO=vger.kernel.org=linux-api-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D843FC433DF
	for <linux-api@archiver.kernel.org>; Tue,  4 Aug 2020 13:57:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BF4312086A
	for <linux-api@archiver.kernel.org>; Tue,  4 Aug 2020 13:57:02 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=szeredi.hu header.i=@szeredi.hu header.b="AEHps8rn"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728387AbgHDN45 (ORCPT <rfc822;linux-api@archiver.kernel.org>);
        Tue, 4 Aug 2020 09:56:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52352 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728489AbgHDN4q (ORCPT
        <rfc822;linux-api@vger.kernel.org>); Tue, 4 Aug 2020 09:56:46 -0400
Received: from mail-ej1-x644.google.com (mail-ej1-x644.google.com [IPv6:2a00:1450:4864:20::644])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D07DBC061756
        for <linux-api@vger.kernel.org>; Tue,  4 Aug 2020 06:56:45 -0700 (PDT)
Received: by mail-ej1-x644.google.com with SMTP id a21so42514256ejj.10
        for <linux-api@vger.kernel.org>; Tue, 04 Aug 2020 06:56:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=szeredi.hu; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=Nir289YmvLvB9cYHD+WrMlDkgzY7IXddotY7RZ5kJuw=;
        b=AEHps8rnJNYWjEsEPmsNrngg9TrZ3KWI5HcB4+HHRs9di0+/ESZLPa6/JKEXxXRDtU
         j0ZA7GgeP7mT12IX5LxV4n0BWV70/alU7ADPeaFlcj67EWL5F74zxF5tjSOVXXhgCu3N
         g/f2upIq2fhT1dR8LKBd75so90/Gkfjyd4Eik=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=Nir289YmvLvB9cYHD+WrMlDkgzY7IXddotY7RZ5kJuw=;
        b=LcsWN7BWKgYdVm9+Mrhk4rVqkEShNAPqeHzkKcy402eQrGjt+2AMoeAiMahBimTLSz
         yWvJMqCfIlB8TVVzh8MlGmvzUXb3I5hzqAl5IaLorNso8e2p2N+6PRY9NKLH5LTSIBrK
         YaUoWVuctJFKY6ZRTnsb483+UWzWCqSGQXCNACiDGm6ZrXxZ3hK8AN9shGkwewENM1ti
         qhjn9YqqpsKugINAorb31qbcTsr05eSpFrubspDD0aHt3iHyMnK99TT8CgPGloYW+oMM
         BWJicvpsZCqlGn5bUr4gstsKatu2iQebA/G9H3hmSsLQ+InmpO2HQdbOKczquw2X/lIT
         eJiw==
X-Gm-Message-State: AOAM531JvpdXSNGdh/8EHDaIRFI9rHCm4Az28XAMoNIl/qRztSkNvnNM
        wimhbAq+zxL+BRczsBdAhYoHvQ==
X-Google-Smtp-Source: ABdhPJyvdxPxUWj7x824NLh/G3TC6fG7Nwu5sJ/FqR59hOHVzeefde3nECyeC40mMapaTamORKbAkg==
X-Received: by 2002:a17:906:f905:: with SMTP id lc5mr20891718ejb.340.1596549404630;
        Tue, 04 Aug 2020 06:56:44 -0700 (PDT)
Received: from miu.piliscsaba.redhat.com (catv-212-96-48-140.catv.broadband.hu. [212.96.48.140])
        by smtp.gmail.com with ESMTPSA id 4sm18404381ejn.84.2020.08.04.06.56.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 04 Aug 2020 06:56:44 -0700 (PDT)
Date:   Tue, 4 Aug 2020 15:56:41 +0200
From:   Miklos Szeredi <miklos@szeredi.hu>
To:     David Howells <dhowells@redhat.com>
Cc:     viro@zeniv.linux.org.uk, torvalds@linux-foundation.org,
        raven@themaw.net, mszeredi@redhat.com, christian@brauner.io,
        jannh@google.com, darrick.wong@oracle.com, kzak@redhat.com,
        jlayton@redhat.com, linux-api@vger.kernel.org,
        linux-fsdevel@vger.kernel.org,
        linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 10/18] fsinfo: Provide notification overrun handling
 support [ver #21]
Message-ID: <20200804135641.GE32719@miu.piliscsaba.redhat.com>
References: <159646178122.1784947.11705396571718464082.stgit@warthog.procyon.org.uk>
 <159646187082.1784947.4293611877413578847.stgit@warthog.procyon.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <159646187082.1784947.4293611877413578847.stgit@warthog.procyon.org.uk>
Sender: linux-api-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-api.vger.kernel.org>
X-Mailing-List: linux-api@vger.kernel.org

On Mon, Aug 03, 2020 at 02:37:50PM +0100, David Howells wrote:
> Provide support for the handling of an overrun in a watch queue.  In the
> event that an overrun occurs, the watcher needs to be able to find out what
> it was that they missed.  To this end, previous patches added event
> counters to struct mount.

So this is optimizing the buffer overrun case?

Shoun't we just make sure that the likelyhood of overruns is low and if it
happens, just reinitialize everthing from scratch (shouldn't be *that*
expensive).

Trying to find out what was missed seems like just adding complexity for no good
reason.


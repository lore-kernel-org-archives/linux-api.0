Return-Path: <linux-api-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 90DFFEE49AD
	for <linux-api@archiver.kernel.org>; Wed, 23 Aug 2023 02:54:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232357AbjHWCyV (ORCPT <rfc822;linux-api@archiver.kernel.org>);
        Tue, 22 Aug 2023 22:54:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49672 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232348AbjHWCyU (ORCPT
        <rfc822;linux-api@vger.kernel.org>); Tue, 22 Aug 2023 22:54:20 -0400
X-Greylist: delayed 922 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Tue, 22 Aug 2023 19:54:18 PDT
Received: from symantec4.comsats.net.pk (symantec4.comsats.net.pk [203.124.41.30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 03A9D1A5
        for <linux-api@vger.kernel.org>; Tue, 22 Aug 2023 19:54:17 -0700 (PDT)
X-AuditID: cb7c291e-06dff70000002aeb-ff-64e55c55a2b5
Received: from iesco.comsatshosting.com (iesco.comsatshosting.com [210.56.28.11])
        (using TLS with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        by symantec4.comsats.net.pk (Symantec Messaging Gateway) with SMTP id 9F.D7.10987.65C55E46; Wed, 23 Aug 2023 06:09:42 +0500 (PKT)
DomainKey-Signature: a=rsa-sha1; c=nofws; q=dns;
        d=iesco.com.pk; s=default;
        h=received:content-type:mime-version:content-transfer-encoding
          :content-description:subject:to:from:date:reply-to;
        b=aYS9U4ifaTSGI68RoZKA4h9uDQPSRjU5r3yvvsQfIIRPzGo6LS6p7bEJbWmoExG1i
          WHReK/xDJ2wFj7+TViHBzSIhPClLPE9u3f18jM0Q8kY5y8u/QWthPeZZ3GG7IKgz/
          36FMDNzum54xRtXpXTvHHuyOFjVypOo1SJQaVJZgU=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=iesco.com.pk; s=default;
        h=reply-to:date:from:to:subject:content-description
          :content-transfer-encoding:mime-version:content-type;
        bh=GMzYzcyTxDsE6wX/XHG6MHqAdAiHrhqbmmLQ/TZ1QnQ=;
        b=UeVRMCGZlAmrw0uxpgR1Gl6b8TqKSzM13j69EEzNIZ9jfveGIjv0goVH9qZMc52q7
          ItT2PT8k1pTKgbc75bK0VuV1bVj2IU2gwy8pZyKaORu4sC1EmmeqFy1VlDk1f6sK8
          QIEvOrCio/eERWJE8ZcNGdev3LBPqhFqjVw7Y1VLA=
Received: from [94.156.6.90] (UnknownHost [94.156.6.90]) by iesco.comsatshosting.com with SMTP;
   Wed, 23 Aug 2023 04:30:57 +0500
Message-ID: <9F.D7.10987.65C55E46@symantec4.comsats.net.pk>
Content-Type: text/plain; charset="iso-8859-1"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Description: Mail message body
Subject: Re; Interest,
To:     linux-api@vger.kernel.org
From:   "Chen Yun" <pso.chairmanbod@iesco.com.pk>
Date:   Tue, 22 Aug 2023 16:31:12 -0700
Reply-To: chnyne@gmail.com
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrDLMWRmVeSWpSXmKPExsVyyUKGWzcs5mmKwaxOPovN3zvYHBg9Pm+S
        C2CM4rJJSc3JLEst0rdL4MpYsu4CS8Fu5oq2/kUsDYyPmboYOTkkBEwkWrYuZO9i5OIQEtjD
        JLHiUDMjiMMisJpZonP5XWYI5yGzxOxnZxghypoZJT7en8DaxcjBwStgLfH8bynIKGYBPYkb
        U6ewgdi8AoISJ2c+YYGIa0ssW/iaGaScWUBN4mtXCUhYWEBM4tO0ZewgtoiArMTkyR/BytkE
        9CVWfAU5ghNor6rEgRvzWEFsIQEpiY1X1rNNYOSfhWTbLCTbZiHZNgth2wJGllWMEsWVuYnA
        UEs20UvOzy1OLCnWy0st0SvI3sQIDMPTNZpyOxiXXko8xCjAwajEw/tz3ZMUIdbEMqCuQ4wS
        HMxKIrzS3x+mCPGmJFZWpRblxxeV5qQWH2KU5mBREue1FXqWLCSQnliSmp2aWpBaBJNl4uCU
        amB0ZX1uJr3y+NzjeqlfdiXv709YbCy6dvPR9/2bcu8LM4k7zRR007Vr/T/veu7mw0LnvzDx
        BGx9vMzTW1xS8ER5lfun3h6nigCVp5+S+t5Pv//eeo34GZe9pRq1220O/ZFhZxE8uJYlwDwl
        84vn+dUJr59e/TTp96/nAZIPThTJi/LLHhA8Oj1MiaU4I9FQi7moOBEA2/ZWWj8CAAA=
Precedence: bulk
List-ID: <linux-api.vger.kernel.org>
X-Mailing-List: linux-api@vger.kernel.org

Re; Interest,

I am interested in discussing the Investment proposal as I explained
in my previous mail. May you let me know your interest and the
possibility of a cooperation aimed for mutual interest.

Looking forward to your mail for further discussion.

Regards

------
Chen Yun - Chairman of CREC
China Railway Engineering Corporation - CRECG
China Railway Plaza, No.69 Fuxing Road, Haidian District, Beijing, P.R.
China


Return-Path: <SRS0=WheX=CQ=vger.kernel.org=linux-api-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C5BFAC43461
	for <linux-api@archiver.kernel.org>; Mon,  7 Sep 2020 07:05:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 73C4F20768
	for <linux-api@archiver.kernel.org>; Mon,  7 Sep 2020 07:05:24 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="nqP2FTxH"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726841AbgIGHFY (ORCPT <rfc822;linux-api@archiver.kernel.org>);
        Mon, 7 Sep 2020 03:05:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59232 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726422AbgIGHFX (ORCPT
        <rfc822;linux-api@vger.kernel.org>); Mon, 7 Sep 2020 03:05:23 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D3222C061573
        for <linux-api@vger.kernel.org>; Mon,  7 Sep 2020 00:05:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=GbAgRu66Ekz1RYk4pCPO3eJmtqkEE30lovVRFEF4vok=; b=nqP2FTxHeFszCKaZh0qvlZukE3
        kr4YSHilqxw+vzgUpzwUUiG4zkmQN6bk2VgXLHYeTABWb+oxoAx4g6uuQDXwhORJ5zf9p6pmH+6OK
        xi3E7kh2TGK7w5FmhcMchkjYbI4XEPFiOn/FEwFtx6uudgM0VMcq5GzZ/6ssaI4ZtodLZ2eWa+/GL
        1upAriDhiSvrP39aBUI2oTRoj2bUJnx2FSIGlgbYBdSbEQuFsDbFHph6tVwRehZuOFwBQlpp72019
        dj4cIXyVzyS/8IVzRRuF8HvFv0VrnBsMba8kyLoWfcDGv153ScXFCjb3vSYeCfiiVb1Fh1M31HWNo
        1EffDnHA==;
Received: from hch by casper.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1kFBDC-0006z1-3N; Mon, 07 Sep 2020 07:05:10 +0000
Date:   Mon, 7 Sep 2020 08:05:10 +0100
From:   Christoph Hellwig <hch@infradead.org>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Andy Lutomirski <luto@amacapital.net>,
        Andy Lutomirski <luto@kernel.org>,
        Adalbert Laz??r <alazar@bitdefender.com>,
        Linux-MM <linux-mm@kvack.org>,
        Linux API <linux-api@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Alexander Graf <graf@amazon.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Jerome Glisse <jglisse@redhat.com>,
        Mihai Don??u <mdontu@bitdefender.com>,
        Mircea Cirjaliu <mcirjaliu@bitdefender.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Sargun Dhillon <sargun@sargun.me>,
        Aleksa Sarai <cyphar@cyphar.com>,
        Oleg Nesterov <oleg@redhat.com>, Jann Horn <jannh@google.com>,
        Kees Cook <keescook@chromium.org>,
        Matthew Wilcox <willy@infradead.org>,
        Christian Brauner <christian.brauner@ubuntu.com>
Subject: Re: [RESEND RFC PATCH 0/5] Remote mapping
Message-ID: <20200907070510.GA25834@infradead.org>
References: <d22e1e08-e2c1-510e-5ae7-accbf69731bf@redhat.com>
 <70D23368-A24D-4A15-8FC7-FA728D102475@amacapital.net>
 <836cff86-e670-8c69-6cbd-b22c5b5538df@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <836cff86-e670-8c69-6cbd-b22c5b5538df@redhat.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-api-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-api.vger.kernel.org>
X-Mailing-List: linux-api@vger.kernel.org

On Fri, Sep 04, 2020 at 11:58:57PM +0200, Paolo Bonzini wrote:
> So why say NACK?  Any half-decent maintainer would hold on merging the
> patches at least until the discussion is over.  Also I suppose any
> deprecation proposal should come with a description of an alternative.

Please stop these totally pointless and overly aggressive personal
attacks.  A maintainers prime job is to say no.

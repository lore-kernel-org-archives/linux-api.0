Return-Path: <SRS0=+ro9=CN=vger.kernel.org=linux-api-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.0 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5FDE5C43461
	for <linux-api@archiver.kernel.org>; Fri,  4 Sep 2020 11:46:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 33C0D206B8
	for <linux-api@archiver.kernel.org>; Fri,  4 Sep 2020 11:46:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729897AbgIDLqX (ORCPT <rfc822;linux-api@archiver.kernel.org>);
        Fri, 4 Sep 2020 07:46:23 -0400
Received: from mx01.bbu.dsd.mx.bitdefender.com ([91.199.104.161]:49662 "EHLO
        mx01.bbu.dsd.mx.bitdefender.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729753AbgIDLqW (ORCPT
        <rfc822;linux-api@vger.kernel.org>); Fri, 4 Sep 2020 07:46:22 -0400
Received: from smtp.bitdefender.com (smtp01.buh.bitdefender.com [10.17.80.75])
        by mx01.bbu.dsd.mx.bitdefender.com (Postfix) with ESMTPS id 8ABDF30003EE;
        Fri,  4 Sep 2020 14:34:03 +0300 (EEST)
Received: from localhost (unknown [195.189.155.252])
        by smtp.bitdefender.com (Postfix) with ESMTPSA id 033E23072785;
        Fri,  4 Sep 2020 14:34:02 +0300 (EEST)
From:   Adalbert =?iso-8859-2?b?TGF643I=?= <alazar@bitdefender.com>
Subject: Re: [RFC PATCH 0/5] Remote mapping
To:     Christian Brauner <christian.brauner@ubuntu.com>
Cc:     linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>,
        Alexander Graf <graf@amazon.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Jerome Glisse <jglisse@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Andy Lutomirski <luto@kernel.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Sargun Dhillon <sargun@sargun.me>,
        Aleksa Sarai <cyphar@cyphar.com>,
        Oleg Nesterov <oleg@redhat.com>, Jann Horn <jannh@google.com>,
        Kees Cook <keescook@chromium.org>,
        Matthew Wilcox <willy@infradead.org>, linux-api@vger.kernel.org
In-Reply-To: <20200904095438.q3vuihvfivhdjvxs@wittgenstein>
References: <20200903174730.2685-1-alazar@bitdefender.com>
        <20200904095438.q3vuihvfivhdjvxs@wittgenstein>
Date:   Fri, 04 Sep 2020 14:34:28 +0300
Message-ID: <15992192680.0c72E.21107@host>
User-agent: void
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
Sender: linux-api-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-api.vger.kernel.org>
X-Mailing-List: linux-api@vger.kernel.org

On Fri, 4 Sep 2020 11:54:38 +0200, Christian Brauner <christian.brauner@ubuntu.com> wrote:
> On Thu, Sep 03, 2020 at 08:47:25PM +0300, Adalbert Lazăr wrote:
> > This patchset adds support for the remote mapping feature.
> > Remote mapping, as its name suggests, is a means for transparent and
> > zero-copy access of a remote process' address space.
> > access of a remote process' address space.
> 
> Hey Adalbert,
> 
> Thanks for the patch. When you resend this patch series, could you
> please make sure that everyone Cced on any individual patch receives the
> full patch series? I only got patch 5/5 and it's a bit annoying because
> one completely lacks context of what's going on. I first thought "did
> someone just add a syscall with 3 lines of commit message?". :)
> 
> Could you please resend the patch series with linux-api, me and the
> following people Cced:

Done :D
Thank you, Christian

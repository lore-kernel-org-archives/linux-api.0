Return-Path: <SRS0=Vdze=BJ=vger.kernel.org=linux-api-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.6 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E638CC433DF
	for <linux-api@archiver.kernel.org>; Thu, 30 Jul 2020 20:36:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C531C2074B
	for <linux-api@archiver.kernel.org>; Thu, 30 Jul 2020 20:36:16 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="gfLcmca3"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730264AbgG3UgQ (ORCPT <rfc822;linux-api@archiver.kernel.org>);
        Thu, 30 Jul 2020 16:36:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55250 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729166AbgG3UgN (ORCPT
        <rfc822;linux-api@vger.kernel.org>); Thu, 30 Jul 2020 16:36:13 -0400
Received: from mail-lf1-x142.google.com (mail-lf1-x142.google.com [IPv6:2a00:1450:4864:20::142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4324AC061575
        for <linux-api@vger.kernel.org>; Thu, 30 Jul 2020 13:36:12 -0700 (PDT)
Received: by mail-lf1-x142.google.com with SMTP id 140so15686071lfi.5
        for <linux-api@vger.kernel.org>; Thu, 30 Jul 2020 13:36:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=sHOs9l3/K6F7LfycNnVOym1V+1P8Mz9mJUC/Blv0iA4=;
        b=gfLcmca3Z6//iKmecsUFmBdl/LU5XvyAvbShCdtcayi8W+PBPK63civUnCtNt3g2VH
         vLiwf8DgHScD6UuT2NL/C3Ifrsr+473Bd8244ztYUkWZ7GIz7OFIeVaTJTXtstRuFdTi
         qXGtZFqChQ44vuuPvXuSmt6hyRZHd5jNq86753P9edP7lzN5x/17f9WozCAkL/e6dbdv
         VovpsshUESDdSriHWmVvHB4FBGi8bpEd/KIWyW7qqebfDGTKqOvOXPdyyTmp865XtVEG
         kB/5QZ3oSYBSQcoLmlTSG1GpWQFoquu6pnP5EmmtIVLhhichbCvskvJq9NtAJL4fpX4q
         ZKjg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=sHOs9l3/K6F7LfycNnVOym1V+1P8Mz9mJUC/Blv0iA4=;
        b=XKeRrB9gWSMi9okVslhSuwHdCGQeqL7fM74C//+nGDyXdcOQnycufZWVyLx1GFbvPy
         bnVG+9hB65hiwTTHf49V/Gwt1T/qt01T7BeFYiB4QddsIj5Te2uirbqWoCcpO82bugmn
         KyWu8qtHpwYnbmOMph0QCi08YvV4JKPLRQlsLG8dYhRauAsTxsLkpnzjVyn85Ew26Snk
         XbYeLDzzuuUgGEy4w4o+1yySlvlYhbnLbDvw6HArZ+2f5+CozmAH6yX06C3w9PADd2L7
         QVoQdA3Bav8tHmWXu2w5Uoey8x4UP69La/JBQkhGyb2fCORfT2diEQKyuHKoCoIwqSdb
         ry3g==
X-Gm-Message-State: AOAM531MmolZ0DocyfPVg9wYlfwQWM11OU4rX66eO9VfxWk9IEVj/jp3
        u0GZj/qpp/LByjlmtWH9L6MrYy9f58yKmWu0WczLqg==
X-Google-Smtp-Source: ABdhPJzYe+GguGADgcXJa2Ka5GEt7uZyHffofzZPUeBFLD30Wlq/KqeIqiHbcB5iO5YlJq0lECgX1IBIqwt7nWgpoeE=
X-Received: by 2002:a19:710:: with SMTP id 16mr184852lfh.171.1596141369641;
 Thu, 30 Jul 2020 13:36:09 -0700 (PDT)
MIME-Version: 1.0
References: <b3b4cf95-5eaa-0b4e-34cc-1a855e7148b6@gmail.com>
 <88273c2f-ce21-db54-688d-5bebd4a81ecd@redhat.com> <cbf7666c-440e-b4bd-0ff6-712123845fae@gmail.com>
 <c690ad2f-5f3c-5a8b-7b4c-ad29976aeab0@redhat.com>
In-Reply-To: <c690ad2f-5f3c-5a8b-7b4c-ad29976aeab0@redhat.com>
From:   enh <enh@google.com>
Date:   Thu, 30 Jul 2020 13:35:57 -0700
Message-ID: <CAJgzZoqR4Vh0phZjrDB9dgxNPzH0a35YjC1CwKb3mREOFn5Kbg@mail.gmail.com>
Subject: Re: [RFC PATCH] Replacing "master-slave" terminology for pseudoterminals
To:     "Carlos O'Donell" <carlos@redhat.com>
Cc:     "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>,
        "libc-alpha@sourceware.org" <libc-alpha@sourceware.org>,
        linux-man <linux-man@vger.kernel.org>,
        Zack Weinberg <zackw@panix.com>,
        Florian Weimer <fweimer@redhat.com>,
        Paul Eggert <eggert@cs.ucla.edu>,
        Joseph Myers <joseph@codesourcery.com>,
        Linux API <linux-api@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-api-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-api.vger.kernel.org>
X-Mailing-List: linux-api@vger.kernel.org

On Thu, Jul 30, 2020 at 4:38 AM Carlos O'Donell <carlos@redhat.com> wrote:
>
> On 7/30/20 5:16 AM, Michael Kerrisk (man-pages) wrote:
> > I know what you mean. One reason for that verbosity is the need to
> > clearly distinguish "pseudoterminal device/end" from "pseudoterminal
> > device pair". It's hard to avoid being wordy there.
>
> The perfect is the enemy of the good. My feeling is that as others
> write this text in emails or discussions, we'll eventually all settle
> on some other short form we find agreeable and then later we can adjust
> the man pages to use that.

based on my own brief experience, i'm expecting that _code_ will
settle on pty and tty. but if you're reading the man pages to
understand the concepts -- which are inherently quite confusing -- i
think spelling things out in longhand might remain useful in that
context.

> Until then taking the lead to change this
> language is the correct way forward.

yeah, definitely.

i'd prefer for michael to go first -- since the bionic documentation
is basically just a link to man7.org, and even without that he's the
canonical source -- but i'm happy to go first and submit my change
first if it helps us make progress :-)

> --
> Cheers,
> Carlos.
>

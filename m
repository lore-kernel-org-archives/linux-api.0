Return-Path: <SRS0=BOV0=7Z=vger.kernel.org=linux-api-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AB5FBC433E0
	for <linux-api@archiver.kernel.org>; Fri, 12 Jun 2020 19:35:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 85D6D2063A
	for <linux-api@archiver.kernel.org>; Fri, 12 Jun 2020 19:35:57 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="mMCretsj"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726358AbgFLTf5 (ORCPT <rfc822;linux-api@archiver.kernel.org>);
        Fri, 12 Jun 2020 15:35:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46760 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726268AbgFLTf4 (ORCPT
        <rfc822;linux-api@vger.kernel.org>); Fri, 12 Jun 2020 15:35:56 -0400
Received: from mail-il1-x142.google.com (mail-il1-x142.google.com [IPv6:2607:f8b0:4864:20::142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8B7E2C03E96F;
        Fri, 12 Jun 2020 12:35:56 -0700 (PDT)
Received: by mail-il1-x142.google.com with SMTP id 9so9803448ilg.12;
        Fri, 12 Jun 2020 12:35:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=fLyHowTjK9VUxR3jGuO5lsoKw9rsC/66b7MwWsYuiLE=;
        b=mMCretsjGQovL2Vlqu0hsbPGV9nUaxzYLua9pej7fFxAD7NkX353fn9VZbdeG9jIVr
         kquhPz7/1Ta1w+kL9+wTVqqCTNrVa5k23kFikoxbfmFV0xjSqnNjh3tQbkvQ0y7Y5qwx
         kNZOO1+Db44CRGp68f0h+YDbC/j38IzIA/KDX1/eeSNSlfyUlPOfnkNMRc/vcYJ2SmOZ
         MnFtfSTuFMRv73NPebXzEc9OqjxJpfkuIi7sfZbwNQP+sLP90b6ahbINtm98J4wBQ17x
         pSv6n/1OXj713UVkpN+LRNcWYQ7Vjuiy60AV6XuAeBrZZFeWk0E3XfClw2rdhev/oRsP
         9IZw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=fLyHowTjK9VUxR3jGuO5lsoKw9rsC/66b7MwWsYuiLE=;
        b=qwLKV2poFHMYcer6+gp7K2pidLO206AzPbYuFROYakqua+pw8P8pMkPmZuFS0Don31
         zC4e9V98QcAJI+kEktEp/eLz63gtl8Gp7e7I4pSkUH7k44YkfK7mFvzPCbyqBNSJxPT5
         rE55RvJjPh8P6LU1hMzhKVoa8F8uLUqlDXlMgKQRP5XhiUodWuRB79Usq/puWJ1FVi8b
         3XkrjAueXR07LqL1ZBfEFYBzXsSWRyhEWpMGJoA8XZ0RUjIS3zC6dsRfyALuZR64MgoA
         1Uog0VLCEprckQUVz3l99Zq+TuV0hfrDsw/EzmgOd6g5aMhbjcw3iJeZ4oESqSRGmTVZ
         MbdQ==
X-Gm-Message-State: AOAM533ebX/+SP3WrvmpJrKH6Usu1sIs6GLX3pjGo8rBYMpPJzsVn2LE
        HiR4UWt7zli/DJZ/TBuVkPuD/fyHYROWOQFqWEzR6w==
X-Google-Smtp-Source: ABdhPJyAjF3WU3IKNqwJ3ysnx28VR/sEcbZ7YwuFYFOfUGEotUuF4Rr54NtXcl5kh8pVZ5CQC+5AFFmaEzHv4Ykl0nQ=
X-Received: by 2002:a92:9914:: with SMTP id p20mr8125160ili.273.1591990555172;
 Fri, 12 Jun 2020 12:35:55 -0700 (PDT)
MIME-Version: 1.0
References: <20200612185122.327860-1-andrealmeid@collabora.com>
In-Reply-To: <20200612185122.327860-1-andrealmeid@collabora.com>
From:   "H.J. Lu" <hjl.tools@gmail.com>
Date:   Fri, 12 Jun 2020 12:35:19 -0700
Message-ID: <CAMe9rOqnBRzXv4xnhFvOgdVpDo0oRc1SYq38zcJWo9BPZseagg@mail.gmail.com>
Subject: Re: [RFC 0/4] futex2: Add new futex interface
To:     =?UTF-8?Q?Andr=C3=A9_Almeida?= <andrealmeid@collabora.com>
Cc:     LKML <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>,
        Florian Weimer <fweimer@redhat.com>, malteskarupke@web.de,
        GNU C Library <libc-alpha@sourceware.org>,
        Linux API <linux-api@vger.kernel.org>,
        Ingo Molnar <mingo@redhat.com>, dvhart@infradead.org,
        kernel@collabora.com, krisman@collabora.com,
        pgriffais@valvesoftware.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-api-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-api.vger.kernel.org>
X-Mailing-List: linux-api@vger.kernel.org

On Fri, Jun 12, 2020 at 11:53 AM Andr=C3=A9 Almeida via Libc-alpha
<libc-alpha@sourceware.org> wrote:
>
> Hello,
>
> This RFC is a followup to the previous discussion initiated from my last
> patch "futex: Implement mechanism to wait on any of several futexes"[1].
> As stated in the thread, the correct approach to move forward with the
> wait multiple operation would be to create a new syscall that would have
> all new cool features.
>
> The first patch adds the new interface and just translate the call for
> the old interface, without implementing new features. The goal here is
> to establish the interface and to check if everyone is happy with this
> API. The rest of patches are selftests to show the interface in action.
> I have the following questions:
>
> - Has anyone stared worked on a implementation of this interface? If
>   yes, it would be nice to share the progress so we don't have duplicated
>   work.
>
> - What suggestions do you have to implement this? Start from scratch or
>   reuse the most code possible?
>
> - The interface seems correct and implements the requirements asked by yo=
u?
>
> - The proposed interface uses ktime_t type for absolute timeout, and I
>   assumed that it should use values in a nsec resolution. If this is true=
,
>   we have some problems with i386 ABI, please check out the
>   COMPAT_32BIT_TIME implementation in patch 1 for more details. I
>   haven't added a time64 implementation yet, until this is clarified.
>
> - Is expected to have a x32 ABI implementation as well? In the case of
>   wait and wake, we could use the same as x86_64 ABI. However, for the
>   waitv (aka wait on multiple futexes) we would need a proper x32 entry
>   since we are dealing with 32bit pointers.

x32 should be able to use the same i386 compat systcall entry.   Will it be
problem?

> Those are the cool new features that this syscall should address some
> day:
>
> - Operate with variable bit size futexes, not restricted to 32:
>   8, 16 and 64
>
> - Wait on multiple futexes, using the following semantics:
>
>   struct futex_wait {
>         void *uaddr;
>         unsigned long val;
>         unsigned long flags;
>   };
>
>   sys_futex_waitv(struct futex_wait *waiters, unsigned int nr_waiters,
>                   unsigned long flags, ktime_t *timo);
>
> - Have NUMA optimizations: if FUTEX_NUMA_FLAG is present, the `void *uadd=
r`
>   argument won't be a u{8, 16, 32, 64} value anymore, but a struct
>   containing a NUMA node hint:
>
>   struct futex32_numa {
>           u32 value __attribute__ ((aligned (8)));
>           u32 hint;
>   };
>
>   struct futex64_numa {
>           u64 value __attribute__ ((aligned (16)));
>           u64 hint;
>   };
>

H.J.

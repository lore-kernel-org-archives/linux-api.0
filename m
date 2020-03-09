Return-Path: <SRS0=YmEt=42=vger.kernel.org=linux-api-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 443ADC10F29
	for <linux-api@archiver.kernel.org>; Mon,  9 Mar 2020 19:33:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 28BEC24673
	for <linux-api@archiver.kernel.org>; Mon,  9 Mar 2020 19:33:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726121AbgCITdh (ORCPT <rfc822;linux-api@archiver.kernel.org>);
        Mon, 9 Mar 2020 15:33:37 -0400
Received: from vmicros1.altlinux.org ([194.107.17.57]:50988 "EHLO
        vmicros1.altlinux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726115AbgCITdh (ORCPT
        <rfc822;linux-api@vger.kernel.org>); Mon, 9 Mar 2020 15:33:37 -0400
Received: from mua.local.altlinux.org (mua.local.altlinux.org [192.168.1.14])
        by vmicros1.altlinux.org (Postfix) with ESMTP id 7101872CCE7;
        Mon,  9 Mar 2020 22:33:33 +0300 (MSK)
Received: by mua.local.altlinux.org (Postfix, from userid 508)
        id 2DD3B7CC7FF; Mon,  9 Mar 2020 22:33:33 +0300 (MSK)
Date:   Mon, 9 Mar 2020 22:33:33 +0300
From:   "Dmitry V. Levin" <ldv@altlinux.org>
To:     "Eric W. Biederman" <ebiederm@xmission.com>
Cc:     Bernd Edlinger <bernd.edlinger@hotmail.de>,
        Christian Brauner <christian.brauner@ubuntu.com>,
        Kees Cook <keescook@chromium.org>,
        Jann Horn <jannh@google.com>, Jonathan Corbet <corbet@lwn.net>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Andrew Morton <akpm@linux-foundation.org>,
        Alexey Dobriyan <adobriyan@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Oleg Nesterov <oleg@redhat.com>,
        Frederic Weisbecker <frederic@kernel.org>,
        Andrei Vagin <avagin@gmail.com>,
        Ingo Molnar <mingo@kernel.org>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Yuyang Du <duyuyang@gmail.com>,
        David Hildenbrand <david@redhat.com>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Anshuman Khandual <anshuman.khandual@arm.com>,
        David Howells <dhowells@redhat.com>,
        James Morris <jamorris@linux.microsoft.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Shakeel Butt <shakeelb@google.com>,
        Jason Gunthorpe <jgg@ziepe.ca>,
        Christian Kellner <christian@kellner.me>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Aleksa Sarai <cyphar@cyphar.com>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "linux-api@vger.kernel.org" <linux-api@vger.kernel.org>
Subject: Re: [PATCH v2 5/5] exec: Add a exec_update_mutex to replace
 cred_guard_mutex
Message-ID: <20200309193332.GA13534@altlinux.org>
References: <87v9ne5y4y.fsf_-_@x220.int.ebiederm.org>
 <87zhcq4jdj.fsf_-_@x220.int.ebiederm.org>
 <AM6PR03MB5170BC58D90BAD80CDEF3F8BE4FE0@AM6PR03MB5170.eurprd03.prod.outlook.com>
 <878sk94eay.fsf@x220.int.ebiederm.org>
 <AM6PR03MB517086003BD2C32E199690A3E4FE0@AM6PR03MB5170.eurprd03.prod.outlook.com>
 <87r1y12yc7.fsf@x220.int.ebiederm.org>
 <87k13t2xpd.fsf@x220.int.ebiederm.org>
 <87d09l2x5n.fsf@x220.int.ebiederm.org>
 <AM6PR03MB5170F0F9DC18F5EA77C9A857E4FE0@AM6PR03MB5170.eurprd03.prod.outlook.com>
 <871rq12vxu.fsf@x220.int.ebiederm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <871rq12vxu.fsf@x220.int.ebiederm.org>
Sender: linux-api-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-api.vger.kernel.org>
X-Mailing-List: linux-api@vger.kernel.org

On Mon, Mar 09, 2020 at 02:02:37PM -0500, Eric W. Biederman wrote:
> Bernd Edlinger <bernd.edlinger@hotmail.de> writes:
> 
> > On 3/9/20 7:36 PM, Eric W. Biederman wrote:
> >> 
> >> 
> >> Does that sound better?
> >> 
> >
> > almost done.
> 
> I think this text is finally clean.
> 
>     exec: Add exec_update_mutex to replace cred_guard_mutex
>     
>     The cred_guard_mutex is problematic as it is held over possibly
>     indefinite waits for userspace.  The possilbe indefinite waits for

-------------------------------------------^^^^^^^^ possible?


-- 
ldv

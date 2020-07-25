Return-Path: <SRS0=uWfO=BE=vger.kernel.org=linux-api-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.0 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D29ACC433E0
	for <linux-api@archiver.kernel.org>; Sat, 25 Jul 2020 11:18:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B3DBC206C1
	for <linux-api@archiver.kernel.org>; Sat, 25 Jul 2020 11:18:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726962AbgGYLSs (ORCPT <rfc822;linux-api@archiver.kernel.org>);
        Sat, 25 Jul 2020 07:18:48 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:38635 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726728AbgGYLSs (ORCPT
        <rfc822;linux-api@vger.kernel.org>); Sat, 25 Jul 2020 07:18:48 -0400
Received: from ip5f5af08c.dynamic.kabel-deutschland.de ([95.90.240.140] helo=wittgenstein)
        by youngberry.canonical.com with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.86_2)
        (envelope-from <christian.brauner@ubuntu.com>)
        id 1jzI9n-0006EM-Of; Sat, 25 Jul 2020 11:15:59 +0000
Date:   Sat, 25 Jul 2020 13:15:58 +0200
From:   Christian Brauner <christian.brauner@ubuntu.com>
To:     Kees Cook <keescook@chromium.org>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Aleksa Sarai <cyphar@cyphar.com>
Cc:     Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org,
        =?utf-8?Q?Micka=C3=ABl_Sala=C3=BCn?= <mic@digikod.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Andy Lutomirski <luto@kernel.org>,
        Christian Heimes <christian@python.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Deven Bowers <deven.desai@linux.microsoft.com>,
        Dmitry Vyukov <dvyukov@google.com>,
        Eric Biggers <ebiggers@kernel.org>,
        Eric Chiang <ericchiang@google.com>,
        Florian Weimer <fweimer@redhat.com>,
        James Morris <jmorris@namei.org>, Jan Kara <jack@suse.cz>,
        Jann Horn <jannh@google.com>, Jonathan Corbet <corbet@lwn.net>,
        Lakshmi Ramasubramanian <nramas@linux.microsoft.com>,
        Matthew Garrett <mjg59@google.com>,
        Matthew Wilcox <willy@infradead.org>,
        Michael Kerrisk <mtk.manpages@gmail.com>,
        Mimi Zohar <zohar@linux.ibm.com>,
        Philippe =?utf-8?Q?Tr=C3=A9buchet?= 
        <philippe.trebuchet@ssi.gouv.fr>,
        Scott Shell <scottsh@microsoft.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Shuah Khan <shuah@kernel.org>,
        Steve Dower <steve.dower@python.org>,
        Steve Grubb <sgrubb@redhat.com>,
        Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>,
        Thibaut Sautereau <thibaut.sautereau@clip-os.org>,
        Vincent Strubel <vincent.strubel@ssi.gouv.fr>,
        kernel-hardening@lists.openwall.com, linux-api@vger.kernel.org,
        linux-integrity@vger.kernel.org,
        linux-security-module@vger.kernel.org,
        linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH v7 0/7] Add support for O_MAYEXEC
Message-ID: <20200725111558.sawfxujpsxpzw6fk@wittgenstein>
References: <20200723171227.446711-1-mic@digikod.net>
 <202007241205.751EBE7@keescook>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <202007241205.751EBE7@keescook>
Sender: linux-api-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-api.vger.kernel.org>
X-Mailing-List: linux-api@vger.kernel.org

On Fri, Jul 24, 2020 at 12:06:53PM -0700, Kees Cook wrote:
> I think this looks good now.
> 
> Andrew, since you're already carrying my exec clean-ups (repeated here
> in patch 1-3), can you pick the rest of this series too?

Al,

Not sure if you have already re-surfaced from your
csum()/raw_copy_from_user() work completely yet but you had thoughts
about this series iirc.

Aleksa, thoughts?

Thanks!
Christian

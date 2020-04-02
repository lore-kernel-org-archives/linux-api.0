Return-Path: <SRS0=TDPh=5S=vger.kernel.org=linux-api-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 809D9C43331
	for <linux-api@archiver.kernel.org>; Thu,  2 Apr 2020 17:01:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 221A7206F6
	for <linux-api@archiver.kernel.org>; Thu,  2 Apr 2020 17:01:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389948AbgDBRBQ (ORCPT <rfc822;linux-api@archiver.kernel.org>);
        Thu, 2 Apr 2020 13:01:16 -0400
Received: from out01.mta.xmission.com ([166.70.13.231]:52874 "EHLO
        out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389711AbgDBRBQ (ORCPT
        <rfc822;linux-api@vger.kernel.org>); Thu, 2 Apr 2020 13:01:16 -0400
Received: from in01.mta.xmission.com ([166.70.13.51])
        by out01.mta.xmission.com with esmtps (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.90_1)
        (envelope-from <ebiederm@xmission.com>)
        id 1jK3DO-0008Jh-Ms; Thu, 02 Apr 2020 11:01:14 -0600
Received: from ip68-227-160-95.om.om.cox.net ([68.227.160.95] helo=x220.xmission.com)
        by in01.mta.xmission.com with esmtpsa (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.87)
        (envelope-from <ebiederm@xmission.com>)
        id 1jK3DN-0008NS-8i; Thu, 02 Apr 2020 11:01:14 -0600
From:   ebiederm@xmission.com (Eric W. Biederman)
To:     Alexey Gladkov <gladkov.alexey@gmail.com>
Cc:     LKML <linux-kernel@vger.kernel.org>,
        Kernel Hardening <kernel-hardening@lists.openwall.com>,
        Linux API <linux-api@vger.kernel.org>,
        Linux FS Devel <linux-fsdevel@vger.kernel.org>,
        Linux Security Module <linux-security-module@vger.kernel.org>,
        Akinobu Mita <akinobu.mita@gmail.com>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Alexey Dobriyan <adobriyan@gmail.com>,
        Alexey Gladkov <legion@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Andy Lutomirski <luto@kernel.org>,
        Daniel Micay <danielmicay@gmail.com>,
        Djalal Harouni <tixxdz@gmail.com>,
        "Dmitry V . Levin" <ldv@altlinux.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Ingo Molnar <mingo@kernel.org>,
        "J . Bruce Fields" <bfields@fieldses.org>,
        Jeff Layton <jlayton@poochiereds.net>,
        Jonathan Corbet <corbet@lwn.net>,
        Kees Cook <keescook@chromium.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Oleg Nesterov <oleg@redhat.com>
References: <20200327172331.418878-1-gladkov.alexey@gmail.com>
        <20200327172331.418878-8-gladkov.alexey@gmail.com>
Date:   Thu, 02 Apr 2020 11:58:28 -0500
In-Reply-To: <20200327172331.418878-8-gladkov.alexey@gmail.com> (Alexey
        Gladkov's message of "Fri, 27 Mar 2020 18:23:29 +0100")
Message-ID: <875zehkeob.fsf@x220.int.ebiederm.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-SPF: eid=1jK3DN-0008NS-8i;;;mid=<875zehkeob.fsf@x220.int.ebiederm.org>;;;hst=in01.mta.xmission.com;;;ip=68.227.160.95;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX1+Ru1GXxpvu1H/HwnkkVQs5oho2OLsbxwc=
X-SA-Exim-Connect-IP: 68.227.160.95
X-SA-Exim-Mail-From: ebiederm@xmission.com
Subject: Re: [PATCH v10 7/9] proc: move hidepid values to uapi as they are user interface to mount
X-SA-Exim-Version: 4.2.1 (built Thu, 05 May 2016 13:38:54 -0600)
X-SA-Exim-Scanned: Yes (on in01.mta.xmission.com)
Sender: linux-api-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-api.vger.kernel.org>
X-Mailing-List: linux-api@vger.kernel.org


I will just say that I do not understand exporting this to the uapi
headers.  Why do we want to export the enumeration names?

I understand that the values are uapi.  This looks like it will make it
difficult to make changes that rename enumeration values to make
the code more readable.

Given that this patchset goes immediately to using string enumerated
values, I also don't understand the point of exporting
HIDEPID_NOT_PTRACEABLE.  I don't think we need to ever let
people use the numeric value.

My sense is that if we are switching to string values we should
just leave the existing numeric values as backwards compatiblity
and not do anything to make them easier to use.

Eric


Alexey Gladkov <gladkov.alexey@gmail.com> writes:

> Suggested-by: Alexey Dobriyan <adobriyan@gmail.com>
> Reviewed-by: Alexey Dobriyan <adobriyan@gmail.com>
> Signed-off-by: Alexey Gladkov <gladkov.alexey@gmail.com>
> ---
>  include/linux/proc_fs.h      |  9 +--------
>  include/uapi/linux/proc_fs.h | 13 +++++++++++++
>  2 files changed, 14 insertions(+), 8 deletions(-)
>  create mode 100644 include/uapi/linux/proc_fs.h
>
> diff --git a/include/linux/proc_fs.h b/include/linux/proc_fs.h
> index afd38cae2339..d259817ec913 100644
> --- a/include/linux/proc_fs.h
> +++ b/include/linux/proc_fs.h
> @@ -7,6 +7,7 @@
>  
>  #include <linux/types.h>
>  #include <linux/fs.h>
> +#include <uapi/linux/proc_fs.h>
>  
>  struct proc_dir_entry;
>  struct seq_file;
> @@ -27,14 +28,6 @@ struct proc_ops {
>  	unsigned long (*proc_get_unmapped_area)(struct file *, unsigned long, unsigned long, unsigned long, unsigned long);
>  };
>  
> -/* definitions for hide_pid field */
> -enum {
> -	HIDEPID_OFF	  = 0,
> -	HIDEPID_NO_ACCESS = 1,
> -	HIDEPID_INVISIBLE = 2,
> -	HIDEPID_NOT_PTRACEABLE = 4, /* Limit pids to only ptraceable pids */
> -};
> -
>  /* definitions for proc mount option pidonly */
>  enum {
>  	PROC_PIDONLY_OFF = 0,
> diff --git a/include/uapi/linux/proc_fs.h b/include/uapi/linux/proc_fs.h
> new file mode 100644
> index 000000000000..dc6d717aa6ec
> --- /dev/null
> +++ b/include/uapi/linux/proc_fs.h
> @@ -0,0 +1,13 @@
> +/* SPDX-License-Identifier: GPL-2.0 WITH Linux-syscall-note */
> +#ifndef _UAPI_PROC_FS_H
> +#define _UAPI_PROC_FS_H
> +
> +/* definitions for hide_pid field */
> +enum {
> +	HIDEPID_OFF            = 0,
> +	HIDEPID_NO_ACCESS      = 1,
> +	HIDEPID_INVISIBLE      = 2,
> +	HIDEPID_NOT_PTRACEABLE = 4,
> +};
> +
> +#endif

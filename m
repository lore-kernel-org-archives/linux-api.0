Return-Path: <SRS0=TDPh=5S=vger.kernel.org=linux-api-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 01621C2BA12
	for <linux-api@archiver.kernel.org>; Thu,  2 Apr 2020 15:34:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D7198206F6
	for <linux-api@archiver.kernel.org>; Thu,  2 Apr 2020 15:34:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389162AbgDBPeh (ORCPT <rfc822;linux-api@archiver.kernel.org>);
        Thu, 2 Apr 2020 11:34:37 -0400
Received: from out01.mta.xmission.com ([166.70.13.231]:50552 "EHLO
        out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732754AbgDBPeh (ORCPT
        <rfc822;linux-api@vger.kernel.org>); Thu, 2 Apr 2020 11:34:37 -0400
Received: from in01.mta.xmission.com ([166.70.13.51])
        by out01.mta.xmission.com with esmtps (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.90_1)
        (envelope-from <ebiederm@xmission.com>)
        id 1jK1rW-0005mQ-8t; Thu, 02 Apr 2020 09:34:34 -0600
Received: from ip68-227-160-95.om.om.cox.net ([68.227.160.95] helo=x220.xmission.com)
        by in01.mta.xmission.com with esmtpsa (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.87)
        (envelope-from <ebiederm@xmission.com>)
        id 1jK1rV-0007tb-0b; Thu, 02 Apr 2020 09:34:33 -0600
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
        <20200327172331.418878-3-gladkov.alexey@gmail.com>
Date:   Thu, 02 Apr 2020 10:31:48 -0500
In-Reply-To: <20200327172331.418878-3-gladkov.alexey@gmail.com> (Alexey
        Gladkov's message of "Fri, 27 Mar 2020 18:23:24 +0100")
Message-ID: <87eet5lx97.fsf@x220.int.ebiederm.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-SPF: eid=1jK1rV-0007tb-0b;;;mid=<87eet5lx97.fsf@x220.int.ebiederm.org>;;;hst=in01.mta.xmission.com;;;ip=68.227.160.95;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX18bJm/P/P+XAlq1t04hxE6W/8b8KDRYe10=
X-SA-Exim-Connect-IP: 68.227.160.95
X-SA-Exim-Mail-From: ebiederm@xmission.com
Subject: Re: [PATCH v10 2/9] proc: allow to mount many instances of proc in one pid namespace
X-SA-Exim-Version: 4.2.1 (built Thu, 05 May 2016 13:38:54 -0600)
X-SA-Exim-Scanned: Yes (on in01.mta.xmission.com)
Sender: linux-api-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-api.vger.kernel.org>
X-Mailing-List: linux-api@vger.kernel.org


> diff --git a/include/linux/proc_fs.h b/include/linux/proc_fs.h
> index 40a7982b7285..5920a4ecd71b 100644
> --- a/include/linux/proc_fs.h
> +++ b/include/linux/proc_fs.h
> @@ -27,6 +27,17 @@ struct proc_ops {
>  	unsigned long (*proc_get_unmapped_area)(struct file *, unsigned long, unsigned long, unsigned long, unsigned long);
>  };
>  
> +struct proc_fs_info {
> +	struct pid_namespace *pid_ns;
> +	struct dentry *proc_self;        /* For /proc/self */
> +	struct dentry *proc_thread_self; /* For /proc/thread-self */
> +};

Minor nit.

I have not seen a patch where you remove proc_self and proc_thread_self
from struct pid_namepace.

Ideally it would have been in this patch.  But as it won't break
anyone's bisection can you please have a follow up patch that removes
those fields?

Thank you,
Eric



> +
> +static inline struct proc_fs_info *proc_sb_info(struct super_block *sb)
> +{
> +	return sb->s_fs_info;
> +}
> +
>  #ifdef CONFIG_PROC_FS
>  
>  typedef int (*proc_write_t)(struct file *, char *, size_t);
> @@ -161,6 +172,7 @@ int open_related_ns(struct ns_common *ns,
>  /* get the associated pid namespace for a file in procfs */
>  static inline struct pid_namespace *proc_pid_ns(const struct inode *inode)
>  {
> +	return proc_sb_info(inode->i_sb)->pid_ns;
>  	return inode->i_sb->s_fs_info;
>  }

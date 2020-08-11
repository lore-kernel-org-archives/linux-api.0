Return-Path: <SRS0=pyuL=BV=vger.kernel.org=linux-api-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.0 required=3.0 tests=BAD_ENC_HEADER,BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A3C5EC433E1
	for <linux-api@archiver.kernel.org>; Tue, 11 Aug 2020 19:40:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7286F206B2
	for <linux-api@archiver.kernel.org>; Tue, 11 Aug 2020 19:40:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726134AbgHKTkT convert rfc822-to-8bit (ORCPT
        <rfc822;linux-api@archiver.kernel.org>);
        Tue, 11 Aug 2020 15:40:19 -0400
Received: from out01.mta.xmission.com ([166.70.13.231]:58502 "EHLO
        out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726068AbgHKTkS (ORCPT
        <rfc822;linux-api@vger.kernel.org>); Tue, 11 Aug 2020 15:40:18 -0400
Received: from in01.mta.xmission.com ([166.70.13.51])
        by out01.mta.xmission.com with esmtps  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
        (Exim 4.93)
        (envelope-from <ebiederm@xmission.com>)
        id 1k5a7y-009jin-2l; Tue, 11 Aug 2020 13:40:06 -0600
Received: from ip68-227-160-95.om.om.cox.net ([68.227.160.95] helo=x220.xmission.com)
        by in01.mta.xmission.com with esmtpsa (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.87)
        (envelope-from <ebiederm@xmission.com>)
        id 1k5a7w-0004Qr-Ti; Tue, 11 Aug 2020 13:40:05 -0600
From:   ebiederm@xmission.com (Eric W. Biederman)
To:     =?utf-8?Q?Micka=C3=ABl_Sala=C3=BCn?= <mic@digikod.net>
Cc:     linux-kernel@vger.kernel.org, Aleksa Sarai <cyphar@cyphar.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Andrew Morton <akpm@linux-foundation.org>,
        Andy Lutomirski <luto@kernel.org>,
        Christian Brauner <christian.brauner@ubuntu.com>,
        Christian Heimes <christian@python.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Deven Bowers <deven.desai@linux.microsoft.com>,
        Dmitry Vyukov <dvyukov@google.com>,
        Eric Biggers <ebiggers@kernel.org>,
        Eric Chiang <ericchiang@google.com>,
        Florian Weimer <fweimer@redhat.com>,
        James Morris <jmorris@namei.org>, Jan Kara <jack@suse.cz>,
        Jann Horn <jannh@google.com>, Jonathan Corbet <corbet@lwn.net>,
        Kees Cook <keescook@chromium.org>,
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
References: <20200723171227.446711-1-mic@digikod.net>
        <20200723171227.446711-4-mic@digikod.net>
Date:   Tue, 11 Aug 2020 14:36:38 -0500
In-Reply-To: <20200723171227.446711-4-mic@digikod.net> (=?utf-8?Q?=22Micka?=
 =?utf-8?Q?=C3=ABl_Sala=C3=BCn=22's?=
        message of "Thu, 23 Jul 2020 19:12:23 +0200")
Message-ID: <87a6z1m0u1.fsf@x220.int.ebiederm.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
X-XM-SPF: eid=1k5a7w-0004Qr-Ti;;;mid=<87a6z1m0u1.fsf@x220.int.ebiederm.org>;;;hst=in01.mta.xmission.com;;;ip=68.227.160.95;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX18bRw6Qx631bJvZB6GAyvN2Z5/PhB9504A=
X-SA-Exim-Connect-IP: 68.227.160.95
X-SA-Exim-Mail-From: ebiederm@xmission.com
Subject: Re: [PATCH v7 3/7] exec: Move path_noexec() check earlier
X-SA-Exim-Version: 4.2.1 (built Thu, 05 May 2016 13:38:54 -0600)
X-SA-Exim-Scanned: Yes (on in01.mta.xmission.com)
Sender: linux-api-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-api.vger.kernel.org>
X-Mailing-List: linux-api@vger.kernel.org

Mickaël Salaün <mic@digikod.net> writes:

> From: Kees Cook <keescook@chromium.org>
>
> The path_noexec() check, like the regular file check, was happening too
> late, letting LSMs see impossible execve()s. Check it earlier as well
> in may_open() and collect the redundant fs/exec.c path_noexec() test
> under the same robustness comment as the S_ISREG() check.
>
> My notes on the call path, and related arguments, checks, etc:

A big question arises, that I think someone already asked.

Why perform this test in may_open directly instead of moving
it into inode_permission.  That way the code can be shared with
faccessat, and any other code path that wants it?

That would look to provide a more maintainable kernel.

Eric


> do_open_execat()
>     struct open_flags open_exec_flags = {
>         .open_flag = O_LARGEFILE | O_RDONLY | __FMODE_EXEC,
>         .acc_mode = MAY_EXEC,
>         ...
>     do_filp_open(dfd, filename, open_flags)
>         path_openat(nameidata, open_flags, flags)
>             file = alloc_empty_file(open_flags, current_cred());
>             do_open(nameidata, file, open_flags)
>                 may_open(path, acc_mode, open_flag)
>                     /* new location of MAY_EXEC vs path_noexec() test */
>                     inode_permission(inode, MAY_OPEN | acc_mode)
>                         security_inode_permission(inode, acc_mode)
>                 vfs_open(path, file)
>                     do_dentry_open(file, path->dentry->d_inode, open)
>                         security_file_open(f)
>                         open()
>     /* old location of path_noexec() test */
>
> Signed-off-by: Mickaël Salaün <mic@digikod.net>
> Signed-off-by: Kees Cook <keescook@chromium.org>
> Link: https://lore.kernel.org/r/20200605160013.3954297-4-keescook@chromium.org
> ---
>  fs/exec.c  | 12 ++++--------
>  fs/namei.c |  4 ++++
>  2 files changed, 8 insertions(+), 8 deletions(-)
>
> diff --git a/fs/exec.c b/fs/exec.c
> index bdc6a6eb5dce..4eea20c27b01 100644
> --- a/fs/exec.c
> +++ b/fs/exec.c
> @@ -147,10 +147,8 @@ SYSCALL_DEFINE1(uselib, const char __user *, library)
>  	 * and check again at the very end too.
>  	 */
>  	error = -EACCES;
> -	if (WARN_ON_ONCE(!S_ISREG(file_inode(file)->i_mode)))
> -		goto exit;
> -
> -	if (path_noexec(&file->f_path))
> +	if (WARN_ON_ONCE(!S_ISREG(file_inode(file)->i_mode) ||
> +			 path_noexec(&file->f_path)))
>  		goto exit;
>  
>  	fsnotify_open(file);
> @@ -897,10 +895,8 @@ static struct file *do_open_execat(int fd, struct filename *name, int flags)
>  	 * and check again at the very end too.
>  	 */
>  	err = -EACCES;
> -	if (WARN_ON_ONCE(!S_ISREG(file_inode(file)->i_mode)))
> -		goto exit;
> -
> -	if (path_noexec(&file->f_path))
> +	if (WARN_ON_ONCE(!S_ISREG(file_inode(file)->i_mode) ||
> +			 path_noexec(&file->f_path)))
>  		goto exit;
>  
>  	err = deny_write_access(file);
> diff --git a/fs/namei.c b/fs/namei.c
> index a559ad943970..ddc9b25540fe 100644
> --- a/fs/namei.c
> +++ b/fs/namei.c
> @@ -2863,6 +2863,10 @@ static int may_open(const struct path *path, int acc_mode, int flag)
>  			return -EACCES;
>  		flag &= ~O_TRUNC;
>  		break;
> +	case S_IFREG:
> +		if ((acc_mode & MAY_EXEC) && path_noexec(path))
> +			return -EACCES;
> +		break;
>  	}
>  
>  	error = inode_permission(inode, MAY_OPEN | acc_mode);

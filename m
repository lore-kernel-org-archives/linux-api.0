From: Oleg Nesterov <oleg@redhat.com>
Subject: Re: [PATCH v7 02/11] proc: add proc_fs_info struct to store proc
 information
Date: Tue, 28 Jan 2020 15:58:38 +0100
Message-ID: <20200128145837.GD17943@redhat.com>
References: <20200125130541.450409-1-gladkov.alexey@gmail.com>
 <20200125130541.450409-3-gladkov.alexey@gmail.com>
 <20200128134337.GC17943@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-security-module-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20200128134337.GC17943@redhat.com>
Sender: owner-linux-security-module@vger.kernel.org
To: Alexey Gladkov <gladkov.alexey@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Kernel Hardening <kernel-hardening@lists.openwall.com>, Linux API <linux-api@vger.kernel.org>, Linux FS Devel <linux-fsdevel@vger.kernel.org>, Linux Security Module <linux-security-module@vger.kernel.org>, Akinobu Mita <akinobu.mita@gmail.com>, Alexander Viro <viro@zeniv.linux.org.uk>, Alexey Dobriyan <adobriyan@gmail.com>, Andrew Morton <akpm@linux-foundation.org>, Andy Lutomirski <luto@kernel.org>, Daniel Micay <danielmicay@gmail.com>, Djalal Harouni <tixxdz@gmail.com>, "Dmitry V . Levin" <ldv@altlinux.org>, "Eric W . Biederman" <ebiederm@xmission.com>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Ingo Molnar <mingo@kernel.org>, "J . Bruce Fields" <bfields@fieldses.org>, Jeff Layton <jlayton@poochiereds.net>
List-Id: linux-api@vger.kernel.org

On 01/28, Oleg Nesterov wrote:
>
> On 01/25, Alexey Gladkov wrote:
> >
> >  static int proc_init_fs_context(struct fs_context *fc)
> >  {
> >  	struct proc_fs_context *ctx;
> > +	struct pid_namespace *pid_ns;
> >
> >  	ctx = kzalloc(sizeof(struct proc_fs_context), GFP_KERNEL);
> >  	if (!ctx)
> >  		return -ENOMEM;
> >
> > -	ctx->pid_ns = get_pid_ns(task_active_pid_ns(current));
> > +	pid_ns = get_pid_ns(task_active_pid_ns(current));
> > +
> > +	if (!pid_ns->proc_mnt) {
> > +		ctx->fs_info = kzalloc(sizeof(struct proc_fs_info), GFP_KERNEL);
> > +		if (!ctx->fs_info) {
> > +			kfree(ctx);
> > +			return -ENOMEM;
> > +		}
> > +		ctx->fs_info->pid_ns = pid_ns;
> > +	} else {
> > +		ctx->fs_info = proc_sb_info(pid_ns->proc_mnt->mnt_sb);
> > +	}
> > +
>
> it seems that this code lacks put_pid_ns() if pid_ns->proc_mnt != NULL
> or if kzalloc() fails?

OK, this is fixed in 6/11.

Oleg.

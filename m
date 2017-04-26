From: Andy Lutomirski <luto@kernel.org>
Subject: Re: [PATCH RFC v2 5/6] proc: instantiate only pids that we can ptrace
 on 'limit_pids=1' mount option
Date: Wed, 26 Apr 2017 15:09:09 -0700
Message-ID: <CALCETrXM7-NBnBcXbuuhDJZyUFLT7iRfcGGvaqUhDJBGkYJgcQ@mail.gmail.com>
References: <1493123038-30590-1-git-send-email-tixxdz@gmail.com> <1493123038-30590-6-git-send-email-tixxdz@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <kernel-hardening-return-7601-glkh-kernel-hardening=m.gmane.org@lists.openwall.com>
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
In-Reply-To: <1493123038-30590-6-git-send-email-tixxdz@gmail.com>
To: Djalal Harouni <tixxdz@gmail.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Andy Lutomirski <luto@kernel.org>, Kees Cook <keescook@chromium.org>, Andrew Morton <akpm@linux-foundation.org>, Linux FS Devel <linux-fsdevel@vger.kernel.org>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, LSM List <linux-security-module@vger.kernel.org>, Linux API <linux-api@vger.kernel.org>, Dongsu Park <dpark@posteo.net>, Casey Schaufler <casey@schaufler-ca.com>, James Morris <james.l.morris@oracle.com>, "Serge E. Hallyn" <serge@hallyn.com>, Jeff Layton <jlayton@poochiereds.net>, "J. Bruce Fields" <bfields@fieldses.org>, Alexander Viro <viro@zeniv.linux.org.uk>, Alexey Dobriyan <adobriyan@gmail.com>, Ingo Molnar <mingo@kernel.org>, "Eric W. Biederman" <ebiederm@xmission.com>, Oleg Nesterov <oleg@redhat.com>, Michal Hocko <mhocko@suse.com>, Jonathan Corbet <corbet@lwn.net>
List-Id: linux-api@vger.kernel.org

On Tue, Apr 25, 2017 at 5:23 AM, Djalal Harouni <tixxdz@gmail.com> wrote:
> If "limit_pids=1" mount option is set then do not instantiate pids that
> we can not ptrace. "limit_pids=1" means that procfs should only contain
> pids that the caller can ptrace.
>
> Cc: Kees Cook <keescook@chromium.org>
> Cc: Andy Lutomirski <luto@kernel.org>
> Signed-off-by: Djalal Harouni <tixxdz@gmail.com>
> ---
>  fs/proc/base.c | 9 +++++++++
>  1 file changed, 9 insertions(+)
>
> diff --git a/fs/proc/base.c b/fs/proc/base.c
> index 2e0f661..a663284 100644
> --- a/fs/proc/base.c
> +++ b/fs/proc/base.c
> @@ -3149,6 +3149,7 @@ struct dentry *proc_pid_lookup(struct inode *dir, struct dentry * dentry, unsign
>         unsigned tgid;
>         struct proc_fs_info *fs_info = proc_sb(dir->i_sb);
>         struct pid_namespace *ns = fs_info->pid_ns;
> +       int limit_pids = proc_fs_limit_pids(fs_info);

Shouldn't the addition of proc_fs_limit_pids() be in this patch?

Also, can we name it something self-documented?
"ptraceable_pids_only=1", perhaps?  Or even pids=ptraceable (as
opposed to pids=all or maybe other choices in the future)?

--Andy

From: Jann Horn <jannh@google.com>
Subject: Re: [PATCH v7 2/6] seccomp: make get_nth_filter available outside of CHECKPOINT_RESTORE
Date: Thu, 27 Sep 2018 18:51:10 +0200
Message-ID: <CAG48ez0-Zq74QCVJ+P0QZZOE4RG-Y_py-GiKhsD12njkbTgVgw@mail.gmail.com>
References: <20180927151119.9989-1-tycho@tycho.ws> <20180927151119.9989-3-tycho@tycho.ws>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180927151119.9989-3-tycho@tycho.ws>
Sender: linux-kernel-owner@vger.kernel.org
To: Tycho Andersen <tycho@tycho.ws>
Cc: Kees Cook <keescook@chromium.org>, kernel list <linux-kernel@vger.kernel.org>, containers@lists.linux-foundation.org, Linux API <linux-api@vger.kernel.org>, Andy Lutomirski <luto@amacapital.net>, Oleg Nesterov <oleg@redhat.com>, "Eric W. Biederman" <ebiederm@xmission.com>, "Serge E. Hallyn" <serge@hallyn.com>, Christian Brauner <christian.brauner@ubuntu.com>, Tyler Hicks <tyhicks@canonical.com>, suda.akihiro@lab.ntt.co.jp, linux-fsdevel@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On Thu, Sep 27, 2018 at 5:11 PM Tycho Andersen <tycho@tycho.ws> wrote:
> In the next commit we'll use this same mnemonic to get a listener for the
> nth filter, so we need it available outside of CHECKPOINT_RESTORE in the
> USER_NOTIFICATION case as well.
>
> v2: new in v2
> v3: no changes
> v4: no changes
> v5: switch to CHECKPOINT_RESTORE || USER_NOTIFICATION to avoid warning when
>     only CONFIG_SECCOMP_FILTER is enabled.
> v7: drop USER_NOTIFICATION bits
>
> Signed-off-by: Tycho Andersen <tycho@tycho.ws>
> CC: Kees Cook <keescook@chromium.org>
> CC: Andy Lutomirski <luto@amacapital.net>
> CC: Oleg Nesterov <oleg@redhat.com>
> CC: Eric W. Biederman <ebiederm@xmission.com>
> CC: "Serge E. Hallyn" <serge@hallyn.com>
> CC: Christian Brauner <christian.brauner@ubuntu.com>
> CC: Tyler Hicks <tyhicks@canonical.com>
> CC: Akihiro Suda <suda.akihiro@lab.ntt.co.jp>

Reviewed-by: Jann Horn <jannh@google.com>

> ---
>  kernel/seccomp.c | 6 ++++--
>  1 file changed, 4 insertions(+), 2 deletions(-)
>
> diff --git a/kernel/seccomp.c b/kernel/seccomp.c
> index fa6fe9756c80..44a31ac8373a 100644
> --- a/kernel/seccomp.c
> +++ b/kernel/seccomp.c
> @@ -1158,7 +1158,7 @@ long prctl_set_seccomp(unsigned long seccomp_mode, char __user *filter)
>         return do_seccomp(op, 0, uargs);
>  }
>
> -#if defined(CONFIG_SECCOMP_FILTER) && defined(CONFIG_CHECKPOINT_RESTORE)
> +#if defined(CONFIG_SECCOMP_FILTER)
>  static struct seccomp_filter *get_nth_filter(struct task_struct *task,
>                                              unsigned long filter_off)
>  {
> @@ -1205,6 +1205,7 @@ static struct seccomp_filter *get_nth_filter(struct task_struct *task,
>         return filter;
>  }
>
> +#if defined(CONFIG_CHECKPOINT_RESTORE)
>  long seccomp_get_filter(struct task_struct *task, unsigned long filter_off,
>                         void __user *data)
>  {
> @@ -1277,7 +1278,8 @@ long seccomp_get_metadata(struct task_struct *task,
>         __put_seccomp_filter(filter);
>         return ret;
>  }
> -#endif
> +#endif /* CONFIG_CHECKPOINT_RESTORE */
> +#endif /* CONFIG_SECCOMP_FILTER */
>
>  #ifdef CONFIG_SYSCTL
>
> --
> 2.17.1
>

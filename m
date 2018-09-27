From: Jann Horn <jannh@google.com>
Subject: Re: [PATCH v7 3/6] seccomp: add a way to get a listener fd from ptrace
Date: Thu, 27 Sep 2018 19:35:06 +0200
Message-ID: <CAG48ez14hkjQr8_ysg13Ax9uc+abKeTtN7pCxuiJ83Ms3Gbo5Q@mail.gmail.com>
References: <20180927151119.9989-1-tycho@tycho.ws> <20180927151119.9989-4-tycho@tycho.ws>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180927151119.9989-4-tycho@tycho.ws>
Sender: linux-kernel-owner@vger.kernel.org
To: Tycho Andersen <tycho@tycho.ws>
Cc: Kees Cook <keescook@chromium.org>, kernel list <linux-kernel@vger.kernel.org>, containers@lists.linux-foundation.org, Linux API <linux-api@vger.kernel.org>, Andy Lutomirski <luto@amacapital.net>, Oleg Nesterov <oleg@redhat.com>, "Eric W. Biederman" <ebiederm@xmission.com>, "Serge E. Hallyn" <serge@hallyn.com>, Christian Brauner <christian.brauner@ubuntu.com>, Tyler Hicks <tyhicks@canonical.com>, suda.akihiro@lab.ntt.co.jp, linux-fsdevel@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On Thu, Sep 27, 2018 at 5:11 PM Tycho Andersen <tycho@tycho.ws> wrote:
>
> As an alternative to SECCOMP_FILTER_FLAG_GET_LISTENER, perhaps a ptrace()
> version which can acquire filters is useful. There are at least two reasons
> this is preferable, even though it uses ptrace:
>
> 1. You can control tasks that aren't cooperating with you
> 2. You can control tasks whose filters block sendmsg() and socket(); if the
>    task installs a filter which blocks these calls, there's no way with
>    SECCOMP_FILTER_FLAG_GET_LISTENER to get the fd out to the privileged task.
[...]
> diff --git a/kernel/ptrace.c b/kernel/ptrace.c
> index 21fec73d45d4..289960ac181b 100644
> --- a/kernel/ptrace.c
> +++ b/kernel/ptrace.c
> @@ -1096,6 +1096,10 @@ int ptrace_request(struct task_struct *child, long request,
>                 ret = seccomp_get_metadata(child, addr, datavp);
>                 break;
>
> +       case PTRACE_SECCOMP_NEW_LISTENER:
> +               ret = seccomp_new_listener(child, addr);
> +               break;

Actually, could you amend this to also ensure that `data == 0` and
return -EINVAL otherwise? Then if we want to abuse `data` for passing
flags in the future, we don't have to worry about what happens if
someone passes in garbage as `data`.

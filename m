From: Andy Lutomirski <luto@kernel.org>
Subject: Re: [PATCH] security: Use user_namespace::level to avoid redundant
 iterations in cap_capable()
Date: Tue, 2 May 2017 09:36:40 -0700
Message-ID: <CALCETrWT5u=dpRadn_dHosa0YEpC9j_-Gttu7qk1pOrN9XmfUA@mail.gmail.com>
References: <149372879732.11927.12565684278286604561.stgit@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <149372879732.11927.12565684278286604561.stgit@localhost.localdomain>
Sender: linux-kernel-owner@vger.kernel.org
To: Kirill Tkhai <ktkhai@virtuozzo.com>
Cc: "Serge E. Hallyn" <serge@hallyn.com>, "Eric W. Biederman" <ebiederm@xmission.com>, Andreas Gruenbacher <agruenba@redhat.com>, Greg KH <gregkh@linuxfoundation.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Oleg Nesterov <oleg@redhat.com>, Paul Moore <paul@paul-moore.com>, Al Viro <viro@zeniv.linux.org.uk>, Andrey Vagin <avagin@openvz.org>, Linux API <linux-api@vger.kernel.org>, Linux FS Devel <linux-fsdevel@vger.kernel.org>, Michael Kerrisk <mtk.manpages@gmail.com>, Andrew Morton <akpm@linux-foundation.org>, Cyrill Gorcunov <gorcunov@openvz.org>, Ingo Molnar <mingo@kernel.org>, Kees Cook <keescook@chromium.org>
List-Id: linux-api@vger.kernel.org

On Tue, May 2, 2017 at 5:40 AM, Kirill Tkhai <ktkhai@virtuozzo.com> wrote:
> When ns->level is not larger then cred->user_ns->level,
> then ns can't be cred->user_ns's descendant, and
> there is no a sence to search in parents.
>
> So, breake the cycle earlier and skip needless iterations.
>
> Signed-off-by: Kirill Tkhai <ktkhai@virtuozzo.com>
> ---
>  security/commoncap.c |    7 +++++--
>  1 file changed, 5 insertions(+), 2 deletions(-)
>
> diff --git a/security/commoncap.c b/security/commoncap.c
> index 78b37838a2d3..f6ef78208d2d 100644
> --- a/security/commoncap.c
> +++ b/security/commoncap.c
> @@ -82,8 +82,11 @@ int cap_capable(const struct cred *cred, struct user_namespace *targ_ns,
>                 if (ns == cred->user_ns)
>                         return cap_raised(cred->cap_effective, cap) ? 0 : -EPERM;
>
> -               /* Have we tried all of the parent namespaces? */
> -               if (ns == &init_user_ns)
> +               /*
> +                * If ns can't be a descendant of cred->user_ns, then it's
> +                * needlessly to go up.
> +                */
> +               if (ns->level <= cred->user_ns->level)
>                         return -EPERM;

This is a nice improvement, but the comment could be better.  How
about "If we're already at a lower level than we're looking for, we're
done searching."

--Andy

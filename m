From: Paul Moore <paul@paul-moore.com>
Subject: Re: [PATCH ghak90 (was ghak32) V4 04/10] audit: add containerid
 support for ptrace and signals
Date: Fri, 19 Oct 2018 19:16:54 -0400
Message-ID: <CAHC9VhSFtNMkSABZivf+C5N5SM9iC2Sh958uC+zYwceUv5zpeQ@mail.gmail.com>
References: <cover.1533065887.git.rgb@redhat.com> <71c7761b5e0289fee7d82ddcc723d39804826e53.1533065887.git.rgb@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <71c7761b5e0289fee7d82ddcc723d39804826e53.1533065887.git.rgb@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: rgb@redhat.com
Cc: containers@lists.linux-foundation.org, linux-api@vger.kernel.org, linux-audit@redhat.com, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, netdev@vger.kernel.org, netfilter-devel@vger.kernel.org, ebiederm@xmission.com, luto@kernel.org, carlos@redhat.com, dhowells@redhat.com, viro@zeniv.linux.org.uk, simo@redhat.com, Eric Paris <eparis@parisplace.org>, Serge Hallyn <serge@hallyn.com>
List-Id: linux-api@vger.kernel.org

On Tue, Jul 31, 2018 at 4:11 PM Richard Guy Briggs <rgb@redhat.com> wrote:
> Add audit container identifier support to ptrace and signals.  In
> particular, the "op" field provides a way to label the auxiliary record
> to which it is associated.
>
> Signed-off-by: Richard Guy Briggs <rgb@redhat.com>
> Acked-by: Serge Hallyn <serge@hallyn.com>
> ---
>  include/linux/audit.h | 11 +++++------
>  kernel/audit.c        | 13 +++++++------
>  kernel/audit.h        |  2 ++
>  kernel/auditsc.c      | 21 ++++++++++++++++-----
>  4 files changed, 30 insertions(+), 17 deletions(-)

...

> @@ -155,9 +156,8 @@ extern void             audit_log_key(struct audit_buffer *ab,
>  extern int audit_log_task_context(struct audit_buffer *ab);
>  extern void audit_log_task_info(struct audit_buffer *ab,
>                                 struct task_struct *tsk);
> -extern int audit_log_contid(struct task_struct *tsk,
> -                                   struct audit_context *context,
> -                                   char *op);
> +extern int audit_log_contid(struct audit_context *context,
> +                                    char *op, u64 contid);
>
>  extern int                 audit_update_lsm_rules(void);

...

> @@ -2047,23 +2049,22 @@ void audit_log_session_info(struct audit_buffer *ab)
>
>  /*
>   * audit_log_contid - report container info
> - * @tsk: task to be recorded
>   * @context: task or local context for record
>   * @op: contid string description
> + * @contid: container ID to report
>   */
> -int audit_log_contid(struct task_struct *tsk,
> -                            struct audit_context *context, char *op)
> +int audit_log_contid(struct audit_context *context,
> +                             char *op, u64 contid)
>  {
>         struct audit_buffer *ab;
>
> -       if (!audit_contid_set(tsk))
> +       if (!audit_contid_valid(contid))
>                 return 0;
>         /* Generate AUDIT_CONTAINER record with container ID */
>         ab = audit_log_start(context, GFP_KERNEL, AUDIT_CONTAINER);
>         if (!ab)
>                 return -ENOMEM;
> -       audit_log_format(ab, "op=%s contid=%llu",
> -                        op, audit_get_contid(tsk));
> +       audit_log_format(ab, "op=%s contid=%llu", op, contid);
>         audit_log_end(ab);
>         return 0;
>  }

My previous comments still apply: these audit_log_contid() changes
should be done earlier in the patchset when you first define
audit_log_contid().

--
paul moore
www.paul-moore.com

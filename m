From: Paul Moore <paul@paul-moore.com>
Subject: Re: [RFC PATCH ghak90 (was ghak32) V3 03/10] audit: add containerid
 support for ptrace and signals
Date: Fri, 20 Jul 2018 18:13:47 -0400
Message-ID: <CAHC9VhRZrGMSdDqQAqEogWOQQfLH26_=30Gh5JVZ4pasdhHUwA@mail.gmail.com>
References: <cover.1528304203.git.rgb@redhat.com> <29359e0e6bc34c74b3a2c3ce0cdfda77f530cf18.1528304204.git.rgb@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <29359e0e6bc34c74b3a2c3ce0cdfda77f530cf18.1528304204.git.rgb@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: rgb@redhat.com
Cc: cgroups@vger.kernel.org, containers@lists.linux-foundation.org, linux-api@vger.kernel.org, linux-audit@redhat.com, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, netdev@vger.kernel.org, ebiederm@xmission.com, luto@kernel.org, jlayton@redhat.com, carlos@redhat.com, dhowells@redhat.com, viro@zeniv.linux.org.uk, simo@redhat.com, Eric Paris <eparis@parisplace.org>, serge@hallyn.com
List-Id: linux-api@vger.kernel.org

On Wed, Jun 6, 2018 at 1:01 PM Richard Guy Briggs <rgb@redhat.com> wrote:
> Add audit container identifier support to ptrace and signals.  In
> particular, the "op" field provides a way to label the auxiliary record
> to which it is associated.
>
> Signed-off-by: Richard Guy Briggs <rgb@redhat.com>
> ---
>  include/linux/audit.h | 11 +++++------
>  kernel/audit.c        | 13 +++++++------
>  kernel/audit.h        |  2 ++
>  kernel/auditsc.c      | 21 ++++++++++++++++-----
>  4 files changed, 30 insertions(+), 17 deletions(-)

...

> diff --git a/kernel/audit.c b/kernel/audit.c
> index 5e150c6..ba304a8 100644
> --- a/kernel/audit.c
> +++ b/kernel/audit.c
> @@ -142,6 +142,7 @@ struct audit_net {
>  kuid_t         audit_sig_uid = INVALID_UID;
>  pid_t          audit_sig_pid = -1;
>  u32            audit_sig_sid = 0;
> +u64            audit_sig_cid = AUDIT_CID_UNSET;
>
>  /* Records can be lost in several ways:
>     0) [suppressed in audit_alloc]
> @@ -1437,6 +1438,7 @@ static int audit_receive_msg(struct sk_buff *skb, struct nlmsghdr *nlh)
>                         memcpy(sig_data->ctx, ctx, len);
>                         security_release_secctx(ctx, len);
>                 }
> +               sig_data->cid = audit_sig_cid;
>                 audit_send_reply(skb, seq, AUDIT_SIGNAL_INFO, 0, 0,
>                                  sig_data, sizeof(*sig_data) + len);
>                 kfree(sig_data);
> @@ -2050,23 +2052,22 @@ void audit_log_session_info(struct audit_buffer *ab)
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
> +       if (!cid_valid(contid))
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

You might as well just make these changes to audit_log_contid() in
patch 2 when you first define audit_log_contid().

--
paul moore
www.paul-moore.com

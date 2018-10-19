From: Paul Moore <paul@paul-moore.com>
Subject: Re: [PATCH ghak90 (was ghak32) V4 06/10] audit: add containerid
 support for tty_audit
Date: Fri, 19 Oct 2018 19:17:34 -0400
Message-ID: <CAHC9VhRPMAUsgs2zXkPEFZPQS6dmAO1-kBX1Y-7tRkD-kwGEjw@mail.gmail.com>
References: <cover.1533065887.git.rgb@redhat.com> <e41cb6760a8183c0955c378fce7b500819f9838f.1533065887.git.rgb@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <e41cb6760a8183c0955c378fce7b500819f9838f.1533065887.git.rgb@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: rgb@redhat.com
Cc: containers@lists.linux-foundation.org, linux-api@vger.kernel.org, linux-audit@redhat.com, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, netdev@vger.kernel.org, netfilter-devel@vger.kernel.org, ebiederm@xmission.com, luto@kernel.org, carlos@redhat.com, dhowells@redhat.com, viro@zeniv.linux.org.uk, simo@redhat.com, Eric Paris <eparis@parisplace.org>, Serge Hallyn <serge@hallyn.com>
List-Id: linux-api@vger.kernel.org

On Sun, Aug 5, 2018 at 4:33 AM Richard Guy Briggs <rgb@redhat.com> wrote:
> Add audit container identifier auxiliary record to tty logging rule
> event standalone records.
>
> Signed-off-by: Richard Guy Briggs <rgb@redhat.com>
> Acked-by: Serge Hallyn <serge@hallyn.com>
> ---
>  drivers/tty/tty_audit.c | 5 ++++-
>  1 file changed, 4 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/tty/tty_audit.c b/drivers/tty/tty_audit.c
> index 50f567b..3e21477 100644
> --- a/drivers/tty/tty_audit.c
> +++ b/drivers/tty/tty_audit.c
> @@ -66,8 +66,9 @@ static void tty_audit_log(const char *description, dev_t dev,
>         uid_t uid = from_kuid(&init_user_ns, task_uid(tsk));
>         uid_t loginuid = from_kuid(&init_user_ns, audit_get_loginuid(tsk));
>         unsigned int sessionid = audit_get_sessionid(tsk);
> +       struct audit_context *context = audit_alloc_local(GFP_KERNEL);
>
> -       ab = audit_log_start(NULL, GFP_KERNEL, AUDIT_TTY);
> +       ab = audit_log_start(context, GFP_KERNEL, AUDIT_TTY);
>         if (ab) {
>                 char name[sizeof(tsk->comm)];
>
> @@ -80,6 +81,8 @@ static void tty_audit_log(const char *description, dev_t dev,
>                 audit_log_n_hex(ab, data, size);
>                 audit_log_end(ab);
>         }
> +       audit_log_contid(context, "tty", audit_get_contid(tsk));
> +       audit_free_context(context);
>  }

Since I never polished up my task_struct/current fix patch enough to
get it past RFC status during this development window (new job, stolen
laptop, etc.) *and* it looks like you are going to need at least one
more respin of this patchset, go ahead and fix this patch to use
current instead of generating a local context.  I'll deal with the
merge fallout if/when it happens.

Local contexts are a last resort.  If you ever find yourself writing
code that generates a local context, you should first be 100% certain
that the event is not the the result of a process initiated action (in
which case it should take from the task's context).

--
paul moore
www.paul-moore.com

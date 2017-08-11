From: Kees Cook <keescook@chromium.org>
Subject: Re: [PATCH v6 3/6] seccomp: Sysctl to configure actions that are
 allowed to be logged
Date: Fri, 11 Aug 2017 12:17:07 -0700
Message-ID: <CAGXu5jJzboJ47tZH_BkeXTYgD_QyTpK4gXd8FTpcj-acO-F+VQ@mail.gmail.com>
References: <1502426037-3777-1-git-send-email-tyhicks@canonical.com> <1502426037-3777-4-git-send-email-tyhicks@canonical.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1502426037-3777-4-git-send-email-tyhicks@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Tyler Hicks <tyhicks@canonical.com>
Cc: Andy Lutomirski <luto@amacapital.net>, Will Drewry <wad@chromium.org>, Paul Moore <paul@paul-moore.com>, Eric Paris <eparis@redhat.com>, John Crispin <john@phrozen.org>, Tycho Andersen <tycho@docker.com>, linux-audit@redhat.com, LKML <linux-kernel@vger.kernel.org>, Linux API <linux-api@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

On Thu, Aug 10, 2017 at 9:33 PM, Tyler Hicks <tyhicks@canonical.com> wrote:
> +static int seccomp_actions_logged_handler(struct ctl_table *ro_table, int write,
> +                                         void __user *buffer, size_t *lenp,
> +                                         loff_t *ppos)
> +{
> +       char names[sizeof(seccomp_actions_avail)];
> +       struct ctl_table table;
> +       int ret;
> +
> +       if (write && !capable(CAP_SYS_ADMIN))
> +               return -EPERM;
> +
> +       memset(names, 0, sizeof(names));
> +
> +       if (!write) {
> +               if (!seccomp_names_from_actions_logged(names, sizeof(names),
> +                                                      seccomp_actions_logged))
> +                       return -EINVAL;
> +       }
> +
> +       table = *ro_table;
> +       table.data = names;
> +       table.maxlen = sizeof(names);
> +       ret = proc_dostring(&table, write, buffer, lenp, ppos);
> +       if (ret)
> +               return ret;
> +
> +       if (write) {
> +               u32 actions_logged;
> +
> +               if (!seccomp_actions_logged_from_names(&actions_logged,
> +                                                      table.data))
> +                       return -EINVAL;
> +
> +               if (actions_logged & SECCOMP_LOG_ALLOW)
> +                       return -EINVAL;
> +
> +               seccomp_actions_logged = actions_logged;
> +       }
> +
> +       return 0;
> +}

One thought here: should "kill" be always forced on during a write?
This flag effectively cannot be disabled, so listing it (or not) in
the sysctl may be confusing...

-Kees

-- 
Kees Cook
Pixel Security

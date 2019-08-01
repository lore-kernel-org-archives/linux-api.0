From: Andy Lutomirski <luto@kernel.org>
Subject: Re: [PATCHv5 01/37] ns: Introduce Time Namespace
Date: Wed, 31 Jul 2019 22:29:45 -0700
Message-ID: <CALCETrWHEcaG9gZe6ACt5H1H+P8D0RobrJ_bf4Wf9ts40NMM9w@mail.gmail.com>
References: <20190729215758.28405-1-dima@arista.com> <20190729215758.28405-2-dima@arista.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190729215758.28405-2-dima@arista.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Dmitry Safonov <dima@arista.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Dmitry Safonov <0x7f454c46@gmail.com>, Andrei Vagin <avagin@openvz.org>, Adrian Reber <adrian@lisas.de>, Andy Lutomirski <luto@kernel.org>, Arnd Bergmann <arnd@arndb.de>, Christian Brauner <christian.brauner@ubuntu.com>, Cyrill Gorcunov <gorcunov@openvz.org>, "Eric W. Biederman" <ebiederm@xmission.com>, "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>, Jann Horn <jannh@google.com>, Jeff Dike <jdike@addtoit.com>, Oleg Nesterov <oleg@redhat.com>, Pavel Emelyanov <xemul@virtuozzo.com>, Shuah Khan <shuah@kernel.org>, Thomas Gleixner <tglx@linutronix.de>, Vincenzo Frascino <vincenzo.frascino@arm.com>, Linux Containers <containers@lists.linux-foundation.org>, criu@openvz.org, Linux API <linux-api@vger.ke>
List-Id: linux-api@vger.kernel.org

On Mon, Jul 29, 2019 at 2:58 PM Dmitry Safonov <dima@arista.com> wrote:
>
> From: Andrei Vagin <avagin@openvz.org>
>
> Time Namespace isolates clock values.

> +static int timens_install(struct nsproxy *nsproxy, struct ns_common *new)
> +{
> +       struct time_namespace *ns = to_time_ns(new);
> +
> +       if (!thread_group_empty(current))
> +               return -EINVAL;

You also need to check for other users of the mm.

> +
> +       if (!ns_capable(ns->user_ns, CAP_SYS_ADMIN) ||
> +           !ns_capable(current_user_ns(), CAP_SYS_ADMIN))
> +               return -EPERM;
> +
> +       get_time_ns(ns);
> +       get_time_ns(ns);
> +       put_time_ns(nsproxy->time_ns);
> +       put_time_ns(nsproxy->time_ns_for_children);
> +       nsproxy->time_ns = ns;
> +       nsproxy->time_ns_for_children = ns;
> +       ns->initialized = true;

I really really wish that setns() took an explicit flag for "change
now" or "change for children", since the semantics are different.  Oh
well.

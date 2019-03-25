From: Jann Horn <jannh@google.com>
Subject: Re: [PATCH 3/4] signal: support pidctl() with pidfd_send_signal()
Date: Mon, 25 Mar 2019 19:39:25 +0100
Message-ID: <CAG48ez1QSJTOb-DAQuVpa5feUe9K-pr8aYuyd=yXg0n9eSg-LQ@mail.gmail.com>
References: <20190325162052.28987-1-christian@brauner.io> <20190325162052.28987-4-christian@brauner.io>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190325162052.28987-4-christian@brauner.io>
Sender: linux-kernel-owner@vger.kernel.org
To: Christian Brauner <christian@brauner.io>
Cc: Konstantin Khlebnikov <khlebnikov@yandex-team.ru>, Andy Lutomirski <luto@kernel.org>, David Howells <dhowells@redhat.com>, "Serge E. Hallyn" <serge@hallyn.com>, "Eric W. Biederman" <ebiederm@xmission.com>, Linux API <linux-api@vger.kernel.org>, kernel list <linux-kernel@vger.kernel.org>, Arnd Bergmann <arnd@arndb.de>, Kees Cook <keescook@chromium.org>, Alexey Dobriyan <adobriyan@gmail.com>, Thomas Gleixner <tglx@linutronix.de>, Michael Kerrisk-manpages <mtk.manpages@gmail.com>, bl0pbl33p@gmail.com, "Dmitry V. Levin" <ldv@altlinux.org>, Andrew Morton <akpm@linux-foundation.org>, Oleg Nesterov <oleg@redhat.com>, Nagarathnam Muthusamy <nagarathnam.muthusamy@oracle.com>, cyphar@cyphar.com, Al Viro <viro@zeniv.linux.org.uk>, "Joel Fernandes (Google)" <joe>
List-Id: linux-api@vger.kernel.org

On Mon, Mar 25, 2019 at 5:21 PM Christian Brauner <christian@brauner.io> wrote:
> Let pidfd_send_signal() use pidfds retrieved via pidctl(). With this patch
> pidfd_send_signal() becomes independent of procfs. This fullfils the
> request made when we merged the pidfd_send_signal() patchset. The
> pidfd_send_signal() syscall is now always available allowing for it to be
> used by users without procfs mounted or even users without procfs support
> compiled into the kernel.
[...]
>  static bool access_pidfd_pidns(struct pid *pid)
>  {
> +       int ret;
>         struct pid_namespace *active = task_active_pid_ns(current);
>         struct pid_namespace *p = ns_of_pid(pid);
>
> -       for (;;) {
> -               if (!p)
> -                       return false;
> -               if (p == active)
> -                       break;
> -               p = p->parent;
> -       }
> +       ret = pidnscmp(active, p);
> +       if (ret < 0)
> +               return false;
>
>         return true;
>  }

Nit, if we keep this function: "if (...) return false; return true;"
seems like an antipattern to me. How about "return ret >= 0", or even
"return pidnscmp(active, p) >= 0"?

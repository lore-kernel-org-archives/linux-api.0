From: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH v5 5/7] proc: instantiate only pids that we can ptrace on
 'limit_pids=1' mount option
Date: Fri, 11 May 2018 09:45:33 -0700
Message-ID: <CA+55aFxYwH6dw=bsQJHEgkM_iZfVNerqn+RAXrrY2iufJag6Qw@mail.gmail.com>
References: <20180511093613.GA1330@comp-core-i7-2640m-0182e6>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180511093613.GA1330@comp-core-i7-2640m-0182e6>
Sender: linux-kernel-owner@vger.kernel.org
To: gladkov.alexey@gmail.com
Cc: Kees Cook <keescook@chromium.org>, Andrew Lutomirski <luto@kernel.org>, Andrew Morton <akpm@linux-foundation.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Kernel Hardening <kernel-hardening@lists.openwall.com>, LSM List <linux-security-module@vger.kernel.org>, Linux API <linux-api@vger.kernel.org>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Al Viro <viro@zeniv.linux.org.uk>, Akinobu Mita <akinobu.mita@gmail.com>, Oleg Nesterov <oleg@redhat.com>, Jeff Layton <jlayton@poochiereds.net>, Ingo Molnar <mingo@kernel.org>, Alexey Dobriyan <adobriyan@gmail.com>, "Eric W. Biederman" <ebiederm@xmission.com>, Daniel Micay <danielmicay@gmail.com>, Jonathan Corbet <corbet@lwn.net>, J.
List-Id: linux-api@vger.kernel.org

On Fri, May 11, 2018 at 2:46 AM Alexey Gladkov <gladkov.alexey@gmail.com>
wrote:

> +       /* Limit procfs to only ptracable tasks */
> +       if (limit_pids == PROC_LIMIT_PIDS_PTRACE) {
> +               cond_resched();
> +               if (!has_pid_permissions(fs_info, task,
HIDEPID_NO_ACCESS))
> +                       goto out_put_task;
> +       }

Where did that "cond_resched()" come from? That doesn't seem to make a lot
of sense.

                    Linus

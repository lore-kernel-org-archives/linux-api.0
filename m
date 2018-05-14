From: Alexey Gladkov <gladkov.alexey@gmail.com>
Subject: Re: [PATCH v5 5/7] proc: instantiate only pids that we can ptrace on
 'limit_pids=1' mount option
Date: Mon, 14 May 2018 10:29:08 +0200
Message-ID: <20180514082908.GA28179@comp-core-i7-2640m-0182e6>
References: <20180511093613.GA1330@comp-core-i7-2640m-0182e6>
 <CA+55aFxYwH6dw=bsQJHEgkM_iZfVNerqn+RAXrrY2iufJag6Qw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CA+55aFxYwH6dw=bsQJHEgkM_iZfVNerqn+RAXrrY2iufJag6Qw@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Kees Cook <keescook@chromium.org>, Andrew Lutomirski <luto@kernel.org>, Andrew Morton <akpm@linux-foundation.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Kernel Hardening <kernel-hardening@lists.openwall.com>, LSM List <linux-security-module@vger.kernel.org>, Linux API <linux-api@vger.kernel.org>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Al Viro <viro@zeniv.linux.org.uk>, Akinobu Mita <akinobu.mita@gmail.com>, Oleg Nesterov <oleg@redhat.com>, Jeff Layton <jlayton@poochiereds.net>, Ingo Molnar <mingo@kernel.org>, Alexey Dobriyan <adobriyan@gmail.com>, "Eric W. Biederman" <ebiederm@xmission.com>, Daniel Micay <danielmicay@gmail.com>, Jonathan Corbet <corbet@lwn.net>, J.
List-Id: linux-api@vger.kernel.org

On Fri, May 11, 2018 at 09:45:33AM -0700, Linus Torvalds wrote:
> On Fri, May 11, 2018 at 2:46 AM Alexey Gladkov <gladkov.alexey@gmail.com>
> wrote:
> 
> > +       /* Limit procfs to only ptracable tasks */
> > +       if (limit_pids == PROC_LIMIT_PIDS_PTRACE) {
> > +               cond_resched();
> > +               if (!has_pid_permissions(fs_info, task,
> HIDEPID_NO_ACCESS))
> > +                       goto out_put_task;
> > +       }
> 
> Where did that "cond_resched()" come from? That doesn't seem to make a lot
> of sense.

This call came along with has_pid_permissions from proc_pid_readdir [1]. It
seems to me that proc_pid_readdir and proc_pid_lookup should act in a
similar way in this case.

[1] https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=3ba4bceef23206349d4130ddf140819b365de7c8

-- 
Rgrds, legion

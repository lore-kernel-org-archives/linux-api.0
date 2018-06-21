From: Jann Horn <jannh@google.com>
Subject: Re: [PATCH v4 4/4] seccomp: add support for passing fds via USER_NOTIF
Date: Fri, 22 Jun 2018 01:34:18 +0200
Message-ID: <CAG48ez0d+tRsfvstU3Kd7T=kkdKbbfpNS+19NLTchhSL1fUyNg@mail.gmail.com>
References: <20180621220416.5412-1-tycho@tycho.ws> <20180621220416.5412-5-tycho@tycho.ws>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180621220416.5412-5-tycho@tycho.ws>
Sender: linux-kernel-owner@vger.kernel.org
To: Tycho Andersen <tycho@tycho.ws>
Cc: Kees Cook <keescook@chromium.org>, kernel list <linux-kernel@vger.kernel.org>, containers@lists.linux-foundation.org, Linux API <linux-api@vger.kernel.org>, Andy Lutomirski <luto@amacapital.net>, Oleg Nesterov <oleg@redhat.com>, "Eric W. Biederman" <ebiederm@xmission.com>, "Serge E. Hallyn" <serge@hallyn.com>, Christian Brauner <christian.brauner@ubuntu.com>, Tyler Hicks <tyhicks@canonical.com>, suda.akihiro@lab.ntt.co.jp, "Tobin C. Harding" <me@tobin.cc>
List-Id: linux-api@vger.kernel.org

On Fri, Jun 22, 2018 at 12:05 AM Tycho Andersen <tycho@tycho.ws> wrote:
>
> The idea here is that the userspace handler should be able to pass an fd
> back to the trapped task, for example so it can be returned from socket().
[...]
> +Userspace can also return file descriptors. For example, one may decide to
> +intercept ``socket()`` syscalls, and return some file descriptor from those
> +based on some policy. To return a file descriptor, the ``return_fd`` member
> +should be non-zero, the ``fd`` argument should be the fd in the listener's
> +table to send to the tracee (similar to how ``SCM_RIGHTS`` works), and
> +``fd_flags`` should be the flags that the fd in the tracee's table is opened
> +with (e.g. ``O_EXCL`` or similar).

fd_flags only contains file descriptor flags (meaning only O_CLOEXEC).
O_EXCL is a file creation flag, so setting it here wouldn't make sense.
Setting file status flags like O_APPEND does make sense, but those are
stored in the `struct file` and don't need to be passed separately;
the caller can e.g. set them via fcntl(fd, F_SETFD, flags) or on
open().
(The fcntl.2 manpage explains these.)

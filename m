From: Jann Horn <jannh@google.com>
Subject: Re: [PATCH v6 4/5] seccomp: add support for passing fds via USER_NOTIF
Date: Thu, 6 Sep 2018 18:15:18 +0200
Message-ID: <CAG48ez2oQnAb=OMGOUz0GfSWMsjqydPe8dmp6L=QswSQpSpVXA@mail.gmail.com>
References: <20180906152859.7810-1-tycho@tycho.ws> <20180906152859.7810-5-tycho@tycho.ws>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180906152859.7810-5-tycho@tycho.ws>
Sender: linux-kernel-owner@vger.kernel.org
To: Tycho Andersen <tycho@tycho.ws>
Cc: Kees Cook <keescook@chromium.org>, kernel list <linux-kernel@vger.kernel.org>, containers@lists.linux-foundation.org, Linux API <linux-api@vger.kernel.org>, Andy Lutomirski <luto@amacapital.net>, Oleg Nesterov <oleg@redhat.com>, "Eric W. Biederman" <ebiederm@xmission.com>, "Serge E. Hallyn" <serge@hallyn.com>, Christian Brauner <christian.brauner@ubuntu.com>, Tyler Hicks <tyhicks@canonical.com>, suda.akihiro@lab.ntt.co.jp
List-Id: linux-api@vger.kernel.org

On Thu, Sep 6, 2018 at 5:29 PM Tycho Andersen <tycho@tycho.ws> wrote:
> The idea here is that the userspace handler should be able to pass an fd
> back to the trapped task, for example so it can be returned from socket().
[...]
> diff --git a/Documentation/userspace-api/seccomp_filter.rst b/Documentation/userspace-api/seccomp_filter.rst
> index d1498885c1c7..1c0aab306426 100644
> --- a/Documentation/userspace-api/seccomp_filter.rst
> +++ b/Documentation/userspace-api/seccomp_filter.rst
> @@ -235,6 +235,9 @@ The interface for a seccomp notification fd consists of two structures:
>          __u64 id;
>          __s32 error;
>          __s64 val;
> +        __u8 return_fd;
> +        __u32 fd;
> +        __u32 fd_flags;

Normally,  syscalls that take an optional file descriptor accept a
signed 32-bit number, with -1 standing for "no file descriptor". Is
there a reason why this uses a separate variable to signal whether an
fd was provided?

Apart from that, this patch looks good to me.

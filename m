From: Florian Weimer <fweimer@redhat.com>
Subject: Re: [PATCH v2 1/1] prctl: add PR_{GET,SET}_KILL_DESCENDANTS_ON_EXIT
Date: Fri, 30 Nov 2018 14:40:14 +0100
Message-ID: <87bm66u1j5.fsf@oldenburg.str.redhat.com>
References: <20181127225408.7553-2-j@bitron.ch>
        <20181130080004.23635-1-j@bitron.ch>
        <20181130080004.23635-2-j@bitron.ch>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20181130080004.23635-2-j@bitron.ch> (=?utf-8?Q?=22J=C3=BCrg?=
 Billeter"'s message
        of "Fri, 30 Nov 2018 08:00:04 +0000")
Sender: linux-kernel-owner@vger.kernel.org
To: =?utf-8?Q?J=C3=BCrg?= Billeter <j@bitron.ch>
Cc: Andrew Morton <akpm@linux-foundation.org>, Oleg Nesterov <oleg@redhat.com>, Thomas Gleixner <tglx@linutronix.de>, Eric Biederman <ebiederm@xmission.com>, Kees Cook <keescook@chromium.org>, Andy Lutomirski <luto@kernel.org>, linux-api@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-api@vger.kernel.org

* Jürg Billeter:

> This introduces a new thread group flag that can be set by calling
>
>     prctl(PR_SET_KILL_DESCENDANTS_ON_EXIT, 1, 0, 0, 0)
>
> When a thread group exits with this flag set, it will send SIGKILL to
> all descendant processes.  This can be used to prevent stray child
> processes.
>
> This flag is cleared on privilege gaining execve(2) to ensure an
> unprivileged process cannot get a privileged process to send SIGKILL.

So this is inherited across regular execve?  I'm not sure that's a good
idea.

> Descendants that are orphaned and reparented to an ancestor of the
> current process before the current process exits, will not be killed.
> PR_SET_CHILD_SUBREAPER can be used to contain orphaned processes.

For double- or triple-forking daemons, the reparenting will be racy, if
I understand things correctly.

Thanks,
Florian

From: Andy Lutomirski <luto@amacapital.net>
Subject: Re: [PATCH v6 3/5] seccomp: add a way to get a listener fd from ptrace
Date: Wed, 12 Sep 2018 17:00:54 -0700
Message-ID: <CALCETrXGBZyqDb7DEysHmOkxaBrXUp4s2X08HfqZkpjM28s3Hg@mail.gmail.com>
References: <20180906152859.7810-1-tycho@tycho.ws> <20180906152859.7810-4-tycho@tycho.ws>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180906152859.7810-4-tycho@tycho.ws>
Sender: linux-kernel-owner@vger.kernel.org
To: Tycho Andersen <tycho@tycho.ws>
Cc: Kees Cook <keescook@chromium.org>, LKML <linux-kernel@vger.kernel.org>, Linux Containers <containers@lists.linux-foundation.org>, Linux API <linux-api@vger.kernel.org>, Oleg Nesterov <oleg@redhat.com>, "Eric W . Biederman" <ebiederm@xmission.com>, "Serge E . Hallyn" <serge@hallyn.com>, Christian Brauner <christian.brauner@ubuntu.com>, Tyler Hicks <tyhicks@canonical.com>, Akihiro Suda <suda.akihiro@lab.ntt.co.jp>, Jann Horn <jannh@google.com>
List-Id: linux-api@vger.kernel.org

On Thu, Sep 6, 2018 at 8:28 AM, Tycho Andersen <tycho@tycho.ws> wrote:
> As an alternative to SECCOMP_FILTER_FLAG_GET_LISTENER, perhaps a ptrace()
> version which can acquire filters is useful. There are at least two reasons
> this is preferable, even though it uses ptrace:
>
> 1. You can control tasks that aren't cooperating with you
> 2. You can control tasks whose filters block sendmsg() and socket(); if the
>    task installs a filter which blocks these calls, there's no way with
>    SECCOMP_FILTER_FLAG_GET_LISTENER to get the fd out to the privileged task.

Hmm.  I contemplated this a bit and looked at your example a bit, and
I have a few thoughts:

 - What happens if you nest code like your sample?  That is, if you
are already in some container that is seccomped and there's a
listener, can you even run your sample?

 - Is there any association between the filter layer that uses the
USER_NOTIF return and the listener?  How would this API express such a
relationship?

I realize that my dream of how this should all work requires eBPF and
BPF_CALL, so it may not be viable right now, but I'd like a better
understanding of how this all fits together.

Also, I think that it's not strictly true that a filter that blocks
sendmsg() is problematic.  You could clone a thread, call seccomp() in
that thread, then get a listener, then execve().  Or we could have a
seccomp() mode that adds a filter but only kicks in after execve().
The latter could be generally useful.

--Andy

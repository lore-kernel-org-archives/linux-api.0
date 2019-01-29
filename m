From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [RESEND PATCH v2 1/1] prctl: add
 PR_{GET,SET}_KILL_DESCENDANTS_ON_EXIT
Date: Mon, 28 Jan 2019 17:23:21 -0800
Message-ID: <20190128172321.780e9b380dd40eb3e7c22daf@linux-foundation.org>
References: <20181127225408.7553-1-j@bitron.ch>
        <20190118131130.42209-1-j@bitron.ch>
        <20190118131130.42209-2-j@bitron.ch>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190118131130.42209-2-j@bitron.ch>
Sender: linux-kernel-owner@vger.kernel.org
To: =?ISO-8859-1?Q?J=FCrg?= Billeter <j@bitron.ch>
Cc: Oleg Nesterov <oleg@redhat.com>, Thomas Gleixner <tglx@linutronix.de>, Eric Biederman <ebiederm@xmission.com>, Kees Cook <keescook@chromium.org>, Andy Lutomirski <luto@kernel.org>, linux-api@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On Fri, 18 Jan 2019 14:11:30 +0100 Jürg Billeter <j@bitron.ch> wrote:

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
> 
> Descendants that are orphaned and reparented to an ancestor of the
> current process before the current process exits, will not be killed.
> PR_SET_CHILD_SUBREAPER can be used to contain orphaned processes.
> 
> If a descendant gained privileges, the current process may not be
> allowed to kill it, and the descendant process will survive.
> PR_SET_NO_NEW_PRIVS can be used to prevent descendant processes from
> gaining privileges.

I don't feel that I'm able to judge the usefulness of this.  It would
help to have a lot more words right here in this changelog which
communicate the value of this change to our users.  References are
useful, but please don't send people off to chase down mailing list and
bugzilla discussions as a substitute for properly describing the feature
and its justification.

Some test code in tools/testing/selftests/ would be helpful.

We'll need to update the prctl(2) manpage if we proceed with this.

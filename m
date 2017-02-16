From: Andy Lutomirski <luto@amacapital.net>
Subject: Re: [PATCH v3 0/4] Improved seccomp logging
Date: Wed, 15 Feb 2017 19:24:41 -0800
Message-ID: <CALCETrXbPQg2V_=3OqZRXbzOf7zGJ8V_RZ5YQ5CHtEEkA0n5HQ@mail.gmail.com>
References: <1487043928-5982-1-git-send-email-tyhicks@canonical.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1487043928-5982-1-git-send-email-tyhicks@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Tyler Hicks <tyhicks@canonical.com>
Cc: Paul Moore <paul@paul-moore.com>, Eric Paris <eparis@redhat.com>, Kees Cook <keescook@chromium.org>, Will Drewry <wad@chromium.org>, linux-audit@redhat.com, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, John Crispin <john@phrozen.org>, linux-api@ver.kernel.org
List-Id: linux-api@vger.kernel.org

On Mon, Feb 13, 2017 at 7:45 PM, Tyler Hicks <tyhicks@canonical.com> wrote:
> This patch set is the third revision of the following two previously
> submitted patch sets:
>
> v1: http://lkml.kernel.org/r/1483375990-14948-1-git-send-email-tyhicks@canonical.com
> v1: http://lkml.kernel.org/r/1483377999-15019-2-git-send-email-tyhicks@canonical.com
>
> v2: http://lkml.kernel.org/r/1486100262-32391-1-git-send-email-tyhicks@canonical.com
>
> The patch set aims to address some known deficiencies in seccomp's current
> logging capabilities:
>
>   1. Inability to log all filter actions.
>   2. Inability to selectively enable filtering; e.g. devs want noisy logging,
>      users want relative quiet.
>   3. Consistent behavior with audit enabled and disabled.
>   4. Inability to easily develop a filter due to the lack of a
>      permissive/complain mode.

I think I dislike this, but I think my dislikes may be fixable with
minor changes.

What I dislike is that this mixes app-specific built-in configuration
(seccomp) with global privileged stuff (audit).  The result is a
potentially difficult to use situation in which you need to modify an
app to make it loggable (using RET_LOG) and then fiddle with
privileged config (auditctl, etc) to actually see the logs.

What if, instead of logging straight to the audit log, SECCOMP_RET_LOG
[1] merely meant "tell our parent about this syscall"?  (Ideally we'd
also figure out a way to express "log this and allow", "log this and
do ERRNO", etc.)  Then we could have another mechanism that installs a
layer in the seccomp stack that, instead of catching syscalls, catches
log events and sticks them in a ring buffer (or audit).

Concretely, it might work like this.  If a filter returns
SECCOMP_RET_LOG, then we "log" and keep processing.  SECCOMP_RET_LOG
is otherwise treated literally like SECCOMP_RET_ALLOW and has no
effect on return value.  If you want log-and-kill, you install two
filters.

There's a new seccomp(2) action that returns an fd.  That fd
references a new thing in the seccomp stack that is a BPF program that
is called whenever SECCOMP_RET_LOG is returned from lower down.  The
output of this filter determines whether the log event is ignored,
stuck in the ring buffer, or passed up the stack for further
processing.  You read(2) the fd to access the ring buffer.

Using this mechanism, you could write a simple seccomptrace tool that
needs no privilege and dumps SECCOMP_RET_LOG events from the target
program to stderr.

Thoughts?

[1] If we went this route, it might want to be renamed.

P.S. We ought to be able to write a BPF verifier pass that makes sure
that filters don't return unsupported return values if we cared to do
so.

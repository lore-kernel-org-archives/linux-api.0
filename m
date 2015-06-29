From: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [GIT PULL] User namespace related fixes for v4.2
Date: Mon, 29 Jun 2015 09:43:09 -0700
Message-ID: <CA+55aFysKDXr2HEwNzm3z9QOw=E4ZeWcvYQ-xLhy5_k+rGbeRg@mail.gmail.com>
References: <87381eyz26.fsf@x220.int.ebiederm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <87381eyz26.fsf@x220.int.ebiederm.org>
Sender: linux-fsdevel-owner@vger.kernel.org
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Linux Containers <containers@lists.linux-foundation.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Linux API <linux-api@vger.kernel.org>, Andy Lutomirski <luto@amacapital.net>, "Serge E. Hallyn" <serge@hallyn.com>, Richard Weinberger <richard@nod.at>, Kenton Varda <kenton@sandstorm.io>, Michael Kerrisk-manpages <mtk.manpages@gmail.com>, =?UTF-8?Q?St=C3=A9phane_Graber?= <stgraber@ubuntu.com>, Eric Windisch <ewindisch@docker.com>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Tejun Heo <tj@kernel.org>, Seth Forshee <seth.forshee@canonical.com>, Omar Sandoval <osandov@osandov.com>, Ivan Delalande <colona@arista.com>
List-Id: linux-api@vger.kernel.org

On Fri, Jun 26, 2015 at 1:50 PM, Eric W. Biederman
<ebiederm@xmission.com> wrote:
>
> Therefore this changeset marks for backporting the attribute enforcement
> that do not cause regressions in the existing userspace. Implements
> enforcement of nosuid and noexec.  Then disables that enforcement of
> nosuid and nosexec and replaces that enforcment with a big fat warning.
> Userspace should be fixed before 4.2 ships so I do not expect these
> warnings to fire.

Eric, that is *not* how this works.

If people have old user-space binaries, we do not require them to be
updated. So it doesn't matter one whit if "Userspace should be fixed
before 4.2 ships", because it is entirely irrelevant if the upstream
project stops doing something, when users want to be able to upgrade
their kernels regardless of whether they've upgraded their system
apps.

I'm going to hold off on pulling this, because I feel you don't
understand the regression rules.

I suggest we instead just always set nosuid and noexec for /proc and
/sys mounts, and make this whole thing a complete non-issue.

Instead of this crazy "let's warn about it and plan on breaking old
existing setups". That's _wrong_. It's so fundamentally wrong that I
will not pull from people who do not understand this.

The reason we have that "no regression" rule is not so that we fix up
bugs. It's because peopel should always feel safe upgrading their
kernel, and basically _know_ that kernel developers consider it
unacceptable to break user space. It should be a warm fuzzy feeling -
the feeling that we try our best, and if we ever fail because we
missed something or really believed that it can't ever matter, we'll
jump on it and we won't be making any excuses for our bugs. Because
breaking user space is a bug.

Kernel developers who don't understand "it is unacceptable to break
user space" shouldn't be kernel developers.

                 Linus

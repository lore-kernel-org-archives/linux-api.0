From: Christian Brauner <christian@brauner.io>
Subject: Re: [PATCH v2 0/5] pid: add pidfd_open()
Date: Sun, 31 Mar 2019 23:19:31 +0200
Message-ID: <20190331211930.wxkqhfvexdupfem6@brauner.io>
References: <20190329155425.26059-1-christian@brauner.io>
 <CAHk-=wjq4dTPcz-qsvhpm5F42SDHCoqEWv1V=rs_kt6MC=ZThA@mail.gmail.com>
 <BCD99947-5F55-4116-8F74-D6832E50340B@brauner.io>
 <CAHk-=whcA0kAWGqet9oJdyttjhP7J4PcU2Ly=n_Qyo6rMJNxRg@mail.gmail.com>
 <CAKOZuevv_QgvzmusA+yey76vo4hn9bEVwud2RumuOr0K4++15A@mail.gmail.com>
 <CAHk-=wj0o8BiUrYiM5ZcTS6JxBh1M60O36Ms8-EqLQ139=1L4g@mail.gmail.com>
 <20190330171215.3yrfxwodstmgzmxy@brauner.io>
 <CAHk-=whF6gnRVbJaArZna4e=tejfrzmNQtRbWjnuSSKpBn+jQg@mail.gmail.com>
 <132107F4-F56B-4D6E-9E00-A6F7C092E6BD@amacapital.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <132107F4-F56B-4D6E-9E00-A6F7C092E6BD@amacapital.net>
Sender: linux-kernel-owner@vger.kernel.org
To: Andy Lutomirski <luto@amacapital.net>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, Daniel Colascione <dancol@google.com>, Jann Horn <jannh@google.com>, Andrew Lutomirski <luto@kernel.org>, David Howells <dhowells@redhat.com>, "Serge E. Hallyn" <serge@hallyn.com>, Linux API <linux-api@vger.kernel.org>, Linux List Kernel Mailing <linux-kernel@vger.kernel.org>, Arnd Bergmann <arnd@arndb.de>, "Eric W. Biederman" <ebiederm@xmission.com>, Konstantin Khlebnikov <khlebnikov@yandex-team.ru>, Kees Cook <keescook@chromium.org>, Alexey Dobriyan <adobriyan@gmail.com>, Thomas Gleixner <tglx@linutronix.de>, Michael Kerrisk-manpages <mtk.manpages@gmail.com>, Jonathan Kowalski <bl0pbl33p@gmail.com>, "Dmitry V. Levin" <ldv@altlinux.org>, Andrew Morton <akpm@linux-foundation.org>, Oleg
List-Id: linux-api@vger.kernel.org

On Sun, Mar 31, 2019 at 02:09:03PM -0600, Andy Lutomirski wrote:
> 
> 
> > On Mar 30, 2019, at 11:24 AM, Linus Torvalds <torvalds@linux-foundation.org> wrote:
> > 
> >> On Sat, Mar 30, 2019 at 10:12 AM Christian Brauner <christian@brauner.io> wrote:
> >> 
> >> 
> >> To clarify, what the Android guys really wanted to be part of the api is
> >> a way to get race-free access to metadata associated with a given pidfd.
> >> And the idea was that *if and only if procfs is mounted* you could do:
> >> 
> >> int pidfd = pidfd_open(1234, 0);
> >> 
> >> int procfd = open("/proc", O_RDONLY | O_CLOEXEC);
> >> int procpidfd = ioctl(pidfd, PIDFD_TO_PROCFD, procfd);
> > 
> > And my claim is that this is three system calls - one of them very
> > hacky - to just do
> > 
> >    int pidfd = open("/proc/%d", O_PATH);
> 
> Hi Linus-
> 
> I want to re-check this because I think Christian’s example was bad.  I proposed these ioctls, but that wasn’t the intended use.  The real point is:

Getting metadata access was pushed as essential originally which is why
this ioctl() came up in the first place. The concerns about
CLONE_PIDFD were not relevant when this came up [1]:

<quote>
> And how do you propose, given one of these handle objects, getting a
> process's current priority, or its current oom score, or its list of
> memory maps? As I mentioned in my original email, and which nobody has
> addressed, if you don't use a dirfd as your process handle or you
> don't provide an easy way to get one of these proc directory FDs, you
> need to duplicate a lot of metadata access interfaces.

An API that takes a process handle object and an fd pointing at /proc
(the root of the proc fs) and gives you back a proc dirfd would do the
trick.  You could do this with no new kernel features at all if you're
willing to read the pid, call openat(2), and handle the races in user
code.
<quote>

[1]: https://lore.kernel.org/lkml/CALCETrUFrFKC2YTLH7ViM_7XPYk3LNmNiaz6s8wtWo1pmJQXzg@mail.gmail.com/

> 
> int pidfd = new_improved_clone(...);
> 
> To be useful, this type of API *must* work without proc mounted.
> 
> And, later:
> 
> openat(fd to pidfd’s proc directory, “status”, ...);
> 
> And we want a non-utterly-crappy way to do this.  The ioctl is certainly ugly, but it *works*.
> 
> Another approach is:
> 
> pid_t pid = pidfd_get_pid(pidfd);
> sprintf(buf, “/proc/%d”, pid);
> int procfd = open(buf, O_PATH);
> if (pidfd_get_pid(pidfd) != pid) {
>   we lose;
> }
> 
> But this is clunky.
> 
> Do you think the clunky version is okay, or do you have a suggestion for making it better?
> 
> —Andy

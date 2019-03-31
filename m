From: Joel Fernandes <joel@joelfernandes.org>
Subject: Re: [PATCH v2 0/5] pid: add pidfd_open()
Date: Sun, 31 Mar 2019 00:08:10 -0400
Message-ID: <20190331040810.GB189578@google.com>
References: <20190329155425.26059-1-christian@brauner.io>
 <CAHk-=wjq4dTPcz-qsvhpm5F42SDHCoqEWv1V=rs_kt6MC=ZThA@mail.gmail.com>
 <CAKOZueuDWWYtg9gUpUgTG2k-gVPE1KBEkstr5eP=FC2EzdmaoA@mail.gmail.com>
 <CAHk-=wjka0W1g3asQp2H=5ot=kkS-Mp+Cx6KHr0rNkGFfCOLYA@mail.gmail.com>
 <CAHk-=wi1kQDVN22qv7M=bWU+CngZZXcPAMKCsDZMeuY3k2tkyg@mail.gmail.com>
 <20190331010716.GA189578@google.com>
 <CAG48ez387kGbD_dLqEbZ1U9rKFbfP0EF9cMVjQT6nwc9=Y9CNw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CAG48ez387kGbD_dLqEbZ1U9rKFbfP0EF9cMVjQT6nwc9=Y9CNw@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Jann Horn <jannh@google.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, Daniel Colascione <dancol@google.com>, Christian Brauner <christian@brauner.io>, Andrew Lutomirski <luto@kernel.org>, David Howells <dhowells@redhat.com>, "Serge E. Hallyn" <serge@hallyn.com>, Linux API <linux-api@vger.kernel.org>, Linux List Kernel Mailing <linux-kernel@vger.kernel.org>, Arnd Bergmann <arnd@arndb.de>, "Eric W. Biederman" <ebiederm@xmission.com>, Konstantin Khlebnikov <khlebnikov@yandex-team.ru>, Kees Cook <keescook@chromium.org>, Alexey Dobriyan <adobriyan@gmail.com>, Thomas Gleixner <tglx@linutronix.de>, Michael Kerrisk-manpages <mtk.manpages@gmail.com>, Jonathan Kowalski <bl0pbl33p@gmail.com>, "Dmitry V. Levin" <ldv@altlinux.org>, Andrew Morton <akpm@linux-foundation.org>, Ol
List-Id: linux-api@vger.kernel.org

On Sun, Mar 31, 2019 at 04:34:57AM +0200, Jann Horn wrote:
> On Sun, Mar 31, 2019 at 3:07 AM Joel Fernandes <joel@joelfernandes.org> wrote:
> > As I said I don't really care about "pidfd" solving any racing issues with
> > /proc/<pid>/* accesses - because I still find it hard to imagine that the pid
> > number can be reused easily from the time you know which <pid> to deal with,
> > to the time when you want to read, say, the /proc/<pid>/status file.
> 
> There have been several Android security bugs related to PID reuse.

Yes PID reuse will be a problem till we have pidfd_clone and
pidfd_send_signal (and any other pidfd related syscalls). I've never denied
PID reuse is *currently* a problem and the set of pidfd syscalls being
proposed are designed to avoid those. So I'm not fully sure what you mean.
Anyway, I would love to see those security bugs you mentioned if you could
point me to them.

> > I am yet
> > to see any real data to show that such overflow happens - you literally need
> > 32k process deaths and forks in such a short time frame
> 
> This seems very inaccurate to me.
> 
> The time frame in which the PID has to wrap around is not the time
> between process death and use of the PID. It is the time between *the
> creation* of the old process and the use of the PID. Consider the
> following sequence of events:
> 
>  - process A starts with PID 1000
>  - some time passes in which some process repeatedly forks, with PIDs
> wrapping around to 999
>  - process B starts an attempt to access process A (using PID 1000)
>  - process A dies
>  - process C spawns with PID 1000
>  - process B accidentally accesses process C
> 
> Also, it's probably worth clarifying that here, "processes" means "threads".
> 
> If there are a lot of active processes, that reduces the number of
> times you have to clone() to get the PID to wrap around.

Ok, that's fair and I take your point. But I wonder what access you're
talking about, is it killing the process? If yes, pidfd_clone +
pidfd_send_signal will solve that in the race free way without relying on the
PID number. Is it accessing /proc/<pid>/? then see below.

> > and on 64-bit, that
> > number is really high
> 
> Which number is really high on 64-bit? Checking on a walleye phone,
> pid_max is still only 32768:
> 
> walleye:/ # cat /proc/sys/kernel/pid_max
> 32768
> walleye:/ #

Ok. I was talking about the theoretical limit of pid_max on a 64-bit
platform. But since we are talking about NOT relying on the PID number in the
first place, we can move on from this point.

> > that its not even an issue. And if this is really an
> > issue, then you can just open a handle to /proc/<pid> at process creation
> > time and keep it around. If the <pid> is reused, you can still use openat(2)
> > on that handle without any races.
> 
> But not if you want to implement something like killall in a
> race-free way, for example.

I am not at all talking about killing processes in your last quote of my
email above, I'm talking about access to /proc/<pid>/ files.

As I said, at the time of process creation, you can obtain an fd by opening
/proc/<pid>/ and keep it open. Then you can do an openat(2) on that fd
without worrying at <pid> reuse, no? And then access all the files that way.

As for killall in Android. I don't think that "killing processes by name" is
relied on for the runtime operation of Android. That would be a very bad
idea. Low memory killer does not kill processes by name. It kills processes
by the PID number using kill(2) which we'd like to replace with
pidfd_send_signal.

Again if you want to convince Linus about having a "pidfd to procfd"
conversion mechanism, then by all means go for it. I just don't think it is
urgently necessary (and others may disagree with me on this), but I wouldn't
care if such a mechanism existed either.  Whatever we do, I just want the
notion of "pidfd" to be consistent as I mentioned in my previous email.

thank you!

 - Joel

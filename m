From: Christian Brauner <christian@brauner.io>
Subject: Re: [PATCH] proc: allow killing processes via file descriptors
Date: Sun, 18 Nov 2018 21:43:19 +0100
Message-ID: <20181118204317.seaztq7fqmysucns@brauner.io>
References: <CAKOZueutLc8d0Fe+7dNWiZKnALhTSST8+kCnOrL+OmB6coUmtA@mail.gmail.com>
 <CALCETrVg71XBv-gMOtL-m0Dd0HNz8_oXOUDSWin5LeViAL0UYA@mail.gmail.com>
 <CAKOZuesCKo4GH9fdum2EUFLrtTWam3aizcDQUn3-vCYg4T1P8w@mail.gmail.com>
 <CALCETrUeNZPfrSYa9vH5Ukrk1Y+Kb9GkZOh6LkqG6Z9NpK5P0w@mail.gmail.com>
 <CAKOZuevVk_aH_2TuiNcmxgMa+gHXMBXz6Uu5a6TDjoxjhaE36g@mail.gmail.com>
 <CALCETrVscRwQG55-j1SKc2TmSb1-=5861804ojUuviNzdyDOrA@mail.gmail.com>
 <CAKOZuevRq-igh06zS_nsGG400zXrKFCtajpEG9-xgU2+Rtb2Pw@mail.gmail.com>
 <20181118190504.ixglsqbn6mxkcdzu@yavin>
 <CAKOZuetfqvn1uVqKJ=16iEzG4g449YOjC_tLM60eKBSkv9u+bQ@mail.gmail.com>
 <608F2959-800D-46EE-A7CD-8C972ACD2F02@amacapital.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <608F2959-800D-46EE-A7CD-8C972ACD2F02@amacapital.net>
Sender: linux-kernel-owner@vger.kernel.org
To: Andy Lutomirski <luto@amacapital.net>
Cc: Daniel Colascione <dancol@google.com>, Aleksa Sarai <cyphar@cyphar.com>, Andy Lutomirski <luto@kernel.org>, Randy Dunlap <rdunlap@infradead.org>, "Eric W. Biederman" <ebiederm@xmission.com>, LKML <linux-kernel@vger.kernel.org>, "Serge E. Hallyn" <serge@hallyn.com>, Jann Horn <jannh@google.com>, Andrew Morton <akpm@linux-foundation.org>, Oleg Nesterov <oleg@redhat.com>, Al Viro <viro@zeniv.linux.org.uk>, Linux FS Devel <linux-fsdevel@vger.kernel.org>, Linux API <linux-api@vger.kernel.org>, Tim Murray <timmurray@google.com>, Kees Cook <keescook@chromium.org>, Jan Engelhardt <jengelh@inai.de>
List-Id: linux-api@vger.kernel.org

On Sun, Nov 18, 2018 at 01:28:41PM -0700, Andy Lutomirski wrote:
> 
> 
> > On Nov 18, 2018, at 12:44 PM, Daniel Colascione <dancol@google.com> wrote:
> > 
> 
> > 
> > That is, I'm proposing an API that looks like this:
> > 
> > int process_kill(int procfs_dfd, int signo, const union sigval value)
> > 
> > If, later, process_kill were to *also* accept process-capability FDs,
> > nothing would break.
> 
> Except that this makes it ambiguous to the caller as to whether their current creds are considered.  So it would need to be a different syscall or at least a flag.  Otherwise a lot of those nice theoretical properties go away.

I can add a flag argument
int process_signal(int procfs_dfd, int signo, siginfo_t *info, int flags)
The way I see it process_signal() should be equivalent to kill(pid, signal) for now.
That is siginfo_t is cleared and set to:

info.si_signo = sig;
info.si_errno = 0;
info.si_code = SI_USER;
info.si_pid = task_tgid_vnr(current);
info.si_uid = from_kuid_munged(current_user_ns(), current_uid());

> 
> > Yes, that's what I have in mind. A siginfo_t is small enough that we
> > could just store it as a blob allocated off the procfs inode or
> > something like that without bothering with a shmfs file. You'd be able
> > to read(2) the exit status as many times as you wanted.
> 
> I think that, if the syscall in question is read(2), then it should work *once* per struct file.  Otherwise running cat on the file would behave very oddly.
> 
> Read and poll have the same problem as write: we can’t check caps in read or poll either.

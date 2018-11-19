From: Daniel Colascione <dancol@google.com>
Subject: Re: [PATCH] proc: allow killing processes via file descriptors
Date: Sun, 18 Nov 2018 17:16:23 -0800
Message-ID: <CAKOZuevHoEAZdnQmuGiwpLcfxSBq3M8T0ZeQFG+Do2aCFcZfQQ@mail.gmail.com>
References: <a7f50692-667c-4efe-a2d0-fa324eebb90b@infradead.org>
 <CAKOZueutLc8d0Fe+7dNWiZKnALhTSST8+kCnOrL+OmB6coUmtA@mail.gmail.com>
 <CALCETrVg71XBv-gMOtL-m0Dd0HNz8_oXOUDSWin5LeViAL0UYA@mail.gmail.com>
 <CAKOZuesCKo4GH9fdum2EUFLrtTWam3aizcDQUn3-vCYg4T1P8w@mail.gmail.com>
 <CALCETrUeNZPfrSYa9vH5Ukrk1Y+Kb9GkZOh6LkqG6Z9NpK5P0w@mail.gmail.com>
 <CAKOZuevVk_aH_2TuiNcmxgMa+gHXMBXz6Uu5a6TDjoxjhaE36g@mail.gmail.com>
 <CALCETrVscRwQG55-j1SKc2TmSb1-=5861804ojUuviNzdyDOrA@mail.gmail.com>
 <CAKOZuevRq-igh06zS_nsGG400zXrKFCtajpEG9-xgU2+Rtb2Pw@mail.gmail.com>
 <20181118190504.ixglsqbn6mxkcdzu@yavin> <CAKOZuetfqvn1uVqKJ=16iEzG4g449YOjC_tLM60eKBSkv9u+bQ@mail.gmail.com>
 <20181119000928.h2wp2rn2pnlfysp7@yavin> <CAKOZueve_r5h9_B2YV5RzJYjTf-yS5uZfAbz+Ftqy5jFSk6Xdw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAKOZueve_r5h9_B2YV5RzJYjTf-yS5uZfAbz+Ftqy5jFSk6Xdw@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Aleksa Sarai <cyphar@cyphar.com>
Cc: Andy Lutomirski <luto@kernel.org>, Randy Dunlap <rdunlap@infradead.org>, Christian Brauner <christian@brauner.io>, "Eric W. Biederman" <ebiederm@xmission.com>, LKML <linux-kernel@vger.kernel.org>, "Serge E. Hallyn" <serge@hallyn.com>, Jann Horn <jannh@google.com>, Andrew Morton <akpm@linux-foundation.org>, Oleg Nesterov <oleg@redhat.com>, Al Viro <viro@zeniv.linux.org.uk>, Linux FS Devel <linux-fsdevel@vger.kernel.org>, Linux API <linux-api@vger.kernel.org>, Tim Murray <timmurray@google.com>, Kees Cook <keescook@chromium.org>, Jan Engelhardt <jengelh@inai.de>
List-Id: linux-api@vger.kernel.org

On Sun, Nov 18, 2018 at 4:53 PM, Daniel Colascione <dancol@google.com> wrote:
>> Sure, I'd propose that ptrace_may_access() is what we should use for
>> operation permission checks.
>
> The tricky part is that ptrace_may_access takes a struct task. We want
> logic that's *like* ptrace_may_access, but that works posthumously.
> It's especially tricky because there's an LSM hook that lets
> __ptrace_may_access do arbitrary things. And we can't just run that
> hook upon process death, since *after* a process dies, a process
> holding an exithand FD (or whatever we call it) may pass that FD to
> another process, and *that* process can read(2) from it.
>
> Another option is doing the exithand access check at open time. I
> think that's probably fine, and it would make things a lot simpler.
> But if we use this option, we should understand what we're doing, and
> get some security-conscious people to think through the implications.

A ptrace check is also probably too strict. Yama's ptrace_scope
feature will block ptrace between unrelated processes within a single
user context, but applying this restriction to exit code monitoring
seems too severe to me.

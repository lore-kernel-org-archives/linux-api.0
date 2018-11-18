From: Daniel Colascione <dancol@google.com>
Subject: Re: [PATCH] proc: allow killing processes via file descriptors
Date: Sun, 18 Nov 2018 12:21:31 -0800
Message-ID: <CAKOZuesXN1qBYKvkTt2StX-07vM0msGvmgqiRvh-+=aaTX4A8Q@mail.gmail.com>
References: <a7f50692-667c-4efe-a2d0-fa324eebb90b@infradead.org>
 <CAKOZueutLc8d0Fe+7dNWiZKnALhTSST8+kCnOrL+OmB6coUmtA@mail.gmail.com>
 <CALCETrVg71XBv-gMOtL-m0Dd0HNz8_oXOUDSWin5LeViAL0UYA@mail.gmail.com>
 <CAKOZuesCKo4GH9fdum2EUFLrtTWam3aizcDQUn3-vCYg4T1P8w@mail.gmail.com>
 <CALCETrUeNZPfrSYa9vH5Ukrk1Y+Kb9GkZOh6LkqG6Z9NpK5P0w@mail.gmail.com>
 <CAKOZuevVk_aH_2TuiNcmxgMa+gHXMBXz6Uu5a6TDjoxjhaE36g@mail.gmail.com>
 <CALCETrVscRwQG55-j1SKc2TmSb1-=5861804ojUuviNzdyDOrA@mail.gmail.com>
 <CAKOZuevRq-igh06zS_nsGG400zXrKFCtajpEG9-xgU2+Rtb2Pw@mail.gmail.com>
 <20181118190504.ixglsqbn6mxkcdzu@yavin> <CAKOZuetfqvn1uVqKJ=16iEzG4g449YOjC_tLM60eKBSkv9u+bQ@mail.gmail.com>
 <20181118201514.c5ujdjav6ccodyff@brauner.io>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20181118201514.c5ujdjav6ccodyff@brauner.io>
Sender: linux-kernel-owner@vger.kernel.org
To: Christian Brauner <christian@brauner.io>
Cc: Aleksa Sarai <cyphar@cyphar.com>, Andy Lutomirski <luto@kernel.org>, Randy Dunlap <rdunlap@infradead.org>, "Eric W. Biederman" <ebiederm@xmission.com>, LKML <linux-kernel@vger.kernel.org>, "Serge E. Hallyn" <serge@hallyn.com>, Jann Horn <jannh@google.com>, Andrew Morton <akpm@linux-foundation.org>, Oleg Nesterov <oleg@redhat.com>, Al Viro <viro@zeniv.linux.org.uk>, Linux FS Devel <linux-fsdevel@vger.kernel.org>, Linux API <linux-api@vger.kernel.org>, Tim Murray <timmurray@google.com>, Kees Cook <keescook@chromium.org>, Jan Engelhardt <jengelh@inai.de>
List-Id: linux-api@vger.kernel.org

On Sun, Nov 18, 2018 at 12:15 PM, Christian Brauner
<christian@brauner.io> wrote:
>> That is, I'm proposing an API that looks like this:
>>
>> int process_kill(int procfs_dfd, int signo, const union sigval value)
>
> I've started a second tree with process_signal(int procpid_dfd, int sig)

Thanks.

> instead of an ioctl(). Why do you want sigval too?

API completeness. The sigqueue interface is a superset of kill, and I
don't want process_kill to do less than any PID-based kill. Maybe
taking a siginfo_t, like rt_sigqueueinfo does, would be even better in
that respect, come to think of it.

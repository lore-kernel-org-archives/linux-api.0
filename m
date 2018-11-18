From: Daniel Colascione <dancol@google.com>
Subject: Re: [PATCH] proc: allow killing processes via file descriptors
Date: Sun, 18 Nov 2018 09:24:36 -0800
Message-ID: <CAKOZuesCKo4GH9fdum2EUFLrtTWam3aizcDQUn3-vCYg4T1P8w@mail.gmail.com>
References: <20181118111751.6142-1-christian@brauner.io> <CAKOZuet3s0WxxPgrtrNkq8YiOWhYAiK6yEio6PKVV9J_H4_TSA@mail.gmail.com>
 <CALCETrUd2Y2MmO8Qx8aUvQDOTNiyj35Y7bctPBZe0p2i1EUiLw@mail.gmail.com>
 <CAKOZuev1JUGFWuwsKqS6rXcFMqpCHT1VAG2kwB4O=FHo6DAFiQ@mail.gmail.com>
 <CALCETrVLP_mudJTW6EQpRr5GZ7kfuGci+QCT1uPrOVDTWcod-A@mail.gmail.com>
 <a7f50692-667c-4efe-a2d0-fa324eebb90b@infradead.org> <CAKOZueutLc8d0Fe+7dNWiZKnALhTSST8+kCnOrL+OmB6coUmtA@mail.gmail.com>
 <CALCETrVg71XBv-gMOtL-m0Dd0HNz8_oXOUDSWin5LeViAL0UYA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CALCETrVg71XBv-gMOtL-m0Dd0HNz8_oXOUDSWin5LeViAL0UYA@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Andy Lutomirski <luto@kernel.org>
Cc: Randy Dunlap <rdunlap@infradead.org>, Christian Brauner <christian@brauner.io>, "Eric W. Biederman" <ebiederm@xmission.com>, LKML <linux-kernel@vger.kernel.org>, "Serge E. Hallyn" <serge@hallyn.com>, Jann Horn <jannh@google.com>, Andrew Morton <akpm@linux-foundation.org>, Oleg Nesterov <oleg@redhat.com>, Aleksa Sarai <cyphar@cyphar.com>, Al Viro <viro@zeniv.linux.org.uk>, Linux FS Devel <linux-fsdevel@vger.kernel.org>, Linux API <linux-api@vger.kernel.org>, Tim Murray <timmurray@google.com>, Kees Cook <keescook@chromium.org>, Jan Engelhardt <jengelh@inai.de>
List-Id: linux-api@vger.kernel.org

On Sun, Nov 18, 2018 at 9:09 AM, Andy Lutomirski <luto@kernel.org> wrote:
> On Sun, Nov 18, 2018 at 8:49 AM Daniel Colascione <dancol@google.com> wrote:
>>
>> On Sun, Nov 18, 2018 at 8:33 AM, Randy Dunlap <rdunlap@infradead.org> wrote:
>> > On 11/18/18 8:17 AM, Andy Lutomirski wrote:
>> >> On Sun, Nov 18, 2018 at 7:53 AM Daniel Colascione <dancol@google.com> wrote:
>> >>>
>> >>> On Sun, Nov 18, 2018 at 7:38 AM, Andy Lutomirski <luto@kernel.org> wrote:
>> >>>> I fully agree that a more comprehensive, less expensive API for
>> >>>> managing processes would be nice.  But I also think that this patch
>> >>>> (using the directory fd and ioctl) is better from a security
>> >>>> perspective than using a new file in /proc.
>> >>>
>> >>> That's an assertion, not an argument. And I'm not opposed to an
>> >>> operation on the directory FD, now that it's clear Linus has banned
>> >>> "write(2)-as-a-command" APIs. I just insist that we implement the API
>> >>> with a system call instead of a less-reliable ioctl due to the
>> >>> inherent namespace collision issues in ioctl command names.
>> >>
>> >> Linus banned it because of bugs iike the ones in the patch.
>> >>
>> >>>
>> >>>> I have an old patch to make proc directory fds pollable:
>> >>>>
>> >>>> https://lore.kernel.org/patchwork/patch/345098/
>> >>>>
>> >>>> That patch plus the one in this thread might make a nice addition to
>> >>>> the kernel even if we expect something much better to come along
>> >>>> later.
>> >>>
>> >>> I've always commented on that patch. You never addressed my technical
>> >>> objections. Why are you bringing up this patch again as if that
>> >>> discussion had never happened? To review, that patch has various race
>> >>> conditions
>> >>
>> >> I don't think I ever saw that review.
>> >>
>> >>> and even if it were technically correct, it'd be an abuse
>> >>> of directory objects (in what other circumstance do we poll
>> >>> directories?) and not logically generalizable to a model in which we
>> >>> expose process exit status via the exit-monitoring API.
>> >>
>> >> I agree it's weird.  It might be better to have /proc/PID/exit_status
>> >> and make *that* pollable.
>> >>
>> >
>> > If there is a new exit_status file, it could even be more than
>> > 8 bits of exit status:
>> >
>> > See https://lore.kernel.org/lkml/alpine.LSU.2.20.1507091257010.9602@nerf40.vanv.qr/T/#u
>> > and http://austingroupbugs.net/view.php?id=594#c1317
>>
>> First of all, as I discussed in [1], we need to first figure out *who*
>> should have access to the process exit information. FreeBSD appears to
>> make it public without disaster, and if we make exit status public, a
>> lot of problems just disappear.
>
> I kind of want to go in the other direction of making a lot of process
> information (especially cmdline) less publicly accessible.

Okay. That has nothing to do with exit status. Please address the
points related to the API we're discussing and that I raised in the
other thread.

Assuming we don't broaden exit status readability (which would make a
lot of things simpler), the exit notification mechanism must work like
this: if you can see a process in /proc, you should be able to wait on
it. If you learn that process's exit status through some other means
--- e.g., you're the process's parent, you can ptrace the process, you
have CAP_WHATEVER_IT_IS_ --- then you should be able to learn the fate
of the process. Otherwise you just be able to learn that the process
exited.

>  Windows has an easy time of it because

Windows has an easier time of it because it doesn't use an ad-hoc
ambient authority permission model. In Windows, if you can open a
handle to do something, that handle lets you do the thing. Period.
There's none of this "well, I opened this process FD, but since I
opened it, the process called setuid, so now I can't get its exit
status" nonsense. Privilege elevation is always accomplished via a
separate call to CreateProcessWithToken, which creates a *new* process
with the elevated privileges. An existing process can't suddenly and
magically become this special thing that you can't inspect, but that
has the same PID and identity as this other process that you used to
be able to inspect. The model is just better, because permission is
baked into the HANDLE. Now, that ship has sailed. We're stuck with
setreuid and exec. But let's be clear about what's causing the
complexity.

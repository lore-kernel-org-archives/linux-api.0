From: Daniel Colascione <dancol@google.com>
Subject: Re: [PATCH] proc: allow killing processes via file descriptors
Date: Sun, 18 Nov 2018 09:56:42 -0800
Message-ID: <CAKOZues_ePV5h-6C1hwWcHvcbB8Lni5yP_YPw=ey4Q31j4TMjA@mail.gmail.com>
References: <20181118111751.6142-1-christian@brauner.io> <CAKOZuet3s0WxxPgrtrNkq8YiOWhYAiK6yEio6PKVV9J_H4_TSA@mail.gmail.com>
 <CALCETrUd2Y2MmO8Qx8aUvQDOTNiyj35Y7bctPBZe0p2i1EUiLw@mail.gmail.com>
 <CAKOZuev1JUGFWuwsKqS6rXcFMqpCHT1VAG2kwB4O=FHo6DAFiQ@mail.gmail.com>
 <CALCETrVLP_mudJTW6EQpRr5GZ7kfuGci+QCT1uPrOVDTWcod-A@mail.gmail.com>
 <CAKOZuetuuxW+yFnyaqS5kW6gkVMstLa8D-7SgYtrLBUQB+sgDg@mail.gmail.com>
 <CALCETrXNBNcASRtxTL_aO-KSj4ahPRpXKLUdHaWG3sPjsWx3CQ@mail.gmail.com>
 <CAKOZues3_uh1mnQr=VPCxoWiY0wfiUq0oFXcVuiHF7rPmUXsuw@mail.gmail.com> <875zwu46z1.fsf@xmission.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <875zwu46z1.fsf@xmission.com>
Sender: linux-kernel-owner@vger.kernel.org
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Andy Lutomirski <luto@kernel.org>, Christian Brauner <christian@brauner.io>, LKML <linux-kernel@vger.kernel.org>, "Serge E. Hallyn" <serge@hallyn.com>, Jann Horn <jannh@google.com>, Andrew Morton <akpm@linux-foundation.org>, Oleg Nesterov <oleg@redhat.com>, Aleksa Sarai <cyphar@cyphar.com>, Al Viro <viro@zeniv.linux.org.uk>, Linux FS Devel <linux-fsdevel@vger.kernel.org>, Linux API <linux-api@vger.kernel.org>, Tim Murray <timmurray@google.com>, Kees Cook <keescook@chromium.org>
List-Id: linux-api@vger.kernel.org

On Sun, Nov 18, 2018 at 9:43 AM, Eric W. Biederman
<ebiederm@xmission.com> wrote:
> Daniel Colascione <dancol@google.com> writes:
>
>> On Sun, Nov 18, 2018 at 9:13 AM, Andy Lutomirski <luto@kernel.org> wrote:
>>> On Sun, Nov 18, 2018 at 8:29 AM Daniel Colascione <dancol@google.com> wrote:
>>>>
>>>> On Sun, Nov 18, 2018 at 8:17 AM, Andy Lutomirski <luto@kernel.org> wrote:
>>>> > On Sun, Nov 18, 2018 at 7:53 AM Daniel Colascione <dancol@google.com> wrote:
>>>> >>
>>>> >> On Sun, Nov 18, 2018 at 7:38 AM, Andy Lutomirski <luto@kernel.org> wrote:
>>>> >> > I fully agree that a more comprehensive, less expensive API for
>>>> >> > managing processes would be nice.  But I also think that this patch
>>>> >> > (using the directory fd and ioctl) is better from a security
>>>> >> > perspective than using a new file in /proc.
>>>> >>
>>>> >> That's an assertion, not an argument. And I'm not opposed to an
>>>> >> operation on the directory FD, now that it's clear Linus has banned
>>>> >> "write(2)-as-a-command" APIs. I just insist that we implement the API
>>>> >> with a system call instead of a less-reliable ioctl due to the
>>>> >> inherent namespace collision issues in ioctl command names.
>>>> >
>>>> > Linus banned it because of bugs iike the ones in the patch.
>>>>
>>>> Maybe: he didn't provide a reason. What's your point?
>>>
>>> My point is that an API that involves a file like /proc/PID/kill is
>>> very tricky to get right.  Here are some considerations:
>>
>> Moot. write(2) for this interface is off the table anyway. The right
>> approach here is a system call that accepts a /proc/pid directory file
>> descriptor, a signal number, and a signal information field (as in
>> sigqueue(2)).
>
> If we did not have the permission check challenges and could perform
> the permission checks in open, write(2) would be on the table.
> Performing write(2) would only be concrend about data.
>
> Unfortunately we have setresuid and exec which make that infeasible
> for the kill operations.
>
>>> Now if we had an ioctlat() API, maybe it would make sense.  But we
>>> don't, and I think it would be a bit crazy to add one.
>>
>> A process is not a driver. Why won't this idea of using an ioctl for
>> the kill-process-by-dfd thing just won't die? An ioctl has *zero*
>> advantage in this context.
>
> An ioctl has an advantage in implementation complexity.  An ioctl is
> very much easier to wire up that a system call.
>
> I don't know if that outweighs ioctls disadvantages in long term
> maintainability.

It's not just maintainability. It's safety. We want to expose the new
kill interface to userspace via some kill(1) extension, probably. So
you should be able to write something like `cd /proc/12345 && kill
--by-handle .`. How does kill --by-handle know that it's safe to
perform the kill-by-proc-dfd operation on the file descriptor that it
opens? If the kill operation is an ioctl, you could pass it
/proc/self/fd/whatever of a completely different type; kill would call
ioctl on whatever FD it got, and potentially do a completely random
thing instead of killing a process. In the same situation, a new
system call would fail reliably. Yes, kill could check that the device
numbers of the file it opened matched proc's somehow, but that's
annoying and error-prone and nobody's going to bother in practice. A
new system call, by contrast, fails safe.

I really don't want to give up safety and fail-safe behavior forever
just because it's annoying, today, to wire up a new system call. (The
new table-driven system call stuff, if it ever lands, would make
things easier.)

From: Randy Dunlap <rdunlap@infradead.org>
Subject: Re: [PATCH] proc: allow killing processes via file descriptors
Date: Sun, 18 Nov 2018 08:33:52 -0800
Message-ID: <a7f50692-667c-4efe-a2d0-fa324eebb90b@infradead.org>
References: <20181118111751.6142-1-christian@brauner.io>
 <CAKOZuet3s0WxxPgrtrNkq8YiOWhYAiK6yEio6PKVV9J_H4_TSA@mail.gmail.com>
 <CALCETrUd2Y2MmO8Qx8aUvQDOTNiyj35Y7bctPBZe0p2i1EUiLw@mail.gmail.com>
 <CAKOZuev1JUGFWuwsKqS6rXcFMqpCHT1VAG2kwB4O=FHo6DAFiQ@mail.gmail.com>
 <CALCETrVLP_mudJTW6EQpRr5GZ7kfuGci+QCT1uPrOVDTWcod-A@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CALCETrVLP_mudJTW6EQpRr5GZ7kfuGci+QCT1uPrOVDTWcod-A@mail.gmail.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Andy Lutomirski <luto@kernel.org>, Daniel Colascione <dancol@google.com>
Cc: Christian Brauner <christian@brauner.io>, "Eric W. Biederman" <ebiederm@xmission.com>, LKML <linux-kernel@vger.kernel.org>, "Serge E. Hallyn" <serge@hallyn.com>, Jann Horn <jannh@google.com>, Andrew Morton <akpm@linux-foundation.org>, Oleg Nesterov <oleg@redhat.com>, Aleksa Sarai <cyphar@cyphar.com>, Al Viro <viro@zeniv.linux.org.uk>, Linux FS Devel <linux-fsdevel@vger.kernel.org>, Linux API <linux-api@vger.kernel.org>, Tim Murray <timmurray@google.com>, Kees Cook <keescook@chromium.org>, Jan Engelhardt <jengelh@inai.de>
List-Id: linux-api@vger.kernel.org

On 11/18/18 8:17 AM, Andy Lutomirski wrote:
> On Sun, Nov 18, 2018 at 7:53 AM Daniel Colascione <dancol@google.com> wrote:
>>
>> On Sun, Nov 18, 2018 at 7:38 AM, Andy Lutomirski <luto@kernel.org> wrote:
>>> I fully agree that a more comprehensive, less expensive API for
>>> managing processes would be nice.  But I also think that this patch
>>> (using the directory fd and ioctl) is better from a security
>>> perspective than using a new file in /proc.
>>
>> That's an assertion, not an argument. And I'm not opposed to an
>> operation on the directory FD, now that it's clear Linus has banned
>> "write(2)-as-a-command" APIs. I just insist that we implement the API
>> with a system call instead of a less-reliable ioctl due to the
>> inherent namespace collision issues in ioctl command names.
> 
> Linus banned it because of bugs iike the ones in the patch.
> 
>>
>>> I have an old patch to make proc directory fds pollable:
>>>
>>> https://lore.kernel.org/patchwork/patch/345098/
>>>
>>> That patch plus the one in this thread might make a nice addition to
>>> the kernel even if we expect something much better to come along
>>> later.
>>
>> I've always commented on that patch. You never addressed my technical
>> objections. Why are you bringing up this patch again as if that
>> discussion had never happened? To review, that patch has various race
>> conditions
> 
> I don't think I ever saw that review.
> 
>> and even if it were technically correct, it'd be an abuse
>> of directory objects (in what other circumstance do we poll
>> directories?) and not logically generalizable to a model in which we
>> expose process exit status via the exit-monitoring API.
> 
> I agree it's weird.  It might be better to have /proc/PID/exit_status
> and make *that* pollable.
> 

If there is a new exit_status file, it could even be more than
8 bits of exit status:

See https://lore.kernel.org/lkml/alpine.LSU.2.20.1507091257010.9602@nerf40.vanv.qr/T/#u
and http://austingroupbugs.net/view.php?id=594#c1317

-- 
~Randy

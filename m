From: David Herrmann <dh.herrmann-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 13/14] kdbus: add walk-through user space example
Date: Tue, 24 Mar 2015 18:15:53 +0100
Message-ID: <CANq1E4QmOg0Xjx9d=fDQmuaAO1aBwQAbdwz_7ucyo6LVvFLzUA@mail.gmail.com>
References: <1425906560-13798-1-git-send-email-gregkh@linuxfoundation.org>
	<1425906560-13798-14-git-send-email-gregkh@linuxfoundation.org>
	<551194C8.4070707@suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <551194C8.4070707-AlSwsSmVLrQ@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jiri Slaby <jslaby-AlSwsSmVLrQ@public.gmane.org>
Cc: Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>, "Eric W. Biederman" <ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org>, One Thousand Gnomes <gnomes-qBU/x9rampVanCEyBjwyrvXRex20P6io@public.gmane.org>, Tom Gundersen <teg-B22kvLQNl6c@public.gmane.org>, Jiri Kosina <jkosina-AlSwsSmVLrQ@public.gmane.org>, Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-kernel <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Daniel Mack <daniel-cYrQPVfZoowdnm+yROfE0A@public.gmane.org>, Djalal Harouni <tixxdz-Umm1ozX2/EEdnm+yROfE0A@public.gmane.org>
List-Id: linux-api@vger.kernel.org

Hi

On Tue, Mar 24, 2015 at 5:46 PM, Jiri Slaby <jslaby-AlSwsSmVLrQ@public.gmane.org> wrote:
> On 03/09/2015, 02:09 PM, Greg Kroah-Hartman wrote:
>> --- /dev/null
>> +++ b/samples/kdbus/Makefile
>> @@ -0,0 +1,10 @@
>> +# kbuild trick to avoid linker error. Can be omitted if a module is built.
>> +obj- := dummy.o
>> +
>> +hostprogs-y += kdbus-workers
>> +
>> +always := $(hostprogs-y)
>
> Errr, no. Not only it causes build failures (even with KDBUS=n), it
> definitely should not be built for everyone.

It's only built if CONFIG_SAMPLES is set, right?

What build-failures does it cause? linux/kdbus.h is not optional based
on CONFIG_KDBUS, so the samples should build just fine. Can you tell
me what kind of errors you get? The kbuild-robots didn't report
anything so far.

> And why is it a host prog? It's a sample prog for the kernel I am
> building, i.e. for the destination arch, like all the other samples.

It's modeled after the other user-space examples in ./samples/, which
all use hostprogs (see samples/{bpf,hidraw,seccomp,uhid}/Makefile). I
have no idea how to build programs that run on the target
architecture. Documentation/kbuild/makefiles.txt doesn't list it,
which is, I guess, the reason why everyone used hostprogs so far. And
given that autotools calls the target architecture "--host", I
actually thought this is what hostprogs does.. apparently that's not
the case, sorry.

Thanks
David

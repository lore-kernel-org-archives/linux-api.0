From: Jiri Slaby <jslaby@suse.cz>
Subject: Re: [PATCH 13/14] kdbus: add walk-through user space example
Date: Tue, 24 Mar 2015 18:37:26 +0100
Message-ID: <5511A0D6.5030606@suse.cz>
References: <1425906560-13798-1-git-send-email-gregkh@linuxfoundation.org>	<1425906560-13798-14-git-send-email-gregkh@linuxfoundation.org>	<551194C8.4070707@suse.cz> <CANq1E4QmOg0Xjx9d=fDQmuaAO1aBwQAbdwz_7ucyo6LVvFLzUA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-kbuild-owner@vger.kernel.org>
In-Reply-To: <CANq1E4QmOg0Xjx9d=fDQmuaAO1aBwQAbdwz_7ucyo6LVvFLzUA@mail.gmail.com>
Sender: linux-kbuild-owner@vger.kernel.org
To: David Herrmann <dh.herrmann@gmail.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Arnd Bergmann <arnd@arndb.de>, "Eric W. Biederman" <ebiederm@xmission.com>, One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>, Tom Gundersen <teg@jklm.no>, Jiri Kosina <jkosina@suse.cz>, Andy Lutomirski <luto@amacapital.net>, Linux API <linux-api@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>, Daniel Mack <daniel@zonque.org>, Djalal Harouni <tixxdz@opendz.org>, Michal Marek <mmarek@suse.cz>, linux-kbuild@vger.kernel.org
List-Id: linux-api@vger.kernel.org

Ccing kbuild fellows (see the very bottom).

On 03/24/2015, 06:15 PM, David Herrmann wrote:
> Hi
> 
> On Tue, Mar 24, 2015 at 5:46 PM, Jiri Slaby <jslaby@suse.cz> wrote:
>> On 03/09/2015, 02:09 PM, Greg Kroah-Hartman wrote:
>>> --- /dev/null
>>> +++ b/samples/kdbus/Makefile
>>> @@ -0,0 +1,10 @@
>>> +# kbuild trick to avoid linker error. Can be omitted if a module is built.
>>> +obj- := dummy.o
>>> +
>>> +hostprogs-y += kdbus-workers
>>> +
>>> +always := $(hostprogs-y)
>>
>> Errr, no. Not only it causes build failures (even with KDBUS=n), it
>> definitely should not be built for everyone.
> 
> It's only built if CONFIG_SAMPLES is set, right?

Yes, but I build other samples selected with separate CONFIG_ options
like CONFIG_SAMPLE_LIVEPATCH. So this guy should have its own CONFIG_
option too, because I (and likely others) don't want to build it. All of
the samples should be protected at least by their respective kernel
CONFIG_ option IMO.

> What build-failures does it cause? linux/kdbus.h is not optional based
> on CONFIG_KDBUS, so the samples should build just fine. Can you tell
> me what kind of errors you get? The kbuild-robots didn't report
> anything so far.

The output is this:
In file included from samples/kdbus/kdbus-workers.c:79:0:
/home/latest/linux/samples/kdbus/kdbus-api.h:5:25: fatal error:
linux/kdbus.h: No such file or directory
 #include <linux/kdbus.h>
                         ^
compilation terminated.

I now know that I have to install_headers *if* I want to build the
sample. But I don't want to build it in the first place. (So the config
option above should be all we need.)

>> And why is it a host prog? It's a sample prog for the kernel I am
>> building, i.e. for the destination arch, like all the other samples.
> 
> It's modeled after the other user-space examples in ./samples/, which
> all use hostprogs (see samples/{bpf,hidraw,seccomp,uhid}/Makefile). I
> have no idea how to build programs that run on the target
> architecture. Documentation/kbuild/makefiles.txt doesn't list it,
> which is, I guess, the reason why everyone used hostprogs so far. And
> given that autotools calls the target architecture "--host", I
> actually thought this is what hostprogs does.. apparently that's not
> the case, sorry.

Oh, it's cut&paste, I see. This does not look correct though. The hack
inclusive. Host progs are intended to be run on the host where the
kernel is built. During the compilation or such (like x/menuconfig).
Quite misleading naming if you are used to the autotools one.

thanks,
-- 
js
suse labs

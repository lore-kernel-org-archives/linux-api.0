From: Michal Marek <mmarek@suse.cz>
Subject: Re: [PATCH 13/14] kdbus: add walk-through user space example
Date: Tue, 24 Mar 2015 19:22:56 +0100
Message-ID: <5511AB80.3020102@suse.cz>
References: <1425906560-13798-1-git-send-email-gregkh@linuxfoundation.org>	<1425906560-13798-14-git-send-email-gregkh@linuxfoundation.org>	<551194C8.4070707@suse.cz> <CANq1E4QmOg0Xjx9d=fDQmuaAO1aBwQAbdwz_7ucyo6LVvFLzUA@mail.gmail.com> <5511A0D6.5030606@suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <5511A0D6.5030606@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
To: Jiri Slaby <jslaby@suse.cz>, David Herrmann <dh.herrmann@gmail.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Arnd Bergmann <arnd@arndb.de>, "Eric W. Biederman" <ebiederm@xmission.com>, One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>, Tom Gundersen <teg@jklm.no>, Jiri Kosina <jkosina@suse.cz>, Andy Lutomirski <luto@amacapital.net>, Linux API <linux-api@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>, Daniel Mack <daniel@zonque.org>, Djalal Harouni <tixxdz@opendz.org>, linux-kbuild@vger.kernel.org
List-Id: linux-api@vger.kernel.org

Dne 24.3.2015 v 18:37 Jiri Slaby napsal(a):
> On 03/24/2015, 06:15 PM, David Herrmann wrote:
>> On Tue, Mar 24, 2015 at 5:46 PM, Jiri Slaby <jslaby@suse.cz> wrote:
>>> Errr, no. Not only it causes build failures (even with KDBUS=n), it
>>> definitely should not be built for everyone.
>>
>> It's only built if CONFIG_SAMPLES is set, right?
> 
> Yes, but I build other samples selected with separate CONFIG_ options
> like CONFIG_SAMPLE_LIVEPATCH. So this guy should have its own CONFIG_
> option too, because I (and likely others) don't want to build it. All of

Definitely.


>> It's modeled after the other user-space examples in ./samples/, which
>> all use hostprogs (see samples/{bpf,hidraw,seccomp,uhid}/Makefile). I
>> have no idea how to build programs that run on the target
>> architecture. Documentation/kbuild/makefiles.txt doesn't list it,
>> which is, I guess, the reason why everyone used hostprogs so far. And
>> given that autotools calls the target architecture "--host", I
>> actually thought this is what hostprogs does.. apparently that's not
>> the case, sorry.
> 
> Oh, it's cut&paste, I see. This does not look correct though. The hack
> inclusive. Host progs are intended to be run on the host where the
> kernel is built. During the compilation or such (like x/menuconfig).
> Quite misleading naming if you are used to the autotools one.

when cross compiling, we are a bit between a rock and a hard place with
the sample userspace programs:
- The target toolchain might not have libc support
- The host toolchain might be lacking recent kernel headers (therefore
  the need to do make headers_install)
- It's not clean whether the samples are meant to be ran on the build
  host or target.

There has been some work by Sam Ravnborg to introduce uapiprogs-y to for
sample userspace programs, but for now, please use hostprogs-y,
-Iusr/include and make each sample opt-in.

Michal

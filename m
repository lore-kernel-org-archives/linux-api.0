From: Laurent Vivier <laurent@vivier.eu>
Subject: Re: [RFC 0/2] ns: introduce binfmt_misc namespace
Date: Mon, 1 Oct 2018 10:45:36 +0200
Message-ID: <5b4f0798-eb22-2684-775c-c038c104e190@vivier.eu>
References: <20180930234628.25528-1-laurent@vivier.eu>
 <CALCETrWcQtLTVJU14ytWxu_gqoLuAYZJpyAvRsKwwgYZz7FEFg@mail.gmail.com>
 <874le63zei.fsf@xmission.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <874le63zei.fsf@xmission.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: "Eric W. Biederman" <ebiederm@xmission.com>, Andy Lutomirski <luto@kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Linux FS Devel <linux-fsdevel@vger.kernel.org>, James Bottomley <James.Bottomley@hansenpartnership.com>, Al Viro <viro@zeniv.linux.org.uk>, Linux API <linux-api@vger.kernel.org>, Dmitry Safonov <dima@arista.com>, Andrey Vagin <avagin@openvz.org>, Linux Containers <containers@lists.linux-foundation.org>
List-Id: linux-api@vger.kernel.org

Le 01/10/2018 à 09:21, Eric W. Biederman a écrit :
> Andy Lutomirski <luto@kernel.org> writes:
> 
>> On Sun, Sep 30, 2018 at 4:47 PM Laurent Vivier <laurent@vivier.eu> wrote:
>>>
>>> This series introduces a new namespace for binfmt_misc.
>>>
>>
>> This seems conceptually quite reasonable, but I'm wondering if the
>> number of namespace types is getting out of hand given the current
>> API.  Should we be considering whether we need a new set of namespace
>> creation APIs that scale better to larger numbers of namespace types?
> 
> I would rather encourage a way to make this part of an existing
> namespace or find a way to make a mount of binfmt_misc control this.
> 
> Hmm.  This looks like something that can be very straight forwardly be
> made part of the user namespace.  If you ever mount binfmt_misc in the
> user namespace you get the new behavior.  Otherwise you get the existing
> behavior.

Thank you. I'll do that.

> A user namespace will definitely be required, as otherwise you run the
> risk of confusing root (and suid root exectuables0 by being able to
> change the behavior of executables.
> 
> What is the motivation for this?  My impression is that very few people
> tweak binfmt_misc.

I think more and more people are using an interpreter like qemu
linux-usermode to have a cross-compilation environment: they bootstrap a
distro filesystems (with something like debootstrap), and then use
binfmt_misc to run the compiler inside this environment (see for
instance [1] [2] [3] or [4] [5]). This is interesting because you have
more than a cross-compiler with that: you have also all the libraries of
the target system, you can select exactly which target release you want
to build to, with the exact same compiler and libraries versions (and
you can re-use it you want to do maintenance on your project 10 years
later...)

The problem with this is you need to be root:
1- to chroot
2- to configure binfmt_misc

We already can use "unshare --map-root-user chroot" to address the point
1, and this series tries to address the point 2.

I think it's also interesting to have a per container configuration for
binfmt_misc when the server administrator configures it and don't want
to share each user configuration with all the other user ones (in
something like docker or a cloud application).

> I also don't think this raises to the level where it makes sense to
> create a new namespace for this.

OK.

Thanks,
Laurent

[1] https://wiki.debian.org/Arm64Qemu
[2] https://wiki.debian.org/M68k/sbuildQEMU
[3] https://wiki.debian.org/RISC-V#Manual_qemu-user_installation
[4] https://kbeckmann.github.io/2017/05/26/QEMU-instead-of-cross-compiling/
[5] https://wiki.gentoo.org/wiki/Crossdev_qemu-static-user-chroot

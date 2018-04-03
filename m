From: Andy Lutomirski <luto@kernel.org>
Subject: Re: [GIT PULL] Kernel lockdown for secure boot
Date: Tue, 3 Apr 2018 16:42:46 -0700
Message-ID: <CALCETrXThwok-koDREAP-0ycjphjpc_o0mSBB3zoNXb9rWGLCQ@mail.gmail.com>
References: <4136.1522452584@warthog.procyon.org.uk> <alpine.LRH.2.21.1803311145180.7769@namei.org>
 <186aeb7e-1225-4bb8-3ff5-863a1cde86de@kernel.org> <30459.1522739219@warthog.procyon.org.uk>
 <CALCETrUFOdrH5ShCCd8yguGjC2NtG8fJY7AW26HH467-02UVGA@mail.gmail.com>
 <CACdnJut31+ZtiR40nkOjm89cfUxS0EM=w-oG69PtWHbXYJQxPg@mail.gmail.com>
 <CALCETrXeVod=kNpG-M7yKAMM0-n+PMg_OakN6ecWrTPmKXgMLg@mail.gmail.com>
 <9758.1522775763@warthog.procyon.org.uk> <CALCETrWHS9p1My=j07=V=OP7v4SwQkW-kJ3JOx6EbPU8fb_XEQ@mail.gmail.com>
 <13189.1522784944@warthog.procyon.org.uk> <CALCETrX4CuHVpn38R24TCcJgCBLSbh-sOD-qcD5kYF8Zo53ZJw@mail.gmail.com>
 <9349.1522794769@warthog.procyon.org.uk> <CALCETrV6E+r942K+fu-ALNf-x6qOZ3o1hNKGeu7qEMvr8sMP9A@mail.gmail.com>
 <10232.1522797179@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <10232.1522797179@warthog.procyon.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
To: David Howells <dhowells@redhat.com>
Cc: Andy Lutomirski <luto@kernel.org>, Matthew Garrett <mjg59@google.com>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, James Morris <jmorris@namei.org>, Alan Cox <gnomes@lxorguk.ukuu.org.uk>, Linus Torvalds <torvalds@linux-foundation.org>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Justin Forbes <jforbes@redhat.com>, linux-man <linux-man@vger.kernel.org>, joeyli <jlee@suse.com>, LSM List <linux-security-module@vger.kernel.org>, Linux API <linux-api@vger.kernel.org>, Kees Cook <keescook@chromium.org>, linux-efi <linux-efi@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

On Tue, Apr 3, 2018 at 4:12 PM, David Howells <dhowells@redhat.com> wrote:
> Andy Lutomirski <luto@kernel.org> wrote:
>
>> I'm having a very, very hard time coming up with a scenario where I
>> can "trust" something if an attacker can get root but can't modify the
>> running kernel image but I can't "trust" something if the attacker
>> can [modify the running kernel image].
>
> (I think the above is what you meant)
>
> Let's go at this a different way.  How do you decide you can trust something
> in this context?  You compare it to something.  Signing it, keeping a hash
> whitelist, IMA - these are all ways of comparing something.  Do you agree with
> that?

I trust or distrust a system as a whole.  I don't make that decision
by comparing it to anything.  I make it by evaluating how the system
works and deciding whether it's trustworthy.

>
> What use is secure boot if processes run as root can subvert your kernel?
>

Secure boot serves several purposes:

1. Anti-competitive purposes.  It's intentionally difficult to run
non-Windows OSes on Windows ARM machines, for example.

2. Allowing me to use a stock UEFI machine to have a verified boot chain.

The latter has nothing whatsoever to do with CPL0.  The former,
however, does.  If I could easily write some Windows program to run
CPL0 code, then I could chainload Linux using the Windows image, and
I've subverted the purpose.

Cynical?  Yes.

>> > There's no point bothering with UID/GID checking either.
>>
>> Give me a break.  There's a *huge* difference between a system where
>> only root can load unsigned modules and a system where anyone can load
>> unsigned modules.
>
> I don't think we've ever advocated letting just anyone load a module.
>
> But my point is that if you can modify the running kernel, you can nullify all
> security checks, including UID/GID checks.
>
>> > However, if /dev/mem can be read, any root process can extract the session
>> > key for your disk.
>>
>> Any root process can read /dev/mapper/plaintext_disk, lockdown or otherwise.
>
> True - for now - and they can also access the mounted filesystem.  But if they
> get their hands on your powered-off computer, no, they can't.

This is, IMO, a silly argument.  You're saying that some bad guy has
managed to run code as root on my laptop.  Then, next week, the bad
guy steals my laptop while it's powered off, and Lockdown is supposed
to protect me against that bad guy.  If this happens, I've already
lost completely, lockdown or no.

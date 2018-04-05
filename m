From: Peter Dolding <oiaohm@gmail.com>
Subject: Re: [GIT PULL] Kernel lockdown for secure boot
Date: Thu, 5 Apr 2018 11:28:53 +1000
Message-ID: <CANA3KFX95osEn-Ny2sCUJ+UG607YCka03Eh3B6VzkLTJ+tzepQ@mail.gmail.com>
References: <4136.1522452584@warthog.procyon.org.uk> <alpine.LRH.2.21.1803311145180.7769@namei.org>
 <186aeb7e-1225-4bb8-3ff5-863a1cde86de@kernel.org> <30459.1522739219@warthog.procyon.org.uk>
 <CALCETrUFOdrH5ShCCd8yguGjC2NtG8fJY7AW26HH467-02UVGA@mail.gmail.com>
 <CACdnJut31+ZtiR40nkOjm89cfUxS0EM=w-oG69PtWHbXYJQxPg@mail.gmail.com>
 <CALCETrXeVod=kNpG-M7yKAMM0-n+PMg_OakN6ecWrTPmKXgMLg@mail.gmail.com>
 <9758.1522775763@warthog.procyon.org.uk> <CALCETrWHS9p1My=j07=V=OP7v4SwQkW-kJ3JOx6EbPU8fb_XEQ@mail.gmail.com>
 <13189.1522784944@warthog.procyon.org.uk> <CALCETrX4CuHVpn38R24TCcJgCBLSbh-sOD-qcD5kYF8Zo53ZJw@mail.gmail.com>
 <9349.1522794769@warthog.procyon.org.uk> <CALCETrV6E+r942K+fu-ALNf-x6qOZ3o1hNKGeu7qEMvr8sMP9A@mail.gmail.com>
 <CA+55aFxKzxdRZthzaokaGPAsWCp3a-p3aVfJSutF+9Fp9sbaVA@mail.gmail.com>
 <CACdnJusSfwULV-ubvgtYd8G_cTF4LnJ4DAeTCux4XRhHKVpBUw@mail.gmail.com>
 <CA+55aFzG==xr2OLK8F03RH0nkUDeP6btWqepFTuHZqkPTAOWjQ@mail.gmail.com>
 <CACdnJuv_=ihPut=5OvCYEphdBOn7+JrKacBbNa0n3wv_JvFMzg@mail.gmail.com>
 <CA+55aFyWNok1K-Jo3TQAXGXHvFOTvuOb-Hw977B9RGjBa7prrg@mail.gmail.com>
 <CACdnJutZFKX+izBxRYbyxefT5KrKhVV0XsymU=vBhywd+TOE3A@mail.gmail.com>
 <CA+55aFwVUmjZ+Swe9xUdDOEE+EOoaU3dh7BcrH74BOLCi8y_Kw@mail.gmail.com>
 <CACdnJuvqQQ+hidokY5GA7g-yrAs5-358it0cs+m_d4RFDMuB_w@mail.gmail.com>
 <CA+55aFwJBGCr-anrdV9N63fUH4V_QJqgr0_fJyHhH=fuqGAoog@mail.gmail.com>
 <CACdnJuvFqXGLsAv1Km3MmdssHBfuH5-C_vG3A4eq4Yuj0HhFBA@mail.gmail.com>
 <CA+55aFzYbpRAdma0PvqE+9ygySuKzNKByqOzzMufBoovXVnfPw@mail.gmail.com>
 <CACdnJuv-VpdhjEe1cMysdHb6Oy67jQqg-_TVHbUrOfH9GmCVvg@mail.gmail.com>
 <CA+55aFwvuoSHhKnn82VnDndZ6oXMJgwHF604gZ=h3ehHyC600A@mail.gmail.com>
 <CA+55aFzJ2sQR13T+20MKEJ5co-f3Ev8rRxQkRCWVaeDSUU3yhQ@mail.gmail.com>
 <CACdnJuti5Riqoi1sesqPALYHq9LT87o4MFj-0Y5BZqqzJ5579g@mail.gmail.com>
 <CA+55aFwhi=gz3HLoGST9--n1_kLJNP6jsf8GSesSFxTDCdPdtQ@mail.gmail.com>
 <CACdnJuuek-sS3esmomNOkjBMV_6VPL2NFCzRd+UGxbZrMe=4nw@mail.gmail.com>
 <CANA3KFXyUH4cEJVTH-yoTwqAnZ+-9h-uboYTzO642Uo78H_wqg@mail.gmail.com> <CACdnJuuXgpnkMw8oacgadJQL5nE897cw3-RZBqV7df+19NuiMQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CACdnJuuXgpnkMw8oacgadJQL5nE897cw3-RZBqV7df+19NuiMQ@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Matthew Garrett <mjg59@google.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, luto@kernel.org, David Howells <dhowells@redhat.com>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, James Morris <jmorris@namei.org>, Alan Cox <gnomes@lxorguk.ukuu.org.uk>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, jforbes@redhat.com, linux-man@vger.kernel.org, jlee@suse.com, LSM List <linux-security-module@vger.kernel.org>, linux-api@vger.kernel.org, Kees Cook <keescook@chromium.org>, linux-efi <linux-efi@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

On Thu, Apr 5, 2018 at 2:26 AM, Matthew Garrett <mjg59@google.com> wrote:
> On Tue, Apr 3, 2018 at 11:56 PM Peter Dolding <oiaohm@gmail.com> wrote:
>> On Wed, Apr 4, 2018 at 11:13 AM, Matthew Garrett <mjg59@google.com> wrote:
>
>> > There are four cases:
>> >
>> > Verified Boot off, lockdown off: Status quo in distro and mainline
> kernels
>> > Verified Boot off, lockdown on: Perception of security improvement
> that's
>> > trivially circumvented (and so bad)
>> > Verified Boot on, lockdown off: Perception of security improvement
> that's
>> > trivially circumvented (and so bad), status quo in mainline kernels
>> > Verified Boot on, lockdown on: Security improvement, status quo in
> distro
>> > kernels
>> >
>> > Of these four options, only two make sense. The most common
> implementation
>> > of Verified Boot on x86 platforms is UEFI Secure Boot,
>
>> Stop right there.   Verified boot does not have to be UEFI secureboot.
>>    You could be using a uboot verified boot or
>> https://www.coreboot.org/git-docs/Intel/vboot.html  google vboot.
>> Neither of these provide flags to kernel to say they have been
>> performed.
>
> They can be modified to set the appropriate bit in the bootparams - the
> reason we can't do that in the UEFI case is that Linux can be built as a
> UEFI binary that the firmware execute directly, and so the firmware has no
> way to set that flag.
>
With some of your embedded hardware boot loaders you have exactly the
same problem.   Where you cannot set bootparams instead have to hard
set everything in the kernel image.  This is why there is a option to
embedded initramfs image inside kernel image because some of them will
only load 1 file.

So not using UEFI  you run into the exact same problem.   So lockdown
on or off need to be a kernel build option setting default.   This
could be 3 options Always on, Always off and "Automatic based on boot
verification system status".

https://linux.die.net/man/8/efibootmgr

Also I have a problem here in non broken UEFI implementations -@ |
--append-binary-args that is very simple set the command line passed
into UEFI binary loaded by the firmware with the Linux kernel this
comes bootparams.   Yes using --append-binary-args can be a pain it is
used to tell the Linux kernel where to find the / drive.   So turning
lockdown off by bootparams is down right possible with working UEFI.
There is a lot of EFI out there that does not work properly.

>> Now Verified Boot on, lockdown off.   Insanely this can be required in
>> diagnostic on some embedded platform because EFI secureboot does not
>> have a off switch.    These are platforms where they don't boot if
>> they don't have a PK and KEK set installed.  Yes some of these is jtag
>> the PK and KEK set in.
>
>> The fact that this Verified Boot on, lockdown off causes trouble
>> points to a clear problem.   User owns the hardware they should have
>> the right to defeat secureboot if they wish to.
>
> Which is why Shim allows you to disable validation if you prove physical
> user presence.

Good idea until you have a motherboard where the PS2 ports have failed
and does not support usb keyboard so you have no keyboard until after
the kernel has booted so no way to prove physical presence.   Or are
working on something embedded that has no physical user presence
interface in the boot stages these embedded devices can also be UEFI
with secureboot.  Not everything running UEFI has keyboard,
screen....anything that you can prove physical user presence with
sometimes you have to pure depend on the signing key.

If I am a person who has made my own PK and has my own KEK in UEFI
system I should have the right to sign kernel with lockdown off by
default.   I may need this for diagnostics on hardware without user
interface and I may need this because the hardware is broken and I
have set PK and KEK set by direct firmware  flash access possibly by
jtag or possibly before critical port on motherboard died.

Of course I am not saying that Microsoft and others cannot have rules
that say if using their KEK that you cannot do this.   But if the
machine is my hardware and I have set my own PK and KEK set I do know
what I am doing and I should be allowed to compromise security if I
wish its my hardware.   I should not have to custom hack to do it.
Of course I am not saying that the setting in Linux kernel
configuration system cannot have a big warning that you should not do
this unless you have no other valid option and I am not saying that
the kernel should not log/report if it see what appears to be a
questionable configuration like dmesg "SECURITY ISSUE:  UEFI
secureboot detected enabled kernel built with lockdown disabled system
at risk of comprise".  Something audit tools could check logs for. .

So a kernel booting secureboot with lockdown disabled in kernel
configuration is perfectly fine to log a message that this is the
case.   Always forcing lockdown on because you see UEFI secureboot
will cause issues.

Broken hardware to get around a failed motherboard with UEFI
secureboot locked on you may wish to chain load though a kernel that
you have the means to sign to boot a different OS that is going to be
complex for you to sign due to on going updates.

In my eyes lockdown have a kernel configuration option with 5 options
setting the mode.
1) Automatic: On if a verified boot system is known to the kernel this
may be UEFI secure boot this could be other systems the Linux kernel
can detect in future and off if verified boot is not detected/disabled
or if user approves turning it off by user presence test.,
2) Always on:  That no matter what the Linux kernel turns lockdown on.
No user action or shim action is going to turn it off.
3) On but user/boot bootparams controllable.   So user can give
command line to EFI or other boot-loader to turn it off so no user
presence test and this is need in some cases..
4) Always off:  that is always off no matter what and put error in
dmesg if the Automatic on condition is found.
5) Completely build linux kernel without lockdown code bar with a
single dmesg reporting this.

3-5 all provide security risks all have valid usage reasons.
3 you may want command line controllable you are developing on a
system with user presence cannot be confirmed and you need to be able
to switch between lockdown on and off and you only want to send 1
kernel cross to device in development stages.
4 is simple you have a case where you need lockdown always off line
chain loading on a system where things have gone wrong.
5 can quite simply be diagnostics we have a issue we want to
absolutely confirm that the lockdown code is not the cause.

I can understand if 3-5 are forbin when using Microsoft KEK or other
parties KEKs but those building their own kernels using their own keys
should not have those restrictions it their hardware it thier
configuration if they decide to make it insecure it their choice..


Peter Dolding

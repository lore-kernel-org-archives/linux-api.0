From: Andy Lutomirski <luto@amacapital.net>
Subject: Re: [GIT PULL] Kernel lockdown for secure boot
Date: Mon, 2 Apr 2018 18:47:05 -0700
Message-ID: <70C7A8C3-3DCC-4448-9FBD-534ADDE2D6E6@amacapital.net>
References: <4136.1522452584@warthog.procyon.org.uk> <alpine.LRH.2.21.1803311145180.7769@namei.org> <186aeb7e-1225-4bb8-3ff5-863a1cde86de@kernel.org> <CAGXu5j+UWQWDacMvvRCke3xUOb7uTkxn=WaHzG4kJTKWh-6tAA@mail.gmail.com>
Mime-Version: 1.0 (1.0)
Content-Type: text/plain;
        charset=utf-8
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAGXu5j+UWQWDacMvvRCke3xUOb7uTkxn=WaHzG4kJTKWh-6tAA@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Kees Cook <keescook@chromium.org>
Cc: Andy Lutomirski <luto@kernel.org>, James Morris <jmorris@namei.org>, David Howells <dhowells@redhat.com>, Alan Cox <gnomes@lxorguk.ukuu.org.uk>, Linus Torvalds <torvalds@linux-foundation.org>, Matthew Garrett <mjg59@google.com>, Greg KH <gregkh@linuxfoundation.org>, LKML <linux-kernel@vger.kernel.org>, Justin Forbes <jforbes@redhat.com>, linux-man <linux-man@vger.kernel.org>, joeyli <jlee@suse.com>, linux-security-module <linux-security-module@vger.kernel.org>, Linux API <linux-api@vger.kernel.org>
List-Id: linux-api@vger.kernel.org


> On Apr 2, 2018, at 5:59 PM, Kees Cook <keescook@chromium.org> wrote:
>=20
>> On Mon, Apr 2, 2018 at 5:37 PM, Andy Lutomirski <luto@kernel.org> wrote:
>>> On 03/30/2018 05:46 PM, James Morris wrote:
>>>=20
>>>> On Sat, 31 Mar 2018, David Howells wrote:
>>>>=20
>>>> Date: Thu, 26 Oct 2017 17:37:38 +0100
>>>>=20
>>>> Hi James,
>>>>=20
>>>> Can you pull this patchset into security/next please?  It has been in
>>>> linux-next since the beginning of March.
>>>>=20
>>>> It adds kernel lockdown support for EFI secure boot.
>>>=20
>>>=20
>>> Applied to
>>> git://git.kernel.org/pub/scm/linux/kernel/git/jmorris/linux-security.git=

>>> next-lockdown and next-testing
>>>=20
>>> Are there any known coverage gaps now?
>>>=20
>>>=20
>>>=20
>>=20
>> This is an attempt at a review.  I'm replying here because I can't find t=
he
>> actual relevant patch emails.
>>=20
>> Cover letter:
>>=20
>>> Here's a set of patches to institute a "locked-down mode" in the
>>> kernel and to trigger that mode if the kernel is booted in secure-boot >=

>>> mode or through the command line.
>>=20
>> I think this is seriously problematic in that it's not well defined.  It
>> sounds like "locked-down mode" means "make me feel good about something".=

>=20
> Naming of this feature has been multi-year bikeshedding, so if we
> could just leave the name, that'd be nice.

Fair enough. How about enum kernel_lockdown_level with three modes?

>=20
>=20

>> "Restrict /dev/{mem,kmem,port} when the kernel is locked down": this shou=
ld
>> probably split into one restriction for read and one for write.
>=20
> I think splitting read and write is only useful if there is a use-case
> for only blocking one of them. I struggle to imagine allowing write
> and blocking read, so really it's the case of wanting to allow read
> and disallow write. Is there actually a use-case for this? In all the
> "locked down" cases I've seen, both are desired.
>=20

Let=E2=80=99s suppose for the sake of argument that UEFI really has a good r=
eason to block writes. Blocking reads (kprobes, perf, etc) sounds extremely a=
nnoying, especially if running a stock distro, and I=E2=80=99d much rather n=
ot do it unless there=E2=80=99s a specific use case that needs it.=20=

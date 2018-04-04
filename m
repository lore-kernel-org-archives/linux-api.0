From: Justin Forbes <jforbes@redhat.com>
Subject: Re: [GIT PULL] Kernel lockdown for secure boot
Date: Wed, 4 Apr 2018 11:46:31 -0500
Message-ID: <CAFbkSA1BT6Ca7ZtcjvCubvtke07ctgMQVo25fcWY4ZTRLKw0pA@mail.gmail.com>
References: <CA+55aFzYbpRAdma0PvqE+9ygySuKzNKByqOzzMufBoovXVnfPw@mail.gmail.com>
 <CACdnJuv-VpdhjEe1cMysdHb6Oy67jQqg-_TVHbUrOfH9GmCVvg@mail.gmail.com>
 <CA+55aFwvuoSHhKnn82VnDndZ6oXMJgwHF604gZ=h3ehHyC600A@mail.gmail.com>
 <CA+55aFzJ2sQR13T+20MKEJ5co-f3Ev8rRxQkRCWVaeDSUU3yhQ@mail.gmail.com>
 <CACdnJuti5Riqoi1sesqPALYHq9LT87o4MFj-0Y5BZqqzJ5579g@mail.gmail.com>
 <CA+55aFwhi=gz3HLoGST9--n1_kLJNP6jsf8GSesSFxTDCdPdtQ@mail.gmail.com>
 <CACdnJuuek-sS3esmomNOkjBMV_6VPL2NFCzRd+UGxbZrMe=4nw@mail.gmail.com>
 <CA+55aFxgrh5eeG9MRSEsJtyL5yTe0TehZ=BS2josGJaLxoMMBQ@mail.gmail.com>
 <CACdnJutuBaE3RaDx0KM5vDF9Sinrp=3tG9csrS-H3eU-J7-Utw@mail.gmail.com>
 <24353.1522848817@warthog.procyon.org.uk> <20180404135251.GD16242@thunk.org>
 <CACdnJuuGRRUt-a3i89o906ka3RDOhs+_7tz_G8LTG8Jc0DXAyQ@mail.gmail.com> <CALCETrXwp1faWnqRJ5iLeo6bOOrRS_-L74_xnRAN1Md1YZW8Tg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CALCETrXwp1faWnqRJ5iLeo6bOOrRS_-L74_xnRAN1Md1YZW8Tg@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Andy Lutomirski <luto@kernel.org>
Cc: Matthew Garrett <mjg59@google.com>, Ted Ts'o <tytso@mit.edu>, David Howells <dhowells@redhat.com>, Linus Torvalds <torvalds@linux-foundation.org>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, James Morris <jmorris@namei.org>, Alan Cox <gnomes@lxorguk.ukuu.org.uk>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, linux-man <linux-man@vger.kernel.org>, joeyli <jlee@suse.com>, LSM List <linux-security-module@vger.kernel.org>, Linux API <linux-api@vger.kernel.org>, Kees Cook <keescook@chromium.org>, linux-efi <linux-efi@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

On Wed, Apr 4, 2018 at 11:39 AM, Andy Lutomirski <luto@kernel.org> wrote:
> On Wed, Apr 4, 2018 at 9:22 AM, Matthew Garrett <mjg59@google.com> wrote:
>> On Wed, Apr 4, 2018 at 6:52 AM Theodore Y. Ts'o <tytso@mit.edu> wrote:
>>
>>> On Wed, Apr 04, 2018 at 02:33:37PM +0100, David Howells wrote:
>>> > Theodore Y. Ts'o <tytso@mit.edu> wrote:
>>> >
>>> > > Whoa.  Why doesn't lockdown prevent kexec?  Put another away, why
>>> > > isn't this a problem for people who are fearful that Linux could be
>>> > > used as part of a Windows boot virus in a Secure UEFI context?
>>> >
>>> > Lockdown mode restricts kexec to booting an authorised image (where the
>>> > authorisation may be by signature or by IMA).
>>
>>> If that's true, then Matthew's assertion that lockdown w/o secure boot
>>> is insecure goes away, no?
>>
>> If you don't have secure boot then an attacker with root can modify your
>> bootloader or kernel, and on next boot lockdown can be silently disabled.
>
> This has been rebutted over and over and over.  Secure boot is not the
> only verified boot mechanism in the world.  Other, better, much more
> auditable, and much simpler mechanisms have been around for a long,
> long time.
>
That is certainly the case, and one of the main reasons for the
secureboot patchset being split out and lockdown taking a different
name. The problem is, right now, secure boot is the only thing using
lockdown. I certainly wouldn't go through any effort to tie into it
with any other mechanism knowing that this patch set has been delayed
upstream for years. I would hope and expect that once lockdown is in
mainline, other verified boot mechanisms would leverage it as well.

>>> The fact that this Verified Boot on, lockdown off causes trouble
>>> points to a clear problem.   User owns the hardware they should have
>>> the right to defeat secureboot if they wish to.
>>
>> Which is why Shim allows you to disable validation if you prove physical
>> user presence.
>
> And that's a giant hack.  The actual feature should be that a user
> proves physical presence and thus disables lockdown *without*
> disabling verification.
>
> --Andy

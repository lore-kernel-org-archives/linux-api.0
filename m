From: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [GIT PULL] Kernel lockdown for secure boot
Date: Tue, 3 Apr 2018 18:43:04 -0700
Message-ID: <CA+55aFxgrh5eeG9MRSEsJtyL5yTe0TehZ=BS2josGJaLxoMMBQ@mail.gmail.com>
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
 <CA+55aFwhi=gz3HLoGST9--n1_kLJNP6jsf8GSesSFxTDCdPdtQ@mail.gmail.com> <CACdnJuuek-sS3esmomNOkjBMV_6VPL2NFCzRd+UGxbZrMe=4nw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CACdnJuuek-sS3esmomNOkjBMV_6VPL2NFCzRd+UGxbZrMe=4nw@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Matthew Garrett <mjg59@google.com>
Cc: Andrew Lutomirski <luto@kernel.org>, David Howells <dhowells@redhat.com>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, James Morris <jmorris@namei.org>, Alan Cox <gnomes@lxorguk.ukuu.org.uk>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Justin Forbes <jforbes@redhat.com>, linux-man <linux-man@vger.kernel.org>, joeyli <jlee@suse.com>, LSM List <linux-security-module@vger.kernel.org>, Linux API <linux-api@vger.kernel.org>, Kees Cook <keescook@chromium.org>, linux-efi <linux-efi@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

On Tue, Apr 3, 2018 at 6:13 PM, Matthew Garrett <mjg59@google.com> wrote:
>
> There are four cases:

No.

Matthew., stop with the agenda already.

This shit is what I'm talking about:

> Verified Boot off, lockdown on: Perception of security improvement that's
> trivially circumvented (and so bad)

You're doing some serious value judgement that is simply bogus.

If lockdown actually helps avoid CPL0 execution attacks, then it helps
even if secure more is off.

Sure, you can do things like try to install kernels and reboot, but
honestly, that's not "trivially circumvented". It can be quite hard to
hide even if you don't have secure boot. Things like disk encryption
(common for a lot of people) for example means that you simply won't
be booting that machine without the user noticing.

Or think of virtual machines - which people often use on purpose for
security things. Again, they very much are _not_ going to have secure
boot, but it's not necessarily even possible to "replace the kernel
and reboot" at all, because the kernel came from outside the virtual
machine entirely, and rebooting might just kill the VM rather than
restart anything.

So I really think you're pushing this whole "not secure boot" means
"trivial circumvention" much much too hard.

To the point of it being an outright lie.

I think the kind of people who run stuff in virtual machines could
easily want to also enable lockdown measures, simply to reduce the
attack window within that VM. Wouldn't you agree? Those are often
security-conscious people.

This is what I mean by having an agenda.  We all know you are a big
proponent of secure boot. But it seems to cloud your arguments, by
turning your assumptions and your agenda into an "argument" that is
simply not even TRUE.

See what I'm unhappy about?

> Verified Boot on, lockdown off: Perception of security improvement that's
> trivially circumvented (and so bad), status quo in mainline kernels

I think this is entirely false too. Again, the "trivial circumvention"
shows a bias and agenda that isn't really all that true.

> Of these four options, only two make sense.

No.

You say that, because you have that bias and that agenda.

But that simply doesn't make it true.

Now, what actually seems to be a real and valid argument is *this* part:

> This makes it easy for a user to switch
> between the two states that make sense by running a single command and then
> following some prompts on the next reboot. The alternative would be to
> provide a signed kernel that always enabled lockdown and an unsigned kernel
> that didn't, which would (a) increase load on distributions and (b) force
> users to both run mokutil --disable-validation and also install a different
> kernel.

THAT is an actual argument. Admittedly I think it's a horrible hack,
but it's a hack that can be explained without outright lying. And it
may be a hack that is "the best we can reasonably do"

See what I'm saying?

One argument is based on your value judgments that not everybody else
believes in.

The other argument is based purely on cold hard particular facts.

Guess which argument is better for people who aren't Matthew Garrett?

That said, wouldn't it be equally good to just make the whole thing be
a protected EFI variable instead? Once you have physical access to the
EFI shell (to turn off secure boot) you have access to that too.

Which would allow the "switch off/on" case even if there are other
reasons why changing secure boot isn't a great option (possibly
because secure boot isn't an option to begin with due to being so
invonvenient).

              Linus

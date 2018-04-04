From: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [GIT PULL] Kernel lockdown for secure boot
Date: Wed, 4 Apr 2018 09:09:03 -0700
Message-ID: <CA+55aFyyom+jje0Q8xwLfKCWGkRbWC2Gan6xPOPWaqBCSS=5Ow@mail.gmail.com>
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
 <CA+55aFxgrh5eeG9MRSEsJtyL5yTe0TehZ=BS2josGJaLxoMMBQ@mail.gmail.com> <CACdnJutuBaE3RaDx0KM5vDF9Sinrp=3tG9csrS-H3eU-J7-Utw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CACdnJutuBaE3RaDx0KM5vDF9Sinrp=3tG9csrS-H3eU-J7-Utw@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Matthew Garrett <mjg59@google.com>
Cc: Andrew Lutomirski <luto@kernel.org>, David Howells <dhowells@redhat.com>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, James Morris <jmorris@namei.org>, Alan Cox <gnomes@lxorguk.ukuu.org.uk>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Justin Forbes <jforbes@redhat.com>, linux-man <linux-man@vger.kernel.org>, joeyli <jlee@suse.com>, LSM List <linux-security-module@vger.kernel.org>, Linux API <linux-api@vger.kernel.org>, Kees Cook <keescook@chromium.org>, linux-efi <linux-efi@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

On Tue, Apr 3, 2018 at 9:30 PM, Matthew Garrett <mjg59@google.com> wrote:
>
> Bear in mind that I'm talking about defaults here

Mattyhew, I really want you to look yourself in the mirror.

Those defaults are really horrible defautls for real technical reasons.

You asked me why when I questioned this, but then when I replied, you
entirely ignored it.

So let me repeat: the defaults are *horrible*. They are horrible for a
very simple reason: kernel behavior changes that depend on some subtle
boot difference are truly nasty to debug, and nasty to get coverage
for.

And this "subtle boot difference" is really bad because it's a
difference that has a particularly bad pattern: pretty much not a
single mainline kernel developer will have secure boot enabled,
exactly because it's so inconvenient for testing.

So what does that mean?

It means that the default is *actively* bad for kernel development. It
means that the people who do kernel development will not be testing
the behavior that "normal" users will actually see.

If you do not see why that is a HORRIBLY BAD THING, I don't know what to say.

Seriously. It's a nasty nasty default behavior. It's absolutely
disastrously wrong.

And then when people call you out on this bad linkage of this feature
with secure boot, you spent a *LOT* of time being dishonest about it.
Instead of answeing a simple technical question, you did just about
everything you could to avoid answering it.

You initially turned the question back into a "Why would you want to?"
rather than just answering.

Then you spent a whole lot of time coming up with completely wrong
excuses that had no actual technical reason for them.

And even now, you're trying to ignore the question, and the REASON for
the question.

See above: the default is really horrendously bad, and is just about
the *worst* default you could ever pick from a kernel development
angle.

So when a kernel developer - both me and Andy - ask you about the
reason for that HORRIBLY BAD default, then you had better stop dancing
around the issue, and be honesy.

Instead, you bring up complete red herrings:

> If a user has a configuration where you're able to verify that userspace
> has some degree of protection (eg, disk encryption keys are in the TPM and
> won't unseal if someone's switched out the kernel) then it's reasonable for
> userland (or a kernel command line option) to enable the functionality.

This line of arguyment of yours ends up STILL being complete and utter garbage.

There is not a single shred of evidence that there is some kind of
"reasonable to enable the functionality" based on completely unrelated
matters.

See above on why such stupid linkages are a bad bad idea. Absolutely
*ANY* time you make that decision silently for a user, you will just
be doing the wrong thing.

You will do the wrong thing for security, but equally importantly, you
will be doing the wrong thing just for *development* and *test
coverage*.

> What I'm afraid of is this turning into a "security" feature that ends up
> being circumvented in most scenarios where it's currently deployed - eg,
> module signatures are mostly worthless in the non-lockdown case because you
> can just grab the sig_enforce symbol address and then kexec a preamble that
> flips it back to N regardless of the kernel config.

Honestyly, all of your arguments are made up shit.

This argument, for example, is just a complete red herring.

Do you want to protect against somebody flipping "sig_enforce"? Makes
perfect sense to me.

Then WHY is that not just a config option for extra hardening?
Seriously. I'd use it. I have never *ever* felt the need to switch
"sig_enforce" off, and I always build with MODULE_SIG_FORCE and
MODULE_SIG_ALL.

Getting rid of that switch entirely for security reasons sounds just
_fine_ to me.

So you use these *stupid* things as "arguments" for why you think you
want to do something. But you're putting the cart before the horse:
you have a particular end result you want to get to, and then you make
up arguments for why you want to get there.

Seriously, go back to that coverage and testing issue. Go back to the
*fundamental* technical issue that we want kernel developers to
actually *test* the code that users are running.

*Gasp*.

Yeah, I know, it's a completely radical idea, but it's true. Having
developers test and run the code actual real humans are using is a
truly revolutionary concept in security too.

> I'm making this argument from the perspective of "What should the kernel do
> when it has no additional information".

And I'm telling you that you're ignoring the fact that you picked a
truly horrendously shitty default.

And then you spent a *lot* of time giving misleading and bad
information about why you picked that shitty default, and instead just
questioning the people who asked you an actual and really simply
technical question.

                  Linus

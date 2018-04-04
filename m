From: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [GIT PULL] Kernel lockdown for secure boot
Date: Tue, 3 Apr 2018 18:58:03 -0700
Message-ID: <CA+55aFwGmbNCjHpXHhtMWLobVkX=eq6_xEg=42jQ+M-EK4Tq2g@mail.gmail.com>
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
 <CA+55aFwhi=gz3HLoGST9--n1_kLJNP6jsf8GSesSFxTDCdPdtQ@mail.gmail.com> <CAFbkSA0ursG3RGWU19LQiD6u30h5V=Aqj3oVyHQCiX6MLopYUg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAFbkSA0ursG3RGWU19LQiD6u30h5V=Aqj3oVyHQCiX6MLopYUg@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Justin Forbes <jforbes@redhat.com>
Cc: Matthew Garrett <mjg59@google.com>, Andrew Lutomirski <luto@kernel.org>, David Howells <dhowells@redhat.com>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, James Morris <jmorris@namei.org>, Alan Cox <gnomes@lxorguk.ukuu.org.uk>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, linux-man <linux-man@vger.kernel.org>, joeyli <jlee@suse.com>, LSM List <linux-security-module@vger.kernel.org>, Linux API <linux-api@vger.kernel.org>, Kees Cook <keescook@chromium.org>, linux-efi <linux-efi@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

On Tue, Apr 3, 2018 at 6:30 PM, Justin Forbes <jforbes@redhat.com> wrote:
>>
>> If there actually was a good explanation for the tie-in, it should
>> have been front-and-center and explained as such.
>>
> Honestly, yes, the major distros have been shipping this patch set for years
> now, and every time it comes to upstream, the same damn arguments emerge.

Well, I think it's because the explanations have been bogus.

Just look at this thread. It took closer to a hundred emails (ok, so
I'm exaggerating, but not _that_ much) until the *real* reason for the
tie-in was actually exposed.

For the first 50+ emails, the explanation was "oh, only if you do
secure boot does this make sense".

Which is still pure BULLSHIT. Of _course_ that kind of stuff raises
peoples hackles and makes people not trust the messenger - he's
clearly being evasive and there must be something else going on.

So instead of the bullshit explanations, just explain the purely
_practical_ side.

Because I find it a *lot* more convincing to hear:

   "We'd like to just enable it all the time, but it's known to break
    some unusual hardware cases that we can't fix in software, and we
    wanted *some* way to disable it that requires explicit and verified
    user intervention to do that, and disabling secure boot is the
    easiest hack we could come up with".

See? No bullshit. Just straight talk about the *actual* reason why
people decided on this particular tie-in, and admitting that it's a
hack, but also clearly stating the reason for the hack.

Now, I still don't necessarily agree that it's the best possible
option, but when stated in those terms I at least understand why that
option was picked as a reasonable one, and it changes the discussion a
lot, and (at least for me) makes it much more palatable.

Because as long as the explanation is just some "you must use secure
boot or you've already lost and further security is pointless"
hocus-pocus magical thinking, I immediately go "no, that sounds
completely bogus, and it makes testing and coverage much worse, we've
done other things quite like that without this secure boot tie-in".

             Linus

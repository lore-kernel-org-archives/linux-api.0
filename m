From: Justin Forbes <jforbes@redhat.com>
Subject: Re: [GIT PULL] Kernel lockdown for secure boot
Date: Tue, 3 Apr 2018 20:36:42 -0500
Message-ID: <CAFbkSA1YTN3DVNBQzYuJpu-Y4cWb6iwR_VeWyZjtZ2Ejd8w6DA@mail.gmail.com>
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
 <CACdnJuti5Riqoi1sesqPALYHq9LT87o4MFj-0Y5BZqqzJ5579g@mail.gmail.com> <CA+55aFwhi=gz3HLoGST9--n1_kLJNP6jsf8GSesSFxTDCdPdtQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CA+55aFwhi=gz3HLoGST9--n1_kLJNP6jsf8GSesSFxTDCdPdtQ@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Matthew Garrett <mjg59@google.com>, Andrew Lutomirski <luto@kernel.org>, David Howells <dhowells@redhat.com>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, James Morris <jmorris@namei.org>, Alan Cox <gnomes@lxorguk.ukuu.org.uk>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, linux-man <linux-man@vger.kernel.org>, joeyli <jlee@suse.com>, LSM List <linux-security-module@vger.kernel.org>, Linux API <linux-api@vger.kernel.org>, Kees Cook <keescook@chromium.org>, linux-efi <linux-efi@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

On Tue, Apr 3, 2018 at 7:56 PM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
> On Tue, Apr 3, 2018 at 5:46 PM, Matthew Garrett <mjg59@google.com> wrote:
>>
>> The generic distros have been shipping this policy for the past 5 years.
>
> .. so apparently it doesn't actually break things? Why not enable it
> by default then?
>
> And if "turn off secure boot" really is the accepted - and actuially
> used - workaround for the breakage, then
>

While there is very little breakage in the *years* we have been
shipping this in distro kernels, the accepted and used workaround has
always been "turn off secure boot" or sign/import your own keys,
depending on the problems encountered.

>    WHY THE HELL DIDN'T YOU START OFF BY EXPLAINING THAT IN THE FIRST
> PLACE WHEN PEOPLE ASKED WHY THE TIE-IN EXISTED?
>
> Sorry for shouting, but really. We have a thread of just *how* many
> email messages that asked for the explanation for this? All we got was
> incomprehensible and illogical crap explanations.
>
> If there actually was a good explanation for the tie-in, it should
> have been front-and-center and explained as such.
>

Honestly, yes, the major distros have been shipping this patch set for
years now, and every time it comes to upstream, the same damn
arguments emerge.  I do not disagree that there are uses for lockdown
outside of secure boot, provided you have some other mechanism to
verify your chain, I believe chrome OS does. But the tie to secure
boot is because that is the use case that users have been using for
years, it was discussed at kernel summit quite a while ago, plans went
forward there seemed to be agreement, and when it comes time for a
pull request, people come out of the woodwork with an expectation that
it solves every problem or it doesn't need to exist. What is here is a
good starting point. I would expect that if it were merged, others
would build upon that and use much of the code already in place to
extend it. It is tied to secure boot because that is what has been
using this for years as it never seems to get upstream.  I am sure
that once it does finally land, it can and will be extended to other
things, but I don't think I would want to spend a lot of time trying
to leverage another external patch set that has been delayed upstream
so many times until it actually did land.
As for the ties to MS that come up every time, and have here as well,
there is no requirement on the MS signature. You can import your own
keys if you don't want them involved, I keep a "test key" imported for
actually running what I build locally.

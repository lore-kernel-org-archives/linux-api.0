From: Jann Horn <jannh@google.com>
Subject: Re: [GIT PULL] Kernel lockdown for secure boot
Date: Wed, 4 Apr 2018 02:17:55 +0200
Message-ID: <CAG48ez1MRsDGoea5MwGTXK6R0LJy9u0mX-1VrSSskwnV98kEjQ@mail.gmail.com>
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
 <CACdnJuvqQQ+hidokY5GA7g-yrAs5-358it0cs+m_d4RFDMuB_w@mail.gmail.com> <CA+55aFwJBGCr-anrdV9N63fUH4V_QJqgr0_fJyHhH=fuqGAoog@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CA+55aFwJBGCr-anrdV9N63fUH4V_QJqgr0_fJyHhH=fuqGAoog@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Matthew Garrett <mjg59@google.com>, Andrew Lutomirski <luto@kernel.org>, David Howells <dhowells@redhat.com>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, James Morris <jmorris@namei.org>, Alan Cox <gnomes@lxorguk.ukuu.org.uk>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Justin Forbes <jforbes@redhat.com>, linux-man <linux-man@vger.kernel.org>, joeyli <jlee@suse.com>, LSM List <linux-security-module@vger.kernel.org>, Linux API <linux-api@vger.kernel.org>, Kees Cook <keescook@chromium.org>, linux-efi <linux-efi@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

On Wed, Apr 4, 2018 at 2:06 AM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
> On Tue, Apr 3, 2018 at 4:59 PM, Matthew Garrett <mjg59@google.com> wrote:
>>
>> Ok. So we can build distribution kernels that *always* have this on, and to
>> turn it off you have to disable Secure Boot and install a different kernel.
>
> Bingo.
>
> Exactly like EVERY OTHER KERNEL CONFIG OPTION.
>
> Just like all the ones that I've mentioned several times.
>
> Or, like a lot of other kernel options, maybe have a way to just
> disable it on the kernel command line, and let the user know about it.
>
> That would still be better than disabling secure boot entirely in your
> world view, so it's (a) more convenient and (b) better.
>
> Again, in no case does it make sense to tie it into "how did we boot".
> Because that's just inconvenient for everybody.

Without taking a stance regarding whether I think that kernel lockdown
makes sense, I think Matthew's point is this:
If you don't have lockdown, secure boot doesn't provide a benefit,
since an attacker could just modify the init binary instead of messing
with your kernel.
If you have secure boot, you want lockdown to prevent chainloading
into a backdoored version of the real OS.

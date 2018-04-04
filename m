From: Matthew Garrett <mjg59@google.com>
Subject: Re: [GIT PULL] Kernel lockdown for secure boot
Date: Wed, 04 Apr 2018 00:12:04 +0000
Message-ID: <CACdnJuvuf13VrHfBadvXvVLUQoqjdbwqmnsRHamfDN_O4Ve+kA@mail.gmail.com>
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
 <CA+55aFx9u-O81MwSq8zpb+MKaWYjYvtEcFu1NLP1_s63ED6_3Q@mail.gmail.com>
 <CACdnJutkO9dgz=HZpPRR9PZC=+cHh97dRUiGB+D3gruZr6U9Kg@mail.gmail.com>
 <CA+55aFxZN_p_cU94z7QN8=HnPanRrpRHH7UUkOBaFDSjfrivnQ@mail.gmail.com>
 <CACdnJutOAPTmPm6dmHiw4+8rj=M7B1SiCkPaRZLmi9-CCuRyNg@mail.gmail.com> <CA+55aFzH6doC2F1xBitPRwTZtbiCO_mX+QVcJ8HQCdsdD3Vmpg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CA+55aFzH6doC2F1xBitPRwTZtbiCO_mX+QVcJ8HQCdsdD3Vmpg@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: luto@kernel.org, David Howells <dhowells@redhat.com>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, jmorris@namei.org, Alan Cox <gnomes@lxorguk.ukuu.org.uk>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, jforbes@redhat.com, linux-man@vger.kernel.org, jlee@suse.com, LSM List <linux-security-module@vger.kernel.org>, linux-api@vger.kernel.org, Kees Cook <keescook@chromium.org>, linux-efi <linux-efi@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

On Tue, Apr 3, 2018 at 5:08 PM Linus Torvalds
<torvalds@linux-foundation.org>
wrote:
> Still better than telling them to disable/enable secure boot, which
> they may or may not even be able to to.

Users who can boot a non-vendor Linux distribution on their platform can
disable Secure Boot 100% of the time.

From: joeyli <jlee@suse.com>
Subject: Re: [GIT PULL] Kernel lockdown for secure boot
Date: Sun, 8 Apr 2018 15:44:09 +0800
Message-ID: <20180408074409.GD7362@linux-l9pv.suse>
References: <CAADnVQLu5EZLJ1C9-dd4=K+sed6+38oy047+nqCMfuPFB=wttw@mail.gmail.com>
 <CACdnJuv8t3kS5BCowWQ7rMjL2K73913wX2-bb5HF0ddY3iaBHg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CACdnJuv8t3kS5BCowWQ7rMjL2K73913wX2-bb5HF0ddY3iaBHg@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Matthew Garrett <mjg59@google.com>
Cc: alexei.starovoitov@gmail.com, luto@kernel.org, David Howells <dhowells@redhat.com>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, jmorris@namei.org, Alan Cox <gnomes@lxorguk.ukuu.org.uk>, Linus Torvalds <torvalds@linux-foundation.org>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, jforbes@redhat.com, linux-man@vger.kernel.org, LSM List <linux-security-module@vger.kernel.org>, linux-api@vger.kernel.org, Kees Cook <keescook@chromium.org>, linux-efi <linux-efi@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

On Wed, Apr 04, 2018 at 04:31:46AM +0000, Matthew Garrett wrote:
> On Tue, Apr 3, 2018 at 7:34 PM Alexei Starovoitov <
> alexei.starovoitov@gmail.com> wrote:
> > If the only thing that folks are paranoid about is reading
> > arbitrary kernel memory with bpf_probe_read() helper
> > then preferred patch would be to disable it during verification
> > when in lockdown mode.
> > No run-time overhead and android folks will be happy
> > that lockdown doesn't break their work.
> > They converted out-of-tree networking accounting
> > module and corresponding user daemon to use bpf:
> 
> https://www.linuxplumbersconf.org/2017/ocw/system/presentations/4791/original/eBPF%20cgroup%20filters%20for%20data%20usage%20accounting%20on%20Android.pdf
> 
> An alternative would be to only disable kernel reads if the kernel contains
> secrets that aren't supposed to be readable by root. If the keyring is
> configured such that root can read everything, it seems like less of a
> concern?

Currently the KMK (kernel master key) can be a trusted key (TPM sealed) or a
user key (plaintext). The EVM keeps a key (plaintext) in memory that
it is decrypted from a KMK encrypted key. Those kernel reads functions should
be disabled when the KMK be loaded to keyring.

You idea is good that kernel can keep those reads functions enabled until KMK
be loaded. Which means those functions are still available before user enables
KMK and EVM.

There have another idea is using a tree to register all sensitive data
then blanking them when reading. Here is a very early developing version:

https://github.com/joeyli/linux-sensitive_data/commits/sensitive-data-tree-v0.1-v4.15

But this approach causes runtime overhead and all sensitive data address must
be found and registered (e.g. plaintext in encryption module)

Thanks a lot!
Joey Lee 

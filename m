From: Alexei Starovoitov <alexei.starovoitov@gmail.com>
Subject: Re: [GIT PULL] Kernel lockdown for secure boot
Date: Sun, 8 Apr 2018 20:40:10 -0700
Message-ID: <20180409034008.dyte7k5kgkbjh5is@ast-mbp.dhcp.thefacebook.com>
References: <CAADnVQLu5EZLJ1C9-dd4=K+sed6+38oy047+nqCMfuPFB=wttw@mail.gmail.com>
 <20180408080742.GE7362@linux-l9pv.suse>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180408080742.GE7362@linux-l9pv.suse>
Sender: linux-kernel-owner@vger.kernel.org
To: joeyli <jlee@suse.com>
Cc: Andy Lutomirski <luto@kernel.org>, David Howells <dhowells@redhat.com>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, James Morris <jmorris@namei.org>, One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>, Linus Torvalds <torvalds@linux-foundation.org>, Matthew Garrett <mjg59@google.com>, Greg KH <gregkh@linuxfoundation.org>, LKML <linux-kernel@vger.kernel.org>, Justin Forbes <jforbes@redhat.com>, linux-man <linux-man@vger.kernel.org>, LSM List <linux-security-module@vger.kernel.org>, Linux API <linux-api@vger.kernel.org>, Kees Cook <keescook@chromium.org>, linux-efi <linux-efi@vger.kernel.org>, Daniel Borkmann <daniel@iogearbox.net>
List-Id: linux-api@vger.kernel.org

On Sun, Apr 08, 2018 at 04:07:42PM +0800, joeyli wrote:
> 
> > If the only thing that folks are paranoid about is reading
> > arbitrary kernel memory with bpf_probe_read() helper
> > then preferred patch would be to disable it during verification
> > when in lockdown mode
> 
> Sorry for I didn't fully understand your idea...
> Do you mean that using bpf verifier to filter out bpf program that
> uses bpf_probe_read()?

Take a look bpf_get_trace_printk_proto().
Similarly we can add bpf_get_probe_read_proto() that
will return NULL if lockdown is on.
Then programs with bpf_probe_read() will be rejected by the verifier.

From: David Howells <dhowells@redhat.com>
Subject: Re: An actual suggestion (Re: [GIT PULL] Kernel lockdown for secure boot)
Date: Wed, 04 Apr 2018 23:19:27 +0100
Message-ID: <15406.1522880367@warthog.procyon.org.uk>
References: <CAG48ez3edmZo1iFXqpvzOKNY0jLzcqa18KuoRrBaPyfp=7huZQ@mail.gmail.com> <CALCETrUVQLDC6_VEvuAbdCOuGrmcxohqTB6P8eyNojm9AryNkg@mail.gmail.com> <1119.1522858644@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAG48ez3edmZo1iFXqpvzOKNY0jLzcqa18KuoRrBaPyfp=7huZQ@mail.gmail.com>
Content-ID: <15405.1522880367.1@warthog.procyon.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
To: Jann Horn <jannh@google.com>
Cc: dhowells@redhat.com, Alexei Starovoitov <ast@kernel.org>, Andy Lutomirski <luto@kernel.org>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, "Theodore Y. Ts'o" <tytso@mit.edu>, Matthew Garrett <mjg59@google.com>, Linus Torvalds <torvalds@linux-foundation.org>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, James Morris <jmorris@namei.org>, Alan Cox <gnomes@lxorguk.ukuu.org.uk>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Justin Forbes <jforbes@redhat.com>, linux-man <linux-man@vger.kernel.org>, joeyli <jlee@suse.com>, LSM List <linux-security-module@vger.kernel.org>, Linux API <linux-api@vger.kernel.org>, Kees Cook <keescook@chromium.org>, linux-efi <linux-efi@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

Jann Horn <jannh@google.com> wrote:

> > Uh, no.  bpf, for example, can be used to modify kernel memory.
> 
> I'm pretty sure bpf isn't supposed to be able to modify arbitrary
> kernel memory. AFAIU if you can use BPF to write to arbitrary kernel
> memory, that's a bug; with CAP_SYS_ADMIN, you can read from userspace,
> write to userspace, and read from kernelspace, but you shouldn't be
> able to write to kernelspace.

Ah - you may be right.  I seem to have misremembered what Joey Lee wrote in
his patch description.

David

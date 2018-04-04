From: Jann Horn <jannh@google.com>
Subject: Re: An actual suggestion (Re: [GIT PULL] Kernel lockdown for secure boot)
Date: Wed, 4 Apr 2018 18:23:28 +0200
Message-ID: <CAG48ez3edmZo1iFXqpvzOKNY0jLzcqa18KuoRrBaPyfp=7huZQ@mail.gmail.com>
References: <CALCETrUVQLDC6_VEvuAbdCOuGrmcxohqTB6P8eyNojm9AryNkg@mail.gmail.com>
 <1119.1522858644@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1119.1522858644@warthog.procyon.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
To: David Howells <dhowells@redhat.com>, Alexei Starovoitov <ast@kernel.org>
Cc: Andy Lutomirski <luto@kernel.org>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, "Theodore Y. Ts'o" <tytso@mit.edu>, Matthew Garrett <mjg59@google.com>, Linus Torvalds <torvalds@linux-foundation.org>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, James Morris <jmorris@namei.org>, Alan Cox <gnomes@lxorguk.ukuu.org.uk>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Justin Forbes <jforbes@redhat.com>, linux-man <linux-man@vger.kernel.org>, joeyli <jlee@suse.com>, LSM List <linux-security-module@vger.kernel.org>, Linux API <linux-api@vger.kernel.org>, Kees Cook <keescook@chromium.org>, linux-efi <linux-efi@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

+ast@kernel.org

On Wed, Apr 4, 2018 at 6:17 PM, David Howells <dhowells@redhat.com> wrote:
> Andy Lutomirski <luto@kernel.org> wrote:
[...]
>> 3. All the bpf and tracing stuf, etc, gets changed so it only takes
>> effect when LOCKDOWN_PROTECT_INTEGRITY_AND_SECRECY is set.
>
> Uh, no.  bpf, for example, can be used to modify kernel memory.

I'm pretty sure bpf isn't supposed to be able to modify arbitrary
kernel memory. AFAIU if you can use BPF to write to arbitrary kernel
memory, that's a bug; with CAP_SYS_ADMIN, you can read from userspace,
write to userspace, and read from kernelspace, but you shouldn't be
able to write to kernelspace.

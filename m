From: Alexei Starovoitov <alexei.starovoitov@gmail.com>
Subject: Re: [PATCH net-next] modules: allow modprobe load regular elf
 binaries
Date: Thu, 8 Mar 2018 17:25:32 -0800
Message-ID: <20180309012530.rk2m5kmpab7eb5fe@ast-mbp>
References: <20180306013457.1955486-1-ast@kernel.org>
 <CAGXu5j+Q=S5sw9N5avyByxi2ekM6povT5Tajjhdb6D9g9ggKxQ@mail.gmail.com>
 <357c330f-0165-b7a4-7ecc-4cd797e61e15@fb.com>
 <CALCETrVUOToH5WnZMdpk+Vt=NK5OuE=ha62sj7cN5Hw5=qrgRw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CALCETrVUOToH5WnZMdpk+Vt=NK5OuE=ha62sj7cN5Hw5=qrgRw@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Andy Lutomirski <luto@amacapital.net>
Cc: Alexei Starovoitov <ast@fb.com>, Kees Cook <keescook@chromium.org>, Alexei Starovoitov <ast@kernel.org>, Djalal Harouni <tixxdz@gmail.com>, Al Viro <viro@zeniv.linux.org.uk>, "David S. Miller" <davem@davemloft.net>, Daniel Borkmann <daniel@iogearbox.net>, Linus Torvalds <torvalds@linux-foundation.org>, Greg KH <gregkh@linuxfoundation.org>, "Luis R. Rodriguez" <mcgrof@kernel.org>, Network Development <netdev@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, kernel-team@fb.com, Linux API <linux-api@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

On Fri, Mar 09, 2018 at 01:04:39AM +0000, Andy Lutomirski wrote:
> On Fri, Mar 9, 2018 at 12:57 AM, Alexei Starovoitov <ast@fb.com> wrote:
> > On 3/8/18 4:24 PM, Kees Cook wrote:
> >>
> >> As Andy asked earlier, why not DYN too to catch PIE executables? Seems
> >> like forcing the userspace helper to be non-PIE would defeat some of
> >> the userspace defenses in use in most distros.
> >
> >
> > because we don't add features without concrete users.
> 
> I disagree here.  If you're going to add a magic trick that triggers
> an execve(), then I think you should either support *both* standard,
> widely-used types of ELF programs or you should give a compelling use
> case that works for ET_EXEC but not for ET_DYN.  Keep in mind that
> many distros have a very strong preference for ET_DYN.

misunderstanding here is that this bpfiler.ko is part of _kernel build_.
Kernel decides how it's build.
Nothing to do with distros.
Current Makefile is very dumb and it's built with HOSTCC:
https://git.kernel.org/pub/scm/linux/kernel/git/ast/bpf.git/tree/net/bpfilter/Makefile?h=ipt_bpf
but it will be standalone with CC before final to make sure crosscompiling works.

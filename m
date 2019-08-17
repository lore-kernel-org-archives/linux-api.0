From: Alexei Starovoitov <alexei.starovoitov@gmail.com>
Subject: Re: [PATCH v2 bpf-next 1/4] bpf: unprivileged BPF access via /dev/bpf
Date: Sat, 17 Aug 2019 08:36:54 -0700
Message-ID: <20190817153652.zfcsklt474j72dzm@ast-mbp.dhcp.thefacebook.com>
References: <20190806011134.p5baub5l3t5fkmou@ast-mbp>
 <CALCETrXEHL3+NAY6P6vUj7Pvd9ZpZsYC6VCLXOaNxb90a_POGw@mail.gmail.com>
 <20190813215823.3sfbakzzjjykyng2@ast-mbp>
 <201908151203.FE87970@keescook>
 <20190815234622.t65oxm5mtfzy6fhg@ast-mbp.dhcp.thefacebook.com>
 <B0364660-AD6A-4E5C-B04F-3B6DA78B4BBE@amacapital.net>
 <20190816214542.inpt6p655whc2ejw@ast-mbp.dhcp.thefacebook.com>
 <20190816222252.a7zizw7azkxnv3ot@wittgenstein>
 <20190817150843.4vsmzpwpcvzndjld@ast-mbp>
 <61B88085-9FBB-41E6-9783-324E445E428D@ubuntu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <netdev-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <61B88085-9FBB-41E6-9783-324E445E428D@ubuntu.com>
Sender: netdev-owner@vger.kernel.org
To: Christian Brauner <christian.brauner@ubuntu.com>
Cc: Andy Lutomirski <luto@amacapital.net>, Kees Cook <keescook@chromium.org>, Andy Lutomirski <luto@kernel.org>, Song Liu <songliubraving@fb.com>, Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>, Alexei Starovoitov <ast@kernel.org>, Daniel Borkmann <daniel@iogearbox.net>, Kernel Team <Kernel-team@fb.com>, Lorenz Bauer <lmb@cloudflare.com>, Jann Horn <jannh@google.com>, Greg KH <gregkh@linuxfoundation.org>, Linux API <linux-api@vger.kernel.org>, LSM List <linux-security-module@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

On Sat, Aug 17, 2019 at 05:16:53PM +0200, Christian Brauner wrote:
> On August 17, 2019 5:08:45 PM GMT+02:00, Alexei Starovoitov <alexei.starovoitov@gmail.com> wrote:
> >On Sat, Aug 17, 2019 at 12:22:53AM +0200, Christian Brauner wrote:
> >> 
> >> (The one usecase I'd care about is to extend seccomp to do
> >pointer-based
> >> syscall filtering. Whether or not that'd require (unprivileged) ebpf
> >is
> >> up for discussion at KSummit.)
> >
> >Kees have been always against using ebpf in seccomp. I believe he still
> >holds this opinion. Until he changes his mind let's stop bringing
> >seccomp
> >as a use case for unpriv bpf.
> 
> That's why I said "whether or not".
> For the record, I do prefer a non-unpriv-ebpf way.
> It's still something that will most surely come up in the discussion though.

It's very un-kernely way to defer to in-person meetings.
If there is anything to discuss please discuss it on the public mailing list.

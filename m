From: Alexei Starovoitov <alexei.starovoitov@gmail.com>
Subject: Re: [PATCH v2 bpf-next 1/4] bpf: unprivileged BPF access via /dev/bpf
Date: Sat, 17 Aug 2019 08:08:45 -0700
Message-ID: <20190817150843.4vsmzpwpcvzndjld@ast-mbp>
References: <20190805192122.laxcaz75k4vxdspn@ast-mbp>
 <CALCETrVtPs8gY-H4gmzSqPboid3CB++n50SvYd6RU9YVde_-Ow@mail.gmail.com>
 <20190806011134.p5baub5l3t5fkmou@ast-mbp>
 <CALCETrXEHL3+NAY6P6vUj7Pvd9ZpZsYC6VCLXOaNxb90a_POGw@mail.gmail.com>
 <20190813215823.3sfbakzzjjykyng2@ast-mbp>
 <201908151203.FE87970@keescook>
 <20190815234622.t65oxm5mtfzy6fhg@ast-mbp.dhcp.thefacebook.com>
 <B0364660-AD6A-4E5C-B04F-3B6DA78B4BBE@amacapital.net>
 <20190816214542.inpt6p655whc2ejw@ast-mbp.dhcp.thefacebook.com>
 <20190816222252.a7zizw7azkxnv3ot@wittgenstein>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <netdev-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20190816222252.a7zizw7azkxnv3ot@wittgenstein>
Sender: netdev-owner@vger.kernel.org
To: Christian Brauner <christian.brauner@ubuntu.com>
Cc: Andy Lutomirski <luto@amacapital.net>, Kees Cook <keescook@chromium.org>, Andy Lutomirski <luto@kernel.org>, Song Liu <songliubraving@fb.com>, Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>, Alexei Starovoitov <ast@kernel.org>, Daniel Borkmann <daniel@iogearbox.net>, Kernel Team <Kernel-team@fb.com>, Lorenz Bauer <lmb@cloudflare.com>, Jann Horn <jannh@google.com>, Greg KH <gregkh@linuxfoundation.org>, Linux API <linux-api@vger.kernel.org>, LSM List <linux-security-module@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

On Sat, Aug 17, 2019 at 12:22:53AM +0200, Christian Brauner wrote:
> 
> (The one usecase I'd care about is to extend seccomp to do pointer-based
> syscall filtering. Whether or not that'd require (unprivileged) ebpf is
> up for discussion at KSummit.)

Kees have been always against using ebpf in seccomp. I believe he still
holds this opinion. Until he changes his mind let's stop bringing seccomp
as a use case for unpriv bpf.

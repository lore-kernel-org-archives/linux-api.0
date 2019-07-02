From: Kees Cook <keescook@chromium.org>
Subject: Re: [PATCH v2 bpf-next 1/4] bpf: unprivileged BPF access via /dev/bpf
Date: Tue, 2 Jul 2019 11:24:35 -0700
Message-ID: <201907021115.DCD56BBABB@keescook>
References: <20190627201923.2589391-1-songliubraving@fb.com>
 <20190627201923.2589391-2-songliubraving@fb.com>
 <21894f45-70d8-dfca-8c02-044f776c5e05@kernel.org>
 <3C595328-3ABE-4421-9772-8D41094A4F57@fb.com>
 <CALCETrWBnH4Q43POU8cQ7YMjb9LioK28FDEQf7aHZbdf1eBZWg@mail.gmail.com>
 <0DE7F23E-9CD2-4F03-82B5-835506B59056@fb.com>
 <CALCETrWBWbNFJvsTCeUchu3BZJ3SH3dvtXLUB2EhnPrzFfsLNA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <netdev-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CALCETrWBWbNFJvsTCeUchu3BZJ3SH3dvtXLUB2EhnPrzFfsLNA@mail.gmail.com>
Sender: netdev-owner@vger.kernel.org
To: Andy Lutomirski <luto@kernel.org>
Cc: Song Liu <songliubraving@fb.com>, "linux-security@vger.kernel.org" <linux-security@vger.kernel.org>, Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>, Alexei Starovoitov <ast@kernel.org>, Daniel Borkmann <daniel@iogearbox.net>, Kernel Team <Kernel-team@fb.com>, Lorenz Bauer <lmb@cloudflare.com>, Jann Horn <jannh@google.com>, Greg KH <gregkh@linuxfoundation.org>, Linux API <linux-api@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

On Mon, Jul 01, 2019 at 06:59:13PM -0700, Andy Lutomirski wrote:
> I think I'm understanding your motivation.  You're not trying to make
> bpf() generically usable without privilege -- you're trying to create
> a way to allow certain users to access dangerous bpf functionality
> within some limits.
> 
> That's a perfectly fine goal, but I think you're reinventing the
> wheel, and the wheel you're reinventing is quite complicated and
> already exists.  I think you should teach bpftool to be secure when
> installed setuid root or with fscaps enabled and put your policy in
> bpftool.  If you want to harden this a little bit, it would seem
> entirely reasonable to add a new CAP_BPF_ADMIN and change some, but
> not all, of the capable() checks to check CAP_BPF_ADMIN instead of the
> capabilities that they currently check.

If finer grained controls are wanted, it does seem like the /dev/bpf
path makes the most sense. open, request abilities, use fd. The open can
be mediated by DAC and LSM. The request can be mediated by LSM. This
provides a way to add policy at the LSM level and at the tool level.
(i.e. For tool-level controls: leave LSM wide open, make /dev/bpf owned
by "bpfadmin" and bpftool becomes setuid "bpfadmin". For fine-grained
controls, leave /dev/bpf wide open and add policy to SELinux, etc.)

With only a new CAP, you don't get the fine-grained controls. (The
"request abilities" part is the key there.)

-- 
Kees Cook

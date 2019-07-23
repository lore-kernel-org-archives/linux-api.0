From: Lorenz Bauer <lmb@cloudflare.com>
Subject: Re: [PATCH v2 bpf-next 1/4] bpf: unprivileged BPF access via /dev/bpf
Date: Tue, 23 Jul 2019 11:45:45 +0100
Message-ID: <CACAyw9-YdqBYP7_vzDVH_AQ6Ko71XrDb5-+ZxkASMw-eHJa05A@mail.gmail.com>
References: <20190627201923.2589391-1-songliubraving@fb.com>
 <20190627201923.2589391-2-songliubraving@fb.com> <21894f45-70d8-dfca-8c02-044f776c5e05@kernel.org>
 <3C595328-3ABE-4421-9772-8D41094A4F57@fb.com> <CALCETrWBnH4Q43POU8cQ7YMjb9LioK28FDEQf7aHZbdf1eBZWg@mail.gmail.com>
 <0DE7F23E-9CD2-4F03-82B5-835506B59056@fb.com> <CALCETrWBWbNFJvsTCeUchu3BZJ3SH3dvtXLUB2EhnPrzFfsLNA@mail.gmail.com>
 <201907021115.DCD56BBABB@keescook> <CALCETrXTta26CTtEDnzvtd03-WOGdXcnsAogP8JjLkcj4-mHvg@mail.gmail.com>
 <4A7A225A-6C23-4C0F-9A95-7C6C56B281ED@fb.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <4A7A225A-6C23-4C0F-9A95-7C6C56B281ED@fb.com>
Sender: netdev-owner@vger.kernel.org
To: Song Liu <songliubraving@fb.com>
Cc: Andy Lutomirski <luto@kernel.org>, Kees Cook <keescook@chromium.org>, "linux-security@vger.kernel.org" <linux-security@vger.kernel.org>, Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>, Alexei Starovoitov <ast@kernel.org>, Daniel Borkmann <daniel@iogearbox.net>, Kernel Team <Kernel-team@fb.com>, Jann Horn <jannh@google.com>, Greg KH <gregkh@linuxfoundation.org>, Linux API <linux-api@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

On Mon, 22 Jul 2019 at 21:54, Song Liu <songliubraving@fb.com> wrote:
>
> Hi Andy, Lorenz, and all,
>
> With 5.3-rc1 out, I am back on this. :)
>
> How about we modify the set as:
>   1. Introduce sys_bpf_with_cap() that takes fd of /dev/bpf.
>   2. Better handling of capable() calls through bpf code. I guess the
>      biggest problem here is is_priv in verifier.c:bpf_check().
>
> With this approach, we will be able to pass the fd around, so it should
> also solve problem for Go.

Thanks for picking this up again. I need to figure out what the API
for this would
look like on the Go side, but I think it's a nice solution!

Lorenz

-- 
Lorenz Bauer  |  Systems Engineer
6th Floor, County Hall/The Riverside Building, SE1 7PB, UK

www.cloudflare.com

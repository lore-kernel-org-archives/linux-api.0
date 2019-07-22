From: Song Liu <songliubraving@fb.com>
Subject: Re: [PATCH v2 bpf-next 1/4] bpf: unprivileged BPF access via /dev/bpf
Date: Mon, 22 Jul 2019 20:53:48 +0000
Message-ID: <4A7A225A-6C23-4C0F-9A95-7C6C56B281ED@fb.com>
References: <20190627201923.2589391-1-songliubraving@fb.com>
 <20190627201923.2589391-2-songliubraving@fb.com>
 <21894f45-70d8-dfca-8c02-044f776c5e05@kernel.org>
 <3C595328-3ABE-4421-9772-8D41094A4F57@fb.com>
 <CALCETrWBnH4Q43POU8cQ7YMjb9LioK28FDEQf7aHZbdf1eBZWg@mail.gmail.com>
 <0DE7F23E-9CD2-4F03-82B5-835506B59056@fb.com>
 <CALCETrWBWbNFJvsTCeUchu3BZJ3SH3dvtXLUB2EhnPrzFfsLNA@mail.gmail.com>
 <201907021115.DCD56BBABB@keescook>
 <CALCETrXTta26CTtEDnzvtd03-WOGdXcnsAogP8JjLkcj4-mHvg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <CALCETrXTta26CTtEDnzvtd03-WOGdXcnsAogP8JjLkcj4-mHvg@mail.gmail.com>
Content-Language: en-US
Content-ID: <4934353FD63ADE4698F42238323400FC@namprd15.prod.outlook.com>
Sender: netdev-owner@vger.kernel.org
To: Andy Lutomirski <luto@kernel.org>
Cc: Kees Cook <keescook@chromium.org>, "linux-security@vger.kernel.org" <linux-security@vger.kernel.org>, Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>, Alexei Starovoitov <ast@kernel.org>, Daniel Borkmann <daniel@iogearbox.net>, Kernel Team <Kernel-team@fb.com>, Lorenz Bauer <lmb@cloudflare.com>, Jann Horn <jannh@google.com>, Greg KH <gregkh@linuxfoundation.org>, Linux API <linux-api@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

Hi Andy, Lorenz, and all,=20

> On Jul 2, 2019, at 2:32 PM, Andy Lutomirski <luto@kernel.org> wrote:
>=20
> On Tue, Jul 2, 2019 at 2:04 PM Kees Cook <keescook@chromium.org> wrote:
>>=20
>> On Mon, Jul 01, 2019 at 06:59:13PM -0700, Andy Lutomirski wrote:
>>> I think I'm understanding your motivation.  You're not trying to make
>>> bpf() generically usable without privilege -- you're trying to create
>>> a way to allow certain users to access dangerous bpf functionality
>>> within some limits.
>>>=20
>>> That's a perfectly fine goal, but I think you're reinventing the
>>> wheel, and the wheel you're reinventing is quite complicated and
>>> already exists.  I think you should teach bpftool to be secure when
>>> installed setuid root or with fscaps enabled and put your policy in
>>> bpftool.  If you want to harden this a little bit, it would seem
>>> entirely reasonable to add a new CAP_BPF_ADMIN and change some, but
>>> not all, of the capable() checks to check CAP_BPF_ADMIN instead of the
>>> capabilities that they currently check.
>>=20
>> If finer grained controls are wanted, it does seem like the /dev/bpf
>> path makes the most sense. open, request abilities, use fd. The open can
>> be mediated by DAC and LSM. The request can be mediated by LSM. This
>> provides a way to add policy at the LSM level and at the tool level.
>> (i.e. For tool-level controls: leave LSM wide open, make /dev/bpf owned
>> by "bpfadmin" and bpftool becomes setuid "bpfadmin". For fine-grained
>> controls, leave /dev/bpf wide open and add policy to SELinux, etc.)
>>=20
>> With only a new CAP, you don't get the fine-grained controls. (The
>> "request abilities" part is the key there.)
>=20
> Sure you do: the effective set.  It has somewhat bizarre defaults, but
> I don't think that's a real problem.  Also, this wouldn't be like
> CAP_DAC_READ_SEARCH -- you can't accidentally use your BPF caps.
>=20
> I think that a /dev capability-like object isn't totally nuts, but I
> think we should do it well, and this patch doesn't really achieve
> that.  But I don't think bpf wants fine-grained controls like this at
> all -- as I pointed upthread, a fine-grained solution really wants
> different treatment for the different capable() checks, and a bunch of
> them won't resemble capabilities or /dev/bpf at all.

With 5.3-rc1 out, I am back on this. :)

How about we modify the set as:
  1. Introduce sys_bpf_with_cap() that takes fd of /dev/bpf.=20
  2. Better handling of capable() calls through bpf code. I guess the
     biggest problem here is is_priv in verifier.c:bpf_check().=20

With this approach, we will be able to pass the fd around, so it should=20
also solve problem for Go.=20

Please let me know your comments/suggestions on this direction.=20

Thanks,
Song

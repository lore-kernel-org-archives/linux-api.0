From: Song Liu <songliubraving@fb.com>
Subject: Re: [PATCH v2 bpf-next 1/3] capability: introduce CAP_BPF and
 CAP_TRACING
Date: Thu, 29 Aug 2019 06:00:01 +0000
Message-ID: <5B8A0EFA-661B-4223-A59C-E16053BBAB81@fb.com>
References: <20190829051253.1927291-1-ast@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20190829051253.1927291-1-ast@kernel.org>
Content-Language: en-US
Content-ID: <AB2ABC2C42A04D4D818BE91564DF3278@namprd15.prod.outlook.com>
Sender: netdev-owner@vger.kernel.org
To: Alexei Starovoitov <ast@kernel.org>
Cc: Andy Lutomirski <luto@amacapital.net>, "davem@davemloft.net" <davem@davemloft.net>, "peterz@infradead.org" <peterz@infradead.org>, "rostedt@goodmis.org" <rostedt@goodmis.org>, "netdev@vger.kernel.org" <netdev@vger.kernel.org>, "bpf@vger.kernel.org" <bpf@vger.kernel.org>, Kernel Team <Kernel-team@fb.com>, "linux-api@vger.kernel.org" <linux-api@vger.kernel.org>
List-Id: linux-api@vger.kernel.org


> On Aug 28, 2019, at 10:12 PM, Alexei Starovoitov <ast@kernel.org> wrote:
>=20

[...]

> - Creation of [ku][ret]probe
> - Accessing arbitrary kernel memory via kprobe + probe_kernel_read
> - Attach tracing bpf programs to perf events
> - Access to kallsyms
>=20
> Signed-off-by: Alexei Starovoitov <ast@kernel.org>

Acked-by: Song Liu <songliubraving@fb.com>

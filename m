From: Song Liu <songliubraving@fb.com>
Subject: Re: [PATCH v2 bpf-next 3/3] perf: implement CAP_TRACING
Date: Thu, 29 Aug 2019 06:06:21 +0000
Message-ID: <BF2CED89-D33C-4363-85BB-F4EAD4A5DBDD@fb.com>
References: <20190829051253.1927291-1-ast@kernel.org>
 <20190829051253.1927291-3-ast@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20190829051253.1927291-3-ast@kernel.org>
Content-Language: en-US
Content-ID: <A7AAF2CEACC5C34BA909C5E7248576E5@namprd15.prod.outlook.com>
Sender: netdev-owner@vger.kernel.org
To: Alexei Starovoitov <ast@kernel.org>
Cc: Andy Lutomirski <luto@amacapital.net>, "David S . Miller" <davem@davemloft.net>, "peterz@infradead.org" <peterz@infradead.org>, "rostedt@goodmis.org" <rostedt@goodmis.org>, "netdev@vger.kernel.org" <netdev@vger.kernel.org>, "bpf@vger.kernel.org" <bpf@vger.kernel.org>, Kernel Team <Kernel-team@fb.com>, "linux-api@vger.kernel.org" <linux-api@vger.kernel.org>
List-Id: linux-api@vger.kernel.org



> On Aug 28, 2019, at 10:12 PM, Alexei Starovoitov <ast@kernel.org> wrote:
>=20
> Implement permissions as stated in uapi/linux/capability.h
>=20
> Similar to CAP_BPF it's highly unlikely that s/CAP_SYS_ADMIN/CAP_TRACING/
> replacement will cause user breakage.
>=20
> Signed-off-by: Alexei Starovoitov <ast@kernel.org>

Acked-by: Song Liu <songliubraving@fb.com>

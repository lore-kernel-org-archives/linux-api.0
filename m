From: Song Liu <songliubraving@fb.com>
Subject: Re: [PATCH v3 0/4] bpf: allow zero-initialising hash map seed
Date: Fri, 16 Nov 2018 17:33:15 +0000
Message-ID: <F7F625D2-5417-468E-BF34-83B64853F501@fb.com>
References: <20181001104509.24211-1-lmb@cloudflare.com>
 <20181116114111.31177-1-lmb@cloudflare.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20181116114111.31177-1-lmb@cloudflare.com>
Content-Language: en-US
Content-ID: <4242E1CD9BB64F42A51C12017BE2232E@namprd15.prod.outlook.com>
Sender: netdev-owner@vger.kernel.org
To: Lorenz Bauer <lmb@cloudflare.com>
Cc: Alexei Starovoitov <ast@kernel.org>, Daniel Borkmann <daniel@iogearbox.net>, "netdev@vger.kernel.org" <netdev@vger.kernel.org>, "linux-api@vger.kernel.org" <linux-api@vger.kernel.org>
List-Id: linux-api@vger.kernel.org



> On Nov 16, 2018, at 3:41 AM, Lorenz Bauer <lmb@cloudflare.com> wrote:
>=20
> Allow forcing the seed of a hash table to zero, for deterministic
> execution during benchmarking and testing.
>=20
> Changes from v2:
> * Change ordering of BPF_F_ZERO_SEED in linux/bpf.h
>=20
> Comments adressed from v1:
> * Add comment to discourage production use to linux/bpf.h
> * Require CAP_SYS_ADMIN
>=20
> Lorenz Bauer (4):
>  bpf: allow zero-initializing hash map seed
>  bpf: move BPF_F_QUERY_EFFECTIVE after map flags
>  tools: sync linux/bpf.h
>  tools: add selftest for BPF_F_ZERO_SEED
>=20
> include/uapi/linux/bpf.h                |  9 ++--
> kernel/bpf/hashtab.c                    | 13 ++++-
> tools/include/uapi/linux/bpf.h          | 13 +++--
> tools/testing/selftests/bpf/test_maps.c | 68 +++++++++++++++++++++----
> 4 files changed, 84 insertions(+), 19 deletions(-)
>=20
> --=20
> 2.17.1
>=20

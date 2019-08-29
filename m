From: Song Liu <songliubraving@fb.com>
Subject: Re: [PATCH v2 bpf-next 2/3] bpf: implement CAP_BPF
Date: Thu, 29 Aug 2019 06:04:42 +0000
Message-ID: <B28631A9-BB92-404A-BD58-7A737BCF10C9@fb.com>
References: <20190829051253.1927291-1-ast@kernel.org>
 <20190829051253.1927291-2-ast@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20190829051253.1927291-2-ast@kernel.org>
Content-Language: en-US
Content-ID: <71D458617FE4954DA46A61851BAB0604@namprd15.prod.outlook.com>
Sender: netdev-owner@vger.kernel.org
To: Alexei Starovoitov <ast@kernel.org>
Cc: Andy Lutomirski <luto@amacapital.net>, "davem@davemloft.net" <davem@davemloft.net>, "peterz@infradead.org" <peterz@infradead.org>, "rostedt@goodmis.org" <rostedt@goodmis.org>, "netdev@vger.kernel.org" <netdev@vger.kernel.org>, "bpf@vger.kernel.org" <bpf@vger.kernel.org>, Kernel Team <Kernel-team@fb.com>, "linux-api@vger.kernel.org" <linux-api@vger.kernel.org>
List-Id: linux-api@vger.kernel.org



> On Aug 28, 2019, at 10:12 PM, Alexei Starovoitov <ast@kernel.org> wrote:
>=20

[...]

> diff --git a/tools/testing/selftests/bpf/test_verifier.c b/tools/testing/=
selftests/bpf/test_verifier.c
> index 44e2d640b088..91a7f25512ca 100644
> --- a/tools/testing/selftests/bpf/test_verifier.c
> +++ b/tools/testing/selftests/bpf/test_verifier.c
> @@ -805,10 +805,20 @@ static void do_test_fixup(struct bpf_test *test, en=
um bpf_prog_type prog_type,
> 	}
> }
>=20
> +struct libcap {
> +	struct __user_cap_header_struct hdr;
> +	struct __user_cap_data_struct data[2];
> +};
> +

I am confused by struct libcap. Why do we need it?=20

> static int set_admin(bool admin)
> {
> 	cap_t caps;
> -	const cap_value_t cap_val =3D CAP_SYS_ADMIN;
> +	/* need CAP_BPF to load progs and CAP_NET_ADMIN to run networking progs=
,
> +	 * and CAP_TRACING to create stackmap
> +	 */
> +	const cap_value_t cap_net_admin =3D CAP_NET_ADMIN;
> +	const cap_value_t cap_sys_admin =3D CAP_SYS_ADMIN;
> +	struct libcap *cap;
> 	int ret =3D -1;
>=20
> 	caps =3D cap_get_proc();
> @@ -816,11 +826,26 @@ static int set_admin(bool admin)
> 		perror("cap_get_proc");
> 		return -1;
> 	}
> -	if (cap_set_flag(caps, CAP_EFFECTIVE, 1, &cap_val,
> +	cap =3D (struct libcap *)caps;
> +	if (cap_set_flag(caps, CAP_EFFECTIVE, 1, &cap_sys_admin, CAP_CLEAR)) {
> +		perror("cap_set_flag clear admin");
> +		goto out;
> +	}
> +	if (cap_set_flag(caps, CAP_EFFECTIVE, 1, &cap_net_admin,
> 				admin ? CAP_SET : CAP_CLEAR)) {
> -		perror("cap_set_flag");
> +		perror("cap_set_flag set_or_clear net");
> 		goto out;
> 	}
> +	/* libcap is likely old and simply ignores CAP_BPF and CAP_TRACING,
> +	 * so update effective bits manually
> +	 */
> +	if (admin) {
> +		cap->data[1].effective |=3D 1 << (38 /* CAP_BPF */ - 32);
> +		cap->data[1].effective |=3D 1 << (39 /* CAP_TRACING */ - 32);
> +	} else {
> +		cap->data[1].effective &=3D ~(1 << (38 - 32));
> +		cap->data[1].effective &=3D ~(1 << (39 - 32));
> +	}

And why we do not need cap->data[0]?

Thanks,
Song

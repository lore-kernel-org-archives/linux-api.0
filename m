From: Andy Lutomirski <luto@amacapital.net>
Subject: Re: [PATCH V33 24/30] bpf: Restrict bpf when kernel lockdown is in confidentiality mode
Date: Wed, 26 Jun 2019 17:57:12 -0700
Message-ID: <6E53376F-01BB-4795-BC02-24F9CAE00001@amacapital.net>
References: <20190621011941.186255-1-matthewgarrett@google.com> <20190621011941.186255-25-matthewgarrett@google.com> <CALCETrVUwQP7roLnW6kFG80Cc5U6X_T6AW+BTAftLccYGp8+Ow@mail.gmail.com> <alpine.LRH.2.21.1906270621080.28132@namei.org>
Mime-Version: 1.0 (1.0)
Content-Type: text/plain;
        charset=utf-8
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <alpine.LRH.2.21.1906270621080.28132@namei.org>
Sender: linux-kernel-owner@vger.kernel.org
To: James Morris <jmorris@namei.org>
Cc: Andy Lutomirski <luto@kernel.org>, Matthew Garrett <matthewgarrett@google.com>, linux-security@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>, Linux API <linux-api@vger.kernel.org>, David Howells <dhowells@redhat.com>, Alexei Starovoitov <alexei.starovoitov@gmail.com>, Matthew Garrett <mjg59@google.com>, Network Development <netdev@vger.kernel.org>, Chun-Yi Lee <jlee@suse.com>, Daniel Borkmann <daniel@iogearbox.net>, linux-security-module@vger.kernel.org
List-Id: linux-api@vger.kernel.org



> On Jun 26, 2019, at 1:22 PM, James Morris <jmorris@namei.org> wrote:
>=20
> [Adding the LSM mailing list: missed this patchset initially]
>=20
>> On Thu, 20 Jun 2019, Andy Lutomirski wrote:
>>=20
>> This patch exemplifies why I don't like this approach:
>>=20
>>> @@ -97,6 +97,7 @@ enum lockdown_reason {
>>>        LOCKDOWN_INTEGRITY_MAX,
>>>        LOCKDOWN_KCORE,
>>>        LOCKDOWN_KPROBES,
>>> +       LOCKDOWN_BPF,
>>>        LOCKDOWN_CONFIDENTIALITY_MAX,
>>=20
>>> --- a/security/lockdown/lockdown.c
>>> +++ b/security/lockdown/lockdown.c
>>> @@ -33,6 +33,7 @@ static char *lockdown_reasons[LOCKDOWN_CONFIDENTIALITY=
_MAX+1] =3D {
>>>        [LOCKDOWN_INTEGRITY_MAX] =3D "integrity",
>>>        [LOCKDOWN_KCORE] =3D "/proc/kcore access",
>>>        [LOCKDOWN_KPROBES] =3D "use of kprobes",
>>> +       [LOCKDOWN_BPF] =3D "use of bpf",
>>>        [LOCKDOWN_CONFIDENTIALITY_MAX] =3D "confidentiality",
>>=20
>> The text here says "use of bpf", but what this patch is *really* doing
>> is locking down use of BPF to read kernel memory.  If the details
>> change, then every LSM needs to get updated, and we risk breaking user
>> policies that are based on LSMs that offer excessively fine
>> granularity.
>=20
> Can you give an example of how the details might change?
>=20
>> I'd be more comfortable if the LSM only got to see "confidentiality"
>> or "integrity".
>=20
> These are not sufficient for creating a useful policy for the SELinux=20
> case.
>=20
>=20

I may have misunderstood, but I thought that SELinux mainly needed to allow c=
ertain privileged programs to bypass the policy.  Is there a real example of=
 what SELinux wants to do that can=E2=80=99t be done in the simplified model=
?

The think that specifically makes me uneasy about exposing all of these prec=
ise actions to LSMs is that they will get exposed to userspace in a way that=
 forces us to treat them as stable ABIs.=

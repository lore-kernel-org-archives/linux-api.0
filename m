From: Andy Lutomirski <luto@amacapital.net>
Subject: Re: [PATCH V32 01/27] Add the ability to lock down access to the running kernel image
Date: Thu, 2 May 2019 17:34:51 -0700
Message-ID: <343EE650-4077-4882-94D6-28BBDBA32182@amacapital.net>
References: <20190404003249.14356-1-matthewgarrett@google.com> <20190404003249.14356-2-matthewgarrett@google.com> <CACdnJus-+VTy0uOWg982SgZr55Lp7Xot653dJb_tO5T=J6D8nw@mail.gmail.com> <alpine.LRH.2.21.1905030653480.32502@namei.org> <CACdnJuusGU2DMXaPAjH3+QOcSj-9q6njbxxG-9s2PweDKognvw@mail.gmail.com> <alpine.LRH.2.21.1905030901180.7491@namei.org>
Mime-Version: 1.0 (1.0)
Content-Type: text/plain;
        charset=utf-8
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <alpine.LRH.2.21.1905030901180.7491@namei.org>
Sender: linux-kernel-owner@vger.kernel.org
To: James Morris <jmorris@namei.org>
Cc: Matthew Garrett <mjg59@google.com>, LSM List <linux-security-module@vger.kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, David Howells <dhowells@redhat.com>, Linux API <linux-api@vger.kernel.org>, Andy Lutomirski <luto@kernel.org>
List-Id: linux-api@vger.kernel.org


> On May 2, 2019, at 4:19 PM, James Morris <jmorris@namei.org> wrote:
>=20
>> On Thu, 2 May 2019, Matthew Garrett wrote:
>>=20
>>> On Thu, May 2, 2019 at 2:07 PM James Morris <jmorris@namei.org> wrote:
>>> One possible direction is to (as previously mentioned) assign IDs to eac=
h
>>> callsite and be able to check this ID against a simple policy array
>>> (allow/deny).  The default policy choices could be reduced to 'all' or
>>> 'none' during kconfig, and allow a custom policy to be loaded later if
>>> desired.
>>=20
>> Ok. My primary concern around this is that it's very difficult to use
>> correctly in anything other than the "all" or "none" modes. If a new
>> kernel feature is added with integrated lockdown support, if an admin
>> is simply setting the flags of things they wish to block then this
>> will be left enabled - and may violate the admin's expectations around
>> integrity. On the other hand, if an admin is simply setting the flags
>> of things they wish to permit, then adding lockdown support to an
>> existing kernel feature may result in that feature suddenly being
>> disabled, which may also violate the admin's expectations around the
>> flags providing a stable set of behaviour.
>=20
> Understood. Most uses will likely be either a distro or an embedded=20
> system, who I'm assuming would provide a useful policy by default, and=20
> perhaps a high-level abstraction for modification.
>=20
>> Given that, would you prefer such a policy expression to look like?
>=20
> Perhaps a write-once policy, injected from userspace during early boot?
>=20
> The policy could be simply a list of:
>=20
> lockdown_feature true|false
>=20

I=E2=80=99m not convinced this is worthwhile.  As I see it, there really are=
 only two privileges here: root can read kernel memory, and root can corrupt=
 kernel state.  A policy that root can=E2=80=99t corrupt kernel memory excep=
t using, say, eBPF is useless =E2=80=94 it gives warm fuzzy feelings but not=
hing else.

From: Andy Lutomirski <luto@amacapital.net>
Subject: Re: [PATCH] seccomp: Add pkru into seccomp_data
Date: Thu, 25 Oct 2018 17:49:20 -0700
Message-ID: <7DC76493-28C9-4CAA-9262-E809F52459DB@amacapital.net>
References: <20181024153523.10974-1-msammler@mpi-sws.org>
 <87zhv3nrr0.fsf@oldenburg.str.redhat.com>
 <11a706bd-060f-41de-118b-bababfd83b3d@mpi-sws.org>
 <875zxqo0ee.fsf@oldenburg.str.redhat.com>
 <c4d3f5c1-a2dc-5b44-4d12-1fae829a372c@mpi-sws.org>
 <CALCETrX_E5_p1-MjCcdtRQbziCCzXcOCfxRBckZx_zbO1QX=Dw@mail.gmail.com>
 <CAGXu5jLE2VBqo_rkBJ+BJkp1==WLLg=N=-3gjTCCjcN1=bodSg@mail.gmail.com>
Mime-Version: 1.0 (1.0)
Content-Type: text/plain;
	charset=utf-8
Content-Transfer-Encoding: quoted-printable
Return-path: <linuxppc-dev-bounces+glppe-linuxppc-embedded-2=m.gmane.org@lists.ozlabs.org>
In-Reply-To: <CAGXu5jLE2VBqo_rkBJ+BJkp1==WLLg=N=-3gjTCCjcN1=bodSg@mail.gmail.com>
List-Unsubscribe: <https://lists.ozlabs.org/options/linuxppc-dev>,
 <mailto:linuxppc-dev-request@lists.ozlabs.org?subject=unsubscribe>
List-Archive: <http://lists.ozlabs.org/pipermail/linuxppc-dev/>
List-Post: <mailto:linuxppc-dev@lists.ozlabs.org>
List-Help: <mailto:linuxppc-dev-request@lists.ozlabs.org?subject=help>
List-Subscribe: <https://lists.ozlabs.org/listinfo/linuxppc-dev>,
 <mailto:linuxppc-dev-request@lists.ozlabs.org?subject=subscribe>
Errors-To: linuxppc-dev-bounces+glppe-linuxppc-embedded-2=m.gmane.org@lists.ozlabs.org
Sender: "Linuxppc-dev"
 <linuxppc-dev-bounces+glppe-linuxppc-embedded-2=m.gmane.org@lists.ozlabs.org>
To: Kees Cook <keescook@chromium.org>
Cc: Florian Weimer <fweimer@redhat.com>, Will Drewry <wad@chromium.org>, Linux API <linux-api@vger.kernel.org>, linuxram@us.ibm.com, Michael Sammler <msammler@mpi-sws.org>, linuxppc-dev <linuxppc-dev@lists.ozlabs.org>
List-Id: linux-api@vger.kernel.org



> On Oct 25, 2018, at 5:35 PM, Kees Cook <keescook@chromium.org> wrote:
>=20
>> On Fri, Oct 26, 2018 at 12:00 AM, Andy Lutomirski <luto@amacapital.net> w=
rote:
>> You could bite the bullet and add seccomp eBPF support :)
>=20
> I'm not convinced this is a good enough reason for gaining the eBPF
> attack surface yet.
>=20
>=20

Is it an interesting attack surface?  It=E2=80=99s certainly scarier if you=E2=
=80=99re worried about attacks from the sandbox creator, but the security in=
side the sandbox should be more or less equivalent, no?=

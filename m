From: Kees Cook <keescook@chromium.org>
Subject: Re: [PATCH] seccomp: Add pkru into seccomp_data
Date: Mon, 29 Oct 2018 15:01:14 -0700
Message-ID: <CAGXu5jLrLwRG79-8HF-L7eCk+xEZADQfCqbdfRgsnaLVkttPZA@mail.gmail.com>
References: <20181024153523.10974-1-msammler@mpi-sws.org>
 <87zhv3nrr0.fsf@oldenburg.str.redhat.com>
 <11a706bd-060f-41de-118b-bababfd83b3d@mpi-sws.org>
 <875zxqo0ee.fsf@oldenburg.str.redhat.com>
 <c4d3f5c1-a2dc-5b44-4d12-1fae829a372c@mpi-sws.org>
 <CALCETrX_E5_p1-MjCcdtRQbziCCzXcOCfxRBckZx_zbO1QX=Dw@mail.gmail.com>
 <CAGXu5jLE2VBqo_rkBJ+BJkp1==WLLg=N=-3gjTCCjcN1=bodSg@mail.gmail.com>
 <7DC76493-28C9-4CAA-9262-E809F52459DB@amacapital.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Return-path: <linuxppc-dev-bounces+glppe-linuxppc-embedded-2=m.gmane.org@lists.ozlabs.org>
In-Reply-To: <7DC76493-28C9-4CAA-9262-E809F52459DB@amacapital.net>
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
To: Andy Lutomirski <luto@amacapital.net>
Cc: Florian Weimer <fweimer@redhat.com>, Will Drewry <wad@chromium.org>, Linux API <linux-api@vger.kernel.org>, Ram Pai <linuxram@us.ibm.com>, Michael Sammler <msammler@mpi-sws.org>, linuxppc-dev <linuxppc-dev@lists.ozlabs.org>
List-Id: linux-api@vger.kernel.org

On Thu, Oct 25, 2018 at 5:49 PM, Andy Lutomirski <luto@amacapital.net> wrot=
e:
>> On Oct 25, 2018, at 5:35 PM, Kees Cook <keescook@chromium.org> wrote:
>>
>>> On Fri, Oct 26, 2018 at 12:00 AM, Andy Lutomirski <luto@amacapital.net>=
 wrote:
>>> You could bite the bullet and add seccomp eBPF support :)
>>
>> I'm not convinced this is a good enough reason for gaining the eBPF
>> attack surface yet.
>
> Is it an interesting attack surface?  It=E2=80=99s certainly scarier if y=
ou=E2=80=99re worried about attacks from the sandbox creator, but the secur=
ity inside the sandbox should be more or less equivalent, no?

Yeah, I'm more worried about the creator: I don't want kernel exploits
via seccomp APIs. :P There have been kind of a long list of
eBPF-related flaws, so I'd really rather not tie seccomp to it. As for
sandbox escapes, I don't think there's too much concern, but I do
worry about "unexpected" situations exposed by eBPF (i.e. maps or
functions not doing what was expected, or allowing map manipulation
from outside). seccomp cBPF is pretty self-contained right now, so I'd
like a strong reason to justify the increase in code complexity and
related attack surface.

--=20
Kees Cook

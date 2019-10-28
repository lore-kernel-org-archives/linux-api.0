From: Andy Lutomirski <luto@amacapital.net>
Subject: Re: [PATCH RFC] mm: add MAP_EXCLUSIVE to create exclusive user mappings
Date: Mon, 28 Oct 2019 14:44:23 -0600
Message-ID: <CA5C22D9-BC3E-4B69-8DD9-4D3B75E40BD5@amacapital.net>
References: <1572171452-7958-1-git-send-email-rppt@kernel.org>
Mime-Version: 1.0 (1.0)
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1572171452-7958-1-git-send-email-rppt@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Mike Rapoport <rppt@kernel.org>
Cc: linux-kernel@vger.kernel.org, Alexey Dobriyan <adobriyan@gmail.com>, Andrew Morton <akpm@linux-foundation.org>, Andy Lutomirski <luto@kernel.org>, Arnd Bergmann <arnd@arndb.de>, Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>, James Bottomley <jejb@linux.ibm.com>, Peter Zijlstra <peterz@infradead.org>, Steven Rostedt <rostedt@goodmis.org>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>, linux-api@vger.kernel.org, linux-mm@kvack.org, x86@kernel.org, Mike Rapoport <rppt@linux.ibm.com>
List-Id: linux-api@vger.kernel.org


> On Oct 27, 2019, at 4:17 AM, Mike Rapoport <rppt@kernel.org> wrote:
>=20
> =EF=BB=BFFrom: Mike Rapoport <rppt@linux.ibm.com>
>=20
> Hi,
>=20
> The patch below aims to allow applications to create mappins that have
> pages visible only to the owning process. Such mappings could be used to
> store secrets so that these secrets are not visible neither to other
> processes nor to the kernel.
>=20
> I've only tested the basic functionality, the changes should be verified
> against THP/migration/compaction. Yet, I'd appreciate early feedback.

I=E2=80=99ve contemplated the concept a fair amount, and I think you should c=
onsider a change to the API. In particular, rather than having it be a MAP_ f=
lag, make it a chardev.  You can, at least at first, allow only MAP_SHARED, a=
nd admins can decide who gets to use it.  It might also play better with the=
 VM overall, and you won=E2=80=99t need a VM_ flag for it =E2=80=94 you can j=
ust wire up .fault to do the right thing.

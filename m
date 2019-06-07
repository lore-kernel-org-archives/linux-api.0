From: Andy Lutomirski <luto@amacapital.net>
Subject: Re: [PATCH v7 03/14] x86/cet/ibt: Add IBT legacy code bitmap setup function
Date: Fri, 7 Jun 2019 13:43:15 -0700
Message-ID: <25281DB3-FCE4-40C2-BADB-B3B05C5F8DD3@amacapital.net>
References: <20190606200926.4029-1-yu-cheng.yu@intel.com> <20190606200926.4029-4-yu-cheng.yu@intel.com> <20190607080832.GT3419@hirez.programming.kicks-ass.net> <aa8a92ef231d512b5c9855ef416db050b5ab59a6.camel@intel.com> <20190607174336.GM3436@hirez.programming.kicks-ass.net> <b3de4110-5366-fdc7-a960-71dea543a42f@intel.com> <34E0D316-552A-401C-ABAA-5584B5BC98C5@amacapital.net> <7e0b97bf1fbe6ff20653a8e4e147c6285cc5552d.camel@intel.com>
Mime-Version: 1.0 (1.0)
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <7e0b97bf1fbe6ff20653a8e4e147c6285cc5552d.camel@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Yu-cheng Yu <yu-cheng.yu@intel.com>
Cc: Dave Hansen <dave.hansen@intel.com>, Peter Zijlstra <peterz@infradead.org>, x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, linux-mm@kvack.org, linux-arch@vger.kernel.org, linux-api@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>, Balbir Singh <bsingharora@gmail.com>, Borislav Petkov <bp@alien8.de>, Cyrill Gorcunov <gorcunov@gmail.com>, Dave Hansen <dave.hansen@linux.intel.com>, Eugene Syromiatnikov <esyr@redhat.com>, Florian Weimer <fweimer@redhat.com>, "H.J. Lu" <hjl.tools@gmail.com>, Jann Horn <jannh@google.com>, Jonathan Corbet <corbet@lwn.net>, Kees Cook <keescook@chromium.org>, Mike Kravetz <mike.kravetz@oracle.com>
List-Id: linux-api@vger.kernel.org



> On Jun 7, 2019, at 12:49 PM, Yu-cheng Yu <yu-cheng.yu@intel.com> wrote:
>=20
> On Fri, 2019-06-07 at 11:29 -0700, Andy Lutomirski wrote:
>>> On Jun 7, 2019, at 10:59 AM, Dave Hansen <dave.hansen@intel.com> wrote:
>>>=20
>>>> On 6/7/19 10:43 AM, Peter Zijlstra wrote:
>>>> I've no idea what the kernel should do; since you failed to answer the
>>>> question what happens when you point this to garbage.
>>>>=20
>>>> Does it then fault or what?
>>>=20
>>> Yeah, I think you'll fault with a rather mysterious CR2 value since
>>> you'll go look at the instruction that faulted and not see any
>>> references to the CR2 value.
>>>=20
>>> I think this new MSR probably needs to get included in oops output when
>>> CET is enabled.
>>=20
>> This shouldn=E2=80=99t be able to OOPS because it only happens at CPL 3, r=
ight?  We
>> should put it into core dumps, though.
>>=20
>>>=20
>>> Why don't we require that a VMA be in place for the entire bitmap?
>>> Don't we need a "get" prctl function too in case something like a JIT is=

>>> running and needs to find the location of this bitmap to set bits itself=
?
>>>=20
>>> Or, do we just go whole-hog and have the kernel manage the bitmap
>>> itself. Our interface here could be:
>>>=20
>>>   prctl(PR_MARK_CODE_AS_LEGACY, start, size);
>>>=20
>>> and then have the kernel allocate and set the bitmap for those code
>>> locations.
>>=20
>> Given that the format depends on the VA size, this might be a good idea. =
 I
>> bet we can reuse the special mapping infrastructure for this =E2=80=94 th=
e VMA could
>> be a MAP_PRIVATE special mapping named [cet_legacy_bitmap] or similar, an=
d we
>> can even make special rules to core dump it intelligently if needed.  And=
 we
>> can make mremap() on it work correctly if anyone (CRIU?) cares.
>>=20
>> Hmm.  Can we be creative and skip populating it with zeros?  The CPU shou=
ld
>> only ever touch a page if we miss an ENDBR on it, so, in normal operation=
, we
>> don=E2=80=99t need anything to be there.  We could try to prevent anyone f=
rom
>> *reading* it outside of ENDBR tracking if we want to avoid people acciden=
tally
>> wasting lots of memory by forcing it to be fully populated when the read i=
t.
>>=20
>> The one downside is this forces it to be per-mm, but that seems like a
>> generally reasonable model anyway.
>>=20
>> This also gives us an excellent opportunity to make it read-only as seen f=
rom
>> userspace to prevent exploits from just poking it full of ones before
>> redirecting execution.
>=20
> GLIBC sets bits only for legacy code, and then makes the bitmap read-only.=
  That
> avoids most issues:

How does glibc know the linear address space size?  We don=E2=80=99t want LA=
64 to break old binaries because the address calculation changed.

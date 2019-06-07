From: Andy Lutomirski <luto@amacapital.net>
Subject: Re: [PATCH v7 03/14] x86/cet/ibt: Add IBT legacy code bitmap setup function
Date: Fri, 7 Jun 2019 15:27:16 -0700
Message-ID: <4F7D0C3C-F239-4B67-BB05-31350F809293@amacapital.net>
References: <20190606200926.4029-1-yu-cheng.yu@intel.com> <20190606200926.4029-4-yu-cheng.yu@intel.com> <20190607080832.GT3419@hirez.programming.kicks-ass.net> <aa8a92ef231d512b5c9855ef416db050b5ab59a6.camel@intel.com> <20190607174336.GM3436@hirez.programming.kicks-ass.net> <b3de4110-5366-fdc7-a960-71dea543a42f@intel.com> <34E0D316-552A-401C-ABAA-5584B5BC98C5@amacapital.net> <7e0b97bf1fbe6ff20653a8e4e147c6285cc5552d.camel@intel.com> <4b448cde-ee4e-1c95-0f7f-4fe694be7db6@intel.com> <0e505563f7dae3849b57fb327f578f41b760b6f7.camel@intel.com> <f6de9073-9939-a20d-2196-25fa223cf3fc@intel.com>
Mime-Version: 1.0 (1.0)
Content-Type: text/plain;
        charset=utf-8
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <f6de9073-9939-a20d-2196-25fa223cf3fc@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Dave Hansen <dave.hansen@intel.com>
Cc: Yu-cheng Yu <yu-cheng.yu@intel.com>, Peter Zijlstra <peterz@infradead.org>, x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, linux-mm@kvack.org, linux-arch@vger.kernel.org, linux-api@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>, Balbir Singh <bsingharora@gmail.com>, Borislav Petkov <bp@alien8.de>, Cyrill Gorcunov <gorcunov@gmail.com>, Dave Hansen <dave.hansen@linux.intel.com>, Eugene Syromiatnikov <esyr@redhat.com>, Florian Weimer <fweimer@redhat.com>, "H.J. Lu" <hjl.tools@gmail.com>, Jann Horn <jannh@google.com>, Jonathan Corbet <corbet@lwn.net>, Kees Cook <keescook@chromium.org>, Mike Kravetz <mike.kravetz@oracle.com>
List-Id: linux-api@vger.kernel.org


> On Jun 7, 2019, at 2:09 PM, Dave Hansen <dave.hansen@intel.com> wrote:
>=20
> On 6/7/19 1:06 PM, Yu-cheng Yu wrote:
>>> Huh, how does glibc know about all possible past and future legacy code
>>> in the application?
>> When dlopen() gets a legacy binary and the policy allows that, it will ma=
nage
>> the bitmap:
>>=20
>>  If a bitmap has not been created, create one.
>>  Set bits for the legacy code being loaded.
>=20
> I was thinking about code that doesn't go through GLIBC like JITs.

CRIU is another consideration: it would be rather annoying if CET programs c=
an=E2=80=99t migrate between LA57 and normal machines.=

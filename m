From: Andy Lutomirski <luto@amacapital.net>
Subject: Re: [PATCH v7 03/14] x86/cet/ibt: Add IBT legacy code bitmap setup function
Date: Fri, 7 Jun 2019 09:35:27 -0700
Message-ID: <76B7B1AE-3AEA-4162-B539-990EF3CCE2C2@amacapital.net>
References: <20190606200926.4029-1-yu-cheng.yu@intel.com> <20190606200926.4029-4-yu-cheng.yu@intel.com> <20190607080832.GT3419@hirez.programming.kicks-ass.net> <aa8a92ef231d512b5c9855ef416db050b5ab59a6.camel@intel.com>
Mime-Version: 1.0 (1.0)
Content-Type: text/plain;
        charset=utf-8
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <aa8a92ef231d512b5c9855ef416db050b5ab59a6.camel@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Yu-cheng Yu <yu-cheng.yu@intel.com>
Cc: Peter Zijlstra <peterz@infradead.org>, x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, linux-mm@kvack.org, linux-arch@vger.kernel.org, linux-api@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>, Balbir Singh <bsingharora@gmail.com>, Borislav Petkov <bp@alien8.de>, Cyrill Gorcunov <gorcunov@gmail.com>, Dave Hansen <dave.hansen@linux.intel.com>, Eugene Syromiatnikov <esyr@redhat.com>, Florian Weimer <fweimer@redhat.com>, "H.J. Lu" <hjl.tools@gmail.com>, Jann Horn <jannh@google.com>, Jonathan Corbet <corbet@lwn.net>, Kees Cook <keescook@chromium.org>, Mike Kravetz <mike.kravetz@oracle.com>, Nadav Amit <nadav.amit@gmail.com>
List-Id: linux-api@vger.kernel.org



> On Jun 7, 2019, at 9:23 AM, Yu-cheng Yu <yu-cheng.yu@intel.com> wrote:
>=20
>> On Fri, 2019-06-07 at 10:08 +0200, Peter Zijlstra wrote:
>>> On Thu, Jun 06, 2019 at 01:09:15PM -0700, Yu-cheng Yu wrote:
>>> Indirect Branch Tracking (IBT) provides an optional legacy code bitmap
>>> that allows execution of legacy, non-IBT compatible library by an
>>> IBT-enabled application.  When set, each bit in the bitmap indicates
>>> one page of legacy code.
>>>=20
>>> The bitmap is allocated and setup from the application.
>>> +int cet_setup_ibt_bitmap(unsigned long bitmap, unsigned long size)
>>> +{
>>> +    u64 r;
>>> +
>>> +    if (!current->thread.cet.ibt_enabled)
>>> +        return -EINVAL;
>>> +
>>> +    if (!PAGE_ALIGNED(bitmap) || (size > TASK_SIZE_MAX))
>>> +        return -EINVAL;
>>> +
>>> +    current->thread.cet.ibt_bitmap_addr =3D bitmap;
>>> +    current->thread.cet.ibt_bitmap_size =3D size;
>>> +
>>> +    /*
>>> +     * Turn on IBT legacy bitmap.
>>> +     */
>>> +    modify_fpu_regs_begin();
>>> +    rdmsrl(MSR_IA32_U_CET, r);
>>> +    r |=3D (MSR_IA32_CET_LEG_IW_EN | bitmap);
>>> +    wrmsrl(MSR_IA32_U_CET, r);
>>> +    modify_fpu_regs_end();
>>> +
>>> +    return 0;
>>> +}
>>=20
>> So you just program a random user supplied address into the hardware.
>> What happens if there's not actually anything at that address or the
>> user munmap()s the data after doing this?
>=20
> This function checks the bitmap's alignment and size, and anything else is=
 the
> app's responsibility.  What else do you think the kernel should check?
>=20

One might reasonably wonder why this state is privileged in the first place a=
nd, given that, why we=E2=80=99re allowing it to be written like this.

Arguably we should have another prctl to lock these values (until exec) as a=
 gardening measure.=

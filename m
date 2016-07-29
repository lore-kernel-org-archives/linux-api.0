From: Dave Hansen <dave.hansen@intel.com>
Subject: Re: [PATCH 08/10] x86, pkeys: default to a restrictive init PKRU
Date: Fri, 29 Jul 2016 10:50:51 -0700
Message-ID: <579B977B.7090609@intel.com>
References: <20160729163009.5EC1D38C@viggo.jf.intel.com>
 <20160729163021.F3C25D4A@viggo.jf.intel.com>
 <CALCETrWMg=+YSi7Az+gw9B59OoAEkOd=znpr7+++5=UUg6DThw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-arch-owner@vger.kernel.org>
In-Reply-To: <CALCETrWMg=+YSi7Az+gw9B59OoAEkOd=znpr7+++5=UUg6DThw@mail.gmail.com>
Sender: linux-arch-owner@vger.kernel.org
To: Andy Lutomirski <luto@amacapital.net>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, X86 ML <x86@kernel.org>, Linux API <linux-api@vger.kernel.org>, linux-arch <linux-arch@vger.kernel.org>, "linux-mm@kvack.org" <linux-mm@kvack.org>, Linus Torvalds <torvalds@linux-foundation.org>, Andrew Morton <akpm@linux-foundation.org>, Andrew Lutomirski <luto@kernel.org>, Mel Gorman <mgorman@techsingularity.net>, Dave Hansen <dave.hansen@linux.intel.com>, Arnd Bergmann <arnd@arndb.de>
List-Id: linux-api@vger.kernel.org

On 07/29/2016 10:29 AM, Andy Lutomirski wrote:
>> > In the end, this ensures that threads which do not know how to
>> > manage their own pkey rights can not do damage to data which is
>> > pkey-protected.
> I think you missed the fpu__clear() caller in kernel/fpu/signal.c.
> 
> ISTM it might be more comprehensible to change fpu__clear in general
> and then special case things you want to behave differently.

The code actually already patched the generic fpu__clear():

	fpu__clear() ->
	copy_init_fpstate_to_fpregs() ->
	copy_init_pkru_to_fpregs()

So I think it hit the case you are talking about.

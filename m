From: Andy Lutomirski <luto@amacapital.net>
Subject: Re: [PATCH 6/9] x86, pkeys: add pkey set/get syscalls
Date: Mon, 11 Jul 2016 07:45:20 -0700
Message-ID: <CALCETrW1qLZE_cq1CvmLkdnFyKRWVZuah29xERTC7o0eZ8DbwQ@mail.gmail.com>
References: <20160707124719.3F04C882@viggo.jf.intel.com> <20160707124728.C1116BB1@viggo.jf.intel.com>
 <20160707144508.GZ11498@techsingularity.net> <577E924C.6010406@sr71.net>
 <20160708071810.GA27457@gmail.com> <577FD587.6050101@sr71.net>
 <20160709083715.GA29939@gmail.com> <CALCETrXJhVz6Za4=oidiM2Vfbb+XdggFBYiVyvOCcia+w064aQ@mail.gmail.com>
 <5783AE8F.3@sr71.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-arch-owner@vger.kernel.org>
In-Reply-To: <5783AE8F.3@sr71.net>
Sender: linux-arch-owner@vger.kernel.org
To: Dave Hansen <dave@sr71.net>
Cc: Ingo Molnar <mingo@kernel.org>, linux-arch <linux-arch@vger.kernel.org>, Thomas Gleixner <tglx@linutronix.de>, "linux-mm@kvack.org" <linux-mm@kvack.org>, Mel Gorman <mgorman@techsingularity.net>, Linus Torvalds <torvalds@linux-foundation.org>, Andrew Morton <akpm@linux-foundation.org>, Linux API <linux-api@vger.kernel.org>, Arnd Bergmann <arnd@arndb.de>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Al Viro <viro@zeniv.linux.org.uk>, Peter Zijlstra <a.p.zijlstra@chello.nl>, Hugh Dickins <hughd@google.com>, "H. Peter Anvin" <hpa@zytor.com>, X86 ML <x86@kernel.org>, Dave Hansen <dave.hansen@linux.intel.com>
List-Id: linux-api@vger.kernel.org

On Mon, Jul 11, 2016 at 7:34 AM, Dave Hansen <dave@sr71.net> wrote:
> On 07/10/2016 09:25 PM, Andy Lutomirski wrote:
>> 2. When thread A allocates a pkey, how does it lock down thread B?
>>
>> #2 could be addressed by using fully-locked-down as the initial state
>> post-exec() and copying the state on clone().  Dave, are there any
>> cases in practice where one thread would allocate a pkey and want
>> other threads to immediately have access to the memory with that key?
>
> The only one I can think of is a model where pkeys are used more in a
> "denial" mode rather than an "allow" mode.
>
> For instance, perhaps you don't want to modify your app to use pkeys,
> except for a small routine where you handle untrusted user data.  You
> would, in that routine, deny access to a bunch of keys, but otherwise
> allow access to all so you didn't have to change any other parts of the app.
>
> Should we instead just recommend to userspace that they lock down access
> to keys by default in all threads as a best practice?

Is that really better than doing it in-kernel?  My concern is that
we'll find library code that creates a thread, and that code could run
before the pkey-aware part of the program even starts running.  So how
is user code supposed lock down all of its threads?

seccomp has TSYNC for this, but I don't think that PKRU allows
something like that.

From: Dave Hansen <dave-gkUM19QKKo4@public.gmane.org>
Subject: Re: [PATCH 00/34] x86: Memory Protection Keys (v5)
Date: Fri, 4 Dec 2015 15:38:41 -0800
Message-ID: <56622401.20001@sr71.net>
References: <20151204011424.8A36E365@viggo.jf.intel.com>
 <CALCETrXwVb99hAvqR2o54aPwtpr8oubROtiRt45SiYRfUTAxCw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CALCETrXwVb99hAvqR2o54aPwtpr8oubROtiRt45SiYRfUTAxCw-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>
Cc: "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org" <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, X86 ML <x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-arch <linux-arch-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Andrea Arcangeli <aarcange-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org>, "Kirill A. Shutemov" <kirill.shutemov-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, Naoya Horiguchi <n-horiguchi-PaJj6Psr51x8UrSeD/g0lQ@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On 12/04/2015 03:31 PM, Andy Lutomirski wrote:
> On Thu, Dec 3, 2015 at 5:14 PM, Dave Hansen <dave-gkUM19QKKo4@public.gmane.org> wrote:
>> Memory Protection Keys for User pages is a CPU feature which will
>> first appear on Skylake Servers, but will also be supported on
>> future non-server parts.  It provides a mechanism for enforcing
>> page-based protections, but without requiring modification of the
>> page tables when an application changes protection domains.  See
>> the Documentation/ patch for more details.
> 
> What, if anything, happened to the signal handling parts?

Patches 12 and 13 contain most of it:

	x86, pkeys: fill in pkey field in siginfo
	signals, pkeys: notify userspace about protection key faults	

I decided to just not try to preserve the pkey_get/set() semantics
across entering and returning from signals, fwiw.

> Also, do you have a git tree for this somewhere?  I can't actually
> enable it (my laptop, while very shiny, is not a Skylake server), but
> I can poke around a bit.

http://git.kernel.org/cgit/linux/kernel/git/daveh/x86-pkeys.git/

Thanks for taking a look!

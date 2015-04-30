From: Mark Williamson <mwilliamson-/4lU09Eg6ahx67MzidHQgQC/G2K4zDHf@public.gmane.org>
Subject: Re: Regression: Requiring CAP_SYS_ADMIN for /proc/<pid>/pagemap
 causes application-level breakage
Date: Thu, 30 Apr 2015 12:50:04 +0100
Message-ID: <CAEVpBaJ3z12p6qfpisu5Fy2sPQhDBvbHsE-PAGNRM2A3P98Y3Q@mail.gmail.com>
References: <CAEVpBa+_RyACkhODZrRvQLs80iy0sqpdrd0AaP_-tgnX3Y9yNQ@mail.gmail.com>
	<CAL82V5P-6_3kKfkgBuv1WMSu5xQ-0mUs7pHXegyPAzgroTgLtA@mail.gmail.com>
	<CAEVpBa+vjfR8p_fJQPXyrQCMYJOocQpTHmkTYmj7nOpGcce=Pg@mail.gmail.com>
	<CAEVpBa+DPbhZeRsA=+Jnn7f1BqVZm9SU=ABjy6bAHbbMi_yn+g@mail.gmail.com>
	<20150429193622.GA11892@node.dhcp.inet.fi>
	<CA+55aFx67hC3RxvAXYXWp=6mN_cfyMVqh_TDJVEqiV17o8+PtA@mail.gmail.com>
	<CALYGNiN6kU5xgEAfbs4VVXsVKmMN+uCStrQoLh6gFCzBxJfy+A@mail.gmail.com>
	<CA+55aFzW52u-LahoBA5kDs47rgeTGU_KF_GUrx+XSUDzeQD3=g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CA+55aFzW52u-LahoBA5kDs47rgeTGU_KF_GUrx+XSUDzeQD3=g@mail.gmail.com>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: Konstantin Khlebnikov <koct9i-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "Kirill A. Shutemov" <kirill-oKw7cIdHH8eLwutG50LtGA@public.gmane.org>, Mark Seaborn <mseaborn-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, kernel list <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "Kirill A. Shutemov" <kirill.shutemov-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, Pavel Emelyanov <xemul-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Finn Grimwood <fgrimwood-/4lU09Eg6ahx67MzidHQgQC/G2K4zDHf@public.gmane.org>, Daniel James <djames-/4lU09Eg6ahx67MzidHQgQC/G2K4zDHf@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Wed, Apr 29, 2015 at 10:02 PM, Linus Torvalds
<torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org> wrote:
> On Wed, Apr 29, 2015 at 1:44 PM, Konstantin Khlebnikov <koct9i-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
>>
>> This's no longer true. After recent fixes for "anon_vma endless growing" new vma
>> might reuse old anon_vma from grandparent vma.
>
> Oh well. I guess that was too simple.
>
> If Mark is ok with the rule that "it's not reliably if you have two
> nested forks" (ie it only works if you exec for every fork you do), it
> should still work, right? It sounds like Mark doesn't necessarily need
> to handle the *generic* case.

Yes, it sounds like that should be OK for us.  Our usecase is pretty
restricted, so we're a long way off requiring a generic solution.

Our code will always fork() a fresh child in which to monitor memory
changes.  We run the operations we're interested in, use pagemap to
figure out "what changed" (by comparing whether the pagemap_entry_t
values are different from their parent) and then throw away the child
process.

Currently our code does an entry-by-entry compare of pagemap, so
anything that exposes writes as a change to values in there would
allow us to run unmodified.  That would be really nice.  That said, I
think we'd still be OK to modify our own code too if we can find a
solution that would continue to function on older kernel releases,
-stable trees, etc.

Thanks,
Mark

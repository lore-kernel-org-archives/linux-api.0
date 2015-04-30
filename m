From: "Kirill A. Shutemov" <kirill-oKw7cIdHH8eLwutG50LtGA@public.gmane.org>
Subject: Re: Regression: Requiring CAP_SYS_ADMIN for /proc/<pid>/pagemap
 causes application-level breakage
Date: Thu, 30 Apr 2015 16:22:30 +0300
Message-ID: <20150430132230.GE15874@node.dhcp.inet.fi>
References: <CAEVpBa+_RyACkhODZrRvQLs80iy0sqpdrd0AaP_-tgnX3Y9yNQ@mail.gmail.com>
 <CAL82V5P-6_3kKfkgBuv1WMSu5xQ-0mUs7pHXegyPAzgroTgLtA@mail.gmail.com>
 <CAEVpBa+vjfR8p_fJQPXyrQCMYJOocQpTHmkTYmj7nOpGcce=Pg@mail.gmail.com>
 <CAEVpBa+DPbhZeRsA=+Jnn7f1BqVZm9SU=ABjy6bAHbbMi_yn+g@mail.gmail.com>
 <20150429193622.GA11892@node.dhcp.inet.fi>
 <CA+55aFx67hC3RxvAXYXWp=6mN_cfyMVqh_TDJVEqiV17o8+PtA@mail.gmail.com>
 <CALYGNiN6kU5xgEAfbs4VVXsVKmMN+uCStrQoLh6gFCzBxJfy+A@mail.gmail.com>
 <CA+55aFzW52u-LahoBA5kDs47rgeTGU_KF_GUrx+XSUDzeQD3=g@mail.gmail.com>
 <CALYGNiOcb2Z+zBVQ0Z058Z7+jp3EixYq8MK1f3MYYXOpT9iAiw@mail.gmail.com>
 <CALYGNiNVvVUuXvRX2nTtcDA8a8uWdQNVJ4bb2HgCY2efeDJrRw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CALYGNiNVvVUuXvRX2nTtcDA8a8uWdQNVJ4bb2HgCY2efeDJrRw-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Konstantin Khlebnikov <koct9i-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Mark Williamson <mwilliamson-/4lU09Eg6ahx67MzidHQgQC/G2K4zDHf@public.gmane.org>, Mark Seaborn <mseaborn-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, kernel list <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "Kirill A. Shutemov" <kirill.shutemov-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, Pavel Emelyanov <xemul-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Finn Grimwood <fgrimwood-/4lU09Eg6ahx67MzidHQgQC/G2K4zDHf@public.gmane.org>, Daniel James <djames-/4lU09Eg6ahx67MzidHQgQC/G2K4zDHf@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Thu, Apr 30, 2015 at 04:11:30PM +0300, Konstantin Khlebnikov wrote:
> On Thu, Apr 30, 2015 at 2:43 PM, Konstantin Khlebnikov <koct9i-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
> > On Thu, Apr 30, 2015 at 12:02 AM, Linus Torvalds
> > <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org> wrote:
> >> On Wed, Apr 29, 2015 at 1:44 PM, Konstantin Khlebnikov <koct9i-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
> >>>
> >>> This's no longer true. After recent fixes for "anon_vma endless growing" new vma
> >>> might reuse old anon_vma from grandparent vma.
> >>
> >> Oh well. I guess that was too simple.
> >>
> >> If Mark is ok with the rule that "it's not reliably if you have two
> >> nested forks" (ie it only works if you exec for every fork you do), it
> >> should still work, right? It sounds like Mark doesn't necessarily need
> >> to handle the *generic* case.
> >
> > What about exposing shared/exclusive bit in pagemap == 1 if
> > page_mapcount() > 1, otherwise 0 (or vise versa).
> >
> > Seems like this should work for detecting CoWed pages in child mm.
> 
> Something like this (see patch in attachment)

THP is not covered.

Any comments on kcmp() idea?

-- 
 Kirill A. Shutemov

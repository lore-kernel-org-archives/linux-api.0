From: "Kirill A. Shutemov" <kirill-oKw7cIdHH8eLwutG50LtGA@public.gmane.org>
Subject: Re: Regression: Requiring CAP_SYS_ADMIN for /proc/<pid>/pagemap
 causes application-level breakage
Date: Thu, 30 Apr 2015 00:37:44 +0300
Message-ID: <20150429213744.GA12552@node.dhcp.inet.fi>
References: <CAEVpBa+_RyACkhODZrRvQLs80iy0sqpdrd0AaP_-tgnX3Y9yNQ@mail.gmail.com>
 <CAL82V5P-6_3kKfkgBuv1WMSu5xQ-0mUs7pHXegyPAzgroTgLtA@mail.gmail.com>
 <CAEVpBa+vjfR8p_fJQPXyrQCMYJOocQpTHmkTYmj7nOpGcce=Pg@mail.gmail.com>
 <CAEVpBa+DPbhZeRsA=+Jnn7f1BqVZm9SU=ABjy6bAHbbMi_yn+g@mail.gmail.com>
 <20150429193622.GA11892@node.dhcp.inet.fi>
 <CA+55aFx67hC3RxvAXYXWp=6mN_cfyMVqh_TDJVEqiV17o8+PtA@mail.gmail.com>
 <CALYGNiN6kU5xgEAfbs4VVXsVKmMN+uCStrQoLh6gFCzBxJfy+A@mail.gmail.com>
 <CA+55aFzW52u-LahoBA5kDs47rgeTGU_KF_GUrx+XSUDzeQD3=g@mail.gmail.com>
 <20150429210513.GA12431@node.dhcp.inet.fi>
 <CA+55aFw-dK4U3Z_gi5wEdGsPz0ZaQMizETKqS-=ajpDAu03Fnw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CA+55aFw-dK4U3Z_gi5wEdGsPz0ZaQMizETKqS-=ajpDAu03Fnw-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: Konstantin Khlebnikov <koct9i-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Mark Williamson <mwilliamson-/4lU09Eg6ahx67MzidHQgQC/G2K4zDHf@public.gmane.org>, Mark Seaborn <mseaborn-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, kernel list <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "Kirill A. Shutemov" <kirill.shutemov-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, Pavel Emelyanov <xemul-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Finn Grimwood <fgrimwood-/4lU09Eg6ahx67MzidHQgQC/G2K4zDHf@public.gmane.org>, Daniel James <djames-/4lU09Eg6ahx67MzidHQgQC/G2K4zDHf@public.gmane.org>, Cyrill Gorcunov <gorcunov-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Wed, Apr 29, 2015 at 02:18:49PM -0700, Linus Torvalds wrote:
> On Wed, Apr 29, 2015 at 2:05 PM, Kirill A. Shutemov
> <kirill-oKw7cIdHH8eLwutG50LtGA@public.gmane.org> wrote:
> >
> > This sounds too ugly to be exposed it as ABI.
> 
> Oh, pretty it ain't. However, regressions in many ways are worse. If
> it makes it possible to not regress...

One idea is to extend kcmp(2) with KCMP_PAGE. idx1 and idx2 are virtual
addresses in two processes. It returns 0 if addresses points to the same
page and 3 otherwise.

Would it be enough for the use case?

I guess it could be too slow to check one page a time...

Invent new kcmpv(2)? ;)

-- 
 Kirill A. Shutemov

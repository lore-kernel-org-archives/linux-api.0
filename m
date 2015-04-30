From: Mark Williamson <mwilliamson-/4lU09Eg6ahx67MzidHQgQC/G2K4zDHf@public.gmane.org>
Subject: Re: Regression: Requiring CAP_SYS_ADMIN for /proc/<pid>/pagemap
 causes application-level breakage
Date: Thu, 30 Apr 2015 19:45:06 +0100
Message-ID: <CAEVpBaLQx-8Hxjav5OO0xntDs=2wEXJwLXXW3FuNE0yCeBjBeQ@mail.gmail.com>
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
	<20150430132230.GE15874@node.dhcp.inet.fi>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20150430132230.GE15874-nhfs4B5ZimeFUdmeq17FyvUpdFzICT1y@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Kirill A. Shutemov" <kirill-oKw7cIdHH8eLwutG50LtGA@public.gmane.org>
Cc: Konstantin Khlebnikov <koct9i-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Mark Seaborn <mseaborn-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, kernel list <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "Kirill A. Shutemov" <kirill.shutemov-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, Pavel Emelyanov <xemul-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Finn Grimwood <fgrimwood-/4lU09Eg6ahx67MzidHQgQC/G2K4zDHf@public.gmane.org>, Daniel James <djames-/4lU09Eg6ahx67MzidHQgQC/G2K4zDHf@public.gmane.org>
List-Id: linux-api@vger.kernel.org

>> Something like this (see patch in attachment)
>
> THP is not covered.
>
> Any comments on kcmp() idea?

It seems like a modified kcmp() would also be a valid approach but, as
you noted, probably speed-limited for our purposes.  As you say, there
is the option of a vector-oriented equivalent.  It seems like a
generally nice facility to have available in the kernel but my
suspicion is that it wouldn't be optimal for us...

My thinking is that using soft-dirty might give us the best
performance on platforms where it's available.  We're only using
fork() as a cunning/hacky way of tracking what pages change;
soft-dirty would allow us to avoid that too, whereas using kcmp()
would still require the forking overhead.

Does that make sense, or have I missed something?

Thanks,
Mark

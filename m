From: Alexey Dobriyan <adobriyan-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 1/2 v2] fdmap(2)
Date: Wed, 25 Oct 2017 14:45:31 +0200
Message-ID: <CACVxJT-YmJQcp9PPhA1cx3rzUF1onzg-AzpC88L+QXz9xgYGtQ@mail.gmail.com>
References: <20170924200620.GA24368@avx2> <9bc11ace-d111-cdef-5280-8cdda027ae9a@gmail.com>
 <20171023092938.GC32228@amd>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20171023092938.GC32228@amd>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Pavel Machek <pavel-+ZI9xUNit7I@public.gmane.org>
Cc: "Michael Kerrisk (man-pages)" <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, rdunlap-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org, tixxdz-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, gladkov.alexey-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, Aliaksandr Patseyenak <Aliaksandr_Patseyenak1-uRwfk40T5oI@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On 10/23/17, Pavel Machek <pavel-+ZI9xUNit7I@public.gmane.org> wrote:

> Binary fdmap looks... quite ugly to me. But close_all(from, to)
> syscall kindof makes sense to me... and is not that ugly.
>
> Given that openbsd has something similar... perhaps we can take that?

closefrom() can be implemented on top of fdmap().
fdmap as is is useful for other purposes.

> Except during startup, application should have good idea what fds it
> has open, so maybe that's enough?

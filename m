From: Aaron Jones <aaronmdjones-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH v2 1/2] capabilities: Ambient capabilities
Date: Tue, 19 May 2015 20:22:17 +0000
Message-ID: <555B9B79.9080806@gmail.com>
References: <cover.1431671529.git.luto@kernel.org> <cc4749638a21079cce12f9f30c806170558e56e5.1431671529.git.luto@kernel.org> <alpine.DEB.2.11.1505150916330.20103@gentwo.org> <CALCETrXKRt9MJQEZc=EEGMFB_vwKDQbZ7ReMNqE-5tRTxxJu2Q@mail.gmail.com> <alpine.DEB.2.11.1505191036490.28005@gentwo.org> <CALCETrV1+3ZuL0MkqQaRoQ8r2V=EcQQEodOdCdP0p-BK1PixGg@mail.gmail.com> <alpine.DEB.2.11.1505191502570.31044@gentwo.org> <CALCETrW6DndOnC5ego+R5rwjoXeFo04cSO4Z2qZnhiJpEPBE=Q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CALCETrW6DndOnC5ego+R5rwjoXeFo04cSO4Z2qZnhiJpEPBE=Q@mail.gmail.com>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>, Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>
Cc: Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, Ted Ts'o <tytso-3s7WtUTddSA@public.gmane.org>, "Andrew G. Morgan" <morgan-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Andrew Morton <akpm-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, Serge Hallyn <serge.hallyn-GeWIH/nMZzLQT0dZR+AlfA@public.gmane.org>, Michael Kerrisk <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Mimi Zohar <zohar-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Austin S Hemmelgarn <ahferroin7-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-security-module <linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Serge Hallyn <serge.hallyn-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>, Markku Savela <msa-kXoF896ld44xHbG02/KK1g@public.gmane.org>, Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, Jonathan Corbet <corbet-T1hC0tSOHrs@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On 19/05/15 20:07, Andy Lutomirski wrote:> It's in the cover letter,
rather vaguely.  I think I want to change
> the setpriv syntax a bit before sending it upstream, though -- it's
> sucks that you have to duplicate the option.
>
> Perhaps the ambient-caps option should implicitly raise inheritable
> caps if they're not already raised.  Or maybe the absence of an
> inh-caps rule should cause any requested ambient caps to be made
> inheritable as well.
>
> --Andy

I propose an additional --ambient-inh option to copy everything from
--inh-caps to the ambient set. Explicit is better than implicit.

-- 
Aaron Jones

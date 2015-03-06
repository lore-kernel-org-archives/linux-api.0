From: Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>
Subject: Re: [PATCH] capabilities: Ambient capability set V2
Date: Fri, 6 Mar 2015 11:02:43 -0800
Message-ID: <CALCETrVQF22rkZFD8VAW_xrVQOjwpej6W4TJS9gbN9B431TEKg@mail.gmail.com>
References: <alpine.DEB.2.11.1502261612370.8994@gentwo.org>
 <20150301233359.GA22196@mail.hallyn.com> <alpine.DEB.2.11.1503050917380.31001@gentwo.org>
 <20150305171326.GA14998@mail.hallyn.com> <alpine.DEB.2.11.1503060948460.8207@gentwo.org>
 <20150306163443.GA28386@mail.hallyn.com> <alpine.DEB.2.11.1503061244130.9804@gentwo.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <alpine.DEB.2.11.1503061244130.9804-gkYfJU5Cukgdnm+yROfE0A@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>
Cc: "Serge E. Hallyn" <serge-A9i7LUbDfNHQT0dZR+AlfA@public.gmane.org>, Serge Hallyn <serge.hallyn-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>, Jonathan Corbet <corbet-T1hC0tSOHrs@public.gmane.org>, Aaron Jones <aaronmdjones-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, LSM List <linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Andrew Morton <akpm-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, "Andrew G. Morgan" <morgan-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Mimi Zohar <zohar-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, Austin S Hemmelgarn <ahferroin7-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Markku Savela <msa-kXoF896ld44xHbG02/KK1g@public.gmane.org>, Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Michael Kerrisk <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Fri, Mar 6, 2015 at 10:53 AM, Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org> wrote:
> On Fri, 6 Mar 2015, Serge E. Hallyn wrote:
>
>> Sorry, something about that patch-patch didn't make sense to me, but I
>> need to look more closely.  My objection was that you were able to get the
>> pA capabilities into pP without them being in your pI.  Your proposed
>> change didn't seem like it would fix that.
>
> Just tried to fix that. Could it be that cap_inherited is never set even
> for a binary that has
>
> christoph@fujitsu-haswell:~$ getcap ambient_test
>
> ambient_test = cap_setpcap,cap_net_admin,cap_net_raw,cap_sys_nice+eip

I think that's right.  fI doesn't set pI.

--Andy

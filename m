From: Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] capabilities: Ambient capability set V2
Date: Fri, 6 Mar 2015 09:47:54 -0600 (CST)
Message-ID: <alpine.DEB.2.11.1503060944570.8136@gentwo.org>
References: <alpine.DEB.2.11.1502261612370.8994@gentwo.org> <20150301233359.GA22196@mail.hallyn.com> <alpine.DEB.2.11.1503050917380.31001@gentwo.org> <20150305171326.GA14998@mail.hallyn.com> <alpine.DEB.2.11.1503051235300.32373@gentwo.org>
 <CALCETrUVrfPBpb69WFyptzFoJ8Sx4LwhhjirVx=KQ11ofCcwYg@mail.gmail.com>
Content-Type: MULTIPART/MIXED; BOUNDARY="8323329-2063140391-1425656874=:8136"
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CALCETrUVrfPBpb69WFyptzFoJ8Sx4LwhhjirVx=KQ11ofCcwYg-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>
Cc: Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, Andrew Morton <akpm-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, LSM List <linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "Andrew G. Morgan" <morgan-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Michael Kerrisk <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Mimi Zohar <zohar-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Austin S Hemmelgarn <ahferroin7-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Aaron Jones <aaronmdjones-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Serge Hallyn <serge.hallyn-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>, "Serge E. Hallyn" <serge-A9i7LUbDfNHQT0dZR+AlfA@public.gmane.org>, Markku Savela <msa-kXoF896ld44xHbG02/KK1g@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Jonathan Corbet <corbet-T1hC0tSOHrs@public.gmane.org>
List-Id: linux-api@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--8323329-2063140391-1425656874=:8136
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: 8BIT

On Thu, 5 Mar 2015, Andy Lutomirski wrote:

> > Yes due to the library issues.
>
> You can't LD_PRELOAD and fP together.  And I'm still unconvinced that
> ambient caps can ever be safe in conjunction with fP.  I'll grill you
> next week on what you're trying to do that makes you want this :)

>From the ld.so manpage:

    LD_PRELOAD
              A whitespace-separated list of additional, user-specified, ELF shared
              libraries to be loaded before all others.  This can be used to selec‐
              tively override functions in other shared libraries.  For setuid/set‐
              gid ELF binaries, only libraries in the standard  search  directories
              that are also setgid will be loaded.

So this mechanism has not been made to work for binaries with caps? We
have to keep using setuid?

--8323329-2063140391-1425656874=:8136--

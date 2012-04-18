From: Thadeu Lima de Souza Cascardo <cascardo@linux.vnet.ibm.com>
Subject: Re: [patch] Fix handling of overlength pathname in AF_UNIX sun_path
Date: Wed, 18 Apr 2012 10:13:18 -0300
Message-ID: <20120418131318.GB2455@oc1711230544.ibm.com>
References: <CADZpyix6DZ93f8MQf3Aa1NVV7HCFMAXVAdzRMFBY7xWHHQMPog@mail.gmail.com>
 <AE90C24D6B3A694183C094C60CF0A2F6026B6EE2@saturn3.aculab.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <netdev-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <AE90C24D6B3A694183C094C60CF0A2F6026B6EE2@saturn3.aculab.com>
Sender: netdev-owner@vger.kernel.org
To: David Laight <David.Laight@ACULAB.COM>
Cc: Carlos O'Donell <carlos@systemhalted.org>, David Miller <davem@davemloft.net>, mtk.manpages@gmail.com, netdev@vger.kernel.org, penguin-kernel@i-love.sakura.ne.jp, linux-api@vger.kernel.org, yoshfuji@linux-ipv6.org, jengelh@medozas.de, w@1wt.eu, alan@lxorguk.ukuu.org.uk
List-Id: linux-api@vger.kernel.org

On Wed, Apr 18, 2012 at 09:17:26AM +0100, David Laight wrote:
> 
> > 
> > Why not have:
> > 
> > diff --git a/net/unix/af_unix.c b/net/unix/af_unix.c
> > index d510353..f9f77a7 100644
> > --- a/net/unix/af_unix.c
> > +++ b/net/unix/af_unix.c
> > @@ -216,6 +216,9 @@ static int unix_mkname(struct sockaddr_un
> > *sunaddr, int len, unsigned *hashp)
> >                  */
> >                 ((char *)sunaddr)[len] = 0;
> >                 len = strlen(sunaddr->sun_path)+1+sizeof(short);
> > +               /* No null terminator was found in the path. */
> > +               if (len > sizeof(*sunaddr))
> > +                       return -EINVAL;
> >                 return len;
> 
> That could generate a kernel page fault!
> (Depending on what follows (or rather doesn't follow!) sun_path.)
> You'd need to use memchr() not strlen().
> 
> 	David
> 

Hi, David.

What follows is a 0 byte, because it's set that way in the line before
strlen. Note that len is tested for sizeof(*sunaddr), and there is a
huge comment about that extra byte that was omitted.

The whole function is at net/unix/af_unix.c:203.

Regards,
Cascardo.

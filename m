From: Matt Mackall <mpm-VDJrAJ4Gl5ZBDgjK7y7TUQ@public.gmane.org>
Subject: Re: [RESEND][PATCH] Add /proc/mempool to display mempool usage
Date: Mon, 01 Dec 2008 16:20:34 -0600
Message-ID: <1228170034.3196.107.camel@calx>
References: <1227980689.6354.24.camel@localhost.localdomain>
	 <20081129214207.GA6747@x200.localdomain> <20081129234907.GA2340@kroah.com>
	 <20081201101245.0a2f3123.randy.dunlap@oracle.com>
	 <1228158811.3196.88.camel@calx>
	 <20081201120210.1ed16bd5.akpm@linux-foundation.org>
	 <84144f020812011207q29fe4b3fq11a9e55f171cf743@mail.gmail.com>
	 <alpine.LFD.2.00.0812011210030.3256@nehalem.linux-foundation.org>
	 <84144f020812011402v3cb3ab24pf5cb6310f2d00c5b@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <84144f020812011402v3cb3ab24pf5cb6310f2d00c5b-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Pekka Enberg <penberg-bbCR+/B0CizivPeTLB3BmA@public.gmane.org>
Cc: Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, randy.dunlap-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org, greg-U8xfFu+wG4EAvxtiuMwx3w@public.gmane.org, adobriyan-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, remi.colinet-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

On Tue, 2008-12-02 at 00:02 +0200, Pekka Enberg wrote:
> Hi Linus,
>=20
> On Mon, 1 Dec 2008, Pekka Enberg wrote:
> >> Hmm, I thought Documentation/ABI/ was supposed to tell us what's a=
n
> >> ABI you can depend on and what's not. I mean, you shouldn't be
> >> depending on anything but the interfaces documented in
> >> Documentation/ABI/stable/, no?
>=20
> On Mon, Dec 1, 2008 at 10:12 PM, Linus Torvalds
> <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org> wrote:
> > Who is the f*cking MORON that thinks that "documentation" has any m=
eaning
> > what-so-ever?
>=20
> Me, I suppose. At least that's the impression I got when being asked
> to document any new kmemtrace debugfs files, for example.
>=20
> On Mon, Dec 1, 2008 at 10:12 PM, Linus Torvalds
> <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org> wrote:
> > The fact that something is documented (whether correctly or not) ha=
s
> > absolutely _zero_ impact on anything at all. What makes something a=
n ABI
> > is that it's useful and available. The only way something isn't an =
ABI is
> > by _explicitly_ making sure that it's not available even by mistake=
 in a
> > stable form for binary use.
>=20
> OK, but why do we have those different ABI "stages" in
> Documentation/ABI then? The README file there seems to contradict wha=
t
> you say. Or maybe I'm reading it wrong...

If the terrain and the map do not agree, follow the terrain. =E2=80=93 =
Swedish
army manual.

If code uses a public interface and we break that interface, we will ge=
t
unhappy users. Putting stuff in debugfs/ in a released kernel makes it
public. That's the terrain.

--=20
Mathematics is the supreme nostalgia of our time.

--
To unsubscribe from this list: send the line "unsubscribe linux-api" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

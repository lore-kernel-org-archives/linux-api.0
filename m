From: "Serge E. Hallyn" <serue@us.ibm.com>
Subject: Re: [PATCH 3/3] p9auth: add p9auth driver
Date: Wed, 21 Apr 2010 08:47:59 -0500
Message-ID: <20100421134759.GE16326@us.ibm.com>
References: <20100421012749.GA21338@us.ibm.com>
 <20100421012908.GB24251@us.ibm.com>
 <20100421030406.GB10258@kroah.com>
 <20100421034532.GA9254@us.ibm.com>
 <h2na67e66b21004202118w484dd8f0pe526b0a1fc7220e0@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-security-module-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <h2na67e66b21004202118w484dd8f0pe526b0a1fc7220e0@mail.gmail.com>
Sender: linux-security-module-owner@vger.kernel.org
To: Ashwin Ganti <ashwin.ganti@gmail.com>
Cc: Greg KH <greg@kroah.com>, lkml <linux-kernel@vger.kernel.org>, David Howells <dhowells@redhat.com>, rsc@swtch.com, ericvh@gmail.com, linux-security-module@vger.kernel.org, Ron Minnich <rminnich@gmail.com>, jt.beard@gmail.com, Andrew Morton <akpm@linux-foundation.org>, Andrew Morgan <morgan@kernel.org>, oleg@us.ibm.com, Eric Paris <eparis@redhat.com>, "Eric W. Biederman" <ebiederm@xmission.com>, linux-api@vger.kernel.org, Randy Dunlap <rdunlap@xenotime.net>
List-Id: linux-api@vger.kernel.org

Quoting Ashwin Ganti (ashwin.ganti@gmail.com):
> On Tue, Apr 20, 2010 at 8:45 PM, Serge E. Hallyn <serue@us.ibm.com> w=
rote:
> > Quoting Greg KH (greg@kroah.com):
> >> Hm, who is going to maintain this, you, or Ashwin?
> >
> > I haven't asked Ashwin, and will be happy either way. =A0Ashwin, di=
d
> > you want to maintain it?
>=20
> Well, since you have been driving a lot of implementation changes
> recently, I feel it makes sense for you to be a maintainer. Honestly =
I
> don't think I will be able to find time maintaining this in the futur=
e
> although I can do the code reviews for you. I will be more than happy
> if this feature continues to get traction.
>=20
> - Ashwin

Ok.  I'll put myself in MAINTAINERS.  If we stick with the p9auth
driver or filesystem approach, I'd like to keep you in MODULE_AUTHOR()
if that's ok, bc it really is yours, and wouldn't exist without you.

thanks,
-serge
--
To unsubscribe from this list: send the line "unsubscribe linux-securit=
y-module" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

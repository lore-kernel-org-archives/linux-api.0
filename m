From: David Rientjes <rientjes@google.com>
Subject: Re: [PATCH selftests 5/6] selftests: vm: Try harder to allocate huge
 pages
Date: Tue, 10 Nov 2015 17:11:15 -0800 (PST)
Message-ID: <alpine.DEB.2.10.1511101710470.19847@chino.kir.corp.google.com>
References: <1446334510.2595.13.camel@decadent.org.uk> <1446334747.2595.19.camel@decadent.org.uk> <alpine.DEB.2.10.1511101159480.29993@chino.kir.corp.google.com> <1447192104.6006.148.camel@decadent.org.uk>
Mime-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="397176738-1583944356-1447204275=:19847"
Return-path: <owner-linux-mm@kvack.org>
In-Reply-To: <1447192104.6006.148.camel@decadent.org.uk>
Sender: owner-linux-mm@kvack.org
To: Ben Hutchings <ben@decadent.org.uk>
Cc: Shuah Khan <shuahkh@osg.samsung.com>, linux-api@vger.kernel.org, linux-mm@kvack.org
List-Id: linux-api@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--397176738-1583944356-1447204275=:19847
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On Tue, 10 Nov 2015, Ben Hutchings wrote:

> > I know this patch is in -mm and hasn't been merged by Linus yet, but =
I'm=20
> > wondering why the multiple /proc/sys/vm/drop_caches is helping?=C2=A0=
 Would it=20
> > simply suffice to put a sleep in there instead or is drop_caches actu=
ally=20
> > doing something useful a second time around?
>=20
> Initially I just retried setting nr_hugepages up to 10 times, which
> wasn't sufficient. =C2=A0Then I added the drop_caches, and after that
> setting nr_hugepages tended to worked first time so I reduced the retry
> count. =C2=A0It might not be necessary to retry at all.
>=20

Ok, thanks.  I was just trying to make sure that the additional=20
drop_caches wasn't actually required for the test, in which case we would=
=20
have to fix drop_caches :)
--397176738-1583944356-1447204275=:19847--

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>

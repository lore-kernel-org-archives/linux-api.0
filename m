From: Artem Bityutskiy <dedekind1@gmail.com>
Subject: Re: [PATCH v3] introduce sys_syncfs to sync a single file system
Date: Mon, 14 Mar 2011 22:29:55 +0200
Message-ID: <1300134595.2332.17.camel@koala>
References: <Pine.LNX.4.64.1102171035220.13904@cobra.newdream.net>
	 <Pine.LNX.4.64.1103101125150.4190@cobra.newdream.net>
	 <edfa4cf081249734807e582c14253fca.squirrel@webmail.greenhost.nl>
	 <201103111255.44979.arnd@arndb.de>
	 <ffafd3ccb3fd1be7c40348c9cee84aef.squirrel@webmail.greenhost.nl>
	 <20110311235607.GB15853@elie>
	 <9446ab1a2315c0d2476c30f8315a0503.squirrel@webmail.greenhost.nl>
	 <20110312021001.GA16833@elie> <20110312173217.GA24981@kroah.com>
	 <1e597aedd3d7825dcc0630b1cf2399fa.squirrel@webmail.greenhost.nl>
	 <20110314131042.5a7fb32f.akpm@linux-foundation.org>
Reply-To: dedekind1@gmail.com
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <20110314131042.5a7fb32f.akpm@linux-foundation.org>
Sender: linux-fsdevel-owner@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Indan Zupancic <indan@nul.nu>, Greg KH <greg@kroah.com>, Jonathan Nieder <jrnieder@gmail.com>, Arnd Bergmann <arnd@arndb.de>, Sage Weil <sage@newdream.net>, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, "Aneesh Kumar K. V" <aneesh.kumar@linux.vnet.ibm.com>, linux-api@vger.kernel.org, mtk.manpages@gmail.com, viro@zeniv.linux.org.uk, hch@lst.de, l@jasper.es
List-Id: linux-api@vger.kernel.org

On Mon, 2011-03-14 at 13:10 -0700, Andrew Morton wrote:
> There might one day be a requirement to be able to initiate a
> resource-management-style writeback against a whole filesystem.  When
> that happens, we'll regret not having added a "mode" argument to
> sys_syncfs().

I think Indan is right about an additional argument which could be used
for future extensions, what is the problem adding it?

--=20
Best Regards,
Artem Bityutskiy (=D0=91=D0=B8=D1=82=D1=8E=D1=86=D0=BA=D0=B8=D0=B9 =D0=90=
=D1=80=D1=82=D1=91=D0=BC)

--
To unsubscribe from this list: send the line "unsubscribe linux-fsdevel=
" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

From: Djalal Harouni <djalal@endocode.com>
Subject: Re: [PATCH] fs, proc: introduce CONFIG_PROC_CHILDREN
Date: Tue, 26 May 2015 16:07:19 +0100
Message-ID: <20150526150719.GA8165@dztty>
References: <20150521135703.22af370fdd0799101a6a1b91@linux-foundation.org>
 <1432298859-2059-1-git-send-email-iago@endocode.com>
 <20150522153705.GI16716@uranus>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20150522153705.GI16716@uranus>
Sender: linux-fsdevel-owner@vger.kernel.org
To: Cyrill Gorcunov <gorcunov@gmail.com>
Cc: Iago =?utf-8?B?TMOzcGV6?= Galeiras <iago@endocode.com>, Oleg Nesterov <oleg@redhat.com>, Kees Cook <keescook@chromium.org>, Pavel Emelyanov <xemul@parallels.com>, Serge Hallyn <serge.hallyn@canonical.com>, KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>, linux-api@vger.kernel.org, Alexander Viro <viro@zeniv.linux.org.uk>, linux-fsdevel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>, Andy Lutomirski <luto@amacapital.net>, Alban Crequy <alban@endocode.com>
List-Id: linux-api@vger.kernel.org

On Fri, May 22, 2015 at 06:37:05PM +0300, Cyrill Gorcunov wrote:
> On Fri, May 22, 2015 at 02:47:39PM +0200, Iago L=C3=B3pez Galeiras wr=
ote:
> > --- a/init/Kconfig
> > +++ b/init/Kconfig
> > @@ -1145,6 +1145,7 @@ endif # CGROUPS
> > =20
> >  config CHECKPOINT_RESTORE
> >  	bool "Checkpoint/restore support" if EXPERT
> > +	depends on PROC_CHILDREN
> >  	default n
> >  	help
> >  	  Enables additional kernel features in a sake of checkpoint/rest=
ore.
>=20
> Maybe better select PROC_CHILDREN here? Also I must admit I don't und=
erstand
> why similar patch from Andy has not been merged earlier? Andy, there =
was
> some problem I forgot about?
=46rom the linked thread, it seems that it was just lost... The discuss=
ion
ended up about task/<tid> and /proc/<pid>... That patch should have bee=
n
applied.

BTW this patch adds the CONFIG guard that was requested by Andrew. Ther=
e
is a v3 coming to make it "select" as suggested.

Thanks!

--=20
Djalal Harouni
http://opendz.org
--
To unsubscribe from this list: send the line "unsubscribe linux-fsdevel=
" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

From: Cyrill Gorcunov <gorcunov-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH v3] fs, proc: introduce CONFIG_PROC_CHILDREN
Date: Wed, 27 May 2015 10:29:54 +0300
Message-ID: <20150527072954.GA1887@uranus>
References: <20150522153705.GI16716@uranus>
 <1432653162-20973-1-git-send-email-iago@endocode.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1432653162-20973-1-git-send-email-iago-973cpzSjLbNWk0Htik3J/w@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Iago =?iso-8859-1?Q?L=F3pez?= Galeiras <iago-973cpzSjLbNWk0Htik3J/w@public.gmane.org>
Cc: Oleg Nesterov <oleg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, Pavel Emelyanov <xemul-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>, Serge Hallyn <serge.hallyn-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>, KAMEZAWA Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Alexander Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>, Djalal Harouni <djalal-973cpzSjLbNWk0Htik3J/w@public.gmane.org>, Alban Crequy <alban-973cpzSjLbNWk0Htik3J/w@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Tue, May 26, 2015 at 05:12:42PM +0200, Iago L=F3pez Galeiras wrote:
=2E..
> Alban tested that /proc/<pid>/task/<tid>/children is present when the
> kernel is configured with CONFIG_PROC_CHILDREN=3Dy but without
> CONFIG_CHECKPOINT_RESTORE
>=20
> v3: change depend -> select
> v2: introduce CONFIG_PROC_CHILDREN http://marc.info/?l=3Dlinux-fsdeve=
l&m=3D143229890217280&w=3D2
> v1: http://marc.info/?l=3Dlinux-api&m=3D143220431121869&w=3D2
>=20
> Signed-off-by: Iago L=F3pez Galeiras <iago-973cpzSjLbNWk0Htik3J/w@public.gmane.org>
> Cc: Alban Crequy <alban-973cpzSjLbNWk0Htik3J/w@public.gmane.org>
> Tested-by: Alban Crequy <alban-973cpzSjLbNWk0Htik3J/w@public.gmane.org>

Looks ok to me, thanks.

Reviewed-by: Cyrill Gorcunov <gorcunov-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>

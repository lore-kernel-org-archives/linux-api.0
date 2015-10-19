From: Richard Weinberger <richard-/L3Ra7n9ekc@public.gmane.org>
Subject: Re: [PATCH] userns/capability: Add user namespace capability
Date: Mon, 19 Oct 2015 14:48:04 +0200
Message-ID: <5624E684.8000302@nod.at>
References: <5622700C.9090107@miglix.eu>
 <20151017215501.GA22900@mail.hallyn.com> <5623FD82.4030902@miglix.eu>
 <20151019014112.GA1683@mail.hallyn.com> <1445258180.4099.18.camel@debian.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1445258180.4099.18.camel-8fiUuRrzOP0dnm+yROfE0A@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Yves-Alexis Perez <corsac-8fiUuRrzOP0dnm+yROfE0A@public.gmane.org>, "Serge E. Hallyn" <serge-A9i7LUbDfNHQT0dZR+AlfA@public.gmane.org>, Tobias Markus <tobias-gyUQdkDHmHmHXe+LvDLADg@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, "Eric W. Biederman" <ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org>, Al Viro <viro-3bDd1+5oDREiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, Serge Hallyn <serge.hallyn-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>, Andrew Morton <akpm-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>, Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>, "Michael Kerrisk (man-pages)" <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-man-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Richard Weinberger <richard.weinberger-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
List-Id: linux-api@vger.kernel.org

Am 19.10.2015 um 14:36 schrieb Yves-Alexis Perez:
> On dim., 2015-10-18 at 20:41 -0500, Serge E. Hallyn wrote:
>> We shouldn't need a long-term solution.  Your concern is bugs.  After
>> some time surely we'll feel that we have achieved a stable solution?
> 
> But this is actually the whole point: we need a long term solution, because
> they will always be bug, whether in user namespaces or in others parts exposed
> by user namespaces. It's fine to fix them when we find them, but that still
> means they're exploitable even before we know about them. We still find bugs
> in code written years ago, it's quite certain there are bugs in current code.

You can replace the term "user namespace" with any other non-trivial kernel subsystem.
There will always be bugs.

Thanks,
//richard

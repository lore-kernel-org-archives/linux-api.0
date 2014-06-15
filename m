From: Mikael Pettersson <mikpelinux-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [RFC 0/2] __vdso_findsym
Date: Sun, 15 Jun 2014 16:25:37 +0200
Message-ID: <21405.44257.742122.786960@gargle.gargle.HOWL>
References: <cover.1402769596.git.luto@amacapital.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <cover.1402769596.git.luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>
Cc: Russ Cox <rsc-iFWiy5xATs8dnm+yROfE0A@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Ian Taylor <iant-iFWiy5xATs8dnm+yROfE0A@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, X86 ML <x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, dalias-8zAoT0mYgF4@public.gmane.org
List-Id: linux-api@vger.kernel.org

Andy Lutomirski writes:
 > The idea is to add AT_VDSO_FINDSYM pointing at __vdso_findsym.  This
 > implements __vdso_findsym.
 > 
 > This would make it easier for runtimes that don't otherwise implement
 > ELF loaders to use the vdso.
 > 
 > Thoughts?

I'm opposed to this based on the principle that the kernel should NOT
be a dumping ground for random code that user-space can and should
implement for itself.  As long as the vdso is correctly formatted ELF,
then parsing it is easy, and the kernel should not care at all if or
how user-space accesses it.

The fact that golang got it wrong is not an argument for moving this
functionality into the kernel.

/Mikael

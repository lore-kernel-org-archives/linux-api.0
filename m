From: Rich Felker <dalias@libc.org>
Subject: Re: [RFC 0/2] __vdso_findsym
Date: Sun, 15 Jun 2014 10:35:00 -0400
Message-ID: <20140615143500.GP179@brightrain.aerifal.cx>
References: <cover.1402769596.git.luto@amacapital.net>
 <21405.44257.742122.786960@gargle.gargle.HOWL>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <21405.44257.742122.786960@gargle.gargle.HOWL>
Sender: linux-kernel-owner@vger.kernel.org
To: Mikael Pettersson <mikpelinux@gmail.com>
Cc: Andy Lutomirski <luto@amacapital.net>, Russ Cox <rsc@golang.org>, linux-api@vger.kernel.org, Ian Taylor <iant@golang.org>, linux-kernel@vger.kernel.org, X86 ML <x86@kernel.org>
List-Id: linux-api@vger.kernel.org

On Sun, Jun 15, 2014 at 04:25:37PM +0200, Mikael Pettersson wrote:
> Andy Lutomirski writes:
>  > The idea is to add AT_VDSO_FINDSYM pointing at __vdso_findsym.  This
>  > implements __vdso_findsym.
>  > 
>  > This would make it easier for runtimes that don't otherwise implement
>  > ELF loaders to use the vdso.
>  > 
>  > Thoughts?
> 
> I'm opposed to this based on the principle that the kernel should NOT
> be a dumping ground for random code that user-space can and should
> implement for itself.  As long as the vdso is correctly formatted ELF,
> then parsing it is easy, and the kernel should not care at all if or
> how user-space accesses it.

Arguably, it was a mistake for the kernel to expose a virtual ELF to
begin with, and it should just have exposed a "lookup function by
name" operation to begin with. Yes this can be done in userspace, but
I see it more as a matter of "fixing a broken API design".

Rich

From: Dave Martin <Dave.Martin@arm.com>
Subject: Re: extending wait4(2) or waitid(2) linux syscall
Date: Fri, 16 Nov 2018 14:26:28 +0000
Message-ID: <20181116142628.GU3505@e103592.cambridge.arm.com>
References: <20170420152051.568f2050.albert.aribaud@3adev.fr>
 <20181115140441.GA2171@altlinux.org>
 <CAK8P3a0Gsqa8WTbALOUchRyEA7E2f3P1f=XQ8nD2xQaemfPpcQ@mail.gmail.com>
 <20181115153008.GC2171@altlinux.org>
 <20181116124238.GT3505@e103592.cambridge.arm.com>
 <874lchrvha.fsf@oldenburg.str.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <libc-alpha-return-97314-glibc-alpha=m.gmane.org@sourceware.org>
List-Unsubscribe: <mailto:libc-alpha-unsubscribe-glibc-alpha=m.gmane.org@sourceware.org>
List-Subscribe: <mailto:libc-alpha-subscribe@sourceware.org>
List-Archive: <http://sourceware.org/ml/libc-alpha/>
List-Post: <mailto:libc-alpha@sourceware.org>
List-Help: <mailto:libc-alpha-help@sourceware.org>, <http://sourceware.org/ml/#faqs>
Sender: libc-alpha-owner@sourceware.org
Content-Disposition: inline
In-Reply-To: <874lchrvha.fsf@oldenburg.str.redhat.com>
To: Florian Weimer <fweimer@redhat.com>
Cc: "Dmitry V. Levin" <ldv@altlinux.org>, Arnd Bergmann <arnd@arndb.de>, Albert ARIBAUD <albert.aribaud@3adev.fr>, "H. Peter Anvin" <hpa@zytor.com>, GNU C Library <libc-alpha@sourceware.org>, linux-api@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On Fri, Nov 16, 2018 at 02:40:49PM +0100, Florian Weimer wrote:
> * Dave Martin:
> 
> > The traditional way would be install a handler for SIGCHLD and
> > do a sigsuspend()/pselect()/ppoll().  Then when the suspend() returns,
> > you pump the status of any children with wait*(..., WNOHANG).
> >
> > Does that not work for you for some reason?
> 
> Changing signal handlers is not what a library should do because they
> are process-global (not even thread-specific).

True, though this is a problem with global resources too.
I guess I need to go and read the slides to understand the broader
context here.  (Is strace a library?)

Cheers
---Dave

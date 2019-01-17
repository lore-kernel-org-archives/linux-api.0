From: Heiko Carstens <heiko.carstens@de.ibm.com>
Subject: Re: [PATCH 2/5] ipc: introduce ksys_ipc()/compat_ksys_ipc() for s390
Date: Thu, 17 Jan 2019 21:13:42 +0100
Message-ID: <20190117201342.GA3687@osiris>
References: <20190116131527.2071570-1-arnd@arndb.de>
 <20190116131527.2071570-3-arnd@arndb.de>
 <20190117132906.GB18351@osiris>
 <CAK8P3a1u0OJKPnuBHVy4WSFy6T04kfNw5BwkpsLmkEU4KQD5eQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAK8P3a1u0OJKPnuBHVy4WSFy6T04kfNw5BwkpsLmkEU4KQD5eQ@mail.gmail.com>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-s390 <linux-s390@vger.kernel.org>, Martin Schwidefsky <schwidefsky@de.ibm.com>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, y2038 Mailman List <y2038@lists.linaro.org>, Dominik Brodowski <linux@dominikbrodowski.net>, Mark Rutland <mark.rutland@arm.com>, Linux API <linux-api@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

On Thu, Jan 17, 2019 at 05:29:55PM +0100, Arnd Bergmann wrote:
> On Thu, Jan 17, 2019 at 2:29 PM Heiko Carstens
> >  SYSCALL_DEFINE1(s390_personality, unsigned int, personality)
> >  {
> > diff --git a/kernel/sys_ni.c b/kernel/sys_ni.c
> > index ab9d0e3c6d50..ad016a7db0ea 100644
> > --- a/kernel/sys_ni.c
> > +++ b/kernel/sys_ni.c
> > @@ -366,7 +366,7 @@ COND_SYSCALL(kexec_file_load);
> >  /* s390 */
> >  COND_SYSCALL(s390_pci_mmio_read);
> >  COND_SYSCALL(s390_pci_mmio_write);
> > -COND_SYSCALL_COMPAT(s390_ipc);
> > +COND_SYSCALL(s390_ipc);
> >
> >  /* powerpc */
> >  COND_SYSCALL(rtas);
> 
> I think you need to keep the
> 
> COND_SYSCALL_COMPAT(s390_ipc);
> 
> here, otherwise it still fails with CONFIG_SYSV_IPC=n, CONFIG_COMPAT=y, right?

Yes, you're right.
